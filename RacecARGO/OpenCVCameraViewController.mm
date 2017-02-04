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


@interface OpenCVCameraViewController () <CvVideoCameraDelegate> {
    CvVideoCamera* videoCamera;
    VMMRecognizer* vMMRecognizer;
}

@property CvVideoCamera* videoCamera;

@end

@implementation OpenCVCameraViewController

@synthesize videoCamera;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.videoCamera = [[CvVideoCamera alloc] initWithParentView:imageView];
    self.videoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionBack;
    self.videoCamera.defaultAVCaptureSessionPreset = AVCaptureSessionPreset352x288;
    self.videoCamera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationPortrait;
    self.videoCamera.defaultFPS = 30;
    self.videoCamera.grayscaleMode = NO;
    
    self.videoCamera.delegate = self;
    
    self->vMMRecognizer = [[VMMRecognizer alloc] init];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#ifdef __cplusplus
- (void)processImage:(cv::Mat&)image {
    cv::Mat grayImage;
    cv::cvtColor(image, grayImage, CV_BGR2GRAY);
    
    // write and read
    std::vector<uchar> array;
    if (grayImage.isContinuous()) {
        array.assign(grayImage.datastart, grayImage.dataend);
    }
    for (int i = 100 * image.cols; i < 140 * image.cols; i++) {
        array[i] = 0;
    }
    cv::Mat loadedImage = cv::Mat(image.rows, image.cols, CV_8UC1);
    memcpy(loadedImage.data, array.data(), array.size() * sizeof(uchar));
    
    
    cv::Rect numberPlateRect = [NumberPlateExtractorProxy extractFrom:loadedImage];
    if (numberPlateRect.width > 0) {
        cv::Scalar color(200, 100, 255);
        cv::rectangle(loadedImage, numberPlateRect, color);
        [self->vMMRecognizer recognize:loadedImage withNumberPlateRect:numberPlateRect];
    }
    loadedImage.copyTo(image);
}
#endif


- (IBAction)start:(id)sender {
    [self.videoCamera start];
}


- (IBAction)stop:(id)stop {
    [self.videoCamera stop];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
