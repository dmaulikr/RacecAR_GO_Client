//
//  TCPSocketRequester.h
//  RacecARGO
//
//  Created by Johannes Heucher on 04.02.17.
//  Copyright © 2017 Johannes Heucher. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TCPSocket.h"

@interface TCPSocketRequester : NSObject <NSStreamDelegate> {
    TCPSocket* socket;
}

@end
