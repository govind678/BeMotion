//==============================================================================
//
//  EffectSettingsViewController.mm
//  BeatMotion
//
//  Created by Anand Mahadevan on 3/9/14.
//  Copyright (c) 2014 PlasmatioTech. All rights reserved.
//
//============================================================================


#import "EffectSettingsViewController.h"
#import "BMAppDelegate.h"
#import "EffectTableViewController.h"
#import "UIFont+Additions.h"


@interface EffectSettingsViewController ()
{
    BMAppDelegate*   appDelegate;
}

@end




@implementation EffectSettingsViewController

@synthesize currentSampleID, currentEffectPosition;
@synthesize gainSliderObject, quantizationSliderObject;
@synthesize bypassButtonObject;
@synthesize sliderCurrentValue0, sliderCurrentValue1, sliderCurrentValue2;
@synthesize sliderObject0, sliderObject1, sliderObject2;
@synthesize sliderParamName0, sliderParamName1, sliderParamName2;
@synthesize gainLabel, quantizationLabel;
@synthesize effectSlotButton0, effectSlotButton1;
@synthesize paramGestureObject0, paramGestureObject1, paramGestureObject2, gainGestureObject, quantizationGestureObject;
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
    
    
    
    
    //--- Sliders ---//
    [gainSliderObject setThumbImage:[UIImage imageNamed:@"SliderThumb.png"] forState:UIControlStateNormal];
    [gainSliderObject setMaximumTrackImage:[UIImage imageNamed:@"SliderMaximum.png"] forState:UIControlStateNormal];
    
    [quantizationSliderObject setThumbImage:[UIImage imageNamed:@"SliderThumb.png"] forState:UIControlStateNormal];
    [quantizationSliderObject setMaximumTrackImage:[UIImage imageNamed:@"SliderMaximum.png"] forState:UIControlStateNormal];
    
    [sliderObject0 setThumbImage:[UIImage imageNamed:@"SliderThumb.png"] forState:UIControlStateNormal];
    [sliderObject0 setMaximumTrackImage:[UIImage imageNamed:@"SliderMaximum.png"] forState:UIControlStateNormal];
    
    [sliderObject1 setThumbImage:[UIImage imageNamed:@"SliderThumb.png"] forState:UIControlStateNormal];
    [sliderObject1 setMaximumTrackImage:[UIImage imageNamed:@"SliderMaximum.png"] forState:UIControlStateNormal];
    
    [sliderObject2 setThumbImage:[UIImage imageNamed:@"SliderThumb.png"] forState:UIControlStateNormal];
    [sliderObject2 setMaximumTrackImage:[UIImage imageNamed:@"SliderMaximum.png"] forState:UIControlStateNormal];
    
    
    switch (currentSampleID) {
            
        case 0:
            [gainSliderObject setMinimumTrackImage:[UIImage imageNamed:@"SliderMinimum0.png"] forState:UIControlStateNormal];
            [quantizationSliderObject setMinimumTrackImage:[UIImage imageNamed:@"SliderMinimum0.png"] forState:UIControlStateNormal];
            [sliderObject0 setMinimumTrackImage:[UIImage imageNamed:@"SliderMinimum0.png"] forState:UIControlStateNormal];
            [sliderObject1 setMinimumTrackImage:[UIImage imageNamed:@"SliderMinimum0.png"] forState:UIControlStateNormal];
            [sliderObject2 setMinimumTrackImage:[UIImage imageNamed:@"SliderMinimum0.png"] forState:UIControlStateNormal];
            
//            [effectSlotButton0 setImage:[UIImage imageNamed:@"SettingsSelect0.png"] forState:UIControlStateSelected];
            [effectSlotButton0 setTitleColor:[UIColor colorWithRed:0.98f green:0.34f blue:0.14f alpha:1.0f] forState:UIControlStateSelected];
//            [effectSlotButton1 setImage:[UIImage imageNamed:@"SettingsSelect0.png"] forState:UIControlStateSelected];
            [effectSlotButton1 setTitleColor:[UIColor colorWithRed:0.98f green:0.34f blue:0.14f alpha:1.0f] forState:UIControlStateSelected];
            [bypassButtonObject setOnTintColor:[UIColor colorWithRed:0.98f green:0.34f blue:0.14f alpha:1.0f]];
            [effectTypeButton setTitleColor:[UIColor colorWithRed:0.98f green:0.34f blue:0.14f alpha:1.0f] forState:UIControlStateNormal];
            break;
            
        case 1:
            [gainSliderObject setMinimumTrackImage:[UIImage imageNamed:@"SliderMinimum1.png"] forState:UIControlStateNormal];
            [quantizationSliderObject setMinimumTrackImage:[UIImage imageNamed:@"SliderMinimum1.png"] forState:UIControlStateNormal];
            [sliderObject0 setMinimumTrackImage:[UIImage imageNamed:@"SliderMinimum1.png"] forState:UIControlStateNormal];
            [sliderObject1 setMinimumTrackImage:[UIImage imageNamed:@"SliderMinimum1.png"] forState:UIControlStateNormal];
            [sliderObject2 setMinimumTrackImage:[UIImage imageNamed:@"SliderMinimum1.png"] forState:UIControlStateNormal];
            
//            [effectSlotButton0 setImage:[UIImage imageNamed:@"SettingsSelect1.png"] forState:UIControlStateSelected];
            [effectSlotButton0 setTitleColor:[UIColor colorWithRed:0.15f green:0.39f blue:0.78f alpha:1.0f] forState:UIControlStateSelected];
//            [effectSlotButton1 setImage:[UIImage imageNamed:@"SettingsSelect1.png"] forState:UIControlStateSelected];
            [effectSlotButton1 setTitleColor:[UIColor colorWithRed:0.15f green:0.39f blue:0.78f alpha:1.0f] forState:UIControlStateSelected];
            [bypassButtonObject setOnTintColor:[UIColor colorWithRed:0.15f green:0.39f blue:0.78f alpha:1.0f]];
            [effectTypeButton setTitleColor:[UIColor colorWithRed:0.15f green:0.39f blue:0.78f alpha:1.0f] forState:UIControlStateNormal];
            break;
            
        case 2:
            [gainSliderObject setMinimumTrackImage:[UIImage imageNamed:@"SliderMinimum2.png"] forState:UIControlStateNormal];
            [quantizationSliderObject setMinimumTrackImage:[UIImage imageNamed:@"SliderMinimum2.png"] forState:UIControlStateNormal];
            [sliderObject0 setMinimumTrackImage:[UIImage imageNamed:@"SliderMinimum2.png"] forState:UIControlStateNormal];
            [sliderObject1 setMinimumTrackImage:[UIImage imageNamed:@"SliderMinimum2.png"] forState:UIControlStateNormal];
            [sliderObject2 setMinimumTrackImage:[UIImage imageNamed:@"SliderMinimum2.png"] forState:UIControlStateNormal];
            
//            [effectSlotButton0 setImage:[UIImage imageNamed:@"SettingsSelect2.png"] forState:UIControlStateSelected];
            [effectSlotButton0 setTitleColor:[UIColor colorWithRed:0.0f green:0.74f blue:0.42f alpha:1.0f] forState:UIControlStateSelected];
//            [effectSlotButton1 setImage:[UIImage imageNamed:@"SettingsSelect2.png"] forState:UIControlStateSelected];
            [effectSlotButton1 setTitleColor:[UIColor colorWithRed:0.0f green:0.74f blue:0.42f alpha:1.0f] forState:UIControlStateSelected];
            [bypassButtonObject setOnTintColor:[UIColor colorWithRed:0.0f green:0.74f blue:0.42f alpha:1.0f]];
            [effectTypeButton setTitleColor:[UIColor colorWithRed:0.0f green:0.74f blue:0.42f alpha:1.0f] forState:UIControlStateNormal];
            break;
            
        case 3:
            [gainSliderObject setMinimumTrackImage:[UIImage imageNamed:@"SliderMinimum3.png"] forState:UIControlStateNormal];
            [quantizationSliderObject setMinimumTrackImage:[UIImage imageNamed:@"SliderMinimum3.png"] forState:UIControlStateNormal];
            [sliderObject0 setMinimumTrackImage:[UIImage imageNamed:@"SliderMinimum3.png"] forState:UIControlStateNormal];
            [sliderObject1 setMinimumTrackImage:[UIImage imageNamed:@"SliderMinimum3.png"] forState:UIControlStateNormal];
            [sliderObject2 setMinimumTrackImage:[UIImage imageNamed:@"SliderMinimum3.png"] forState:UIControlStateNormal];
            
//            [effectSlotButton0 setImage:[UIImage imageNamed:@"SettingsSelect3.png"] forState:UIControlStateSelected];
            [effectSlotButton0 setTitleColor:[UIColor colorWithRed:0.96f green:0.93f blue:0.17f alpha:1.0f] forState:UIControlStateSelected];
//            [effectSlotButton1 setImage:[UIImage imageNamed:@"SettingsSelect3.png"] forState:UIControlStateSelected];
            [effectSlotButton1 setTitleColor:[UIColor colorWithRed:0.96f green:0.93f blue:0.17f alpha:1.0f] forState:UIControlStateSelected];
            [bypassButtonObject setOnTintColor:[UIColor colorWithRed:0.96f green:0.93f blue:0.17f alpha:1.0f]];
            [effectTypeButton setTitleColor:[UIColor colorWithRed:0.96f green:0.93f blue:0.17f alpha:1.0f] forState:UIControlStateNormal];
            break;
            
        default:
            break;
    }
    
    
    
    
    
    
    //--- Get Sample Parameters ---//
    float gain = _backendInterface->getSampleParameter(currentSampleID, PARAM_GAIN);
    [gainSliderObject setValue:gain];
    [gainLabel setText:[@(gain) stringValue]];
    
    float quantization = _backendInterface->getSampleParameter(currentSampleID, PARAM_QUANTIZATION);
    [quantizationSliderObject setValue:quantization];
    [quantizationLabel setText:[@( powf(2, (int)quantization) ) stringValue]];
    
    
    //--- Get Sample Gesture Control Toggles ---//
    if (_backendInterface->getSampleGestureControlToggle(currentSampleID, PARAM_MOTION_GAIN))
    {
        [gainGestureObject setSelected:YES];
        [gainSliderObject setEnabled:NO];
    }
    
    else
    {
        [gainGestureObject setSelected:NO];
        [gainSliderObject setEnabled:YES];
    }
    
    if (_backendInterface->getSampleGestureControlToggle(currentSampleID, PARAM_MOTION_QUANT))
    {
        [quantizationGestureObject setSelected:YES];
        [quantizationSliderObject setEnabled:NO];
    }
    
    else
    {
        [quantizationGestureObject setSelected:NO];
        [quantizationSliderObject setEnabled:YES];
    }
    
    
    
    //--- Get Effect Parameters ---//
    [self updateSliders];
    [self updateButtons];
    
    
    
    //--- Effect Type Button Settings ---//
    [effectTypeButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [effectTypeButton setContentEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [effectTypeButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//    [[effectTypeButton titleLabel] setFont:[UIFont systemFontOfSize:14.0f]];
    [[effectTypeButton titleLabel] setFont:[UIFont defaultFontOfSize:14.0f]];
    NSString* buttonTitle = [effectNames objectAtIndex:_backendInterface->getEffectType(currentSampleID, currentEffectPosition)];
    [effectTypeButton setTitle:buttonTitle forState:UIControlStateNormal];
    
    if (currentEffectPosition == 0) {
        [effectSlotButton0 setSelected:YES];
        [effectSlotButton1 setSelected:NO];
    } else if (currentEffectPosition == 1) {
        [effectSlotButton0 setSelected:NO];
        [effectSlotButton1 setSelected:YES];
    }
    
    //--- Update Display of Effect Type and Slider Values ---//
    [self displayEffectParameters:currentEffectPosition];
    
    
    
    //--- Set Background Image ---//
    [[self view] setBackgroundColor: [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background.png"]]];
    
    
    timer = [NSTimer scheduledTimerWithTimeInterval:0.1f
                                             target:self
                                           selector:@selector(motionUpdateSliders)
                                           userInfo:nil
                                            repeats:YES];
}





- (void)displayEffectParameters: (int)position {
    
    NSString* buttonTitle = [effectNames objectAtIndex:_backendInterface->getEffectType(currentSampleID, currentEffectPosition)];
    [effectTypeButton setTitle:buttonTitle forState:UIControlStateNormal];
    [self updateButtons];
    [self updateSliders];
    
}




//--- Sample Parameter Changes ---//

// Set Gain
- (IBAction)gainSliderChanged:(UISlider *)sender
{
    _backendInterface->setSampleParameter(currentSampleID, PARAM_GAIN, sender.value);
    [gainLabel setText:[@(sender.value) stringValue]];
}

- (IBAction)quantizationSliderChanged:(UISlider *)sender {
    _backendInterface->setSampleParameter(currentSampleID, PARAM_QUANTIZATION, (int)sender.value);
    [quantizationLabel setText:[@( pow(2, (int)sender.value) ) stringValue]];
}



//--- Parameter Action Methods ---//

- (IBAction)bypassStateChanged:(UISwitch *)sender {
    if (sender.on == YES) {
        _backendInterface->setEffectParameter(currentSampleID, currentEffectPosition, PARAM_BYPASS, 1.0f);
    } else {
        _backendInterface->setEffectParameter(currentSampleID, currentEffectPosition, PARAM_BYPASS, 0.0f);
    }
    
}

- (IBAction)sliderChanged0:(UISlider *)sender {
    _backendInterface->setEffectParameter(currentSampleID, currentEffectPosition, PARAM_1, sender.value);
    [sliderCurrentValue0 setText:[@(sender.value) stringValue]];
}

- (IBAction)sliderChanged1:(UISlider *)sender {
    _backendInterface->setEffectParameter(currentSampleID, currentEffectPosition, PARAM_2, sender.value);
    [sliderCurrentValue1 setText:[@(sender.value) stringValue]];
}

- (IBAction)sliderChanged2:(UISlider *)sender {
    _backendInterface->setEffectParameter(currentSampleID, currentEffectPosition, PARAM_3, sender.value);
    [sliderCurrentValue2 setText:[@(sender.value) stringValue]];
}



//--- Gesture Control Toggles ---//

- (IBAction)gainGestureObjectToggle:(UIButton *)sender {
    if (_backendInterface->getSampleGestureControlToggle(currentSampleID, PARAM_MOTION_GAIN)) {
        _backendInterface->setSampleGestureControlToggle(currentSampleID, PARAM_MOTION_GAIN, false);
        [sender setSelected:NO];
        [gainSliderObject setEnabled:YES];
        [gainLabel setHidden:NO];
        
    } else {
        _backendInterface->setSampleGestureControlToggle(currentSampleID, PARAM_MOTION_GAIN, true);
        [sender setSelected:YES];
        [gainSliderObject setEnabled:NO];
        [gainLabel setHidden:YES];
    }
}

- (IBAction)quantizationGestureObjectToggle:(UIButton *)sender {
    if (_backendInterface->getSampleGestureControlToggle(currentSampleID, PARAM_MOTION_QUANT)) {
        _backendInterface->setSampleGestureControlToggle(currentSampleID, PARAM_MOTION_QUANT, false);
        [sender setSelected:NO];
        [quantizationSliderObject setEnabled:YES];
        [quantizationLabel setHidden:NO];
    } else {
        _backendInterface->setSampleGestureControlToggle(currentSampleID, PARAM_MOTION_QUANT, true);
        [sender setSelected:YES];
        [quantizationSliderObject setEnabled:NO];
        [quantizationLabel setHidden:YES];
    }
}

- (IBAction)gestureObjectToggle0:(UIButton *)sender {
    if (_backendInterface->getEffectGestureControlToggle(currentSampleID, currentEffectPosition, PARAM_MOTION_PARAM1)) {
        _backendInterface->setEffectGestureControlToggle(currentSampleID, currentEffectPosition, PARAM_MOTION_PARAM1, false);
        [sender setSelected:NO];
        [sliderObject0 setEnabled:YES];
        [sliderCurrentValue0 setHidden:NO];
    } else {
        _backendInterface->setEffectGestureControlToggle(currentSampleID, currentEffectPosition, PARAM_MOTION_PARAM1, true);
        [sender setSelected:YES];
        [sliderObject0 setEnabled:NO];
        [sliderCurrentValue0 setHidden:YES];
    }
}


- (IBAction)gestureObjectToggle1:(UIButton *)sender {
    if (_backendInterface->getEffectGestureControlToggle(currentSampleID, currentEffectPosition, PARAM_MOTION_PARAM2)) {
        _backendInterface->setEffectGestureControlToggle(currentSampleID, currentEffectPosition, PARAM_MOTION_PARAM2, false);
        [sender setSelected:NO];
        [sliderObject1 setEnabled:YES];
        [sliderCurrentValue1 setHidden:NO];
    } else {
        _backendInterface->setEffectGestureControlToggle(currentSampleID, currentEffectPosition, PARAM_MOTION_PARAM2, true);
        [sender setSelected:YES];
        [sliderObject1 setEnabled:NO];
        [sliderCurrentValue1 setHidden:YES];
    }
}


- (IBAction)gestureObjectToggle2:(UIButton *)sender {
    if (_backendInterface->getEffectGestureControlToggle(currentSampleID, currentEffectPosition, PARAM_MOTION_PARAM3)) {
        _backendInterface->setEffectGestureControlToggle(currentSampleID, currentEffectPosition, PARAM_MOTION_PARAM3, false);
        [sender setSelected:NO];
        [sliderObject2 setEnabled:YES];
        [sliderCurrentValue2 setHidden:NO];
    } else {
        _backendInterface->setEffectGestureControlToggle(currentSampleID, currentEffectPosition, PARAM_MOTION_PARAM3, true);
        [sender setSelected:YES];
        [sliderObject2 setEnabled:NO];
        [sliderCurrentValue2 setHidden:YES];
    }
}


- (IBAction)fxButtonClicked0:(UIButton *)sender {
    currentEffectPosition = 0;
    [effectSlotButton0 setSelected:YES];
    [effectSlotButton1 setSelected:NO];
    [self displayEffectParameters:currentEffectPosition];
}


- (IBAction)fxButtonClicked1:(UIButton *)sender {
    currentEffectPosition = 1;
    [effectSlotButton0 setSelected:NO];
    [effectSlotButton1 setSelected:YES];
    [self displayEffectParameters:currentEffectPosition];
}


- (void) updateSliders {
    
    float param1 = _backendInterface->getEffectParameter(currentSampleID, currentEffectPosition, PARAM_1);
    float param2 = _backendInterface->getEffectParameter(currentSampleID, currentEffectPosition, PARAM_2);
    float param3 = _backendInterface->getEffectParameter(currentSampleID, currentEffectPosition, PARAM_3);
    
    [sliderObject0 setValue:param1];
    [sliderObject1 setValue:param2];
    [sliderObject2 setValue:param3];
    
    [sliderCurrentValue0 setText:[@(param1) stringValue]];
    [sliderCurrentValue1 setText:[@(param2) stringValue]];
    [sliderCurrentValue2 setText:[@(param3) stringValue]];
}


- (void) updateButtons {
    
    
    if (_backendInterface->getEffectParameter(currentSampleID, currentEffectPosition, PARAM_BYPASS) < 0.5) {
        [bypassButtonObject setOn:NO animated:YES];
    } else {
        [bypassButtonObject setOn:YES animated:YES];
    }
    
    
    
    //-- Update Gesture Control Buttons --//
    
    if (_backendInterface->getEffectGestureControlToggle(currentSampleID, currentEffectPosition, PARAM_MOTION_PARAM1)) {
        [paramGestureObject0 setSelected:YES];
        [sliderObject0 setEnabled:NO];
        [sliderCurrentValue0 setHidden:YES];
    } else {
        [paramGestureObject0 setSelected:NO];
        [sliderObject0 setEnabled:YES];
        [sliderCurrentValue0 setHidden:NO];
    }
    
    if (_backendInterface->getEffectGestureControlToggle(currentSampleID, currentEffectPosition, PARAM_MOTION_PARAM2))
    {
        [paramGestureObject1 setSelected:YES];
        [sliderObject1 setEnabled:NO];
        [sliderCurrentValue1 setHidden:YES];
    } else {
        [paramGestureObject1 setSelected:NO];
        [sliderObject1 setEnabled:YES];
        [sliderCurrentValue1 setHidden:NO];
    }
    
    if (_backendInterface->getEffectGestureControlToggle(currentSampleID, currentEffectPosition, PARAM_MOTION_PARAM3)) {
        [paramGestureObject2 setSelected:YES];
        [sliderObject2 setEnabled:NO];
        [sliderCurrentValue2 setHidden:YES];
    } else {
        [paramGestureObject2 setSelected:NO];
        [sliderObject2 setEnabled:YES];
        [sliderCurrentValue2 setHidden:NO];
    }
    
    
    NSString* effectTitle = [effectNames objectAtIndex:_backendInterface->getEffectType(currentSampleID, currentEffectPosition)];
    NSArray* params = [effectDict objectForKey:effectTitle];
    
    NSString* text1 = [params objectAtIndex:0];
    NSString* text2 = [params objectAtIndex:1];
    NSString* text3 = [params objectAtIndex:2];
    
    [sliderParamName0 setText:text1];
    [sliderParamName1 setText:text2];
    [sliderParamName2 setText:text3];
}




//--- Destructor ---//

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSLog(@"Memory Warning in BeatMotionViewController");
}




- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"loadEffectTable"]) {
        
        EffectTableViewController* vc = [segue destinationViewController];
        [vc setSampleID:currentSampleID];
        [vc setEffectPosition: currentEffectPosition];
    }
    
    
}


- (void)motionUpdateSliders {
    
    if (_backendInterface->getEffectGestureControlToggle(currentSampleID, currentEffectPosition, PARAM_MOTION_PARAM1))
    {
        float param1 = _backendInterface->getMotionParameter(currentSampleID, currentEffectPosition, PARAM_1);
        [sliderObject0 setValue:param1];
        [sliderCurrentValue0 setText:[@(param1) stringValue]];
    }
    
    if (_backendInterface->getEffectGestureControlToggle(currentSampleID, currentEffectPosition, PARAM_MOTION_PARAM2))
    {
        float param2 = _backendInterface->getMotionParameter(currentSampleID, currentEffectPosition, PARAM_2);
        [sliderObject1 setValue:param2];
        [sliderCurrentValue1 setText:[@(param2) stringValue]];
    }
    
    if (_backendInterface->getEffectGestureControlToggle(currentSampleID, currentEffectPosition, PARAM_MOTION_PARAM3))
    {
        float param3 = _backendInterface->getMotionParameter(currentSampleID, currentEffectPosition, PARAM_3);
        [sliderObject2 setValue:param3];
        [sliderCurrentValue2 setText:[@(param3) stringValue]];
    }
    
    if (_backendInterface->getSampleGestureControlToggle(currentSampleID, PARAM_MOTION_GAIN))
    {
        float gain = _backendInterface->getSampleParameter(currentSampleID, PARAM_GAIN);
        [gainSliderObject setValue:gain];
    }
    
    if (_backendInterface->getSampleGestureControlToggle(currentSampleID, PARAM_MOTION_QUANT))
    {
        float quant = _backendInterface->getSampleParameter(currentSampleID, PARAM_QUANTIZATION);
        [quantizationSliderObject setValue:quant];
    }
}




- (void)dealloc
{
    [timer invalidate];
    [effectNames release];
    
    [gainSliderObject release];
    [quantizationSliderObject release];
    
    [gainGestureObject release];
    [quantizationGestureObject release];
    [paramGestureObject0 release];
    [paramGestureObject1 release];
    [paramGestureObject2 release];
    
    [gainLabel release];
    [quantizationLabel release];

    
    [effectSlotButton0 release];
    [effectSlotButton1 release];

    [effectTypeButton release];

    [bypassButtonObject release];
    
    [sliderObject0 release];
    [sliderObject1 release];
    [sliderObject2 release];
    
    [sliderCurrentValue0 release];
    [sliderCurrentValue1 release];
    [sliderCurrentValue2 release];
    
    [sliderParamName0 release];
    [sliderParamName1 release];
    [sliderParamName2 release];
    
    [quantizationSliderObject release];
    
    [super dealloc];
}

@end
