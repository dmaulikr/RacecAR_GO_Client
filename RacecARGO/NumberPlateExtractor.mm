//
//  NumberPlateRecognizer.m
//  RacecARGO
//
//  Created by Johannes Heucher on 01.02.17.
//  Copyright © 2017 Johannes Heucher. All rights reserved.
//

#import <opencv2/imgproc/imgproc.hpp>
#import "NumberPlateExtractor.h"

@implementation NumberPlateExtractor

+ (cv::Rect)extract:(cv::Mat&)src {
    cv::Mat binary;
    cv::Mat edges;
    cv::Mat contours;
    
    // blur
    cv::Size kernelSize(GAUSS_KERNEL_SIZE, GAUSS_KERNEL_SIZE);
    cv::GaussianBlur(src, binary, kernelSize, 1.0);
    
    // binarize
    
    
    cv::Rect result(0, 0, 100, 100);
    return result;
}

@end
