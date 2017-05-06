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
    
    private let vehicles: [Vehicle] = []
    
    
    override init () {
        
        // read already collected vehicles from storage
        // addVehicle(withMake: make, andModel: model, addToStorage: false)
    }
    
    
    private func addVehicle(withMake make: String, andModel model: String, addToStorage: Bool) {
        
    }
    
    
    private func addVehicle(withMake make: String, andModel model: String) {
        addVehicle(withMake: make, andModel: model, addToStorage: true)
    }
}
