//
//  Vehicle.swift
//  RacecARGO
//
//  Created by Johannes Heucher on 06.05.17.
//  Copyright © 2017 Johannes Heucher. All rights reserved.
//

import UIKit

class Vehicle: NSObject {
    private var _make: String
    private var _model: String
    private var _properties: VehicleProperties
    
    var makeModel: String {
        get { return _make + " " + _model }
    }
    
    
    init (withMake make: String, andModel model: String) {
        _make = make
        _model = model
        _properties = VehicleProperties.properties(forMakeModel: make + " " + model)
        
        super.init()
    }
}
