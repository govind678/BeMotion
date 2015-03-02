//==============================================================================
//
//  EffectSettingsViewController.h
//  BeatMotion
//
//  Created by Anand Mahadevan on 3/9/14.
//  Copyright (c) 2014 PlasmatioTech. All rights reserved.
//
//============================================================================

#import  <UIKit/UIKit.h>
#import  <AVFoundation/AVFoundation.h>
#import  <CoreMedia/CoreMedia.h>

#include "BeatMotionInterface.h"
#include "Macros.h"


@interface EffectSettingsViewController : UIViewController
{
    NSMutableDictionary*    effectDict;
    NSArray*                effectNames;
    
    NSTimer* timer;
}

@property (nonatomic, assign) BeatMotionInterface* backendInterface;
@property (nonatomic, assign) int  currentSampleID;
@property (nonatomic, assign) int  currentEffectPosition;
@property (nonatomic, retain) NSMutableDictionary* effectDict;
@property (nonatomic, retain) NSArray* effectNames;


//--- UI Objects ---//

//-- Gain and Quantization --//
@property (retain, nonatomic) IBOutlet UISlider *gainSliderObject;
@property (retain, nonatomic) IBOutlet UISlider *quantizationSliderObject;


@property (retain, nonatomic) IBOutlet UILabel *gainLabel;
@property (retain, nonatomic) IBOutlet UILabel *quantizationLabel;

- (IBAction)gainSliderChanged:(UISlider *)sender;
- (IBAction)quantizationSliderChanged:(UISlider *)sender;



//--- FX Buttons ---//
@property (retain, nonatomic) IBOutlet UIButton *effectSlotButton0;
@property (retain, nonatomic) IBOutlet UIButton *effectSlotButton1;

- (IBAction)fxButtonClicked0:(UIButton *)sender;
- (IBAction)fxButtonClicked1:(UIButton *)sender;


@property (retain, nonatomic) IBOutlet UIButton *effectTypeButton;



@property (retain, nonatomic) IBOutlet UISwitch *bypassButtonObject;

@property (retain, nonatomic) IBOutlet UISlider *sliderObject0;
@property (retain, nonatomic) IBOutlet UISlider *sliderObject1;
@property (retain, nonatomic) IBOutlet UISlider *sliderObject2;

- (IBAction)sliderChanged0:(UISlider *)sender;
- (IBAction)sliderChanged1:(UISlider *)sender;
- (IBAction)sliderChanged2:(UISlider *)sender;



@property (retain, nonatomic) IBOutlet UILabel *sliderCurrentValue0;
@property (retain, nonatomic) IBOutlet UILabel *sliderCurrentValue1;
@property (retain, nonatomic) IBOutlet UILabel *sliderCurrentValue2;

@property (retain, nonatomic) IBOutlet UILabel *sliderParamName0;
@property (retain, nonatomic) IBOutlet UILabel *sliderParamName1;
@property (retain, nonatomic) IBOutlet UILabel *sliderParamName2;



//-- Motion Gesture Objects --//
@property (retain, nonatomic) IBOutlet UIButton *gainGestureObject;
@property (retain, nonatomic) IBOutlet UIButton *quantizationGestureObject;
@property (retain, nonatomic) IBOutlet UIButton *paramGestureObject0;
@property (retain, nonatomic) IBOutlet UIButton *paramGestureObject1;
@property (retain, nonatomic) IBOutlet UIButton *paramGestureObject2;

- (IBAction)bypassStateChanged:(UISwitch *)sender;

- (IBAction)gainGestureObjectToggle:(UIButton *)sender;
- (IBAction)quantizationGestureObjectToggle:(UIButton *)sender;
- (IBAction)gestureObjectToggle0:(UIButton *)sender;
- (IBAction)gestureObjectToggle1:(UIButton *)sender;
- (IBAction)gestureObjectToggle2:(UIButton *)sender;



- (void) updateSliders;
- (void) updateButtons;

- (void) motionUpdateSliders;

- (void)displayEffectParameters:(int)position;


@end

