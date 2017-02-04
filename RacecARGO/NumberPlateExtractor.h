//
//  NumberPlateRecognizer.h
//  RacecARGO
//
//  Created by Johannes Heucher on 01.02.17.
//  Copyright © 2017 Johannes Heucher. All rights reserved.
//

#import <opencv2/opencv.hpp>
#import <Foundation/Foundation.h>


#define IMAGE_WIDTH 300
#define NUMBER_PLATE_ASPECT_RATIO 4.3f
#define NUMBER_PLATE_ASPECT_RATIO_EPSILON 0.75f

// originally for an image width of 800: {180, 300} x {30, 75}
#define NUMBER_PLATE_MIN_WIDTH  (int)(IMAGE_WIDTH * 0.225)
#define NUMBER_PLATE_MAX_WIDTH  (int)(IMAGE_WIDTH * 0.375)
#define NUMBER_PLATE_MIN_HEIGHT (int)(NUMBER_PLATE_MIN_WIDTH / (NUMBER_PLATE_ASPECT_RATIO + NUMBER_PLATE_ASPECT_RATIO_EPSILON))
#define NUMBER_PLATE_MAX_HEIGHT (int)(NUMBER_PLATE_MAX_WIDTH / (NUMBER_PLATE_ASPECT_RATIO - NUMBER_PLATE_ASPECT_RATIO_EPSILON))

#define NUMBER_PLATE_WIDTH  (NUMBER_PLATE_MAX_WIDTH  + NUMBER_PLATE_MIN_WIDTH)  / 2
#define NUMBER_PLATE_HEIGHT (NUMBER_PLATE_MAX_HEIGHT + NUMBER_PLATE_MIN_HEIGHT) / 2
#define NUMBER_PLATE_WIDTH_HALFRANGE  (NUMBER_PLATE_MAX_WIDTH  - NUMBER_PLATE_MIN_WIDTH)  / 2
#define NUMBER_PLATE_HEIGHT_HALFRANGE (NUMBER_PLATE_MAX_HEIGHT - NUMBER_PLATE_MIN_HEIGHT) / 2


@interface NumberPlateExtractor : NSObject

+ (cv::Rect)extractFrom:(cv::Mat&)src;

@end
