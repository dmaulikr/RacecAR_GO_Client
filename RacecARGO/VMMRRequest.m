//
//  VMMRRequest.m
//  RacecARGO
//
//  Created by Johannes Heucher on 07.02.17.
//  Copyright © 2017 Johannes Heucher. All rights reserved.
//

#import "VMMRRequest.h"
#import "Const.h"

@implementation VMMRRequest


- (NSNumber*)messageId {
    return [NSNumber numberWithUnsignedChar:MESSAGE_ID_VMMR];
}


- (void)startWithDescriptors:(const uint8_t*)descriptors withRows:(int)rows andCols:(int)cols {
    // TODO DEBUG
    NSMutableData* message = [NSMutableData dataWithCapacity:rows * cols /*+ sizeof(rows) + sizeof(cols)*/];
    
    so wird zumindest manchmal das korrekte Bild übertragen. Warum nicht immer?
    Ist die gesendete Größe konstant? Da ja der Server von einer konstanten ausgeht.
    Sind vllt noch Reste im InputStream übrig, die beim nächsten Mal mitgelesen werden?
    Gesendete roi auch mal auf dem Device anzeigen
    
    // TODO DEBUG
    // append 4 bytes each for rows and cols
//    [message appendBytes:&rows length:sizeof(rows)];
//    [message appendBytes:&cols length:sizeof(cols)];
    
    // append data
    [message appendBytes:descriptors length:rows * cols];
    
    [super startWithMessage:message];
}

@end
