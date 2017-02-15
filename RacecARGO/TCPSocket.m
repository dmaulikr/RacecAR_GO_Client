//
//  TCPSocket.m
//  RacecARGO
//
//  Created by Johannes Heucher on 04.02.17.
//  Copyright © 2017 Johannes Heucher. All rights reserved.
//

#import "TCPSocket.h"

//#define ADDRESS @"95.88.122.103"
#define ADDRESS @"192.168.1.105"
#define PORT 1234

@implementation TCPSocket

@synthesize inputStream, outputStream;


- (id)initWithDelegate:(id<NSStreamDelegate>)aDelegate {
    if (self = [super init]) {
        self->delegate = aDelegate;
        [self connect];
    }
    return self;
}


- (void)connect {
    NSLog(@"%@", @"connecting");
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    
    CFStreamCreatePairWithSocketToHost(NULL, (CFStringRef)ADDRESS, PORT, &readStream, &writeStream);
    
    self.inputStream = (NSInputStream*)CFBridgingRelease(readStream);
    self.outputStream = (NSOutputStream*)CFBridgingRelease(writeStream);
    
    [self.inputStream setDelegate: delegate];
    [self.outputStream setDelegate: delegate];
    
    [self.inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [self.outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
    [self.inputStream open];
    [self.outputStream open];
    NSLog(@"%@", @"opened");
}


- (void)disconnect {
    [self->inputStream close];
    [self->outputStream close];
    NSLog(@"%@", @"closed");
}

@end
