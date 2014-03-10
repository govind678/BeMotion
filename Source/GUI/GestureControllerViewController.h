//
//  TransducerMusicViewController.h
//  TransducerMusic
//
//  Created by Govinda Ram Pingali on 11/10/13.
//  Copyright (c) 2013 GTCMT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>
#include "OSCCom.h"


@interface TransducerMusicViewController : UIViewController
{
    OSCCom *osc;
    
    NSString* hostIPAddress;
    int oscPortNumber;
    
    UIColor* blackColour;
    UIColor* redColour;
    UIColor* greenColour;
    UIColor* blueColour;
    UIColor* yellowColour;

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
