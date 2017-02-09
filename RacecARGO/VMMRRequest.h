//
//  VMMRRequest.h
//  RacecARGO
//
//  Created by Johannes Heucher on 07.02.17.
//  Copyright © 2017 Johannes Heucher. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TCPRequest.h"


@protocol VMMRRequestDelegate
- (void)receivedMake:(NSString*)make andModel:(NSString*)model orError:(NSString*)error;
@end



@interface VMMRRequest : TCPRequest

- (void)startWithDescriptors:(const uint8_t*)descriptors withRows:(uint16_t)rows andCols:(uint16_t)cols;

@end
