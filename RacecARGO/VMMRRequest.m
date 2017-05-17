//
//  VMMRRequest.m
//  RacecARGO
//
//  Created by Johannes Heucher on 07.02.17.
//  Copyright © 2017 Johannes Heucher. All rights reserved.
//

#import "VMMRRequest.h"
#import "Const.h"

@implementation VMMRRequest
@synthesize delegate;

- (NSNumber*)messageId {
    return [NSNumber numberWithUnsignedChar:MESSAGE_ID_VMMR];
}


- (void)startWithDescriptors:(const uint8_t*)descriptors withRows:(uint16_t)rows andCols:(uint16_t)cols {
    NSMutableData* message = [NSMutableData dataWithCapacity:rows * cols + sizeof(rows) + sizeof(cols)];
    
    // append number of rows and cols
    [message appendBytes:&rows length:sizeof(rows)];
    [message appendBytes:&cols length:sizeof(cols)];
    
    NSLog(@"sent (rows: %d, cols: %d)", rows, cols);
    
    // append data
    [message appendBytes:descriptors length:rows * cols];
    
    [super startWithMessage:message];
}


- (void)receivedMessage:(NSData*)message {
    [super receivedMessage:message];
    
    // parse message
    NSString* make;
    NSString* model;
    NSString* error;
    
    if (message.length > 0) {
        char* bytes = malloc(message.length);
        [message getBytes:bytes length:message.length];
        NSString* payload = [NSString stringWithUTF8String:&bytes[1]];
        if (bytes[0] == '0') {
            NSArray<NSString*>* makeModel = [payload componentsSeparatedByString:@"_"];
            make = [makeModel objectAtIndex:0];
            model = (makeModel.count > 1) ? [makeModel objectAtIndex:1] : @"";
        } else {
            error = payload;
        }
    } else {
        error = @"empty message";
    }
    
    if (delegate != nil) {
        [delegate receivedMake:make andModel:model orError:error];
    }
}

@end
