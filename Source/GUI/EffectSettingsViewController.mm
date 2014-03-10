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
static float m_fSliderValues[NUM_EFFECTS_PARAMS]; // these are just indicators, they will be mapped to actual effects params
// which will be passed from the UserInterfaceData class



@implementation EffectSettingsViewController

- (IBAction)Slider1Changed:(UISlider *)sender {

    //redSample.sampleID = [NSNumber numberWithFloat:10];
}
- (IBAction)Slider2Changed:(UISlider *)sender {
}
- (IBAction)Slider3Changed:(UISlider *)sender {
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
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
            [self.slider1EffectParam setText:@"Delay Time"];
            [self.slider2EffectParam setText:@"Feedback"];
            [self.slider3EffectParam setText:@"WetDry"];
            m_iCurrentEffectChosen[m_iCurrentEffectPosition] = DELAY_EFFECT;
            [self.currentData.effectChain replaceObjectAtIndex:m_iCurrentEffectPosition withObject:[NSNumber numberWithInt:m_iCurrentEffectChosen[m_iCurrentEffectPosition]]];
            break;
        case 1:
            [self.slider1EffectParam setText:@"Depth"];
            [self.slider2EffectParam setText:@"Frequency"];
            [self.slider3EffectParam setText:@"Signal"];
            m_iCurrentEffectChosen[m_iCurrentEffectPosition] = TREMOLO_EFFECT;
            [self.currentData.effectChain replaceObjectAtIndex:m_iCurrentEffectPosition withObject:[NSNumber numberWithInt:m_iCurrentEffectChosen[m_iCurrentEffectPosition]]];
            break;
        case 2:
            [self.slider1EffectParam setText:@"Width"];
            [self.slider2EffectParam setText:@"Frequency"];
            [self.slider3EffectParam setText:@"Signal"];
            m_iCurrentEffectChosen[m_iCurrentEffectPosition] = VIBRATO_EFFECT;
            [self.currentData.effectChain replaceObjectAtIndex:m_iCurrentEffectPosition withObject:[NSNumber numberWithInt:m_iCurrentEffectChosen[m_iCurrentEffectPosition]]];
            break;
        case 3:
            [self.slider1EffectParam setText:@"Frequency"];
            [self.slider2EffectParam setText:@"Gain"];
            [self.slider3EffectParam setText:@"Resonance"];
            m_iCurrentEffectChosen[m_iCurrentEffectPosition] = WAH_EFFECT;
            [self.currentData.effectChain replaceObjectAtIndex:m_iCurrentEffectPosition withObject:[NSNumber numberWithInt:m_iCurrentEffectChosen[m_iCurrentEffectPosition]]];
            break;
        default:
            break;
    }
    
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


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)bypassButton:(UISwitch *)sender {
    NSLog(@"Bypass is pressed");
    switch(m_iCurrentEffectChosen[m_iCurrentEffectPosition]){
        case DELAY_EFFECT:
            self.currentData.delayEffect.bypass   = (sender.on ? [NSNumber numberWithInt:1]:[NSNumber numberWithInt:0]);
            m_bEffectBypassToggle[m_iCurrentEffectPosition] = (sender.on ? 1:0);
            break;
        case TREMOLO_EFFECT:
            self.currentData.tremoloEffect.bypass = (sender.on ? [NSNumber numberWithInt:1]:[NSNumber numberWithInt:0]);
            m_bEffectBypassToggle[m_iCurrentEffectPosition] = (sender.on ? 1:0);
            break;
        case VIBRATO_EFFECT:
            self.currentData.vibratoEffect.bypass = (sender.on ? [NSNumber numberWithInt:1]:[NSNumber numberWithInt:0]);
            m_bEffectBypassToggle[m_iCurrentEffectPosition] = (sender.on ? 1:0);
            break;
        case WAH_EFFECT:
            self.currentData.wahEffect.bypass     = (sender.on ? [NSNumber numberWithInt:1]:[NSNumber numberWithInt:0]);
            m_bEffectBypassToggle[m_iCurrentEffectPosition] = (sender.on ? 1:0);
            break;
        default:
            break;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    m_iCurrentEffectChosen[0] = DELAY_EFFECT;
    self.effects  = @[@"Delay" , @"Tremolo" , @"Vibrato", @"Wah"];

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
    [super dealloc];
}
@end
