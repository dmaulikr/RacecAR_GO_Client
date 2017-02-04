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

@implementation VMMRecognizer

- (void)recognize:(cv::Mat&)vehicleImage withNumberPlateRect:(cv::Rect&)rect {
    // extract RoI
    cv::Mat roI = [RoIExtractor extractFromSource:vehicleImage withNumberPlateRect:rect];
    
TODO: Check that RoI has exactly the same size as the training images. Otherwise,
    the extracted descriptors will differ in amount and style.
    
    // extract feature descriptors
    cv::Mat descriptors;
    [FeatureExtractor extractFromSource:roI returnDescriptors:descriptors];
    
    std::vector<uchar> array;
    if (descriptors.isContinuous()) {
        array.assign(descriptors.datastart, descriptors.dataend);
    }
    
}

@end
