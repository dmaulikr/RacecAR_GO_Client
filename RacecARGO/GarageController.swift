//
//  GarageController.swift
//  RacecARGO
//
//  Created by Johannes Heucher on 06.05.17.
//  Copyright © 2017 Johannes Heucher. All rights reserved.
//

import UIKit

class GarageController: NSObject {
    static let sharedInstance = GarageController()
    
    private let VEHICLES_KEY = "VEHICLES"
    private let MAKE_MODEL_SEPARATOR = "$"
    
    private var _vehicles: [Vehicle] = []
    var vehicles: [Vehicle] {
        get {
            return _vehicles
        }
    }
    
    
    override init () {
        super.init()
        
        // read already collected vehicles from storage
        // addVehicle(withMake: make, andModel: model, addToStorage: false)
        let defaults = NSUserDefaults.standardUserDefaults()
        if let vehicleStrings = defaults.stringArrayForKey(VEHICLES_KEY) {
            for makeModelString in vehicleStrings {
                let makeModel = makeModelString.componentsSeparatedByString("$")
                addVehicle(withMake: makeModel[0], andModel: makeModel[1], addToStorage: false)
            }
        }
    }
    
    
    private func addVehicle(withMake make: String, andModel model: String, addToStorage: Bool) {
        _vehicles.append(Vehicle(withMake: make, andModel: model))
        
        if addToStorage {
            let defaults = NSUserDefaults.standardUserDefaults()
            var vehicleStrings = defaults.stringArrayForKey(VEHICLES_KEY)
            if (vehicleStrings == nil) {
                vehicleStrings = []
            }
            vehicleStrings?.append(make + MAKE_MODEL_SEPARATOR + model)
            defaults.setObject(vehicleStrings, forKey: VEHICLES_KEY)
        }
    }
    
    
    func addVehicle(withMake make: String, andModel model: String) {
        addVehicle(withMake: make, andModel: model, addToStorage: true)
    }
}
