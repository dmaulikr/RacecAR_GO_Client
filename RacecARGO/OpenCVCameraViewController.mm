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
#import "NumberPlateExtractor.h"        // just for testing


@interface OpenCVCameraViewController () <CvVideoCameraDelegate> {
    CvVideoCamera* videoCamera;
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
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#ifdef __cplusplus
- (void)processImage:(cv::Mat&)image {
    cv::cvtColor((const cv::_InputArray)image, (const cv::_OutputArray)image, CV_BGR2GRAY);
    
    //VMMRecognizer recognize       // TODO later
    
    // TEST: number plate extraction
    cv::Rect numberPlateRect = [NumberPlateExtractor extract:image];
    cv::Scalar color(0, 0, 0);
    cv::rectangle(image, numberPlateRect, color);
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
