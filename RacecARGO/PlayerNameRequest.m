//
//  VMMRRequest.m
//  RacecARGO
//
//  Created by Johannes Heucher on 07.02.17.
//  Copyright © 2017 Johannes Heucher. All rights reserved.
//

#import "PlayerNameRequest.h"
#import "Const.h"
#import "RacecARGO-Swift.h"

@implementation PlayerNameRequest

- (NSNumber*)messageId {
    return [NSNumber numberWithUnsignedChar:MESSAGE_ID_PLAYER_NAME];
}


- (void)start {
    NSString* name = [[NSUserDefaults standardUserDefaults] stringForKey:SettingsViewController.PLAYER_NAME_KEY];
    uint16_t length = name.length;
    NSMutableData* message = [NSMutableData dataWithCapacity:name.length + sizeof(length)];
    
    // append number of bytes
    [message appendBytes:&length length:sizeof(length)];
    
    NSLog(@"sent name %@ with length %d", name, length);
    
    // append data
    //[message appendBytes:[name cStringUsingEncoding:NSUTF8StringEncoding] length:length];
    [message appendBytes:[name UTF8String] length:length];
    [super startWithMessage:message];
}


- (void)receivedMessage:(NSData*)message {
    [super receivedMessage:message];
    
    // @TODO: noting supposed to receive here
}

@end
