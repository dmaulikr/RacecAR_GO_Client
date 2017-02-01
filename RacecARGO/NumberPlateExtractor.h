//
//  NumberPlateRecognizer.h
//  RacecARGO
//
//  Created by Johannes Heucher on 01.02.17.
//  Copyright © 2017 Johannes Heucher. All rights reserved.
//

#import <opencv2/opencv.hpp>
#import <Foundation/Foundation.h>

#define GAUSS_KERNEL_SIZE 13

@interface NumberPlateExtractor : NSObject

+ (cv::Rect)extract:(cv::Mat&)src;

@end
