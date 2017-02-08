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
    NSMutableData* typedMessage = [NSMutableData dataWithCapacity:message.length + 2];
    uint8_t idAsByte = [self messageId].unsignedCharValue;
    [typedMessage appendBytes:&idAsByte length:1];
    [typedMessage appendBytes:message.bytes length:message.length];
    
    NSString* lineBreak = @"\n";
    const char* bytes = [lineBreak UTF8String];
    [typedMessage appendBytes:bytes length:lineBreak.length];
    
    [[TCPSocketRequester defaultRequester] sendMessage:typedMessage withDelegate:self];
    
    
//    NSString* mess = @"this is the client, hello\n";
//    const char* bytes = [mess UTF8String];
//    NSData* data = [NSData dataWithBytes:bytes length:mess.length];
//    [[TCPSocketRequester defaultRequester] sendMessage:data withDelegate:self];
    
//    NSMutableData* typedMessage = [NSMutableData dataWithCapacity:8];
//    uint8_t idAsByte = [self messageId].unsignedCharValue;
//    [typedMessage appendBytes:&idAsByte length:1];
//    
//    uint8_t v200 = 200;
//    [typedMessage appendBytes:&v200 length:1];
//    
//    SignedByte v15 = 15;
//    [typedMessage appendBytes:&v15 length:1];
//    
//    char vm = 'm';
//    [typedMessage appendBytes:&vm length:1];
//    
//    NSString* vs = @"Joh";
//    const char* vss = [vs UTF8String];
//    [typedMessage appendBytes:vss length:3];
    
//    NSString* mid = @"a";
//    const char* midc = [mid UTF8String];
//    [typedMessage appendBytes:midc length:mid.length];
    
//    NSString* lineBreak = @"\n";
//    NSLog(@"len: %lu", (unsigned long)lineBreak.length);
//    const char* bytes = [lineBreak UTF8String];
//    [typedMessage appendBytes:bytes length:lineBreak.length];
//    
//    [[TCPSocketRequester defaultRequester] sendMessage:typedMessage withDelegate:self];
}


/**
 * Override in sub classes
 */
- (void)receivedMessage:(NSData*)message {
}

@end
