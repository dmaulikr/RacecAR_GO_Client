//
//  VMMRecognizer.m
//  RacecARGO
//
//  Created by Johannes Heucher on 01.02.17.
//  Copyright © 2017 Johannes Heucher. All rights reserved.
//

#import "VMMRecognizer.h"
#import "RoIExtractor.h"
#import "FeatureExtractor.h"
#import "ImageUtils.h"
#import "Const.h"
#import "VMMRRequest.h"


@interface VMMRecognizer () <VMMRRequestDelegate> {
    BOOL pending;
    VMMRRequest* request;
}
- (void)resetPending;
@end


@implementation VMMRecognizer

- (id)init {
    if (self = [super init]) {
        pending = NO;
        request = [[VMMRRequest alloc] init];
        request.delegate = self;
        // TODO DEBUG
        //[NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(resetPending) userInfo:nil repeats:YES];
    }
    return self;
}


- (void)recognize:(cv::Mat&)vehicleImage withNumberPlateRect:(cv::Rect&)rect {
    if (!pending) {
        
        // extract RoI
        cv::Mat roI = [RoIExtractor extractFromSource:vehicleImage withNumberPlateRect:rect];
        
        // normalize RoI
        cv::equalizeHist(roI, roI);
        [ImageUtils resize:roI to:roI withWidth:ROI_WIDTH];
        
        
        // TODO: Make a test: Compute descriptors for the same image with JAVA and
        // iOS app. #descriptors should be the same.
        
        // extract feature descriptors
        cv::Mat descriptors;
        [FeatureExtractor extractFromSource:roI returnDescriptors:descriptors];
        
        std::vector<uchar> array;
        if (descriptors.isContinuous()) {
            array.assign(descriptors.datastart, descriptors.dataend);
        }
        
        // send request for make-model
        pending = YES;
        NSLog(@"sending");
        // TODO DEBUG as a test send whole RoI instead of descriptors
        [request startWithDescriptors:roI.datastart withRows:roI.rows andCols:roI.cols];
        NSLog(@"sent");
    }
}


- (void)resetPending {
    pending = NO;
}


#pragma mark - VMMR Requester Delegate

- (void)receivedMake:(NSString*)make andModel:(NSString*)model orError:(NSString*)error {
    pending = NO;
    NSLog(@"make: %@\nmodel: %@\nerror: %@", make, model, error);
}

@end
