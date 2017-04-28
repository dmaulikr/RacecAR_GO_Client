//
//  OpenCVCameraViewController.h
//  RacecARGO
//
//  Created by Johannes Heucher on 01.02.17.
//  Copyright © 2017 Johannes Heucher. All rights reserved.
//

#import <UIKit/UIKit.h>


#import <SceneKit/SceneKit.h>
#import <ModelIO/ModelIO.h>
#import <SceneKit/ModelIO.h>


@interface OpenCVCameraViewController : UIViewController {
    IBOutlet UIImageView* imageView;
    IBOutlet SCNView* sceneView;
    IBOutlet UILabel* makeModelLabel;
}

- (IBAction)start:(id)sender;
- (IBAction)stop:(id)sender;
- (IBAction)capture:(id)sender;

@end
