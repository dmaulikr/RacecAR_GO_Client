//
//  TCPRequest.h
//  RacecARGO
//
//  Created by Johannes Heucher on 07.02.17.
//  Copyright © 2017 Johannes Heucher. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TCPSocketRequester.h"

@interface TCPRequest : NSObject <TCPSocketResponseDelegate>

- (void)startWithMessage:(NSData*)message;

@end
