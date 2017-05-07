//
//  VehicleCardViewController.swift
//  RacecARGO
//
//  Created by Johannes Heucher on 07.05.17.
//  Copyright © 2017 Johannes Heucher. All rights reserved.
//

import UIKit
import SceneKit.ModelIO

class VehicleCardViewController: UIViewController {
    @IBOutlet var kW: UILabel?
    @IBOutlet var weight: UILabel?
    @IBOutlet var emission: UILabel?
    @IBOutlet var maxSpeed: UILabel?
    @IBOutlet var maxDistance: UILabel?
    @IBOutlet var numberOfClowns: UILabel?
    
    @IBOutlet var vehicleView: SCNView?
    private var scene: SCNScene?
    private var cameraNode: SCNNode?
    private var modelNode: SCNNode?
    
    private var _vehicle: Vehicle?
    var vehicle: Vehicle? {
        get {
            return _vehicle
        }
        set (value) {
            _vehicle = value
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cameraNode = SCNNode()
//        cameraNode.camera = [SCNCamera camera];
//        cameraNode.position = SCNVector3Make(0, 0.7f, 4.5f);
        
        scene = SCNScene()
//        [scene.rootNode addChildNode:cameraNode];
        
        vehicleView?.autoenablesDefaultLighting = true
        vehicleView?.allowsCameraControl = true
        vehicleView?.scene = scene
        vehicleView?.backgroundColor = UIColor.clearColor()
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if let vehicle = vehicle {
            kW?.text = String(format: "%d kW", vehicle.properties.kW ?? 0)
            weight?.text = String(format: "%d kg", vehicle.properties.weight ?? 0)
            emission?.text = String(format: "%d", vehicle.properties.emission ?? 0)
            maxSpeed?.text = String(format: "%d km/h", vehicle.properties.maxSpeed ?? 0)
            maxDistance?.text = String(format: "%d km", vehicle.properties.maxDistance ?? 0)
            numberOfClowns?.text = String(format: "%d", vehicle.properties.numberOfClowns ?? 0)
            
            // remove current model node
            if modelNode !== nil {
                modelNode?.removeFromParentNode()
            }
            
            // load and show respective model
            let filename = "Models/" + vehicle.make + "_" + vehicle.model
            let url = NSBundle.mainBundle().URLForResource(filename, withExtension: "obj")
            if let url = url {
                let asset = MDLAsset(URL: url)
                let mesh = asset.objectAtIndex(0)
                modelNode = SCNNode(MDLObject: mesh)
                if let modelNode = modelNode {
                    scene?.rootNode.addChildNode(modelNode)
                }
            }
        }
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
