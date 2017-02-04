//
//  NumberPlateRecognizer.m
//  RacecARGO
//
//  Created by Johannes Heucher on 01.02.17.
//  Copyright © 2017 Johannes Heucher. All rights reserved.
//

#import <opencv2/imgproc/imgproc.hpp>
#import "NumberPlateExtractor.h"
#import "ImageUtils.h"


#define GAUSS_KERNEL_SIZE 13


@interface NumberPlateExtractor () {
}
+ (float)isNumberPlate:(std::vector< cv::Point >&)contour inBoundingRect:(cv::Rect&)rect;
@end

@implementation NumberPlateExtractor


/**
 * @param src Grayscale image
 */
+ (cv::Rect)extractFrom:(cv::Mat&)src {
    cv::Mat resized;
    cv::Mat binary;
    cv::Mat edges;
    std::vector< std::vector< cv::Point > > contours;
    
    // resize
    [ImageUtils resize:src to:resized withWidth:IMAGE_WIDTH];
    
    // blur
    cv::Size kernelSize(GAUSS_KERNEL_SIZE, GAUSS_KERNEL_SIZE);
    cv::GaussianBlur(resized, binary, kernelSize, 1.0);
    
    // binarize
    cv::threshold(binary, binary, 130, 155, CV_THRESH_BINARY);
    
    // detect edges
    cv::Canny(binary, edges, 50, 200);
    
    // detect contours
    cv::Mat hierarchy;
    cv::findContours(edges, contours, hierarchy, CV_RETR_EXTERNAL, CV_CHAIN_APPROX_SIMPLE);
    
    cv::Rect minRect(0, 0, 0, 0);
    float minScore = FLT_MAX;
    for (int i = 0; i < contours.size(); i++) {
        cv::Rect rect = cv::boundingRect(contours[i]);
        float score = [NumberPlateExtractor isNumberPlate:contours[i] inBoundingRect:rect];
        if (score <= 1 && score < minScore) {
            minScore = score;
            minRect = rect;
        }
    }
    
    return minRect;
}


+ (float)isNumberPlate:(std::vector< cv::Point >&)contour inBoundingRect:(cv::Rect&)rect {
    float widthError  = abs(NUMBER_PLATE_WIDTH  - rect.width)  / (float)NUMBER_PLATE_WIDTH_HALFRANGE;
    float heightError = abs(NUMBER_PLATE_HEIGHT - rect.height) / (float)NUMBER_PLATE_HEIGHT_HALFRANGE;
    float aspectError = fabsf(NUMBER_PLATE_ASPECT_RATIO - rect.width / (float)rect.height) / NUMBER_PLATE_ASPECT_RATIO_EPSILON;
    
    if (widthError <= 1 && heightError <= 1 && aspectError <= 1) {
        double perimeter = cv::arcLength(contour, true);
        std::vector< cv::Point > approx;
        cv::approxPolyDP(contour, approx, perimeter * 0.04, true);
        
        // expected number of points
        const int MIN_NUM_POINTS = 2;
        const int MAX_NUM_POINTS = 8;
        const float MID_NUM_POINTS = (MAX_NUM_POINTS + MIN_NUM_POINTS) / 2.0f;
        const float NUM_POINTS_HALFRANGE = (MAX_NUM_POINTS - MIN_NUM_POINTS) / 2.0f;
        
        float numPointsError = abs((int)approx.size() - MIN_NUM_POINTS) / NUM_POINTS_HALFRANGE;
        
        if (numPointsError <= 1) {
            return (widthError + heightError + aspectError + numPointsError) / 4;
        }
    }
    return FLT_MAX;
}

@end
