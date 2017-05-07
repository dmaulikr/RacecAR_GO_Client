//
//  VehicleCardViewController.swift
//  RacecARGO
//
//  Created by Johannes Heucher on 07.05.17.
//  Copyright © 2017 Johannes Heucher. All rights reserved.
//

import UIKit

class VehicleCardViewController: UIViewController {
    @IBOutlet var vehicleView: SCNView?
    @IBOutlet var kW: UILabel?
    @IBOutlet var weight: UILabel?
    @IBOutlet var emission: UILabel?
    @IBOutlet var maxSpeed: UILabel?
    @IBOutlet var maxDistance: UILabel?
    @IBOutlet var numberOfClowns: UILabel?
    
    private var _makeModel: String?
    var makeModel: String? {
        get {
            return _makeModel
        }
        set (value) {
            _makeModel = value
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        //
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
