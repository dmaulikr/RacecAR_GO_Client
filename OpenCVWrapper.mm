//
//  OpenCVWrapper.m
//  RacecARGO
//
//  Created by Johannes Heucher on 01.02.17.
//  Copyright © 2017 Johannes Heucher. All rights reserved.
//

#import <opencv2/opencv.hpp>
#import "OpenCVWrapper.h"

@implementation OpenCVWrapper

+ (NSString*)versionString {
    return [NSString stringWithFormat:@"OpenCV Version: %s", CV_VERSION];
}

@end
