//
//  GlobalSettingsViewController.h
//  GestureController
//
//  Created by Govinda Ram Pingali on 4/10/14.
//  Copyright (c) 2014 GTCMT. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "GestureControllerInterface.h"
#include "Metronome.h"
#include "Macros.h"

@interface GlobalSettingsViewController : UIViewController
{
    float       m_iTempo;
    int         m_iCurrentPresetBank;
}


@property (nonatomic, assign) GestureControllerInterface* backendInterface;
@property (nonatomic, assign) Metronome* metronome;

//--- Tempo Settings ---//
@property (retain, nonatomic) IBOutlet UISlider *tempoSlider;
- (IBAction)tempoSliderChanged:(UISlider *)sender;
@property (retain, nonatomic) IBOutlet UILabel *tempoLabel;

//--- Preset Bank Settings ---//
@property (retain, nonatomic) IBOutlet UISegmentedControl *presetBankSelector;
- (IBAction)presetSampleBankLoader:(UISegmentedControl *)sender;


@end
