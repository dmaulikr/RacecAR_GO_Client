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
        } else {
            // insert address that is valid for 2017-05-07
            serverAddressInput?.text = "91.67.233.112"
        }
        
        connect()
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 2 {
            connect()
        }
    }
    
    
    func connect() {
        if let address = serverAddressInput?.text, playerName = playerNameInput?.text where address.characters.count > 0 && playerName.characters.count > 0 {
            TCPSocketRequester.defaultRequester().connectToServerWithIP(address)
        } else {
            let alert = UIAlertController(title: "Unable to connect", message: "First type in a valid player name and a server address.", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "OK", style: .Default, handler: { action in
                alert.dismissViewControllerAnimated(true, completion: nil)
            })
            alert.addAction(okAction)
            self.presentViewController(alert, animated: true, completion: nil)
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
    
    
    func didOpen() {
        // wait a little before sending name. Does not send otherwise
        NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: #selector(SettingsViewController.sendPlayerName), userInfo: nil, repeats: false)
    }
    
    
    func sendPlayerName() {
        let playerNameRequest = PlayerNameRequest()
        playerNameRequest.startWithName(playerNameInput?.text)
    }
}
