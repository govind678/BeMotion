//==============================================================================
//
//  EffectSettingsViewController.mm
//  BeMotion
//
//  Created by Anand Mahadevan on 3/9/14.
//  Copyright (c) 2014 BeMotionLLC. All rights reserved.
//
//============================================================================


#import "EffectSettingsViewController.h"
#import "BeMotionAppDelegate.h"
#import "EffectTableViewController.h"


@interface EffectSettingsViewController ()
{
    BeMotionAppDelegate*   appDelegate;
}

@end




@implementation EffectSettingsViewController

@synthesize currentSampleID, currentEffectPosition;
@synthesize gainSliderObject, quantizationSliderObject;
@synthesize bypassButtonObject;
@synthesize slider1Object, slider2Object, slider3Object;
@synthesize slider1CurrentValue, slider2CurrentValue, slider3CurrentValue;
@synthesize slider1EffectParam, slider2EffectParam, slider3EffectParam;
@synthesize gainGestureObject, quantGestureObject, param1GestureObject, param2GestureObject, param3GestureObject;
@synthesize gainLabel, quantizationLabel;
@synthesize triggerModeButton, loopModeButton, beatRepeatModeButton, fourthModeButton;
@synthesize effectSlotButton0, effectSlotButton1, effectSlotButton2, effectSlotButton3;
@synthesize effectTypeButton, effectDict, effectNames;



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //--- Get Reference to Backend ---//
    appDelegate = [[UIApplication sharedApplication] delegate];
    _backendInterface   =  [appDelegate getBackendReference];
    
    NSString* fxParamsPath = [[NSBundle mainBundle] pathForResource:@"FXParameterNames" ofType:@"plist"];
    effectDict = [[NSMutableDictionary alloc] initWithContentsOfFile:fxParamsPath];
    effectNames = [[NSArray alloc] initWithArray:[appDelegate fxTypes] copyItems:YES];
    
    
    //--- Sample Mode Buttons and Labels ---//
    
    loopModeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [loopModeButton setImage:[UIImage imageNamed:@"Loop.png"] forState:UIControlStateNormal];
    [loopModeButton addTarget:self action:@selector(loopModeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    loopModeButton.frame = CGRectMake(20.0f, 60.0f, SETTINGS_ICON_RADIUS, SETTINGS_ICON_RADIUS);
    [loopModeButton setClipsToBounds:YES];
    [[loopModeButton layer] setCornerRadius:SETTINGS_ICON_RADIUS * 0.5f];
    [loopModeButton setAlpha:BUTTON_OFF_ALPHA];
    
    triggerModeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [triggerModeButton setImage:[UIImage imageNamed:@"Trigger.png"] forState:UIControlStateNormal];
    [triggerModeButton addTarget:self action:@selector(triggerModeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    triggerModeButton.frame = CGRectMake(90.0f, 60.0f, SETTINGS_ICON_RADIUS, SETTINGS_ICON_RADIUS);
    [triggerModeButton setClipsToBounds:YES];
    [[triggerModeButton layer] setCornerRadius:SETTINGS_ICON_RADIUS * 0.5f];
    [triggerModeButton setAlpha:BUTTON_OFF_ALPHA];
    
    beatRepeatModeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [beatRepeatModeButton setImage:[UIImage imageNamed:@"BeatRepeat.png"] forState:UIControlStateNormal];
    [beatRepeatModeButton addTarget:self action:@selector(beatRepeatModeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    beatRepeatModeButton.frame = CGRectMake(160.0f, 60.0f, SETTINGS_ICON_RADIUS, SETTINGS_ICON_RADIUS);
    [beatRepeatModeButton setClipsToBounds:YES];
    [[beatRepeatModeButton layer] setCornerRadius:SETTINGS_ICON_RADIUS * 0.5f];
    [beatRepeatModeButton setAlpha:BUTTON_OFF_ALPHA];
    
    fourthModeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [fourthModeButton setImage:[UIImage imageNamed:@"Activate.png"] forState:UIControlStateNormal];
    [fourthModeButton addTarget:self action:@selector(fourthModeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    fourthModeButton.frame = CGRectMake(230.0f, 60.0f, SETTINGS_ICON_RADIUS, SETTINGS_ICON_RADIUS);
    [fourthModeButton setClipsToBounds:YES];
    [[fourthModeButton layer] setCornerRadius:SETTINGS_ICON_RADIUS * 0.5f];
    [fourthModeButton setAlpha:BUTTON_OFF_ALPHA];
    
    
    UILabel* loopModeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 110.0f, SETTINGS_ICON_RADIUS, 16.0f)];
    [loopModeLabel setBackgroundColor:[UIColor clearColor]];
    [loopModeLabel setTextAlignment:NSTextAlignmentCenter];
    [loopModeLabel setTextColor:[UIColor lightGrayColor]];
    [loopModeLabel setNumberOfLines:1];
    [loopModeLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [loopModeLabel setFont:[UIFont systemFontOfSize:10.0f]];
    [loopModeLabel setText:@"Loop"];
    
    UILabel* triggerModeLabel = [[UILabel alloc] initWithFrame:CGRectMake(90.0f, 110.0f, SETTINGS_ICON_RADIUS, 16.0f)];
    [triggerModeLabel setBackgroundColor:[UIColor clearColor]];
    [triggerModeLabel setTextAlignment:NSTextAlignmentCenter];
    [triggerModeLabel setTextColor:[UIColor lightGrayColor]];
    [triggerModeLabel setNumberOfLines:1];
    [triggerModeLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [triggerModeLabel setFont:[UIFont systemFontOfSize:10.0f]];
    [triggerModeLabel setText:@"One Shot"];
    
    UILabel* beatRepeatModeLabel = [[UILabel alloc] initWithFrame:CGRectMake(160.0f, 110.0f, SETTINGS_ICON_RADIUS, 16.0f)];
    [beatRepeatModeLabel setBackgroundColor:[UIColor clearColor]];
    [beatRepeatModeLabel setTextAlignment:NSTextAlignmentCenter];
    [beatRepeatModeLabel setTextColor:[UIColor lightGrayColor]];
    [beatRepeatModeLabel setNumberOfLines:1];
    [beatRepeatModeLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [beatRepeatModeLabel setFont:[UIFont systemFontOfSize:10.0f]];
    [beatRepeatModeLabel setText:@"Beat Repeat"];
    
    UILabel* fourthModeLabel = [[UILabel alloc] initWithFrame:CGRectMake(230.0f, 110.0f, SETTINGS_ICON_RADIUS, 16.0f)];
    [fourthModeLabel setBackgroundColor:[UIColor clearColor]];
    [fourthModeLabel setTextAlignment:NSTextAlignmentCenter];
    [fourthModeLabel setTextColor:[UIColor lightGrayColor]];
    [fourthModeLabel setNumberOfLines:1];
    [fourthModeLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [fourthModeLabel setFont:[UIFont systemFontOfSize:10.0f]];
    [fourthModeLabel setText:@"4th Mode"];
    
    
    
    [[self view] addSubview:loopModeButton];
    [[self view] addSubview:triggerModeButton];
    [[self view] addSubview:beatRepeatModeButton];
    [[self view] addSubview:fourthModeButton];
    
    [[self view] addSubview:loopModeLabel];
    [[self view] addSubview:triggerModeLabel];
    [[self view] addSubview:beatRepeatModeLabel];
    [[self view] addSubview:fourthModeLabel];
    
    
    
    
    //--- Sliders ---//
    [gainSliderObject setThumbImage:[UIImage imageNamed:@"SliderThumb.png"] forState:UIControlStateNormal];
    [gainSliderObject setMaximumTrackImage:[UIImage imageNamed:@"SliderMaximum.png"] forState:UIControlStateNormal];
    
    [quantizationSliderObject setThumbImage:[UIImage imageNamed:@"SliderThumb.png"] forState:UIControlStateNormal];
    [quantizationSliderObject setMaximumTrackImage:[UIImage imageNamed:@"SliderMaximum.png"] forState:UIControlStateNormal];
    
    [slider1Object setThumbImage:[UIImage imageNamed:@"SliderThumb.png"] forState:UIControlStateNormal];
    [slider1Object setMaximumTrackImage:[UIImage imageNamed:@"SliderMaximum.png"] forState:UIControlStateNormal];
    
    [slider2Object setThumbImage:[UIImage imageNamed:@"SliderThumb.png"] forState:UIControlStateNormal];
    [slider2Object setMaximumTrackImage:[UIImage imageNamed:@"SliderMaximum.png"] forState:UIControlStateNormal];
    
    [slider3Object setThumbImage:[UIImage imageNamed:@"SliderThumb.png"] forState:UIControlStateNormal];
    [slider3Object setMaximumTrackImage:[UIImage imageNamed:@"SliderMaximum.png"] forState:UIControlStateNormal];
    
    
    switch (currentSampleID) {
            
        case 0:
            [gainSliderObject setMinimumTrackImage:[UIImage imageNamed:@"SliderMinimum0.png"] forState:UIControlStateNormal];
            [quantizationSliderObject setMinimumTrackImage:[UIImage imageNamed:@"SliderMinimum0.png"] forState:UIControlStateNormal];
            [slider1Object setMinimumTrackImage:[UIImage imageNamed:@"SliderMinimum0.png"] forState:UIControlStateNormal];
            [slider2Object setMinimumTrackImage:[UIImage imageNamed:@"SliderMinimum0.png"] forState:UIControlStateNormal];
            [slider3Object setMinimumTrackImage:[UIImage imageNamed:@"SliderMinimum0.png"] forState:UIControlStateNormal];
            break;
            
        case 1:
            [gainSliderObject setMinimumTrackImage:[UIImage imageNamed:@"SliderMinimum1.png"] forState:UIControlStateNormal];
            [quantizationSliderObject setMinimumTrackImage:[UIImage imageNamed:@"SliderMinimum1.png"] forState:UIControlStateNormal];
            [slider1Object setMinimumTrackImage:[UIImage imageNamed:@"SliderMinimum1.png"] forState:UIControlStateNormal];
            [slider2Object setMinimumTrackImage:[UIImage imageNamed:@"SliderMinimum1.png"] forState:UIControlStateNormal];
            [slider3Object setMinimumTrackImage:[UIImage imageNamed:@"SliderMinimum1.png"] forState:UIControlStateNormal];
            break;
            
        case 2:
            [gainSliderObject setMinimumTrackImage:[UIImage imageNamed:@"SliderMinimum2.png"] forState:UIControlStateNormal];
            [quantizationSliderObject setMinimumTrackImage:[UIImage imageNamed:@"SliderMinimum2.png"] forState:UIControlStateNormal];
            [slider1Object setMinimumTrackImage:[UIImage imageNamed:@"SliderMinimum2.png"] forState:UIControlStateNormal];
            [slider2Object setMinimumTrackImage:[UIImage imageNamed:@"SliderMinimum2.png"] forState:UIControlStateNormal];
            [slider3Object setMinimumTrackImage:[UIImage imageNamed:@"SliderMinimum2.png"] forState:UIControlStateNormal];
            break;
            
        case 3:
            [gainSliderObject setMinimumTrackImage:[UIImage imageNamed:@"SliderMinimum3.png"] forState:UIControlStateNormal];
            [quantizationSliderObject setMinimumTrackImage:[UIImage imageNamed:@"SliderMinimum3.png"] forState:UIControlStateNormal];
            [slider1Object setMinimumTrackImage:[UIImage imageNamed:@"SliderMinimum3.png"] forState:UIControlStateNormal];
            [slider2Object setMinimumTrackImage:[UIImage imageNamed:@"SliderMinimum3.png"] forState:UIControlStateNormal];
            [slider3Object setMinimumTrackImage:[UIImage imageNamed:@"SliderMinimum3.png"] forState:UIControlStateNormal];
            break;
            
        default:
            break;
    }
    
    
    
    
    //--- Effect Slot Buttons ---//
    
    effectSlotButton0 = [UIButton buttonWithType:UIButtonTypeCustom];
    [effectSlotButton0 addTarget:self action:@selector(effectSlotButtonClicked0) forControlEvents:UIControlEventTouchUpInside];
    effectSlotButton0.frame = CGRectMake(20.0f, 220.0f, SETTINGS_ICON_RADIUS, SETTINGS_ICON_RADIUS);
    [effectSlotButton0 setClipsToBounds:YES];
    [[effectSlotButton0 layer] setCornerRadius:SETTINGS_ICON_RADIUS * 0.5f];
    
    effectSlotButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [effectSlotButton1 addTarget:self action:@selector(effectSlotButtonClicked1) forControlEvents:UIControlEventTouchUpInside];
    effectSlotButton1.frame = CGRectMake(90.0f, 220.0f, SETTINGS_ICON_RADIUS, SETTINGS_ICON_RADIUS);
    [effectSlotButton1 setClipsToBounds:YES];
    [[effectSlotButton1 layer] setCornerRadius:SETTINGS_ICON_RADIUS * 0.5f];
    
    effectSlotButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [effectSlotButton2 addTarget:self action:@selector(effectSlotButtonClicked2) forControlEvents:UIControlEventTouchUpInside];
    effectSlotButton2.frame = CGRectMake(160.0f, 220.0f, SETTINGS_ICON_RADIUS, SETTINGS_ICON_RADIUS);
    [effectSlotButton2 setClipsToBounds:YES];
    [[effectSlotButton2 layer] setCornerRadius:SETTINGS_ICON_RADIUS * 0.5f];
    
    effectSlotButton3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [effectSlotButton3 addTarget:self action:@selector(effectSlotButtonClicked3) forControlEvents:UIControlEventTouchUpInside];
    effectSlotButton3.frame = CGRectMake(230.0f, 220.0f, SETTINGS_ICON_RADIUS, SETTINGS_ICON_RADIUS);
    [effectSlotButton3 setClipsToBounds:YES];
    [[effectSlotButton3 layer] setCornerRadius:SETTINGS_ICON_RADIUS * 0.5f];
    
    [[self view] addSubview:effectSlotButton0];
    [[self view] addSubview:effectSlotButton1];
    [[self view] addSubview:effectSlotButton2];
    [[self view] addSubview:effectSlotButton3];
    
    
    
    
    //--- Get Sample Parameters ---//
    
    buttonMode = _backendInterface->getSampleParameter(currentSampleID, PARAM_PLAYBACK_MODE);
    [self displayButtonMode:buttonMode];
    
    float gain = _backendInterface->getSampleParameter(currentSampleID, PARAM_GAIN);
    [gainSliderObject setValue:gain];
    [gainLabel setText:[@(gain) stringValue]];
    
    float quantization = _backendInterface->getSampleParameter(currentSampleID, PARAM_QUANTIZATION);
    [quantizationSliderObject setValue:quantization];
    [quantizationLabel setText:[@( powf(2, (int)quantization) ) stringValue]];
    
    
    //--- Get Sample Gesture Control Toggles ---//
    if (_backendInterface->getSampleGestureControlToggle(currentSampleID, PARAM_MOTION_GAIN))
    {
        [gainGestureObject setAlpha: 1.0f];
        [gainSliderObject setEnabled:NO];
    }
    
    else
    {
        [gainGestureObject setAlpha: 0.4f];
        [gainSliderObject setEnabled:YES];
    }
    
    if (_backendInterface->getSampleGestureControlToggle(currentSampleID, PARAM_MOTION_QUANT))
    {
        [quantGestureObject setAlpha: 1.0f];
        [quantizationSliderObject setEnabled:NO];
    }
    
    else
    {
        [quantGestureObject setAlpha: 0.4f];
        [quantizationSliderObject setEnabled:YES];
    }
    
    
    
    //--- Get Effect Parameters ---//
    [self updateSlidersAndLabels];
    
    
    
    //--- Effect Type Button Settings ---//
    [effectTypeButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [effectTypeButton setContentEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [effectTypeButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [[effectTypeButton titleLabel] setFont:[UIFont systemFontOfSize:14.0f]];
    NSString* buttonTitle = [effectNames objectAtIndex:_backendInterface->getEffectType(currentSampleID, currentEffectPosition)];
    [effectTypeButton setTitle:buttonTitle forState:UIControlStateNormal];
    
    
    
    //--- Update Display of Effect Type and Slider Values ---//
    [self displayEffectParameters:currentEffectPosition];
    
    
    
    //--- Set Background Image ---//
    [[self view] setBackgroundColor: [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background.png"]]];
}




//--- Sample Mode Methods ---//

- (void)triggerModeButtonClicked {
    _backendInterface->setSampleParameter(currentSampleID, PARAM_PLAYBACK_MODE, MODE_TRIGGER);
    [self displayButtonMode:MODE_TRIGGER];
}

- (void)loopModeButtonClicked {
    _backendInterface->setSampleParameter(currentSampleID, PARAM_PLAYBACK_MODE, MODE_LOOP);
    [self displayButtonMode:MODE_LOOP];
}

- (void)beatRepeatModeButtonClicked {
    _backendInterface->setSampleParameter(currentSampleID, PARAM_PLAYBACK_MODE, MODE_BEATREPEAT);
    [self displayButtonMode:MODE_BEATREPEAT];
}

- (void)fourthModeButtonClicked {
    _backendInterface->setSampleParameter(currentSampleID, PARAM_PLAYBACK_MODE, MODE_FOURTH);
    [self displayButtonMode:MODE_FOURTH];
}


- (void)displayButtonMode:(int)mode {
    
    switch (mode) {
            
        case MODE_LOOP:
            [loopModeButton setAlpha:1.0f];
            [triggerModeButton setAlpha:BUTTON_OFF_ALPHA];
            [beatRepeatModeButton setAlpha:BUTTON_OFF_ALPHA];
            [fourthModeButton setAlpha:BUTTON_OFF_ALPHA];
            break;
            
        case MODE_TRIGGER:
            [loopModeButton setAlpha:BUTTON_OFF_ALPHA];
            [triggerModeButton setAlpha:1.0f];
            [beatRepeatModeButton setAlpha:BUTTON_OFF_ALPHA];
            [fourthModeButton setAlpha:BUTTON_OFF_ALPHA];
            break;
            
        case MODE_BEATREPEAT:
            [loopModeButton setAlpha:BUTTON_OFF_ALPHA];
            [triggerModeButton setAlpha:BUTTON_OFF_ALPHA];
            [beatRepeatModeButton setAlpha:1.0f];
            [fourthModeButton setAlpha:BUTTON_OFF_ALPHA];
            break;
            
        case MODE_FOURTH:
            [loopModeButton setAlpha:BUTTON_OFF_ALPHA];
            [triggerModeButton setAlpha:BUTTON_OFF_ALPHA];
            [beatRepeatModeButton setAlpha:BUTTON_OFF_ALPHA];
            [fourthModeButton setAlpha:1.0f];
            break;
            
        default:
            break;
    }
}




//--- Effect Slot Methods ---//

- (void)effectSlotButtonClicked0 {
    currentEffectPosition = 0;
    [self displayEffectParameters:currentEffectPosition];
}

- (void)effectSlotButtonClicked1 {
    currentEffectPosition = 1;
    [self displayEffectParameters:currentEffectPosition];
}

- (void)effectSlotButtonClicked2 {
    currentEffectPosition = 2;
    [self displayEffectParameters:currentEffectPosition];
}

- (void)effectSlotButtonClicked3 {
    currentEffectPosition = 3;
    [self displayEffectParameters:currentEffectPosition];
}



- (void)displayEffectParameters: (int)position {
    
    switch (position) {
            
        case 0:
            
            switch (currentSampleID) {
                case 0:
                    [effectSlotButton0 setImage:[UIImage imageNamed:@"Slot_Selected_0_0.png"] forState:UIControlStateNormal];
                    [effectSlotButton1 setImage:[UIImage imageNamed:@"Slot_Disabled_1.png"] forState:UIControlStateNormal];
                    [effectSlotButton2 setImage:[UIImage imageNamed:@"Slot_Disabled_2.png"] forState:UIControlStateNormal];
                    [effectSlotButton3 setImage:[UIImage imageNamed:@"Slot_Disabled_3.png"] forState:UIControlStateNormal];
                    break;
                    
                case 1:
                    [effectSlotButton0 setImage:[UIImage imageNamed:@"Slot_Selected_1_0.png"] forState:UIControlStateNormal];
                    [effectSlotButton1 setImage:[UIImage imageNamed:@"Slot_Disabled_1.png"] forState:UIControlStateNormal];
                    [effectSlotButton2 setImage:[UIImage imageNamed:@"Slot_Disabled_2.png"] forState:UIControlStateNormal];
                    [effectSlotButton3 setImage:[UIImage imageNamed:@"Slot_Disabled_3.png"] forState:UIControlStateNormal];
                    break;
                    
                case 2:
                    [effectSlotButton0 setImage:[UIImage imageNamed:@"Slot_Selected_2_0.png"] forState:UIControlStateNormal];
                    [effectSlotButton1 setImage:[UIImage imageNamed:@"Slot_Disabled_1.png"] forState:UIControlStateNormal];
                    [effectSlotButton2 setImage:[UIImage imageNamed:@"Slot_Disabled_2.png"] forState:UIControlStateNormal];
                    [effectSlotButton3 setImage:[UIImage imageNamed:@"Slot_Disabled_3.png"] forState:UIControlStateNormal];
                    break;
                    
                case 3:
                    [effectSlotButton0 setImage:[UIImage imageNamed:@"Slot_Selected_3_0.png"] forState:UIControlStateNormal];
                    [effectSlotButton1 setImage:[UIImage imageNamed:@"Slot_Disabled_1.png"] forState:UIControlStateNormal];
                    [effectSlotButton2 setImage:[UIImage imageNamed:@"Slot_Disabled_2.png"] forState:UIControlStateNormal];
                    [effectSlotButton3 setImage:[UIImage imageNamed:@"Slot_Disabled_3.png"] forState:UIControlStateNormal];
                    break;
                    
                default:
                    break;
            }
            
            break;
            
            
            
        case 1:
            
            switch (currentSampleID) {
                case 0:
                    [effectSlotButton0 setImage:[UIImage imageNamed:@"Slot_Disabled_0.png"] forState:UIControlStateNormal];
                    [effectSlotButton1 setImage:[UIImage imageNamed:@"Slot_Selected_0_1.png"] forState:UIControlStateNormal];
                    [effectSlotButton2 setImage:[UIImage imageNamed:@"Slot_Disabled_2.png"] forState:UIControlStateNormal];
                    [effectSlotButton3 setImage:[UIImage imageNamed:@"Slot_Disabled_3.png"] forState:UIControlStateNormal];
                    break;
                    
                case 1:
                    [effectSlotButton0 setImage:[UIImage imageNamed:@"Slot_Disabled_0.png"] forState:UIControlStateNormal];
                    [effectSlotButton1 setImage:[UIImage imageNamed:@"Slot_Selected_1_1.png"] forState:UIControlStateNormal];
                    [effectSlotButton2 setImage:[UIImage imageNamed:@"Slot_Disabled_2.png"] forState:UIControlStateNormal];
                    [effectSlotButton3 setImage:[UIImage imageNamed:@"Slot_Disabled_3.png"] forState:UIControlStateNormal];
                    break;
                    
                case 2:
                    [effectSlotButton0 setImage:[UIImage imageNamed:@"Slot_Disabled_0.png"] forState:UIControlStateNormal];
                    [effectSlotButton1 setImage:[UIImage imageNamed:@"Slot_Selected_2_1.png"] forState:UIControlStateNormal];
                    [effectSlotButton2 setImage:[UIImage imageNamed:@"Slot_Disabled_2.png"] forState:UIControlStateNormal];
                    [effectSlotButton3 setImage:[UIImage imageNamed:@"Slot_Disabled_3.png"] forState:UIControlStateNormal];
                    break;
                    
                case 3:
                    [effectSlotButton0 setImage:[UIImage imageNamed:@"Slot_Disabled_0.png"] forState:UIControlStateNormal];
                    [effectSlotButton1 setImage:[UIImage imageNamed:@"Slot_Selected_3_1.png"] forState:UIControlStateNormal];
                    [effectSlotButton2 setImage:[UIImage imageNamed:@"Slot_Disabled_2.png"] forState:UIControlStateNormal];
                    [effectSlotButton3 setImage:[UIImage imageNamed:@"Slot_Disabled_3.png"] forState:UIControlStateNormal];
                    break;
                    
                default:
                    break;
            }
            
            break;
            
            
            
        case 2:
            
            switch (currentSampleID) {
                case 0:
                    [effectSlotButton0 setImage:[UIImage imageNamed:@"Slot_Disabled_0.png"] forState:UIControlStateNormal];
                    [effectSlotButton1 setImage:[UIImage imageNamed:@"Slot_Disabled_1.png"] forState:UIControlStateNormal];
                    [effectSlotButton2 setImage:[UIImage imageNamed:@"Slot_Selected_0_2.png"] forState:UIControlStateNormal];
                    [effectSlotButton3 setImage:[UIImage imageNamed:@"Slot_Disabled_3.png"] forState:UIControlStateNormal];
                    break;
                    
                case 1:
                    [effectSlotButton0 setImage:[UIImage imageNamed:@"Slot_Disabled_0.png"] forState:UIControlStateNormal];
                    [effectSlotButton1 setImage:[UIImage imageNamed:@"Slot_Disabled_1.png"] forState:UIControlStateNormal];
                    [effectSlotButton2 setImage:[UIImage imageNamed:@"Slot_Selected_1_2.png"] forState:UIControlStateNormal];
                    [effectSlotButton3 setImage:[UIImage imageNamed:@"Slot_Disabled_3.png"] forState:UIControlStateNormal];
                    break;
                    
                case 2:
                    [effectSlotButton0 setImage:[UIImage imageNamed:@"Slot_Disabled_0.png"] forState:UIControlStateNormal];
                    [effectSlotButton1 setImage:[UIImage imageNamed:@"Slot_Disabled_1.png"] forState:UIControlStateNormal];
                    [effectSlotButton2 setImage:[UIImage imageNamed:@"Slot_Selected_2_2.png"] forState:UIControlStateNormal];
                    [effectSlotButton3 setImage:[UIImage imageNamed:@"Slot_Disabled_3.png"] forState:UIControlStateNormal];
                    break;
                    
                case 3:
                    [effectSlotButton0 setImage:[UIImage imageNamed:@"Slot_Disabled_0.png"] forState:UIControlStateNormal];
                    [effectSlotButton1 setImage:[UIImage imageNamed:@"Slot_Disabled_1.png"] forState:UIControlStateNormal];
                    [effectSlotButton2 setImage:[UIImage imageNamed:@"Slot_Selected_3_2.png"] forState:UIControlStateNormal];
                    [effectSlotButton3 setImage:[UIImage imageNamed:@"Slot_Disabled_3.png"] forState:UIControlStateNormal];
                    break;
                    
                default:
                    break;
            }
            
            break;
            
            
            
        case 3:
            
            switch (currentSampleID) {
                case 0:
                    [effectSlotButton0 setImage:[UIImage imageNamed:@"Slot_Disabled_0.png"] forState:UIControlStateNormal];
                    [effectSlotButton1 setImage:[UIImage imageNamed:@"Slot_Disabled_1.png"] forState:UIControlStateNormal];
                    [effectSlotButton2 setImage:[UIImage imageNamed:@"Slot_Disabled_2.png"] forState:UIControlStateNormal];
                    [effectSlotButton3 setImage:[UIImage imageNamed:@"Slot_Selected_0_3.png"] forState:UIControlStateNormal];
                    break;
                    
                case 1:
                    [effectSlotButton0 setImage:[UIImage imageNamed:@"Slot_Disabled_0.png"] forState:UIControlStateNormal];
                    [effectSlotButton1 setImage:[UIImage imageNamed:@"Slot_Disabled_1.png"] forState:UIControlStateNormal];
                    [effectSlotButton2 setImage:[UIImage imageNamed:@"Slot_Disabled_2.png"] forState:UIControlStateNormal];
                    [effectSlotButton3 setImage:[UIImage imageNamed:@"Slot_Selected_1_3.png"] forState:UIControlStateNormal];
                    break;
                    
                case 2:
                    [effectSlotButton0 setImage:[UIImage imageNamed:@"Slot_Disabled_0.png"] forState:UIControlStateNormal];
                    [effectSlotButton1 setImage:[UIImage imageNamed:@"Slot_Disabled_1.png"] forState:UIControlStateNormal];
                    [effectSlotButton2 setImage:[UIImage imageNamed:@"Slot_Disabled_2.png"] forState:UIControlStateNormal];
                    [effectSlotButton3 setImage:[UIImage imageNamed:@"Slot_Selected_2_3.png"] forState:UIControlStateNormal];
                    break;
                    
                case 3:
                    [effectSlotButton0 setImage:[UIImage imageNamed:@"Slot_Disabled_0.png"] forState:UIControlStateNormal];
                    [effectSlotButton1 setImage:[UIImage imageNamed:@"Slot_Disabled_1.png"] forState:UIControlStateNormal];
                    [effectSlotButton2 setImage:[UIImage imageNamed:@"Slot_Disabled_2.png"] forState:UIControlStateNormal];
                    [effectSlotButton3 setImage:[UIImage imageNamed:@"Slot_Selected_3_3.png"] forState:UIControlStateNormal];
                    break;
                    
                default:
                    break;
            }
            
            break;
            
        default:
            break;
    }
    
    
    NSString* buttonTitle = [effectNames objectAtIndex:_backendInterface->getEffectType(currentSampleID, currentEffectPosition)];
    [effectTypeButton setTitle:buttonTitle forState:UIControlStateNormal];
    [self updateSlidersAndLabels];
    
}




//--- Sample Parameter Changes ---//

// Set Gain
- (IBAction)gainSliderChanged:(UISlider *)sender
{
    _backendInterface->setSampleParameter(currentSampleID, PARAM_GAIN, sender.value);
    [gainLabel setText:[@(sender.value) stringValue]];
}

// Set Quantization Time for Note Repeat
- (IBAction)quantizationSliderChanged:(UISlider *)sender
{
    _backendInterface->setSampleParameter(currentSampleID, PARAM_QUANTIZATION, (int)sender.value);
    [quantizationLabel setText:[@( pow(2, (int)sender.value) ) stringValue]];
}






- (IBAction)bypassToggleButtonChanged:(UISwitch *)sender
{
    _backendInterface->setEffectParameter(currentSampleID, currentEffectPosition, PARAM_BYPASS, sender.on);
}

- (IBAction)Slider1Changed:(UISlider *)sender
{
    _backendInterface->setEffectParameter(currentSampleID, currentEffectPosition, PARAM_1, sender.value);
    [slider1CurrentValue setText:[@(sender.value) stringValue]];
}

- (IBAction)Slider2Changed:(UISlider *)sender
{
    _backendInterface->setEffectParameter(currentSampleID, currentEffectPosition, PARAM_2, sender.value);
    [slider2CurrentValue setText:[@(sender.value) stringValue]];
}

- (IBAction)Slider3Changed:(UISlider *)sender
{
    _backendInterface->setEffectParameter(currentSampleID, currentEffectPosition, PARAM_3, sender.value);
    [slider3CurrentValue setText:[@(sender.value) stringValue]];
}






- (void) updateSlidersAndLabels
{
    float param1 = _backendInterface->getEffectParameter(currentSampleID, currentEffectPosition, PARAM_1);
    float param2 = _backendInterface->getEffectParameter(currentSampleID, currentEffectPosition, PARAM_2);
    float param3 = _backendInterface->getEffectParameter(currentSampleID, currentEffectPosition, PARAM_3);
    
    [slider1Object setValue:param1];
    [slider2Object setValue:param2];
    [slider3Object setValue:param3];
    
    [slider1CurrentValue setText:[@(param1) stringValue]];
    [slider2CurrentValue setText:[@(param2) stringValue]];
    [slider3CurrentValue setText:[@(param3) stringValue]];
    
    [bypassButtonObject setSelected:_backendInterface->getEffectParameter(currentSampleID, currentEffectPosition, PARAM_BYPASS)];
    
    
    //-- Update Gesture Control Buttons --//
    
    if (_backendInterface->getEffectGestureControlToggle(currentSampleID, currentEffectPosition, PARAM_MOTION_PARAM1))
    {
        [param1GestureObject setAlpha:1.0f];
    }
    
    else
    {
        [param1GestureObject setAlpha:0.4f];
    }
    
    if (_backendInterface->getEffectGestureControlToggle(currentSampleID, currentEffectPosition, PARAM_MOTION_PARAM2))
    {
        [param2GestureObject setAlpha:1.0f];
    }
    
    else
    {
        [param2GestureObject setAlpha:0.4f];
    }
    
    if (_backendInterface->getEffectGestureControlToggle(currentSampleID, currentEffectPosition, PARAM_MOTION_PARAM3))
    {
        [param3GestureObject setAlpha:1.0f];
    }
    
    else
    {
        [param3GestureObject setAlpha:0.4f];
    }
    
    
    NSString* effectTitle = [effectNames objectAtIndex:_backendInterface->getEffectType(currentSampleID, currentEffectPosition)];
    NSArray* params = [effectDict objectForKey:effectTitle];
    
    NSString* text1 = [params objectAtIndex:0];
    NSString* text2 = [params objectAtIndex:1];
    NSString* text3 = [params objectAtIndex:2];
    
    [self.slider1EffectParam setText:text1];
    [self.slider2EffectParam setText:text2];
    [self.slider3EffectParam setText:text3];
    
}




//--- Gesture Control Toggles ---//

- (IBAction)gainGestureToggle:(UIButton *)sender
{
    if (_backendInterface->getSampleGestureControlToggle(currentSampleID, PARAM_MOTION_GAIN))
    {
        _backendInterface->setSampleGestureControlToggle(currentSampleID, PARAM_MOTION_GAIN, false);
        sender.alpha = 0.4;
        [gainSliderObject setEnabled:YES];
    }
    
    else
    {
        _backendInterface->setSampleGestureControlToggle(currentSampleID, PARAM_MOTION_GAIN, true);
        sender.alpha = 1.0f;
        [gainSliderObject setEnabled:NO];
    }
}

- (IBAction)quantGestureToggle:(UIButton *)sender
{
    if (_backendInterface->getSampleGestureControlToggle(currentSampleID, PARAM_MOTION_QUANT))
    {
        _backendInterface->setSampleGestureControlToggle(currentSampleID, PARAM_MOTION_QUANT, false);
        sender.alpha = 0.4;
        [quantizationSliderObject setEnabled:YES];
    }
    
    else
    {
        _backendInterface->setSampleGestureControlToggle(currentSampleID, PARAM_MOTION_QUANT, true);
        sender.alpha = 1.0f;
        [quantizationSliderObject setEnabled:NO];
    }
}

- (IBAction)param1GestureToggle:(UIButton *)sender
{
    if (_backendInterface->getEffectGestureControlToggle(currentSampleID, currentEffectPosition, PARAM_MOTION_PARAM1))
    {
        _backendInterface->setEffectGestureControlToggle(currentSampleID, currentEffectPosition, PARAM_MOTION_PARAM1, false);
        sender.alpha = 0.4;
    }
    
    else
    {
        _backendInterface->setEffectGestureControlToggle(currentSampleID, currentEffectPosition, PARAM_MOTION_PARAM1, true);
        sender.alpha = 1.0f;
    }
}

- (IBAction)param2GestureToggle:(UIButton *)sender
{
    if (_backendInterface->getEffectGestureControlToggle(currentSampleID, currentEffectPosition, PARAM_MOTION_PARAM2))
    {
        _backendInterface->setEffectGestureControlToggle(currentSampleID, currentEffectPosition, PARAM_MOTION_PARAM2, false);
        sender.alpha = 0.4;
    }
    
    else
    {
        _backendInterface->setEffectGestureControlToggle(currentSampleID, currentEffectPosition, PARAM_MOTION_PARAM2, true);
        sender.alpha = 1.0f;
    }
}

- (IBAction)param3GestureToggle:(UIButton *)sender
{
    if (_backendInterface->getEffectGestureControlToggle(currentSampleID, currentEffectPosition, PARAM_MOTION_PARAM3))
    {
        _backendInterface->setEffectGestureControlToggle(currentSampleID, currentEffectPosition, PARAM_MOTION_PARAM3, false);
        sender.alpha = 0.4;
    }
    
    else
    {
        _backendInterface->setEffectGestureControlToggle(currentSampleID, currentEffectPosition, PARAM_MOTION_PARAM3, true);
        sender.alpha = 1.0f;
    }
    
}



//--- Media Picker Stuff ---//




//--- Destructor ---//

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"loadEffectTable"]) {
        
        EffectTableViewController* vc = [segue destinationViewController];
        [vc setSampleID:currentSampleID];
        [vc setEffectPosition: currentEffectPosition];
    }
    
    
}


- (void)dealloc
{
    [effectNames release];
    [slider1EffectParam release];
    [slider2EffectParam release];
    [slider3EffectParam release];
    [slider1CurrentValue release];
    [slider2CurrentValue release];
    [slider3CurrentValue release];
    
    [slider1Object release];
    [slider2Object release];
    [slider3Object release];
    [bypassButtonObject release];
    
    
    [gainSliderObject release];
    [quantizationSliderObject release];
    [bypassButtonObject release];
    
    [gainGestureObject release];
    [quantGestureObject release];
    [param1GestureObject release];
    [param2GestureObject release];
    [param3GestureObject release];
    
    [gainLabel release];
    [quantizationLabel release];
    
    [triggerModeButton release];
    [loopModeButton release];
    [beatRepeatModeButton release];
    [fourthModeButton release];

    [effectTypeButton release];
    
    [super dealloc];
}


@end
