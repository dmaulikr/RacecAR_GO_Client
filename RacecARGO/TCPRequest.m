//
//  TCPRequest.m
//  RacecARGO
//
//  Created by Johannes Heucher on 07.02.17.
//  Copyright © 2017 Johannes Heucher. All rights reserved.
//

#import "TCPRequest.h"
#import "Const.h"

@implementation TCPRequest

- (NSNumber*)messageId {
    return [NSNumber numberWithUnsignedChar:MESSAGE_ID_NONE];
}


- (void)startWithMessage:(NSData*)message {
    NSMutableData* typedMessage = [NSMutableData dataWithLength:message.length + 1];
    uint8_t idAsByte = [self messageId].unsignedCharValue;
    [typedMessage appendBytes:&idAsByte length:1];
    [typedMessage appendBytes:message.bytes length:message.length];
    [[TCPSocketRequester defaultRequester] sendMessage:message withDelegate:self];
}


/**
 * Override in sub classes
 */
- (void)receivedMessage:(NSData*)message {
}

@end
