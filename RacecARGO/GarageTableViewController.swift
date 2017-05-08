//
//  GarageTableViewController.swift
//  RacecARGO
//
//  Created by Johannes Heucher on 07.05.17.
//  Copyright © 2017 Johannes Heucher. All rights reserved.
//

import UIKit

class GarageTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GarageController.sharedInstance.vehicles.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("vehicleCell", forIndexPath: indexPath)
        
        let makeModel = GarageController.sharedInstance.vehicles[indexPath.row].makeModel
        cell.textLabel?.text = makeModel
        cell.imageView?.image = UIImage(named: makeModel)
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let card = segue.destinationViewController as? VehicleCardViewController {
            if let row = tableView.indexPathForSelectedRow?.row {
                card.vehicle = GarageController.sharedInstance.vehicles[row]
            }
        }
    }

}



extension GarageTableViewController: TCPSocketStatusDelegate {
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
    }
}
