//
//  ImageUtils.h
//  RacecARGO
//
//  Created by Johannes Heucher on 04.02.17.
//  Copyright © 2017 Johannes Heucher. All rights reserved.
//

#import <opencv2/opencv.hpp>
#import <Foundation/Foundation.h>

@interface ImageUtils : NSObject

+ (void)resize:(cv::Mat&)src to:(cv::Mat&)dst withWidth:(int)width;

@end
