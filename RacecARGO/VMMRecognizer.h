//
//  VMMRecognizer.h
//  RacecARGO
//
//  Created by Johannes Heucher on 01.02.17.
//  Copyright © 2017 Johannes Heucher. All rights reserved.
//

#import <opencv2/opencv.hpp>
#import <Foundation/Foundation.h>

@protocol VMMRecognizerDelegate
- (void)recognizedMake:(NSString*)make andModel:(NSString*)model;
@end


@interface VMMRecognizer : NSObject

- (id)initWithDelegate:(id<VMMRecognizerDelegate>)aDelegate;
- (void)recognize:(cv::Mat&)vehicleImage withNumberPlateRect:(cv::Rect&)rect;

@property (nonatomic, retain) id<VMMRecognizerDelegate> delegate;

@end
