//
//  VMMRecognizer.m
//  RacecARGO
//
//  Created by Johannes Heucher on 01.02.17.
//  Copyright © 2017 Johannes Heucher. All rights reserved.
//

#import "VMMRecognizer.h"
#import "RoIExtractor.h"
#import "FeatureExtractor.h"
#import "ImageUtils.h"
#import "Const.h"

@implementation VMMRecognizer

- (void)recognize:(cv::Mat&)vehicleImage withNumberPlateRect:(cv::Rect&)rect {
    // extract RoI
    cv::Mat roI = [RoIExtractor extractFromSource:vehicleImage withNumberPlateRect:rect];
    
    // normalize RoI
    cv::equalizeHist(roI, roI);
    [ImageUtils resize:roI to:roI withWidth:ROI_WIDTH];
    
    
    // TODO: Make a test: Compute descriptors for the same image with JAVA and
    // iOS app. #descriptors should be the same.
    
    // extract feature descriptors
    cv::Mat descriptors;
    [FeatureExtractor extractFromSource:roI returnDescriptors:descriptors];
    
    std::vector<uchar> array;
    if (descriptors.isContinuous()) {
        array.assign(descriptors.datastart, descriptors.dataend);
    }
    
}

@end
