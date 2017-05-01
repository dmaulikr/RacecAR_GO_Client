//
//  VMMRRequest.h
//  RacecARGO
//
//  Created by Johannes Heucher on 07.02.17.
//  Copyright © 2017 Johannes Heucher. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TCPRequest.h"


@interface PlayerNameRequest : TCPRequest

- (void)startWithName:(NSString*)name;

@end
