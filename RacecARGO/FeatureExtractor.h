//
//  FeatureExtractor.h
//  RacecARGO
//
//  Created by Johannes Heucher on 03.02.17.
//  Copyright © 2017 Johannes Heucher. All rights reserved.
//

#import <opencv2/opencv.hpp>
#import <Foundation/Foundation.h>

@interface FeatureExtractor : NSObject

+ (void)extractFromSource:(cv::Mat&)src returnDescriptors:(cv::Mat&)descriptors;

@end
