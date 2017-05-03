//
//  MenuTableViewController.swift
//  RacecARGO
//
//  Created by Johannes Heucher on 28.04.17.
//  Copyright © 2017 Johannes Heucher. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation


class GameNavigationController: UINavigationController {
    var locationManager: CLLocationManager?
    var lastSentLocation: CLLocation?
    var locationRequest: LocationRequest?
    
    override func viewDidLoad() {
        // start location tracking
        locationManager = CLLocationManager()
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.distanceFilter = kCLDistanceFilterNone
        locationManager?.delegate = self
        locationManager?.startUpdatingLocation()
        
        locationRequest = LocationRequest()
    }
}



extension GameNavigationController: MenuItemSelectedDelegate {
    func menuItemSelected(identifier: String) {
        popViewControllerAnimated(false)
        performSegueWithIdentifier(identifier, sender: self)
    }
}



extension GameNavigationController: CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            
            print(NSString(format: "%f, %f\n", latitude, longitude))
            
            let MIN_STEP: CLLocationDistance = 0.0001
            if lastSentLocation == nil || lastSentLocation?.distanceFromLocation(location) > MIN_STEP {
                locationRequest?.startWith(latitude: latitude, andLongitude: longitude)
                lastSentLocation = location
            }
        }
    }
}
