//==============================================================================
//
//  GestureControllerViewController.h
//  GestureController
//
//  Created by Anand Mahadevan on 3/8/14.
//  Copyright (c) 2014 GTCMT. All rights reserved.
//
//==============================================================================


#import <UIKit/UIKit.h>
#include "GestureControllerInterface.h"

@interface GestureControllerViewController : UIViewController
{
    GestureControllerInterface*     backEndInterface;
    
    bool m_bAudioToggleStatus_1;
    bool m_bAudioToggleStatus_2;
    
    int m_iAudioEffectsStatus_1;
    int m_iAudioEffectsStatus_2;
    
    int m_iPlayRecordStatus;
}



@property (retain, nonatomic) IBOutlet UIButton *toggleAudioButton;
- (IBAction)toggleAudioButtonClicked:(UIButton *)sender;


- (IBAction)addEffectButtonClicked:(UIButton *)sender;

@property (retain, nonatomic) IBOutlet UIButton *removeEffectButton;
- (IBAction)removeEffectButtonClicked:(UIButton *)sender;

- (IBAction)playRecordButtonClicked:(UIButton *)sender;

@end
