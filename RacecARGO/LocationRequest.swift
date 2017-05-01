//
//  LocationRequest.swift
//  RacecARGO
//
//  Created by Johannes Heucher on 01.05.17.
//  Copyright © 2017 Johannes Heucher. All rights reserved.
//

import UIKit

class LocationRequest: TCPRequest {
    override func messageId() -> NSNumber! {
        return NSNumber(int: MESSAGE_ID_GPS)
    }
    
    
    func startWith(latitude latitude: float_t, andLongitude longitude: float_t) {
        /*
         uint16_t length = name.length;
         NSMutableData* message = [NSMutableData dataWithCapacity:name.length + sizeof(length)];
         
         // append number of bytes
         [message appendBytes:&length length:sizeof(length)];
         
         NSLog(@"sent name %@ with length %d", name, length);
         
         // append data
         //[message appendBytes:[name cStringUsingEncoding:NSUTF8StringEncoding] length:length];
         [message appendBytes:[name UTF8String] length:length];
         [super startWithMessage:message];
        */
    }
}
