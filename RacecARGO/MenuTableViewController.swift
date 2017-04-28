//
//  MenuTableViewController.swift
//  RacecARGO
//
//  Created by Johannes Heucher on 28.04.17.
//  Copyright © 2017 Johannes Heucher. All rights reserved.
//

import Foundation
import UIKit;


protocol MenuItemSelectedDelegate: class {
    func menuItemSelected(identifier: String)
}


class MenuTableViewController: UITableViewController {
    weak var delegate: MenuItemSelectedDelegate?
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let identifier = (indexPath.row == 0) ? "ShowCapture" : "ShowSettings"
        
        if let delegate = delegate {
            delegate.menuItemSelected(identifier)
            
            if let gameController = delegate as? GameNavigationController {
                splitViewController?.showDetailViewController(gameController, sender: nil)
            }
        }
    }
}
