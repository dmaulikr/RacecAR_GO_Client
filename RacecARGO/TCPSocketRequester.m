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
        
        // connect to IP address stored in user defaults
        NSString* address = [[NSUserDefaults standardUserDefaults] stringForKey:@"SERVER_ADDRESS"];
        
        if (address != nil && address.length > 0) {
            [self connectToServerWithIP:address];
        }
        delegates = [NSMutableDictionary dictionary];
        currentMessageLength = 0;
        expectedMessageLength = 0;
    }
    return self;
}


- (void)connectToServerWithIP:(NSString*)ipAddress {
    if ([socket isConnected]) {
        [socket disconnect];
    }
    [socket connectToServerWithIPAddress:ipAddress];
}


- (void)sendMessage:(NSData*)message withDelegate:(id<TCPSocketResponseDelegate>)delegate {
    if ([socket isConnected]) {
        [delegates setObject:delegate forKey:[delegate messageId]];
        [socket.outputStream write:[message bytes] maxLength: [message length]];
    } else {
        NSLog(@"ERROR: Trying to send message whereas socket is not connected!");
    }
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
                    NSLog(@"length: %ld", len);
                    if (len > 0) {
                        // append read bytes to message buffer
                        memcpy(&messageBuffer[currentMessageLength], buffer, len);
                        currentMessageLength += len;
                        
                        if (expectedMessageLength == 0 && currentMessageLength >= 2) {
                            // read length of message (2 bytes)
                            // (not necessarily read with first package of message, if first
                            // package is just one byte)
                            expectedMessageLength = (uint16_t)(messageBuffer[0] << 8 | messageBuffer[1]);
                        }
                        
                        // parse message if it is complete
                        if (currentMessageLength == expectedMessageLength) {
                            [self parseBuffer:&messageBuffer[2] withLength:currentMessageLength - 2];
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
