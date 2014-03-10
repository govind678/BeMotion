//
//  SettingsViewController.h
//  TransducerMusic
//
//  Created by Govinda Ram Pingali on 11/13/13.
//  Copyright (c) 2013 GTCMT. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "OSCCom.h"

@interface SettingsViewController : UIViewController
{
    OSCCom *osc;
}


- (IBAction)masterGain:(UISlider *)sender;
@property (weak, nonatomic) IBOutlet UISlider *masterGainSlider;

- (IBAction)audioToggle:(UISwitch *)sender;
@property (weak, nonatomic) IBOutlet UISwitch *audioToggleSwitch;






@end
