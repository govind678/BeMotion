//
//  SharedLibraryViewController.h
//  SharedLibrary
//
//  Created by Govinda Ram Pingali on 3/8/14.
//  Copyright (c) 2014 GTCMT. All rights reserved.
//

#import  <UIKit/UIKit.h>
#include "GestureControllerInterface.h"
#import  "UserInterfaceData.h"
#import  "EffectSettingsViewController.h"
#import <CoreMotion/CoreMotion.h>

@interface SharedLibraryViewController : UIViewController
{
    GestureControllerInterface*     backEndInterface;
    
    bool m_bRedButtonToggleStatus;  // is red button pressed
    bool m_bBlueButtonToggleStatus; // is blue button pressed
    bool m_bModeToggleStatus;       // if settings mode, segue to effectSettings scene, else start playback
}


@property (strong, nonatomic) CMMotionManager *motionManager;

- (void)motionDeviceUpdate: (CMDeviceMotion*) deviceMotion;

- (void)processUserAcceleration: (CMAcceleration) userAcceleration;

//@property (retain, nonatomic) IBOutlet UIButton *toggleAudioButton;
//- (IBAction)toggleAudioButtonClicked:(UIButton *)sender;
//
//
//- (IBAction)addEffectButtonClicked:(UIButton *)sender;

@end
