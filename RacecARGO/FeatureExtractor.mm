//
//  FeatureExtractor.m
//  RacecARGO
//
//  Created by Johannes Heucher on 03.02.17.
//  Copyright © 2017 Johannes Heucher. All rights reserved.
//

#import <opencv2/features2d/features2d.hpp>
#import "FeatureExtractor.h"

@implementation FeatureExtractor

+ (void)extractFromSource:(cv::Mat&)src returnDescriptors:(cv::Mat&)descriptors {
    cv::Ptr<cv::ORB> detector = cv::ORB::create();
    
    // extract descriptors
    std::vector<cv::KeyPoint> keyPoints;
    detector.get()->detect(src, keyPoints);
    detector.get()->compute(src, keyPoints, descriptors);
}

@end
