//==============================================================================
//
//  GlobalSettingsViewController.mm
//  BeMotion
//
//  Created by Govinda Ram Pingali on 4/10/14.
//  Copyright (c) 2014 BeMotionLLC. All rights reserved.
//
//==============================================================================


#import "GlobalSettingsViewController.h"

@interface GlobalSettingsViewController ()

@end

@implementation GlobalSettingsViewController

@synthesize tempoLabel, tempoSlider;
@synthesize presetButton1, presetButton2, presetButton3, presetButton4, presetButton5, presetButton6, presetButton7;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    m_iTempo                = [_metronome getTempo];
    m_iCurrentPresetBank    = _backendInterface->getCurrentPresetBank();
    [self updatePresetButton];
    [tempoLabel setText:[@(m_iTempo) stringValue]];
    [tempoSlider setValue:m_iTempo];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (void)dealloc
{
    [tempoSlider release];
    [tempoLabel release];
    
    [presetButton1 release];
    [presetButton2 release];
    [presetButton3 release];
    [presetButton4 release];
    [presetButton5 release];
    [presetButton6 release];
    
    [super dealloc];
}



- (IBAction)tempoSliderChanged:(UISlider *)sender
{
    m_iTempo = sender.value;
    
    [_metronome setTempo:m_iTempo];
    [tempoLabel setText:[@(m_iTempo) stringValue]];
}


- (IBAction)presetClicked1:(UIButton *)sender
{
    m_iCurrentPresetBank    =   0;
    [self loadPresetBank];
    [self updatePresetButton];
}

- (IBAction)presetClicked2:(UIButton *)sender
{
    m_iCurrentPresetBank    =   1;
    [self loadPresetBank];
    [self updatePresetButton];
}

- (IBAction)presetClicked3:(UIButton *)sender
{
    m_iCurrentPresetBank    =   2;
    [self loadPresetBank];
    [self updatePresetButton];
}

- (IBAction)presetClicked4:(UIButton *)sender
{
    m_iCurrentPresetBank    =   3;
    [self loadPresetBank];
    [self updatePresetButton];
}

- (IBAction)presetClicked5:(UIButton *)sender
{
    m_iCurrentPresetBank    =   4;
    [self loadPresetBank];
    [self updatePresetButton];
}

- (IBAction)presetClicked6:(UIButton *)sender
{
    m_iCurrentPresetBank    =   5;
    [self loadPresetBank];
    [self updatePresetButton];
}


- (IBAction)presetClicked7:(UIButton *)sender
{
    m_iCurrentPresetBank    =   6;
    [self loadPresetBank];
    [self updatePresetButton];
}




- (void) updatePresetButton
{
    switch (m_iCurrentPresetBank)
    {
        case PRESET_BANK_1:
            [presetButton1 setAlpha:1.0f];
            [presetButton2 setAlpha:0.2f];
            [presetButton3 setAlpha:0.2f];
            [presetButton4 setAlpha:0.2f];
            [presetButton5 setAlpha:0.2f];
            [presetButton6 setAlpha:0.2f];
            [presetButton7 setAlpha:0.2f];
            break;
            
        case PRESET_BANK_2:
            [presetButton1 setAlpha:0.2f];
            [presetButton2 setAlpha:1.0f];
            [presetButton3 setAlpha:0.2f];
            [presetButton4 setAlpha:0.2f];
            [presetButton5 setAlpha:0.2f];
            [presetButton6 setAlpha:0.2f];
            [presetButton7 setAlpha:0.2f];
            break;
            
            
        case PRESET_BANK_3:
            [presetButton1 setAlpha:0.2f];
            [presetButton2 setAlpha:0.2f];
            [presetButton3 setAlpha:1.0f];
            [presetButton4 setAlpha:0.2f];
            [presetButton5 setAlpha:0.2f];
            [presetButton6 setAlpha:0.2f];
            [presetButton7 setAlpha:0.2f];
            break;
            
        case PRESET_BANK_4:
            [presetButton1 setAlpha:0.2f];
            [presetButton2 setAlpha:0.2f];
            [presetButton3 setAlpha:0.2f];
            [presetButton4 setAlpha:1.0f];
            [presetButton5 setAlpha:0.2f];
            [presetButton6 setAlpha:0.2f];
            [presetButton7 setAlpha:0.2f];
            break;
            
            
        case PRESET_BANK_5:
            [presetButton1 setAlpha:0.2f];
            [presetButton2 setAlpha:0.2f];
            [presetButton3 setAlpha:0.2f];
            [presetButton4 setAlpha:0.2f];
            [presetButton5 setAlpha:1.0f];
            [presetButton6 setAlpha:0.2f];
            [presetButton7 setAlpha:0.2f];
            break;
            
            
        case PRESET_BANK_6:
            [presetButton1 setAlpha:0.2f];
            [presetButton2 setAlpha:0.2f];
            [presetButton3 setAlpha:0.2f];
            [presetButton4 setAlpha:0.2f];
            [presetButton5 setAlpha:0.2f];
            [presetButton6 setAlpha:1.0f];
            [presetButton7 setAlpha:0.2f];
            break;
            
            
        case PRESET_BANK_7:
            [presetButton1 setAlpha:0.2f];
            [presetButton2 setAlpha:0.2f];
            [presetButton3 setAlpha:0.2f];
            [presetButton4 setAlpha:0.2f];
            [presetButton5 setAlpha:0.2f];
            [presetButton6 setAlpha:0.2f];
            [presetButton7 setAlpha:1.0f];
            break;
            
        default:
            break;
    }
}



- (void)loadPresetBank
{
    _backendInterface->setCurrentPresetBank(m_iCurrentPresetBank);
    
    switch (m_iCurrentPresetBank)
    {
        case PRESET_BANK_1:
            
            sample1Path = [[NSBundle mainBundle] pathForResource:@"E_Kit0" ofType:@"wav"];
            sample2Path = [[NSBundle mainBundle] pathForResource:@"E_Kit1" ofType:@"wav"];
            sample3Path = [[NSBundle mainBundle] pathForResource:@"E_Kit2" ofType:@"wav"];
            sample4Path = [[NSBundle mainBundle] pathForResource:@"E_Kit3" ofType:@"wav"];
            sample5Path = [[NSBundle mainBundle] pathForResource:@"E_Kit4" ofType:@"wav"];
            
            m_iTempo = BANK1_TEMPO;
            
            break;
            
        case PRESET_BANK_2:
            
            sample1Path = [[NSBundle mainBundle] pathForResource:@"DubBeat0" ofType:@"wav"];
            sample2Path = [[NSBundle mainBundle] pathForResource:@"DubBeat1" ofType:@"wav"];
            sample3Path = [[NSBundle mainBundle] pathForResource:@"DubBeat2" ofType:@"wav"];
            sample4Path = [[NSBundle mainBundle] pathForResource:@"Breakbeat2" ofType:@"wav"];
            sample5Path = [[NSBundle mainBundle] pathForResource:@"DubBeat4" ofType:@"wav"];
            
            m_iTempo = BANK2_TEMPO;
            
            break;
            
            
        case PRESET_BANK_3:
            
            sample1Path = [[NSBundle mainBundle] pathForResource:@"Breakbeat0" ofType:@"wav"];
            sample2Path = [[NSBundle mainBundle] pathForResource:@"Breakbeat1" ofType:@"wav"];
            sample3Path = [[NSBundle mainBundle] pathForResource:@"DubBeat2" ofType:@"wav"];
            sample4Path = [[NSBundle mainBundle] pathForResource:@"Breakbeat3" ofType:@"wav"];
            sample5Path = [[NSBundle mainBundle] pathForResource:@"Breakbeat4" ofType:@"wav"];
            
            m_iTempo = BANK3_TEMPO;
            
            break;
            
        case PRESET_BANK_4:
            
            sample1Path = [[NSBundle mainBundle] pathForResource:@"Indian_Percussion0" ofType:@"wav"];
            sample2Path = [[NSBundle mainBundle] pathForResource:@"Indian_Percussion1" ofType:@"wav"];
            sample3Path = [[NSBundle mainBundle] pathForResource:@"Indian_Percussion2" ofType:@"wav"];
            sample4Path = [[NSBundle mainBundle] pathForResource:@"Indian_Percussion3" ofType:@"wav"];
            sample5Path = [[NSBundle mainBundle] pathForResource:@"Indian_Percussion4" ofType:@"wav"];
            
            m_iTempo = BANK4_TEMPO;
            
            break;
            
            
        case PRESET_BANK_5:
            
            sample1Path = [[NSBundle mainBundle] pathForResource:@"Embryo0" ofType:@"wav"];
            sample2Path = [[NSBundle mainBundle] pathForResource:@"Embryo1" ofType:@"wav"];
            sample3Path = [[NSBundle mainBundle] pathForResource:@"Embryo2" ofType:@"wav"];
            sample4Path = [[NSBundle mainBundle] pathForResource:@"Embryo3" ofType:@"wav"];
            sample5Path = [[NSBundle mainBundle] pathForResource:@"Embryo4" ofType:@"wav"];
            
            m_iTempo = BANK5_TEMPO;
            
            break;
            
            
        case PRESET_BANK_6:
            
            sample1Path = [[NSBundle mainBundle] pathForResource:@"Skies0" ofType:@"wav"];
            sample2Path = [[NSBundle mainBundle] pathForResource:@"Skies1" ofType:@"wav"];
            sample3Path = [[NSBundle mainBundle] pathForResource:@"Skies2" ofType:@"wav"];
            sample4Path = [[NSBundle mainBundle] pathForResource:@"Skies3" ofType:@"wav"];
            sample5Path = [[NSBundle mainBundle] pathForResource:@"Skies4" ofType:@"wav"];
            
            m_iTempo = BANK6_TEMPO;
            
            break;
            
            
        case PRESET_BANK_7:
            
            sample1Path = [[NSBundle mainBundle] pathForResource:@"MachineTransformations0" ofType:@"wav"];
            sample2Path = [[NSBundle mainBundle] pathForResource:@"MachineTransformations1" ofType:@"wav"];
            sample3Path = [[NSBundle mainBundle] pathForResource:@"MachineTransformations2" ofType:@"wav"];
            sample4Path = [[NSBundle mainBundle] pathForResource:@"MachineTransformations3" ofType:@"wav"];
            sample5Path = [[NSBundle mainBundle] pathForResource:@"MachineTransformations4" ofType:@"wav"];
            
            m_iTempo = BANK7_TEMPO;
            
            break;
            
        default:
            break;
    }
    
    
    if( (_backendInterface->loadAudioFile(0, sample1Path)) != 0 )
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error Loading Audio File"
                                                        message:@"Retry loading"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        
    }
    
    if( (_backendInterface->loadAudioFile(1, sample2Path)) != 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error Loading Audio File"
                                                        message:@"Retry loading"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    
    if( (_backendInterface->loadAudioFile(2, sample3Path)) != 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error Loading Audio File"
                                                        message:@"Retry loading"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    
    
    if( (_backendInterface->loadAudioFile(3, sample4Path)) != 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error Loading Audio File"
                                                        message:@"Retry loading"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    
    
    if( (_backendInterface->loadAudioFile(4, sample5Path)) != 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error Loading Audio File"
                                                        message:@"Retry loading"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    
    
    
    [_metronome setTempo:m_iTempo];
    [tempoLabel setText:[@(m_iTempo) stringValue]];
    [tempoSlider setValue:m_iTempo];
    
}




@end
