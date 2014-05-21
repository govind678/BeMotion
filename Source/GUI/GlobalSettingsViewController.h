//==============================================================================
//
//  GlobalSettingsViewController.h
//  BeMotion
//
//  Created by Govinda Ram Pingali on 4/10/14.
//  Copyright (c) 2014 BeMotionLLC. All rights reserved.
//
//==============================================================================


#import <UIKit/UIKit.h>
#include "BeMotionInterface.h"
#include "Metronome.h"
#include "Macros.h"

@interface GlobalSettingsViewController : UIViewController
{
    float       m_iTempo;
    int         m_iCurrentPresetBank;
    
    
    NSString *sample1Path;
    NSString *sample2Path;
    NSString *sample3Path;
    NSString *sample4Path;
    NSString *sample5Path;
}


@property (nonatomic, assign) BeMotionInterface* backendInterface;
@property (nonatomic, assign) Metronome* metronome;

//--- Tempo Settings ---//
@property (retain, nonatomic) IBOutlet UISlider *tempoSlider;
- (IBAction)tempoSliderChanged:(UISlider *)sender;
@property (retain, nonatomic) IBOutlet UILabel *tempoLabel;



- (void) updatePresetButton;

//--- Preset Load Buttons ---//

- (IBAction)presetClicked1:(UIButton *)sender;
- (IBAction)presetClicked2:(UIButton *)sender;
- (IBAction)presetClicked3:(UIButton *)sender;
- (IBAction)presetClicked4:(UIButton *)sender;
- (IBAction)presetClicked5:(UIButton *)sender;
- (IBAction)presetClicked6:(UIButton *)sender;
- (IBAction)presetClicked7:(UIButton *)sender;


@property (retain, nonatomic) IBOutlet UIButton *presetButton1;
@property (retain, nonatomic) IBOutlet UIButton *presetButton2;
@property (retain, nonatomic) IBOutlet UIButton *presetButton3;
@property (retain, nonatomic) IBOutlet UIButton *presetButton4;
@property (retain, nonatomic) IBOutlet UIButton *presetButton5;
@property (retain, nonatomic) IBOutlet UIButton *presetButton6;
@property (retain, nonatomic) IBOutlet UIButton *presetButton7;



@end
