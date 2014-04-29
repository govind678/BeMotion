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
    [gainSliderObject setValue:_backEndInterface->getSampleParameter(m_iCurrentSampleID, PARAM_GAIN)];
    [playbackModeObject setSelectedSegmentIndex:_backEndInterface->getSampleParameter(m_iCurrentSampleID, PARAM_PLAYBACK_MODE)];
    [quantizationSliderObject setValue:_backEndInterface->getSampleParameter(m_iCurrentSampleID, PARAM_QUANTIZATION)];
    
    
    //--- Get Effect Parameters ---//
    [pickerObject selectRow:_backEndInterface->getEffectType(m_iCurrentSampleID, m_iCurrentEffectPosition) inComponent:0 animated:YES];
    [self updateSlidersAndLabels];
}





//--- Sample Parameter Changes ---//

// Set Gain
- (IBAction)gainSliderChanged:(UISlider *)sender
{
    _backEndInterface->setSampleParameter(m_iCurrentSampleID, PARAM_GAIN, sender.value);
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
}






//--- Audio Effect Parameter Changes ---//


// Effect Position Segmented View - Display parameters based on effect position
- (IBAction)SegementControl:(UISegmentedControl *)sender
{
    m_iCurrentEffectPosition    =   sender.selectedSegmentIndex;
    [pickerObject selectRow:_backEndInterface->getEffectType(m_iCurrentSampleID, m_iCurrentEffectPosition) inComponent:0 animated:YES];
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
}

- (IBAction)Slider2Changed:(UISlider *)sender
{
    _backEndInterface->setEffectParameter(m_iCurrentSampleID, m_iCurrentEffectPosition, PARAM_2, sender.value);
}

- (IBAction)Slider3Changed:(UISlider *)sender
{
    _backEndInterface->setEffectParameter(m_iCurrentSampleID, m_iCurrentEffectPosition, PARAM_3, sender.value);
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





//--- Gesture Control ---//

- (IBAction)gainGestureToggle:(UIButton *)sender
{
//    _backEndInterface->setSampleGestureControlToggle(m_iCurrentSampleID, PARAM_GAIN, )
    
}

- (IBAction)quantGestureToggle:(UIButton *)sender
{
    
}

- (IBAction)param1GestureToggle:(UIButton *)sender
{
    
}

- (IBAction)param2GestureToggle:(UIButton *)sender
{
    
}

- (IBAction)param3GestureToggle:(UIButton *)sender
{
    
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
    
    
    [_gainGestureObject release];
    [super dealloc];
}


@end
