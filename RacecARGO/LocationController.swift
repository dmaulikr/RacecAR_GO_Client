//
//  LocationController.swift
//  RacecARGO
//
//  Created by Johannes Heucher on 01.05.17.
//  Copyright © 2017 Johannes Heucher. All rights reserved.
//

import UIKit
import CoreLocation

class LocationController: NSObject {
    var locationManager: CLLocationManager
    
    override init () {
        locationManager = CLLocationManager()
        super.init()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        locationManager.requestWhenInUseAuthorization()
    }
}



extension LocationController: CLLocationManagerDelegate {
    @objc func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            NSLog("%f, %f", location.coordinate.latitude, location.coordinate.longitude)
        }
    }
}
