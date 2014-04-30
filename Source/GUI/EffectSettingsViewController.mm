//
//  EffectSettingsViewController.mm
//  SharedLibrary
//
//  Created by Anand on 3/9/14.
//  Copyright (c) 2014 GTCMT. All rights reserved.
//

#import  "EffectSettingsViewController.h"


@interface EffectSettingsViewController ()

@end




@implementation EffectSettingsViewController

@synthesize m_iCurrentSampleID;

@synthesize effectNames;
@synthesize gainSliderObject, playbackModeObject, quantizationSliderObject;
@synthesize pickerObject, bypassButtonObject;
@synthesize slider1Object, slider2Object, slider3Object;
@synthesize slider1CurrentValue, slider2CurrentValue, slider3CurrentValue;
@synthesize slider1EffectParam, slider2EffectParam, slider3EffectParam;
@synthesize gainGestureObject, quantGestureObject, param1GestureObject, param2GestureObject, param3GestureObject;
@synthesize gainLabel, quantizationLabel;





- (void)awakeFromNib
{
    self.effectNames  = @[@"None", @"Tremolo", @"Delay", @"Vibrato", @"Wah", @"Granularizer"];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
}



- (void)viewDidAppear:(BOOL)animated
{
    m_iCurrentEffectPosition        =   0;
    
    
    //--- Get Sample Parameters ---//
    float gain = _backEndInterface->getSampleParameter(m_iCurrentSampleID, PARAM_GAIN);
    [gainSliderObject setValue:gain];
    [gainLabel setText:[@(gain) stringValue]];
    
    [playbackModeObject setSelectedSegmentIndex:_backEndInterface->getSampleParameter(m_iCurrentSampleID, PARAM_PLAYBACK_MODE)];
    
    float quantization = _backEndInterface->getSampleParameter(m_iCurrentSampleID, PARAM_QUANTIZATION);
    [quantizationSliderObject setValue:quantization];
    [quantizationLabel setText:[@( powf(2, (int)quantization) ) stringValue]];
    
    
    //--- Get Sample Gesture Control Toggles ---//
    if (_backEndInterface->getSampleGestureControlToggle(m_iCurrentSampleID, PARAM_MOTION_GAIN))
    {
        [gainGestureObject setAlpha: 1.0f];
        [gainSliderObject setEnabled:NO];
    }
    
    else
    {
        [gainGestureObject setAlpha: 0.4f];
        [gainSliderObject setEnabled:YES];
    }
    
    if (_backEndInterface->getSampleGestureControlToggle(m_iCurrentSampleID, PARAM_MOTION_QUANT))
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
    [pickerObject selectRow:_backEndInterface->getEffectType(m_iCurrentSampleID, m_iCurrentEffectPosition) inComponent:0 animated:YES];
    [self updateSlidersAndLabels];
    
}





//--- Sample Parameter Changes ---//

// Set Gain
- (IBAction)gainSliderChanged:(UISlider *)sender
{
    _backEndInterface->setSampleParameter(m_iCurrentSampleID, PARAM_GAIN, sender.value);
    [gainLabel setText:[@(sender.value) stringValue]];
}


// Segmented Control for Button Mode
- (IBAction)buttonModeChanged:(UISegmentedControl *)sender
{
    _backEndInterface->setSampleParameter(m_iCurrentSampleID, PARAM_PLAYBACK_MODE, (int)sender.selectedSegmentIndex);
}


// Set Quantization Time for Note Repeat
- (IBAction)quantizationSliderChanged:(UISlider *)sender
{
    _backEndInterface->setSampleParameter(m_iCurrentSampleID, PARAM_QUANTIZATION, (int)sender.value);
    [quantizationLabel setText:[@( pow(2, (int)sender.value) ) stringValue]];
}






//--- Audio Effect Parameter Changes ---//


// Effect Position Segmented View - Display parameters based on effect position
- (IBAction)SegementControl:(UISegmentedControl *)sender
{
    m_iCurrentEffectPosition    =   (int)sender.selectedSegmentIndex;
    int effectType = _backEndInterface->getEffectType(m_iCurrentSampleID, m_iCurrentEffectPosition);
    [pickerObject selectRow:effectType inComponent:0 animated:YES];
    [self updateSlidersAndLabels];
}



//--- UI Picker View Stuff for Choosing Audio Effect ---//

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1; // Only 1 component
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return NUM_EFFECTS;
}

// Fill Picker View with effect names
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return effectNames[row];
}

// Callback when picker row is changed
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _backEndInterface->addAudioEffect(m_iCurrentSampleID, m_iCurrentEffectPosition, (int)row);
    [self updateSlidersAndLabels];
}



- (IBAction)bypassToggleButtonChanged:(UISwitch *)sender
{
    _backEndInterface->setEffectParameter(m_iCurrentSampleID, m_iCurrentEffectPosition, PARAM_BYPASS, sender.on);
}

- (IBAction)Slider1Changed:(UISlider *)sender
{
    _backEndInterface->setEffectParameter(m_iCurrentSampleID, m_iCurrentEffectPosition, PARAM_1, sender.value);
    [slider1CurrentValue setText:[@(sender.value) stringValue]];
}

- (IBAction)Slider2Changed:(UISlider *)sender
{
    _backEndInterface->setEffectParameter(m_iCurrentSampleID, m_iCurrentEffectPosition, PARAM_2, sender.value);
    [slider2CurrentValue setText:[@(sender.value) stringValue]];
}

- (IBAction)Slider3Changed:(UISlider *)sender
{
    _backEndInterface->setEffectParameter(m_iCurrentSampleID, m_iCurrentEffectPosition, PARAM_3, sender.value);
    [slider3CurrentValue setText:[@(sender.value) stringValue]];
}






- (void) updateSlidersAndLabels
{
    float param1 = _backEndInterface->getEffectParameter(m_iCurrentSampleID, m_iCurrentEffectPosition, PARAM_1);
    float param2 = _backEndInterface->getEffectParameter(m_iCurrentSampleID, m_iCurrentEffectPosition, PARAM_2);
    float param3 = _backEndInterface->getEffectParameter(m_iCurrentSampleID, m_iCurrentEffectPosition, PARAM_3);
    
    [slider1Object setValue:param1];
    [slider2Object setValue:param2];
    [slider3Object setValue:param3];
    
    [slider1CurrentValue setText:[@(param1) stringValue]];
    [slider2CurrentValue setText:[@(param2) stringValue]];
    [slider3CurrentValue setText:[@(param3) stringValue]];
    
    [bypassButtonObject setSelected:_backEndInterface->getEffectParameter(m_iCurrentSampleID, m_iCurrentEffectPosition, PARAM_BYPASS)];
    
    
    //-- Update Gesture Control Buttons --//
    
    if (_backEndInterface->getEffectGestureControlToggle(m_iCurrentSampleID, m_iCurrentEffectPosition, PARAM_MOTION_PARAM1))
    {
        [param1GestureObject setAlpha:1.0f];
    }
    
    else
    {
        [param1GestureObject setAlpha:0.4f];
    }
    
    if (_backEndInterface->getEffectGestureControlToggle(m_iCurrentSampleID, m_iCurrentEffectPosition, PARAM_MOTION_PARAM2))
    {
        [param2GestureObject setAlpha:1.0f];
    }
    
    else
    {
        [param2GestureObject setAlpha:0.4f];
    }
    
    if (_backEndInterface->getEffectGestureControlToggle(m_iCurrentSampleID, m_iCurrentEffectPosition, PARAM_MOTION_PARAM3))
    {
        [param3GestureObject setAlpha:1.0f];
    }
    
    else
    {
        [param3GestureObject setAlpha:0.4f];
    }
    
    
    
    
    
    switch (_backEndInterface->getEffectType(m_iCurrentSampleID, m_iCurrentEffectPosition))
    {
        case 0:
            [self.slider1EffectParam setText:@"Null"];
            [self.slider2EffectParam setText:@"Null"];
            [self.slider3EffectParam setText:@"Null"];
            break;
            
        case 1:
            [self.slider1EffectParam setText:@"Frequency"];
            [self.slider2EffectParam setText:@"Depth"];
            [self.slider3EffectParam setText:@"LFO"];
            break;
            
        case 2:
            [self.slider1EffectParam setText:@"Time"];
            [self.slider2EffectParam setText:@"Feedback"];
            [self.slider3EffectParam setText:@"Wet/Dry"];
            break;
            
        case 3:
            [self.slider1EffectParam setText:@"Rate"];
            [self.slider2EffectParam setText:@"Width"];
            [self.slider3EffectParam setText:@"LFO"];
            break;
            
        case 4:
            [self.slider1EffectParam setText:@"Gain"];
            [self.slider2EffectParam setText:@"Frequency"];
            [self.slider3EffectParam setText:@"Resonance"];
            break;
            
            
        case 5:
            [self.slider1EffectParam setText:@"Size"];
            [self.slider2EffectParam setText:@"Interval"];
            [self.slider3EffectParam setText:@"Pool"];
            break;
            
            
        default:
            break;
    }
}





//--- Gesture Control Toggles ---//

- (IBAction)gainGestureToggle:(UIButton *)sender
{
    if (_backEndInterface->getSampleGestureControlToggle(m_iCurrentSampleID, PARAM_MOTION_GAIN))
    {
        _backEndInterface->setSampleGestureControlToggle(m_iCurrentSampleID, PARAM_MOTION_GAIN, false);
        sender.alpha = 0.4;
        [gainSliderObject setEnabled:YES];
    }
    
    else
    {
        _backEndInterface->setSampleGestureControlToggle(m_iCurrentSampleID, PARAM_MOTION_GAIN, true);
        sender.alpha = 1.0f;
        [gainSliderObject setEnabled:NO];
    }
}

- (IBAction)quantGestureToggle:(UIButton *)sender
{
    if (_backEndInterface->getSampleGestureControlToggle(m_iCurrentSampleID, PARAM_MOTION_QUANT))
    {
        _backEndInterface->setSampleGestureControlToggle(m_iCurrentSampleID, PARAM_MOTION_QUANT, false);
        sender.alpha = 0.4;
        [quantizationSliderObject setEnabled:YES];
    }
    
    else
    {
        _backEndInterface->setSampleGestureControlToggle(m_iCurrentSampleID, PARAM_MOTION_QUANT, true);
        sender.alpha = 1.0f;
        [quantizationSliderObject setEnabled:NO];
    }
}

- (IBAction)param1GestureToggle:(UIButton *)sender
{
    if (_backEndInterface->getEffectGestureControlToggle(m_iCurrentSampleID, m_iCurrentEffectPosition, PARAM_MOTION_PARAM1))
    {
        _backEndInterface->setEffectGestureControlToggle(m_iCurrentSampleID, m_iCurrentEffectPosition, PARAM_MOTION_PARAM1, false);
        sender.alpha = 0.4;
    }
    
    else
    {
        _backEndInterface->setEffectGestureControlToggle(m_iCurrentSampleID, m_iCurrentEffectPosition, PARAM_MOTION_PARAM1, true);
        sender.alpha = 1.0f;
    }
}

- (IBAction)param2GestureToggle:(UIButton *)sender
{
    if (_backEndInterface->getEffectGestureControlToggle(m_iCurrentSampleID, m_iCurrentEffectPosition, PARAM_MOTION_PARAM2))
    {
        _backEndInterface->setEffectGestureControlToggle(m_iCurrentSampleID, m_iCurrentEffectPosition, PARAM_MOTION_PARAM2, false);
        sender.alpha = 0.4;
    }
    
    else
    {
        _backEndInterface->setEffectGestureControlToggle(m_iCurrentSampleID, m_iCurrentEffectPosition, PARAM_MOTION_PARAM2, true);
        sender.alpha = 1.0f;
    }
}

- (IBAction)param3GestureToggle:(UIButton *)sender
{
    if (_backEndInterface->getEffectGestureControlToggle(m_iCurrentSampleID, m_iCurrentEffectPosition, PARAM_MOTION_PARAM3))
    {
        _backEndInterface->setEffectGestureControlToggle(m_iCurrentSampleID, m_iCurrentEffectPosition, PARAM_MOTION_PARAM3, false);
        sender.alpha = 0.4;
    }
    
    else
    {
        _backEndInterface->setEffectGestureControlToggle(m_iCurrentSampleID, m_iCurrentEffectPosition, PARAM_MOTION_PARAM3, true);
        sender.alpha = 1.0f;
    }
    
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [pickerObject release];
    

    [gainSliderObject release];
    [quantizationSliderObject release];
    [bypassButtonObject release];
    [playbackModeObject release];
    
    
    [gainGestureObject release];
    [quantGestureObject release];
    [param1GestureObject release];
    [param2GestureObject release];
    [param3GestureObject release];
    
    [gainLabel release];
    [quantizationLabel release];
    
    [super dealloc];
}


@end
