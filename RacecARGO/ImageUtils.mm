//
//  ImageUtils.m
//  RacecARGO
//
//  Created by Johannes Heucher on 04.02.17.
//  Copyright © 2017 Johannes Heucher. All rights reserved.
//

#import "ImageUtils.h"

@implementation ImageUtils

+ (void)resize:(cv::Mat&)src to:(cv::Mat&)dst withWidth:(int)width {
    float ratio = src.cols / (float)src.rows;
    int height = (int)(width / ratio);
    cv::resize(src, dst, cv::Size(width, height));
}

@end
