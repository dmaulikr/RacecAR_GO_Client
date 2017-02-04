//
//  NumberPlateExtractorProxy.m
//  RacecARGO
//
//  Created by Johannes Heucher on 03.02.17.
//  Copyright © 2017 Johannes Heucher. All rights reserved.
//

#import "NumberPlateExtractorProxy.h"
#import "NumberPlateExtractor.h"

@implementation NumberPlateExtractorProxy

+ (cv::Rect)extractFrom:(cv::Mat&)src {
    int width = src.cols / 4;
    int height = width / NUMBER_PLATE_ASPECT_RATIO;
    int centerX = src.cols / 2;
    int centerY = (int)(src.rows * 0.7);
    return cv::Rect(centerX - width / 2, centerY - height / 2, width, height);
}

@end
