//
//  TCPSocketRequester.m
//  RacecARGO
//
//  Created by Johannes Heucher on 04.02.17.
//  Copyright © 2017 Johannes Heucher. All rights reserved.
//

#import "TCPSocketRequester.h"

#define CHAR_0 48

@interface TCPSocketRequester () {
    /**
     * Delegates by message ID
     */
    NSMutableDictionary<NSNumber*, id<TCPSocketResponseDelegate>>* delegates;
    
    uint8_t messageBuffer[4096];
    NSInteger currentMessageLength;
    uint16_t expectedMessageLength;
}
- (void)parseBuffer:(uint8_t*)buffer withLength:(NSInteger)length;
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
        currentMessageLength = 0;
        expectedMessageLength = 0;
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
            break;
        case NSStreamEventEndEncountered:
            NSLog(@"EndEncountered");
            break;
        case NSStreamEventNone:
            NSLog(@"None");
            break;
        case NSStreamEventHasBytesAvailable:
            NSLog(@"HasBytesAvailable");
            
            if (aStream == socket.inputStream) {
                NSInputStream* stream = self->socket.inputStream;
                while (stream.hasBytesAvailable) {
                    
                    // messages don't always arrive in one piece
                    uint8_t buffer[4096];
                    NSInteger len = [stream read:buffer maxLength:sizeof(buffer)];
                    if (len > 0) {
                        uint8_t* bufferPtr;
                        if (currentMessageLength == 0) {
                            // currentMessageLength == 0 means new message arrives, so read its real length
                            expectedMessageLength = (uint16_t)(buffer[0] << 8 | buffer[1]);
                            // skip first two bytes which contain expected length
                            bufferPtr = &buffer[2];
                            len -= 2;
                        } else {
                            bufferPtr = buffer;
                        }
                        // add buffer to stored buffer at position currentLength
                        if (len > 0) {
                            memcpy(&messageBuffer[currentMessageLength], bufferPtr, len);
                            currentMessageLength += len;
                        }
                        
                        // parse message if it is complete
                        if (currentMessageLength == expectedMessageLength) {
                            [self parseBuffer:messageBuffer withLength:currentMessageLength];
                            currentMessageLength = 0;
                            expectedMessageLength = 0;
                        }
                    } else {
                        NSLog(@"empty string from stream");
                    }
                }
            }
            break;
        case NSStreamEventOpenCompleted:
            NSLog(@"OpenCompleted");
            break;
        case NSStreamEventHasSpaceAvailable:
            NSLog(@"HasSpaceAvailable");
            break;
        default: NSLog(@"default reached. unknown stream event");
    }
}


- (void)parseBuffer:(uint8_t*)buffer withLength:(NSInteger)length {
    // read message length
    
    
    // read message ID (first byte)
    uint8_t messageId = buffer[0] - CHAR_0;
    NSNumber* delegateKey = [NSNumber numberWithUnsignedChar:messageId];
    id<TCPSocketResponseDelegate> delegate = [delegates objectForKey:delegateKey];
    
    // inform delegate with that ID
    if (delegate != nil) {
        [delegate receivedMessage:[NSData dataWithBytes:&buffer[1] length:length - 1]];
    }
//    NSString* output = [[NSString alloc] initWithBytes:buffer length:len encoding:NSASCIIStringEncoding];
//    if (output != nil) {
//        NSLog(@"server said: %@", output);
//    }
}

@end
