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
        let identifier: String?
        switch indexPath.row {
        case 0:
            identifier = "ShowCapture"
            break
        case 1:
            identifier = "ShowGarage"
            break
        default:
            identifier = "ShowSettings"
            break
        }
        
        if let delegate = delegate, let identifier = identifier {
            delegate.menuItemSelected(identifier)
            
            if let gameController = delegate as? GameNavigationController {
                splitViewController?.showDetailViewController(gameController, sender: nil)
            }
        }
    }
}
