//
//  GestureControllerViewController.h
//  GestureController
//
//  Created by Govinda Ram Pingali on 11/10/13.
//  Copyright (c) 2013 GTCMT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>
#include "GestureControllerInterface.h"

@interface GestureControllerViewController : UIViewController
{
    UIColor* blackColour;
    UIColor* redColour;
    UIColor* greenColour;
    UIColor* blueColour;
    UIColor* yellowColour;
    
    GestureControllerInterface*     backEndInterface;
    
    bool m_bAudioToggleStatus_1;
    bool m_bAudioToggleStatus_2;
    
    int m_iAudioEffectsStatus_1;
    int m_iAudioEffectsStatus_2;
}


//--- Motion Processing ---//

@property (strong, nonatomic) CMMotionManager *motionManager;

- (void)motionDeviceUpdate: (CMDeviceMotion*) deviceMotion;

- (void)processUserAcceleration: (CMAcceleration) userAcceleration;



//--- UI Actions ---//

- (UIColor*)colorFromHexString : (NSString*)hexString;

- (IBAction)redButtonDown:(UIButton *)sender;
- (IBAction)redButtonUp:(UIButton *)sender;

- (IBAction)greenButtonDown:(UIButton *)sender;
- (IBAction)greenButtonUp:(UIButton *)sender;

- (IBAction)blueButtonDown:(id)sender;
- (IBAction)blueButtonUp:(UIButton *)sender;

- (IBAction)yellowButtonDown:(UIButton *)sender;
- (IBAction)yellowButtonUp:(UIButton *)sender;


@end
