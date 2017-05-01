//
//  MenuTableViewController.swift
//  RacecARGO
//
//  Created by Johannes Heucher on 28.04.17.
//  Copyright © 2017 Johannes Heucher. All rights reserved.
//

import Foundation
import UIKit;


class GameNavigationController: UINavigationController {
    override func viewDidLoad() {
        // start location tracking
        _ = LocationController()
    }
}


extension GameNavigationController: MenuItemSelectedDelegate {
    func menuItemSelected(identifier: String) {
        popViewControllerAnimated(false)
        performSegueWithIdentifier(identifier, sender: self)
    }
}
