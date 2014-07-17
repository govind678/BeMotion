//==============================================================================
//
//  EffectSettingsViewController.h
//  BeMotion
//
//  Created by Anand Mahadevan on 3/9/14.
//  Copyright (c) 2014 BeMotionLLC. All rights reserved.
//
//============================================================================

#import  <UIKit/UIKit.h>
#import  <AVFoundation/AVFoundation.h>
#import  <CoreMedia/CoreMedia.h>

#include "BeMotionInterface.h"
#include "Macros.h"


@interface EffectSettingsViewController : UIViewController
{
    int                     buttonMode;
    NSMutableDictionary*    effectDict;
    NSArray*                effectNames;
}

@property (nonatomic, assign) BeMotionInterface* backendInterface;
@property (nonatomic, assign) int  currentSampleID;
@property (nonatomic, assign) int  currentEffectPosition;
@property (nonatomic, retain) NSMutableDictionary* effectDict;
@property (nonatomic, retain) NSArray* effectNames;


//--- UI Objects ---//

@property (retain, nonatomic) UIButton *triggerModeButton;
@property (retain, nonatomic) UIButton *loopModeButton;
@property (retain, nonatomic) UIButton *beatRepeatModeButton;
@property (retain, nonatomic) UIButton *fourthModeButton;


@property (retain, nonatomic) IBOutlet UISlider *gainSliderObject;
@property (retain, nonatomic) IBOutlet UISlider *quantizationSliderObject;

@property (retain, nonatomic) IBOutlet UILabel *gainLabel;
@property (retain, nonatomic) IBOutlet UILabel *quantizationLabel;

@property (retain, nonatomic) UIButton *effectSlotButton0;
@property (retain, nonatomic) UIButton *effectSlotButton1;
@property (retain, nonatomic) UIButton *effectSlotButton2;
@property (retain, nonatomic) UIButton *effectSlotButton3;

@property (retain, nonatomic) IBOutlet UIButton *effectTypeButton;

@property (retain, nonatomic) IBOutlet UISlider *slider1Object;
@property (retain, nonatomic) IBOutlet UISlider *slider2Object;
@property (retain, nonatomic) IBOutlet UISlider *slider3Object;
@property (retain, nonatomic) IBOutlet UISwitch *bypassButtonObject;


@property (retain, nonatomic) IBOutlet UILabel *slider1EffectParam;
@property (retain, nonatomic) IBOutlet UILabel *slider2EffectParam;
@property (retain, nonatomic) IBOutlet UILabel *slider3EffectParam;

@property (retain, nonatomic) IBOutlet UILabel *slider1CurrentValue;
@property (retain, nonatomic) IBOutlet UILabel *slider2CurrentValue;
@property (retain, nonatomic) IBOutlet UILabel *slider3CurrentValue;



@property (retain, nonatomic) IBOutlet UIButton *gainGestureObject;
@property (retain, nonatomic) IBOutlet UIButton *quantGestureObject;
@property (retain, nonatomic) IBOutlet UIButton *param1GestureObject;
@property (retain, nonatomic) IBOutlet UIButton *param2GestureObject;
@property (retain, nonatomic) IBOutlet UIButton *param3GestureObject;


- (void) updateSlidersAndLabels;



//--- Sample Mode Methods ---//

- (void)triggerModeButtonClicked;
- (void)loopModeButtonClicked;
- (void)beatRepeatModeButtonClicked;
- (void)fourthModeButtonClicked;

- (void)displayButtonMode:(int)mode;


//--- Effect Slot Methods ---//

- (void)effectSlotButtonClicked0;
- (void)effectSlotButtonClicked1;
- (void)effectSlotButtonClicked2;
- (void)effectSlotButtonClicked3;

- (void)displayEffectParameters:(int)position;


@end

