//
//  TCPSocketRequester.m
//  RacecARGO
//
//  Created by Johannes Heucher on 04.02.17.
//  Copyright © 2017 Johannes Heucher. All rights reserved.
//

#import "TCPSocketRequester.h"

@interface TCPSocketRequester () {
    /**
     * Delegates by message ID
     */
    NSMutableDictionary<NSNumber*, id<TCPSocketResponseDelegate>>* delegates;
}
@end



@implementation TCPSocketRequester

+ (TCPSocketRequester*)defaultRequester {
    static TCPSocketRequester* sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[TCPSocketRequester alloc] init];
    });
    return sharedInstance;
}


- (id)init {
    if (self = [super init]) {
        socket = [[TCPSocket alloc] initWithDelegate:self];
        delegates = [NSMutableDictionary dictionary];
    }
    return self;
}


- (void)sendMessage:(NSData*)message withDelegate:(id<TCPSocketResponseDelegate>)delegate {
    [delegates setObject:delegate forKey:[delegate messageId]];
    [socket.outputStream write:[message bytes] maxLength: [message length]];
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
            if (aStream == socket.inputStream) {
                NSInputStream* stream = self->socket.inputStream;
                while (stream.hasBytesAvailable) {
                    NSInteger len = [stream read:buffer maxLength:sizeof(buffer)];
                    if (len > 0) {
                        // read message ID (first byte)
                        uint8_t messageId = buffer[0];
                        NSNumber* delegateKey = [NSNumber numberWithUnsignedChar:messageId];
                        id<TCPSocketResponseDelegate> delegate = [delegates objectForKey:delegateKey];
                        
                        // inform delegate with that ID
                        if (delegate != nil) {
                            [delegate receivedMessage:[NSData dataWithBytes:&buffer[1] length:len - 1]];
                        }
//                        NSString* output = [[NSString alloc] initWithBytes:buffer length:len encoding:NSASCIIStringEncoding];
//                        if (output != nil) {
//                            NSLog(@"server said: %@", output);
//                        }
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
