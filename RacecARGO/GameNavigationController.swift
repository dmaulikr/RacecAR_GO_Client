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
    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        // start location tracking
        locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
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
            print(NSString(format: "%f, %f\n", location.coordinate.latitude, location.coordinate.longitude))
        }
    }
}
