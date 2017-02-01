//
//  OpenCVCameraViewController.h
//  RacecARGO
//
//  Created by Johannes Heucher on 01.02.17.
//  Copyright © 2017 Johannes Heucher. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OpenCVCameraViewController : UIViewController {
    IBOutlet UIImageView* imageView;
}

- (IBAction)start:(id)sender;
- (IBAction)stop:(id)stop;

@end
