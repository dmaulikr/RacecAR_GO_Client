//
//  SettingsViewController.swift
//  RacecARGO
//
//  Created by Johannes Heucher on 28.04.17.
//  Copyright © 2017 Johannes Heucher. All rights reserved.
//

import Foundation


class SettingsViewController: UITableViewController {
    @IBOutlet weak var playerNameInput: UITextField?
    @IBOutlet weak var serverAddressInput: UITextField?
    
    private let PLAYER_NAME_KEY = "PLAYER_NAME"
    private let SERVER_ADDRESS_KEY = "SERVER_ADDRESS"
    
    
    override func viewDidLoad() {
        let defaults = NSUserDefaults.standardUserDefaults()
        if let playerName = defaults.stringForKey(PLAYER_NAME_KEY) {
            playerNameInput?.text = playerName
            playerNameInput?.enabled = false
        }
        
        if let serverAddress = defaults.stringForKey(SERVER_ADDRESS_KEY) {
            serverAddressInput?.text = serverAddress
        }
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 2 {
            let address = serverAddressInput?.text
            TCPSocketRequester.defaultRequester().connectToServerWithIP(address)
        }
    }
    
    
    
    @IBAction func playerNameEditingDidEnd() {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setValue(playerNameInput?.text, forKey: PLAYER_NAME_KEY)
        playerNameInput?.enabled = false
    }
    
    
    @IBAction func serverAddressEditingDidEnd() {
        let defaults = NSUserDefaults.standardUserDefaults()
        let address = serverAddressInput?.text
        defaults.setValue(address, forKey: SERVER_ADDRESS_KEY)
    }
}



extension SettingsViewController: TCPSocketStatusDelegate {
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        TCPSocketRequester.defaultRequester().addSocketStatusDelegate(self)
    }
    
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        TCPSocketRequester.defaultRequester().removeSocketStatusDelegate(self)
    }
    
    
    func statusUpdate(status: String!) {
        self.navigationItem.rightBarButtonItem?.title = status;
    }
}
