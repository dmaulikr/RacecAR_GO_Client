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
    
    static let PLAYER_NAME_KEY = "PLAYER_NAME"
    static let SERVER_ADDRESS_KEY = "SERVER_ADDRESS"
    
    
    override func viewDidLoad() {
        let defaults = NSUserDefaults.standardUserDefaults()
        if let playerName = defaults.stringForKey(SettingsViewController.PLAYER_NAME_KEY) {
            playerNameInput?.text = playerName
            playerNameInput?.enabled = false
        }
        
        if let serverAddress = defaults.stringForKey(SettingsViewController.SERVER_ADDRESS_KEY) {
            serverAddressInput?.text = serverAddress
        } else {
            // insert address that is valid for 2017-05-07
            serverAddressInput?.text = "91.67.233.112"
            serverAddressEditingDidEnd()
        }
        
        self.view.backgroundColor = UIColor.blackColor()
        self.tableView.backgroundColor = UIColor.blackColor()
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAtIndexPath: indexPath)
        cell.textLabel?.textColor = UIColor.whiteColor()
        return cell
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 2 {
            connect()
        }
    }
    
    
    func connect() {
        if let address = serverAddressInput?.text, playerName = playerNameInput?.text where address.characters.count > 0 && playerName.characters.count > 0 {
            TCPSocketRequester.defaultRequester().connectToServerWithIP(address)
            playerNameInput?.enabled = false
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
        if playerNameInput?.text?.characters.count > 0 {
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setValue(playerNameInput?.text, forKey: SettingsViewController.PLAYER_NAME_KEY)
            playerNameInput?.enabled = false
        }
    }
    
    
    @IBAction func serverAddressEditingDidEnd() {
        let defaults = NSUserDefaults.standardUserDefaults()
        let address = serverAddressInput?.text
        defaults.setValue(address, forKey: SettingsViewController.SERVER_ADDRESS_KEY)
    }
}



extension SettingsViewController: TCPSocketStatusDelegate {
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        TCPSocketRequester.defaultRequester().addSocketStatusDelegate(self)
        
        // fix for menu navigation
        navigationController?.viewControllers = [self]
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
        playerNameRequest.start()
    }
}
