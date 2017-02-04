//
//  TCPSocketRequester.m
//  RacecARGO
//
//  Created by Johannes Heucher on 04.02.17.
//  Copyright © 2017 Johannes Heucher. All rights reserved.
//

#import "TCPSocketRequester.h"

@implementation TCPSocketRequester

- (id)init {
    if (self = [super init]) {
        self->socket = [[TCPSocket alloc] initWithDelegate:self];
    }
    return self;
}


- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode {
    switch (eventCode) {
        case NSStreamEventErrorOccurred:
            NSLog(@"ErrorOccurred");
        case NSStreamEventEndEncountered:
            NSLog(@"EndEncountered");
        case NSStreamEventNone:
            NSLog(@"None");
        case NSStreamEventHasBytesAvailable:
            NSLog(@"HasBytesAvailable");
            uint8_t buffer[4096];
            if (aStream == self->socket.inputStream) {
                NSInputStream* stream = self->socket.inputStream;
                while (stream.hasBytesAvailable) {
                    NSInteger len = [stream read:buffer maxLength:sizeof(buffer)];
                    if (len > 0) {
                        NSString* output = [[NSString alloc] initWithBytes:buffer length:len encoding:NSASCIIStringEncoding];
                        if (output != nil) {
                            NSLog(@"server said: %@", output);
                        }
                    } else {
                        NSLog(@"empty string from stream");
                    }
                }
            }
        case NSStreamEventOpenCompleted:
            NSLog(@"OpenCompleted");
        case NSStreamEventHasSpaceAvailable:
            NSLog(@"HasSpaceAvailable");
        default: NSLog(@"default reached. unknown stream event");
    }
}

@end
