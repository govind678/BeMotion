//
//  EffectSettingsViewController.mm
//  SharedLibrary
//
//  Created by Anand on 3/9/14.
//  Copyright (c) 2014 GTCMT. All rights reserved.
//

#import  "EffectSettingsViewController.h"


@interface EffectSettingsViewController ()

@property (nonatomic,retain) NSArray *effects;

@property (retain, nonatomic) IBOutlet UILabel *slider1EffectParam;
@property (retain, nonatomic) IBOutlet UILabel *slider2EffectParam;
@property (retain, nonatomic) IBOutlet UILabel *slider3EffectParam;
@property (retain, nonatomic) IBOutlet UILabel *slider1CurrentValue;
@property (retain, nonatomic) IBOutlet UILabel *slider2CurrentValue;
@property (retain, nonatomic) IBOutlet UILabel *slider3CurrentValue;
@property (retain, nonatomic) IBOutlet UILabel *effectBeingModifiedLabel;


@end


static BOOL  m_bEffectBypassToggle[NUM_EFFECTS];
static int   m_iCurrentEffectChosen[NUM_EFFECTS];
static int   m_iCurrentEffectPosition;
//static float m_fSliderValues[NUM_EFFECTS_PARAMS]; // these are just indicators, they will be mapped to actual effects params
// which will be passed from the UserInterfaceData class


@implementation EffectSettingsViewController

@synthesize m_iCurrentSampleID;


- (IBAction)Slider1Changed:(UISlider *)sender
{
     _backEndInterface->setEffectParameter(m_iCurrentSampleID, m_iCurrentEffectPosition, PARAM_1, sender.value);
    //redSample.sampleID = [NSNumber numberWithFloat:10];
}


- (IBAction)Slider2Changed:(UISlider *)sender {
     _backEndInterface->setEffectParameter(m_iCurrentSampleID, m_iCurrentEffectPosition, PARAM_2, sender.value);
}


- (IBAction)Slider3Changed:(UISlider *)sender {
     _backEndInterface->setEffectParameter(m_iCurrentSampleID, m_iCurrentEffectPosition, PARAM_3, sender.value);
}


- (IBAction)gainSliderChanged:(UISlider *)sender
{
    _backEndInterface->setSampleParameter(m_iCurrentSampleID, PARAM_GAIN, sender.value);
}

- (IBAction)bypassToggleButtonChanged:(UISwitch *)sender {
    _backEndInterface->setEffectParameter(m_iCurrentSampleID, m_iCurrentEffectPosition, PARAM_BYPASS, sender.on);
}




- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1; // Only 1 component
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return NUM_EFFECTS;
    
}

// the below routine will be called automatically
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.effects[row];
}

// also called automatically
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSString *LabelEffectParam = self.effects[row];
    LabelEffectParam = [LabelEffectParam stringByAppendingString:@" Parameters"];
    [self.effectBeingModifiedLabel setText:LabelEffectParam];
    
    switch (row) {
        case 0:
            [self.slider1EffectParam setText:@"Null"];
            [self.slider2EffectParam setText:@"Null"];
            [self.slider3EffectParam setText:@"Null"];
            m_iCurrentEffectChosen[m_iCurrentEffectPosition] = EFFECT_NONE;
            [self.currentData.effectChain replaceObjectAtIndex:m_iCurrentEffectPosition withObject:[NSNumber numberWithInt:m_iCurrentEffectChosen[m_iCurrentEffectPosition]]];
            break;
        case 1:
            [self.slider1EffectParam setText:@"Frequency"];
            [self.slider2EffectParam setText:@"Depth"];
            [self.slider3EffectParam setText:@"LFO"];
            m_iCurrentEffectChosen[m_iCurrentEffectPosition] = EFFECT_TREMOLO;
            [self.currentData.effectChain replaceObjectAtIndex:m_iCurrentEffectPosition withObject:[NSNumber numberWithInt:m_iCurrentEffectChosen[m_iCurrentEffectPosition]]];
            break;
        case 2:
            [self.slider1EffectParam setText:@"Time"];
            [self.slider2EffectParam setText:@"Feedback"];
            [self.slider3EffectParam setText:@"Wet/Dry"];
            m_iCurrentEffectChosen[m_iCurrentEffectPosition] = EFFECT_DELAY;
            [self.currentData.effectChain replaceObjectAtIndex:m_iCurrentEffectPosition withObject:[NSNumber numberWithInt:m_iCurrentEffectChosen[m_iCurrentEffectPosition]]];
            break;
        case 3:
            [self.slider1EffectParam setText:@"Rate"];
            [self.slider2EffectParam setText:@"Width"];
            [self.slider3EffectParam setText:@"LFO"];
            m_iCurrentEffectChosen[m_iCurrentEffectPosition] = EFFECT_VIBRATO;
            [self.currentData.effectChain replaceObjectAtIndex:m_iCurrentEffectPosition withObject:[NSNumber numberWithInt:m_iCurrentEffectChosen[m_iCurrentEffectPosition]]];
            break;
        
        case 4:
            [self.slider1EffectParam setText:@"Gain"];
            [self.slider2EffectParam setText:@"Frequency"];
            [self.slider3EffectParam setText:@"Resonance"];
            m_iCurrentEffectChosen[m_iCurrentEffectPosition] = EFFECT_WAH;
            [self.currentData.effectChain replaceObjectAtIndex:m_iCurrentEffectPosition withObject:[NSNumber numberWithInt:m_iCurrentEffectChosen[m_iCurrentEffectPosition]]];
            break;
            
            
        case 5:
            [self.slider1EffectParam setText:@"Size"];
            [self.slider2EffectParam setText:@"Interval"];
            [self.slider3EffectParam setText:@"Pool"];
            m_iCurrentEffectChosen[m_iCurrentEffectPosition] = EFFECT_GRANULAR;
            [self.currentData.effectChain replaceObjectAtIndex:m_iCurrentEffectPosition withObject:[NSNumber numberWithInt:m_iCurrentEffectChosen[m_iCurrentEffectPosition]]];
            break;
            
            
        default:
            break;
    }
    
    
    _backEndInterface->addAudioEffect(m_iCurrentSampleID, m_iCurrentEffectPosition, (int)row);
    
}

- (IBAction)SegementControl:(UISegmentedControl *)sender {
    switch(sender.selectedSegmentIndex){
        case 0:
            m_iCurrentEffectPosition = 0;
            if (m_bEffectBypassToggle[m_iCurrentEffectPosition]) [self.bypassButtonObject setOn:TRUE]; else [self.bypassButtonObject setOn:FALSE];
            [self.pickerObject selectRow:m_iCurrentEffectChosen[m_iCurrentEffectPosition] inComponent:0 animated:YES];
            [self.currentData.effectChain replaceObjectAtIndex:m_iCurrentEffectPosition withObject:[NSNumber numberWithInt:m_iCurrentEffectChosen[m_iCurrentEffectPosition]]];
            break;
        case 1:
            m_iCurrentEffectPosition = 1;
            if (m_bEffectBypassToggle[m_iCurrentEffectPosition]) [self.bypassButtonObject setOn:TRUE]; else [self.bypassButtonObject setOn:FALSE];
            [self.pickerObject selectRow:m_iCurrentEffectChosen[m_iCurrentEffectPosition] inComponent:0 animated:YES];
            [self.currentData.effectChain replaceObjectAtIndex:m_iCurrentEffectPosition withObject:[NSNumber numberWithInt:m_iCurrentEffectChosen[m_iCurrentEffectPosition]]];
            break;
        case 2:
            m_iCurrentEffectPosition = 2;
            if (m_bEffectBypassToggle[m_iCurrentEffectPosition]) [self.bypassButtonObject setOn:TRUE]; else [self.bypassButtonObject setOn:FALSE];
            [self.pickerObject selectRow:m_iCurrentEffectChosen[m_iCurrentEffectPosition] inComponent:0 animated:YES];
            [self.currentData.effectChain replaceObjectAtIndex:m_iCurrentEffectPosition withObject:[NSNumber numberWithInt:m_iCurrentEffectChosen[m_iCurrentEffectPosition]]];
            break;
        case 3:
            m_iCurrentEffectPosition = 3;
            if (m_bEffectBypassToggle[m_iCurrentEffectPosition]) [self.bypassButtonObject setOn:TRUE]; else [self.bypassButtonObject setOn:FALSE];
            [self.pickerObject selectRow:m_iCurrentEffectChosen[m_iCurrentEffectPosition] inComponent:0 animated:YES];
            [self.currentData.effectChain replaceObjectAtIndex:m_iCurrentEffectPosition withObject:[NSNumber numberWithInt:m_iCurrentEffectChosen[m_iCurrentEffectPosition]]];
            break;
        default:
            break;
    }
    

}

// Segmented Control for Button Mode
- (IBAction)buttonModeChanged:(UISegmentedControl *)sender
{
    switch ((int)sender.selectedSegmentIndex)
    {
        case 0:
            _backEndInterface->setMode(m_iCurrentSampleID, MODE_LOOP);
            break;
            
        case 1:
            _backEndInterface->setMode(m_iCurrentSampleID, MODE_TRIGGER);
            break;
            
        case 2:
            _backEndInterface->setMode(m_iCurrentSampleID, MODE_BEATREPEAT);
            break;
            
        default:
            break;
    }
    
}

- (IBAction)quantizationSliderChanged:(UISlider *)sender
{
    _backEndInterface->setSampleParameter(m_iCurrentSampleID, PARAM_QUANTIZATION, (int)sender.value);
}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)bypassButton:(UISwitch *)sender {
    
//    switch(m_iCurrentEffectChosen[m_iCurrentEffectPosition]){
//        case EFFECT_TREMOLO:
//            self.currentData.tremoloEffect.bypass   = (sender.on ? [NSNumber numberWithInt:1]:[NSNumber numberWithInt:0]);
//            m_bEffectBypassToggle[m_iCurrentEffectPosition] = (sender.on ? 1:0);
//            break;
//        case EFFECT_DELAY:
//            self.currentData.delayEffect.bypass = (sender.on ? [NSNumber numberWithInt:1]:[NSNumber numberWithInt:0]);
//            m_bEffectBypassToggle[m_iCurrentEffectPosition] = (sender.on ? 1:0);
//            break;
//        case EFFECT_VIBRATO:
//            self.currentData.vibratoEffect.bypass = (sender.on ? [NSNumber numberWithInt:1]:[NSNumber numberWithInt:0]);
//            m_bEffectBypassToggle[m_iCurrentEffectPosition] = (sender.on ? 1:0);
//            break;
//        case EFFECT_WAH:
//            self.currentData.wahEffect.bypass     = (sender.on ? [NSNumber numberWithInt:1]:[NSNumber numberWithInt:0]);
//            m_bEffectBypassToggle[m_iCurrentEffectPosition] = (sender.on ? 1:0);
//            break;
//        case EFFECT_GRANULAR:
//            self.currentData.wahEffect.bypass     = (sender.on ? [NSNumber numberWithInt:1]:[NSNumber numberWithInt:0]);
//            m_bEffectBypassToggle[m_iCurrentEffectPosition] = (sender.on ? 1:0);
//            break;
//        default:
//            break;
//    }
    
    _backEndInterface->setEffectParameter(_currentData.sampleID.intValue, m_iCurrentEffectPosition, PARAM_BYPASS, sender.on);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    m_iCurrentEffectChosen[0] = EFFECT_NONE;
    self.effects  = @[@"None", @"Tremolo", @"Delay", @"Vibrato", @"Wah", @"Granularizer"];

	// Do any additional setup after loading the view.
    
    //if (m_bEffectBypassToggle[0]) [self.bypassButtonObject setOn:TRUE]; else [self.bypassButtonObject setOn:FALSE];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_effects release];
    //[_currentData release];
    [_slider1EffectParam release];
    [_slider2EffectParam release];
    [_slider3EffectParam release];
    [_slider1CurrentValue release];
    [_slider2CurrentValue release];
    [_slider3CurrentValue release];
    [_effectBeingModifiedLabel release];

    [_slider1Object release];
    [_slider2Object release];
    [_slider3Object release];
    [_bypassButtonObject release];
    [_pickerObject release];
    
//    delete _backEndInterface;

    [super dealloc];
}
@end
