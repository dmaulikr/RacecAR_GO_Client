//
//  TCPSocket.m
//  RacecARGO
//
//  Created by Johannes Heucher on 04.02.17.
//  Copyright © 2017 Johannes Heucher. All rights reserved.
//

#import "TCPSocket.h"

#define ADDRESS @"91.67.233.112"
//#define ADDRESS @"192.168.1.101"
#define PORT 1234

@interface TCPSocket () {
    BOOL _isCconnected;
}
@end


@implementation TCPSocket

@synthesize inputStream, outputStream;


- (id)initWithDelegate:(id<NSStreamDelegate>)aDelegate {
    if (self = [super init]) {
        self->delegate = aDelegate;
        _isCconnected = NO;
    }
    return self;
}


- (void)connectToServerWithIPAddress:(NSString*)ipAddress {
    NSLog(@"connecting to %@", ipAddress);
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    
    CFStreamCreatePairWithSocketToHost(NULL, (__bridge CFStringRef)ipAddress, PORT, &readStream, &writeStream);
    
    self.inputStream = (NSInputStream*)CFBridgingRelease(readStream);
    self.outputStream = (NSOutputStream*)CFBridgingRelease(writeStream);
    
    [self.inputStream setDelegate: delegate];
    [self.outputStream setDelegate: delegate];
    
    [self.inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [self.outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
    [self.inputStream open];
    [self.outputStream open];
    
    
    NSLog(@"opened with status %lu and error %@", (unsigned long)[self.inputStream streamStatus], [self.inputStream streamError]);
    _isCconnected = YES;
}


- (void)disconnect {
    [self->inputStream close];
    [self->outputStream close];
    NSLog(@"%@", @"closed");
    _isCconnected = NO;
}


- (BOOL)isConnected {
    return _isCconnected;
}

@end
