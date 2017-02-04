//
//  VMMRecognizer.h
//  RacecARGO
//
//  Created by Johannes Heucher on 01.02.17.
//  Copyright © 2017 Johannes Heucher. All rights reserved.
//

#import <opencv2/opencv.hpp>
#import <Foundation/Foundation.h>

@interface VMMRecognizer : NSObject

- (void)recognize:(cv::Mat&)vehicleImage withNumberPlateRect:(cv::Rect&)rect;

@end
