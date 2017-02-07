//
//  VMMRRequest.m
//  RacecARGO
//
//  Created by Johannes Heucher on 07.02.17.
//  Copyright © 2017 Johannes Heucher. All rights reserved.
//

#import "VMMRRequest.h"

@implementation VMMRRequest

- (void)startWithDescriptors:(const uint8_t*)descriptors withRows:(int)rows andCols:(int)cols {
    NSMutableData* message = [NSMutableData dataWithLength:rows * cols + sizeof(rows) + sizeof(cols)];
    
    // append 4 bytes each for rows and cols
    [message appendBytes:&rows length:sizeof(rows)];
    [message appendBytes:&cols length:sizeof(cols)];
    
    // append data
    [message appendBytes:descriptors length:rows * cols];
    
    [super startWithMessage:message];
}

@end
