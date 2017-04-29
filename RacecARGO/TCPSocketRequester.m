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
     * Status delegates
     */
    NSMutableArray<id<TCPSocketStatusDelegate>>* statusDelegates;
    
    /**
     * Message delegates by message ID
     */
    NSMutableDictionary<NSNumber*, id<TCPSocketResponseDelegate>>* messageDelegates;
    
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
        statusDelegates = [NSMutableArray array];
        messageDelegates = [NSMutableDictionary dictionary];
        currentMessageLength = 0;
        expectedMessageLength = 0;
        
        // start timer to check socket status regularly
        [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(socketStatusTimerDidFire) userInfo:nil repeats:YES];
    }
    return self;
}


- (void)connectToServerWithIP:(NSString*)ipAddress {
    if ([socket isConnected]) {
        [socket disconnect];
    }
    [socket connectToServerWithIPAddress:ipAddress];
}


#pragma mark - Socket Status

- (NSArray*)socketStatusDelegates {
    return self->statusDelegates;
}


- (void)addSocketStatusDelegate:(id<TCPSocketStatusDelegate>)delegate {
    [self->statusDelegates addObject:delegate];
}


- (void)removeSocketStatusDelegate:(id<TCPSocketStatusDelegate>)delegate {
    [self->statusDelegates removeObject:delegate];
}


- (NSStreamStatus)socketStatus {
    return socket.inputStream.streamStatus;
}


- (void)socketStatusTimerDidFire {
    NSString* statusMessage;
    switch ([TCPSocketRequester defaultRequester].socketStatus) {
        case NSStreamStatusNotOpen:
            statusMessage = @"not open";
            break;
        case NSStreamStatusOpening:
            statusMessage = @"opening";
            break;
        case NSStreamStatusOpen:
            statusMessage = @"open";
            break;
        case NSStreamStatusReading:
            statusMessage = @"reading";
            break;
        case NSStreamStatusWriting:
            statusMessage = @"writing";
            break;
        case NSStreamStatusAtEnd:
            statusMessage = @"at end";
            break;
        case NSStreamStatusClosed:
            statusMessage = @"closed";
            break;
        case NSStreamStatusError:
            statusMessage = @"error";
            break;
        default:
            statusMessage = @"no valid status";
    }
    for (id<TCPSocketStatusDelegate> delegate in statusDelegates) {
        [delegate statusUpdate:statusMessage];
    }
}


#pragma mark - Send and Receive

- (void)sendMessage:(NSData*)message withDelegate:(id<TCPSocketResponseDelegate>)delegate {
    if ([socket isConnected]) {
        [messageDelegates setObject:delegate forKey:[delegate messageId]];
        [socket.outputStream write:[message bytes] maxLength: [message length]];
    } else {
        NSLog(@"ERROR: Trying to send message whereas socket is not connected!");
    }
}


- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode {
    switch (eventCode) {
        case NSStreamEventErrorOccurred:
            NSLog(@"ErrorOccurred");
            NSLog(@"status %lu and error %@", (unsigned long)[socket.inputStream streamStatus], [socket.inputStream streamError]);
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
    id<TCPSocketResponseDelegate> delegate = [messageDelegates objectForKey:delegateKey];
    
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
