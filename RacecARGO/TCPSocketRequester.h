//
//  TCPSocketRequester.h
//  RacecARGO
//
//  Created by Johannes Heucher on 04.02.17.
//  Copyright © 2017 Johannes Heucher. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TCPSocket.h"


@protocol TCPSocketResponseDelegate
- (void)receivedMessage:(NSData*)message;
- (NSNumber*)messageId;
@end



@interface TCPSocketRequester : NSObject <NSStreamDelegate> {
    TCPSocket* socket;
}

@property (class, readonly, strong) TCPSocketRequester *defaultRequester;

- (void)connectToServerWithIP:(NSString*)ipAddress;
- (void)sendMessage:(NSData*)message withDelegate:(id<TCPSocketResponseDelegate>)delegate;

@end
