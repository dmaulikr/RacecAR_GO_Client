//
//  LocationController.swift
//  RacecARGO
//
//  Created by Johannes Heucher on 01.05.17.
//  Copyright © 2017 Johannes Heucher. All rights reserved.
//

import UIKit
import CoreLocation

class LocationController: NSObject, CLLocationManagerDelegate {
    var locationManager: CLLocationManager!
    
    override init () {
        super.init()
        
        locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        
//        locationManager = CLLocationManager()
//        locationManager?.delegate = self
//        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager?.distanceFilter = kCLDistanceFilterNone
//        locationManager?.requestWhenInUseAuthorization()
//        locationManager?.startUpdatingLocation()
    }
    
//    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
//        print(error)
//    }
//    
//    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        print(locations)
//    }
//    
//    
//    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
//        print(status)
//    }
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            print(NSString(format: "%f, %f\n", location.coordinate.latitude, location.coordinate.longitude))
        }
    }
    
    
//    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
//        NSLog("%d", status.rawValue)
//    }
}



//extension LocationController: CLLocationManagerDelegate {
//    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        if let location = locations.last {
//            NSLog("%f, %f", location.coordinate.latitude, location.coordinate.longitude)
//        }
//    }
//}
