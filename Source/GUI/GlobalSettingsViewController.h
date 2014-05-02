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
    
    
    NSString *sample1Path;
    NSString *sample2Path;
    NSString *sample3Path;
    NSString *sample4Path;
    NSString *sample5Path;
}


@property (nonatomic, assign) GestureControllerInterface* backendInterface;
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


@property (retain, nonatomic) IBOutlet UIButton *presetButton1;
@property (retain, nonatomic) IBOutlet UIButton *presetButton2;
@property (retain, nonatomic) IBOutlet UIButton *presetButton3;
@property (retain, nonatomic) IBOutlet UIButton *presetButton4;
@property (retain, nonatomic) IBOutlet UIButton *presetButton5;
@property (retain, nonatomic) IBOutlet UIButton *presetButton6;



@end
