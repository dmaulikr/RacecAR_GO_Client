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
        // start connection to server
        let defaults = NSUserDefaults.standardUserDefaults()
        let playerName = defaults.stringForKey(SettingsViewController.PLAYER_NAME_KEY)
        let serverAddress = defaults.stringForKey(SettingsViewController.SERVER_ADDRESS_KEY)
        if let _ = playerName, let serverAddress = serverAddress {
            TCPSocketRequester.defaultRequester().addSocketStatusDelegate(self)
            TCPSocketRequester.defaultRequester().connectToServerWithIP(serverAddress)
        } else {
            menuItemSelected("ShowSettings")
        }
        
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
        performSegueWithIdentifier(identifier, sender: self)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        
//        self.roo segue.destinationViewController
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



extension GameNavigationController: TCPSocketStatusDelegate {
    func statusUpdate(status: String!) {
        self.navigationItem.rightBarButtonItem?.title = status;
    }
    
    
    func didOpen() {
        // wait a little before sending name. Does not send otherwise
        NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: #selector(GameNavigationController.sendPlayerName), userInfo: nil, repeats: false)
    }
    
    
    func sendPlayerName() {
        let playerNameRequest = PlayerNameRequest()
        playerNameRequest.start()
    }
}
