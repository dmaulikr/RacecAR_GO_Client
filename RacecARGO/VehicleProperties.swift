//
//  VehicleProperties.swift
//  RacecARGO
//
//  Created by Johannes Heucher on 06.05.17.
//  Copyright © 2017 Johannes Heucher. All rights reserved.
//

import UIKit

class VehicleProperties: NSObject {
    var kW: Int
    var weight: Int
    var emission: Int
    var maxSpeed: Int
    var maxDistance: Int
    var numberOfClowns: Int
    
    
    private init (kW: Int, weight: Int, emission: Int, maxSpeed: Int, maxDistance: Int, numberOfClowns: Int) {
        self.kW = kW
        self.weight = weight
        self.emission = emission
        self.maxSpeed = maxSpeed
        self.maxDistance = maxDistance
        self.numberOfClowns = numberOfClowns
    }
    
    
    static func properties(forMakeModel makeModel: String) -> VehicleProperties {
        return VehicleProperties.defaultProperties[makeModel] ?? VehicleProperties.defaultProperties["default"]!
    }
    
    
    private static let defaultProperties: [String:VehicleProperties] = [
        "vw kaefer" :       VehicleProperties(kW: 22, weight: 750, emission: 8, maxSpeed: 112, maxDistance: 400, numberOfClowns: 9),
        "vw polo 9n3":      VehicleProperties(kW: 96, weight: 1150, emission: 10, maxSpeed: 205, maxDistance: 800, numberOfClowns: 5),
        "vw golf iv":       VehicleProperties(kW: 55, weight: 1200, emission: 5, maxSpeed: 170, maxDistance: 650, numberOfClowns: 5),
        "tesla model s":    VehicleProperties(kW: 310, weight: 2000, emission: 0, maxSpeed: 250, maxDistance: 557, numberOfClowns: 0),
        "opel corsa d":     VehicleProperties(kW: 54, weight: 1200, emission: 2, maxSpeed: 180, maxDistance: 760, numberOfClowns: 6),
        "porsche 911":      VehicleProperties(kW: 294, weight: 1420, emission: 9, maxSpeed: 304, maxDistance: 800, numberOfClowns: 2),
        "opel mokka":       VehicleProperties(kW: 71, weight: 1410, emission: 4, maxSpeed: 190, maxDistance: 720, numberOfClowns: 4),
        "default":          VehicleProperties(kW: 50, weight: 1310, emission: 3, maxSpeed: 174, maxDistance: 680, numberOfClowns: 3),
    ]
}
