//
//  LocationRequest.swift
//  RacecARGO
//
//  Created by Johannes Heucher on 01.05.17.
//  Copyright © 2017 Johannes Heucher. All rights reserved.
//

import UIKit
import CoreLocation

class LocationRequest: TCPRequest {
    override func messageId() -> NSNumber! {
        return NSNumber(int: MESSAGE_ID_GPS)
    }
    
    
    func startWith(latitude latitude: CLLocationDegrees, andLongitude longitude: CLLocationDegrees) {
        
        // Quirk fix: Because there has been trouble with sending Doubles, send Ints
        let message = NSMutableData(capacity: 2 * sizeof(Int32))
        
        var lat: Int32 = Int32(latitude * 1e6)
        var lon: Int32 = Int32(longitude * 1e6)
        message?.appendBytes(&lat, length: sizeof(Int32))
        message?.appendBytes(&lon, length: sizeof(Int32))
        
        //print(NSString(format: "send lat, lon: (%.4f, %.4f)", lat, lon))
        print(NSString(format: "send lat, lon: (%d, %d)", lat, lon))
        super.startWithMessage(message)
        
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
