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
//    NSMutableData* typedMessage = [NSMutableData dataWithLength:message.length + 3];
//    uint8_t idAsByte = [self messageId].unsignedCharValue;
//    [typedMessage appendBytes:&idAsByte length:1];
//    [typedMessage appendBytes:message.bytes length:message.length];
//    
//    char* lineBreak = "\n";
//    [typedMessage appendBytes:lineBreak length:2];
//    
//    [[TCPSocketRequester defaultRequester] sendMessage:typedMessage withDelegate:self];
    
    
//    NSString* mess = @"this is the client, hello\n";
//    const char* bytes = [mess UTF8String];
//    NSData* data = [NSData dataWithBytes:bytes length:mess.length];
//    [[TCPSocketRequester defaultRequester] sendMessage:data withDelegate:self];
    
    why does this id not reach the server right? better send a char like 'a' and read this in server.
    don't forget to use UTF8String to encode
    
    NSMutableData* typedMessage = [NSMutableData dataWithLength:3];
    uint8_t idAsByte = [self messageId].unsignedCharValue;
    [typedMessage appendBytes:&idAsByte length:1];
    
    NSString* lineBreak = @"\n";
    const char* bytes = [lineBreak UTF8String];
    [typedMessage appendBytes:bytes length:lineBreak.length];
    
    [[TCPSocketRequester defaultRequester] sendMessage:typedMessage withDelegate:self];
}


/**
 * Override in sub classes
 */
- (void)receivedMessage:(NSData*)message {
}

@end
