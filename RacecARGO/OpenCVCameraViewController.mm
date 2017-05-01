//
//  OpenCVCameraViewController.m
//  RacecARGO
//
//  Created by Johannes Heucher on 01.02.17.
//  Copyright © 2017 Johannes Heucher. All rights reserved.
//


#ifdef __cplusplus
#import <opencv2/opencv.hpp>
#import <opencv2/videoio/cap_ios.h>
#import <opencv2/imgcodecs/ios.h>
#endif

#import "OpenCVCameraViewController.h"

#import "VMMRecognizer.h"
#import "NumberPlateExtractorProxy.h"        // just for testing
#import "TCPSocketRequester.h"


@interface OpenCVCameraViewController () <CvVideoCameraDelegate, VMMRecognizerDelegate, TCPSocketStatusDelegate> {
    CMMotionManager* motionManager;
    CMAttitude* initialAttitude;            // attitude at time of capturing
    
    SCNScene* scene;
    SCNNode* cameraNode;
    SCNNode* modelNode;
    
    CvVideoCamera* videoCamera;
    VMMRecognizer* vMMRecognizer;
    cv::Mat cropped;
}

@property CvVideoCamera* videoCamera;

@end

@implementation OpenCVCameraViewController

@synthesize videoCamera;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // camera and video
    self.videoCamera = [[CvVideoCamera alloc] initWithParentView:imageView];
    self.videoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionBack;
    //self.videoCamera.defaultAVCaptureSessionPreset = AVCaptureSessionPreset1920x1080;
    self.videoCamera.defaultAVCaptureSessionPreset = AVCaptureSessionPreset1280x720;
    self.videoCamera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationPortrait;
    self.videoCamera.defaultFPS = 30;
    self.videoCamera.grayscaleMode = NO;
    
    self.videoCamera.delegate = self;
    
    
    // scene overlay
    cameraNode = [SCNNode node];
    cameraNode.camera = [SCNCamera camera];
    cameraNode.position = SCNVector3Make(0, 0.7f, 4.5f);
    
    scene = [[SCNScene alloc] init];
    [scene.rootNode addChildNode:cameraNode];
    
    sceneView.autoenablesDefaultLighting = YES;
    sceneView.allowsCameraControl = YES;
    sceneView.scene = scene;
    sceneView.backgroundColor = [UIColor clearColor];
    
    
    // recognition
    self->vMMRecognizer = [[VMMRecognizer alloc] initWithDelegate:self];
    
    
    
    // TODO DEBUG initialize requester here to build up TCP connection
    [TCPSocketRequester defaultRequester];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // receive socket status
    [[TCPSocketRequester defaultRequester] addSocketStatusDelegate:self];
    
    // start video capture
    [self.videoCamera start];
    
    // start motion capture
    motionManager = [[CMMotionManager alloc] init];
    [motionManager setDeviceMotionUpdateInterval:0.04];
    
    NSOperationQueue* queue = [[NSOperationQueue alloc] init];
    [motionManager startDeviceMotionUpdatesToQueue:queue withHandler: ^(CMDeviceMotion* motion, NSError* error) {
        CMAttitude* attitude = motion.attitude;
        if (initialAttitude != nil) {
            [attitude multiplyByInverseOfAttitude:initialAttitude];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            SCNQuaternion q = SCNVector4Make(attitude.quaternion.x, attitude.quaternion.y, attitude.quaternion.z, attitude.quaternion.w);
            cameraNode.orientation = q;
        });
    }];
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    // stop receiving socket status
    [[TCPSocketRequester defaultRequester] removeSocketStatusDelegate:self];
    
    // stop video capture
    [self.videoCamera stop];
    
    // stop motion capture
    [motionManager stopDeviceMotionUpdates];
}



#ifdef __cplusplus
- (void)processImage:(cv::Mat&)image {
    // crop to fit image view
    int width  = (int)self->imageView.bounds.size.width * 2;
    int height = (int)self->imageView.bounds.size.height * 2;
    cropped = image(cv::Rect(0, 0, MIN(image.cols, width), height));
    cv::cvtColor(cropped, image, CV_BGR2RGB);
    
    // TODO DEBUG as long as the real number plate recognition is bad, use proxy
    cv::Rect numberPlateRect = [NumberPlateExtractorProxy extractFrom:image];
    if (numberPlateRect.width > 0) {
        cv::rectangle(image, numberPlateRect, cv::Scalar(200, 100, 255), 5);
    }
}
#endif


- (IBAction)capture:(id)sender {
    cv::Mat grayImage;
    
    // turn to gray for VMMR
    cv::cvtColor(cropped, grayImage, CV_BGR2GRAY);
    
    
    // TEST: write and read
    //    std::vector<uchar> array;
    //    if (grayImage.isContinuous()) {
    //        array.assign(grayImage.datastart, grayImage.dataend);
    //    }
    //    for (int i = 100 * image.cols; i < 140 * image.cols; i++) {
    //        array[i] = 0;
    //    }
    //    cv::Mat loadedImage = cv::Mat(image.rows, image.cols, CV_8UC1);
    //    memcpy(loadedImage.data, array.data(), array.size() * sizeof(uchar));
    // ---
    cv::Rect numberPlateRect = [NumberPlateExtractorProxy extractFrom:grayImage];
    if (numberPlateRect.width > 0) {
        [self->vMMRecognizer recognize:grayImage withNumberPlateRect:numberPlateRect];
    }
    makeModelLabel.text = @"Recognizing ...";
    
    // save attitude at time of capture, because this will be the identity in capturing space
    initialAttitude = motionManager.deviceMotion.attitude;
}


#pragma mark - VMMRecognitionDelegate

- (void)recognizedMake:(NSString*)make andModel:(NSString*)model {
    makeModelLabel.text = [NSString stringWithFormat:@"%@ %@", make, model];
    
    // remove current model node
    if (modelNode != nil) {
        [modelNode removeFromParentNode];
    }
    
    // load and show respective model
    NSString* filename = [NSString stringWithFormat:@"Models/%@_%@", make, model];
    NSURL* url = [[NSBundle mainBundle] URLForResource:filename withExtension:@"obj"];
    MDLAsset* asset = [[MDLAsset alloc] initWithURL:url];
    MDLMesh* mesh = (MDLMesh*)[asset objectAtIndex:0];
    modelNode = [SCNNode nodeWithMDLObject:mesh];
    [scene.rootNode addChildNode:modelNode];
}


#pragma mark - Socket Status

- (void)statusUpdate:(NSString*)status {
    self.navigationItem.rightBarButtonItem.title = status;
}


- (void)didOpen {
}

@end
