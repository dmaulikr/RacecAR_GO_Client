//
//  VMMRecognizer.m
//  RacecARGO
//
//  Created by Johannes Heucher on 01.02.17.
//  Copyright © 2017 Johannes Heucher. All rights reserved.
//

#import "VMMRecognizer.h"
#import "NumberPlateExtractor.h"

@implementation VMMRecognizer

- (void)recognize:(cv::Mat&)vehicleImage {
    cv::Rect numberPlateRect = [NumberPlateExtractor extract:vehicleImage];
}

@end
