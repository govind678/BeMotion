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
#import "BeMotionAppDelegate.h"

@interface GlobalSettingsViewController ()
{
    BeMotionAppDelegate*   appDelegate;
}

@end

@implementation GlobalSettingsViewController

@synthesize tempoLabel, tempoSlider;
@synthesize presetButton1, presetButton2, presetButton3, presetButton4, presetButton5, presetButton6, presetButton7, presetButton8, presetButton9, presetButton10;
@synthesize fxPackButton0, fxPackButton1, fxPackButton2, fxPackButton3, fxPackButton4;


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
    
    //--- Get Reference to Backend and Metronome ---//
    appDelegate = [[UIApplication sharedApplication] delegate];
    _backendInterface   =  [appDelegate getBackendReference];
    _metronome          =  [appDelegate getMetronomeReference];
    
    
    m_iTempo                = [_metronome getTempo];
    m_iCurrentPresetBank    = _backendInterface->getCurrentAudioPresetBank();
    m_iCurrentFXPack        = _backendInterface->getCurrentFXPack();
    
    [self updateAudioPresetButtons];
    [self updateFXPackButtons];
    
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
    [presetButton8 release];
    [presetButton9 release];
    
    [fxPackButton0 release];
    [fxPackButton1 release];
    [fxPackButton2 release];
    [fxPackButton3 release];
    [fxPackButton4 release];
    
    [presetButton10 release];
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
    [self loadAudioPresetBank];
    [self updateAudioPresetButtons];
}

- (IBAction)presetClicked2:(UIButton *)sender
{
    m_iCurrentPresetBank    =   1;
    [self loadAudioPresetBank];
    [self updateAudioPresetButtons];
}

- (IBAction)presetClicked3:(UIButton *)sender
{
    m_iCurrentPresetBank    =   2;
    [self loadAudioPresetBank];
    [self updateAudioPresetButtons];
}

- (IBAction)presetClicked4:(UIButton *)sender
{
    m_iCurrentPresetBank    =   3;
    [self loadAudioPresetBank];
    [self updateAudioPresetButtons];
}

- (IBAction)presetClicked5:(UIButton *)sender
{
    m_iCurrentPresetBank    =   4;
    [self loadAudioPresetBank];
    [self updateAudioPresetButtons];
}

- (IBAction)presetClicked6:(UIButton *)sender
{
    m_iCurrentPresetBank    =   5;
    [self loadAudioPresetBank];
    [self updateAudioPresetButtons];
}


- (IBAction)presetClicked7:(UIButton *)sender
{
    m_iCurrentPresetBank    =   6;
    [self loadAudioPresetBank];
    [self updateAudioPresetButtons];
}

- (IBAction)presetClicked8:(UIButton *)sender
{
    m_iCurrentPresetBank    =   7;
    [self loadAudioPresetBank];
    [self updateAudioPresetButtons];
}


- (IBAction)presetClicked9:(UIButton *)sender
{
    m_iCurrentPresetBank    =   8;
    [self loadAudioPresetBank];
    [self updateAudioPresetButtons];
}

- (IBAction)presetClicked10:(UIButton *)sender
{
    m_iCurrentPresetBank    =   9;
    [self loadAudioPresetBank];
    [self updateAudioPresetButtons];
}



- (void) updateAudioPresetButtons
{
    switch (m_iCurrentPresetBank)
    {
        case PRESET_BANK_EKIT:
            [presetButton1 setAlpha:1.0f];
            [presetButton2 setAlpha:0.2f];
            [presetButton3 setAlpha:0.2f];
            [presetButton4 setAlpha:0.2f];
            [presetButton5 setAlpha:0.2f];
            [presetButton6 setAlpha:0.2f];
            [presetButton7 setAlpha:0.2f];
            [presetButton8 setAlpha:0.2f];
            [presetButton9 setAlpha:0.2f];
            [presetButton10 setAlpha:0.2f];
            break;
            
        case PRESET_BANK_DUBBEAT:
            [presetButton1 setAlpha:0.2f];
            [presetButton2 setAlpha:1.0f];
            [presetButton3 setAlpha:0.2f];
            [presetButton4 setAlpha:0.2f];
            [presetButton5 setAlpha:0.2f];
            [presetButton6 setAlpha:0.2f];
            [presetButton7 setAlpha:0.2f];
            [presetButton8 setAlpha:0.2f];
            [presetButton9 setAlpha:0.2f];
            [presetButton10 setAlpha:0.2f];
            break;
            
            
        case PRESET_BANK_BREAKBEAT:
            [presetButton1 setAlpha:0.2f];
            [presetButton2 setAlpha:0.2f];
            [presetButton3 setAlpha:1.0f];
            [presetButton4 setAlpha:0.2f];
            [presetButton5 setAlpha:0.2f];
            [presetButton6 setAlpha:0.2f];
            [presetButton7 setAlpha:0.2f];
            [presetButton8 setAlpha:0.2f];
            [presetButton9 setAlpha:0.2f];
            [presetButton10 setAlpha:0.2f];
            break;
            
        case PRESET_BANK_INDIANPERC:
            [presetButton1 setAlpha:0.2f];
            [presetButton2 setAlpha:0.2f];
            [presetButton3 setAlpha:0.2f];
            [presetButton4 setAlpha:1.0f];
            [presetButton5 setAlpha:0.2f];
            [presetButton6 setAlpha:0.2f];
            [presetButton7 setAlpha:0.2f];
            [presetButton8 setAlpha:0.2f];
            [presetButton9 setAlpha:0.2f];
            [presetButton10 setAlpha:0.2f];
            break;
            
            
        case PRESET_BANK_EMBRYO:
            [presetButton1 setAlpha:0.2f];
            [presetButton2 setAlpha:0.2f];
            [presetButton3 setAlpha:0.2f];
            [presetButton4 setAlpha:0.2f];
            [presetButton5 setAlpha:1.0f];
            [presetButton6 setAlpha:0.2f];
            [presetButton7 setAlpha:0.2f];
            [presetButton8 setAlpha:0.2f];
            [presetButton9 setAlpha:0.2f];
            [presetButton10 setAlpha:0.2f];
            break;
            
            
        case PRESET_BANK_SKIES:
            [presetButton1 setAlpha:0.2f];
            [presetButton2 setAlpha:0.2f];
            [presetButton3 setAlpha:0.2f];
            [presetButton4 setAlpha:0.2f];
            [presetButton5 setAlpha:0.2f];
            [presetButton6 setAlpha:1.0f];
            [presetButton7 setAlpha:0.2f];
            [presetButton8 setAlpha:0.2f];
            [presetButton9 setAlpha:0.2f];
            [presetButton10 setAlpha:0.2f];
            break;
            
            
        case PRESET_BANK_MT:
            [presetButton1 setAlpha:0.2f];
            [presetButton2 setAlpha:0.2f];
            [presetButton3 setAlpha:0.2f];
            [presetButton4 setAlpha:0.2f];
            [presetButton5 setAlpha:0.2f];
            [presetButton6 setAlpha:0.2f];
            [presetButton7 setAlpha:1.0f];
            [presetButton8 setAlpha:0.2f];
            [presetButton9 setAlpha:0.2f];
            [presetButton10 setAlpha:0.2f];
            break;
            
            
        case PRESET_BANK_LATINPERC:
            [presetButton1 setAlpha:0.2f];
            [presetButton2 setAlpha:0.2f];
            [presetButton3 setAlpha:0.2f];
            [presetButton4 setAlpha:0.2f];
            [presetButton5 setAlpha:0.2f];
            [presetButton6 setAlpha:0.2f];
            [presetButton7 setAlpha:0.2f];
            [presetButton8 setAlpha:1.0f];
            [presetButton9 setAlpha:0.2f];
            [presetButton10 setAlpha:0.2f];
            break;
            
            
        case PRESET_BANK_LATINLOOP:
            [presetButton1 setAlpha:0.2f];
            [presetButton2 setAlpha:0.2f];
            [presetButton3 setAlpha:0.2f];
            [presetButton4 setAlpha:0.2f];
            [presetButton5 setAlpha:0.2f];
            [presetButton6 setAlpha:0.2f];
            [presetButton7 setAlpha:0.2f];
            [presetButton8 setAlpha:0.2f];
            [presetButton9 setAlpha:1.0f];
            [presetButton10 setAlpha:0.2f];
            break;
            
        case PRESET_BANK_ELECTRONIC:
            [presetButton1 setAlpha:0.2f];
            [presetButton2 setAlpha:0.2f];
            [presetButton3 setAlpha:0.2f];
            [presetButton4 setAlpha:0.2f];
            [presetButton5 setAlpha:0.2f];
            [presetButton6 setAlpha:0.2f];
            [presetButton7 setAlpha:0.2f];
            [presetButton8 setAlpha:0.2f];
            [presetButton9 setAlpha:0.2f];
            [presetButton10 setAlpha:1.0f];
            break;
            
        default:
            break;
    }
}



- (void)loadAudioPresetBank
{
    _backendInterface->setCurrentPresetBank(m_iCurrentPresetBank);
    
    switch (m_iCurrentPresetBank)
    {
        case PRESET_BANK_EKIT:
            
            sample1Path = [[NSBundle mainBundle] pathForResource:@"EKit0" ofType:@"wav"];
            sample2Path = [[NSBundle mainBundle] pathForResource:@"EKit1" ofType:@"wav"];
            sample3Path = [[NSBundle mainBundle] pathForResource:@"EKit2" ofType:@"wav"];
            sample4Path = [[NSBundle mainBundle] pathForResource:@"EKit3" ofType:@"wav"];
            sample5Path = [[NSBundle mainBundle] pathForResource:@"EKit4" ofType:@"wav"];
            
            m_iTempo = BANK0_TEMPO;
            
            break;
            
        case PRESET_BANK_DUBBEAT:
            
            sample1Path = [[NSBundle mainBundle] pathForResource:@"DubBeat0" ofType:@"wav"];
            sample2Path = [[NSBundle mainBundle] pathForResource:@"DubBeat1" ofType:@"wav"];
            sample3Path = [[NSBundle mainBundle] pathForResource:@"DubBeat2" ofType:@"wav"];
            sample4Path = [[NSBundle mainBundle] pathForResource:@"Breakbeat2" ofType:@"wav"];
            sample5Path = [[NSBundle mainBundle] pathForResource:@"DubBeat4" ofType:@"wav"];
            
            m_iTempo = BANK1_TEMPO;
            
            break;
            
            
        case PRESET_BANK_BREAKBEAT:
            
            sample1Path = [[NSBundle mainBundle] pathForResource:@"Breakbeat0" ofType:@"wav"];
            sample2Path = [[NSBundle mainBundle] pathForResource:@"Breakbeat1" ofType:@"wav"];
            sample3Path = [[NSBundle mainBundle] pathForResource:@"DubBeat2" ofType:@"wav"];
            sample4Path = [[NSBundle mainBundle] pathForResource:@"Breakbeat3" ofType:@"wav"];
            sample5Path = [[NSBundle mainBundle] pathForResource:@"Breakbeat4" ofType:@"wav"];
            
            m_iTempo = BANK2_TEMPO;
            
            break;
            
        case PRESET_BANK_INDIANPERC:
            
            sample1Path = [[NSBundle mainBundle] pathForResource:@"Indian_Percussion0" ofType:@"wav"];
            sample2Path = [[NSBundle mainBundle] pathForResource:@"Indian_Percussion1" ofType:@"wav"];
            sample3Path = [[NSBundle mainBundle] pathForResource:@"Indian_Percussion2" ofType:@"wav"];
            sample4Path = [[NSBundle mainBundle] pathForResource:@"Indian_Percussion3" ofType:@"wav"];
            sample5Path = [[NSBundle mainBundle] pathForResource:@"Indian_Percussion4" ofType:@"wav"];
            
            m_iTempo = BANK3_TEMPO;
            
            break;
            
            
        case PRESET_BANK_EMBRYO:
            
            sample1Path = [[NSBundle mainBundle] pathForResource:@"Embryo0" ofType:@"wav"];
            sample2Path = [[NSBundle mainBundle] pathForResource:@"Embryo1" ofType:@"wav"];
            sample3Path = [[NSBundle mainBundle] pathForResource:@"Embryo2" ofType:@"wav"];
            sample4Path = [[NSBundle mainBundle] pathForResource:@"Embryo3" ofType:@"wav"];
            sample5Path = [[NSBundle mainBundle] pathForResource:@"Embryo4" ofType:@"wav"];
            
            m_iTempo = BANK4_TEMPO;
            
            break;
            
            
        case PRESET_BANK_SKIES:
            
            sample1Path = [[NSBundle mainBundle] pathForResource:@"Skies0" ofType:@"wav"];
            sample2Path = [[NSBundle mainBundle] pathForResource:@"Skies1" ofType:@"wav"];
            sample3Path = [[NSBundle mainBundle] pathForResource:@"Skies2" ofType:@"wav"];
            sample4Path = [[NSBundle mainBundle] pathForResource:@"Skies3" ofType:@"wav"];
            sample5Path = [[NSBundle mainBundle] pathForResource:@"Skies4" ofType:@"wav"];
            
            m_iTempo = BANK5_TEMPO;
            
            break;
            
            
        case PRESET_BANK_MT:
            
            sample1Path = [[NSBundle mainBundle] pathForResource:@"MachineTransformations0" ofType:@"wav"];
            sample2Path = [[NSBundle mainBundle] pathForResource:@"MachineTransformations1" ofType:@"wav"];
            sample3Path = [[NSBundle mainBundle] pathForResource:@"MachineTransformations2" ofType:@"wav"];
            sample4Path = [[NSBundle mainBundle] pathForResource:@"MachineTransformations3" ofType:@"wav"];
            sample5Path = [[NSBundle mainBundle] pathForResource:@"MachineTransformations4" ofType:@"wav"];
            
            m_iTempo = BANK6_TEMPO;
            
            break;
            
        case PRESET_BANK_LATINPERC:
            
            sample1Path = [[NSBundle mainBundle] pathForResource:@"Latin_Percussion0" ofType:@"wav"];
            sample2Path = [[NSBundle mainBundle] pathForResource:@"Latin_Percussion1" ofType:@"wav"];
            sample3Path = [[NSBundle mainBundle] pathForResource:@"Latin_Percussion2" ofType:@"wav"];
            sample4Path = [[NSBundle mainBundle] pathForResource:@"Latin_Percussion3" ofType:@"wav"];
            sample5Path = [[NSBundle mainBundle] pathForResource:@"Latin_Percussion4" ofType:@"wav"];
            
            m_iTempo = BANK7_TEMPO;
            
            break;
            
        case PRESET_BANK_LATINLOOP:
            
            sample1Path = [[NSBundle mainBundle] pathForResource:@"Latin_Loop0" ofType:@"wav"];
            sample2Path = [[NSBundle mainBundle] pathForResource:@"Latin_Loop1" ofType:@"wav"];
            sample3Path = [[NSBundle mainBundle] pathForResource:@"Latin_Loop2" ofType:@"wav"];
            sample4Path = [[NSBundle mainBundle] pathForResource:@"Latin_Loop3" ofType:@"wav"];
            sample5Path = [[NSBundle mainBundle] pathForResource:@"Latin_Loop4" ofType:@"wav"];
            
            m_iTempo = BANK8_TEMPO;
            
            break;
            
        case PRESET_BANK_ELECTRONIC:
            
            sample1Path = [[NSBundle mainBundle] pathForResource:@"Electronic0" ofType:@"wav"];
            sample2Path = [[NSBundle mainBundle] pathForResource:@"Electronic1" ofType:@"wav"];
            sample3Path = [[NSBundle mainBundle] pathForResource:@"Electronic2" ofType:@"wav"];
            sample4Path = [[NSBundle mainBundle] pathForResource:@"Electronic3" ofType:@"wav"];
            sample5Path = [[NSBundle mainBundle] pathForResource:@"Electronic4" ofType:@"wav"];
            
            m_iTempo = BANK9_TEMPO;
            
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
    
    
    
    //--- Start Playback if Already Playing ---//
    
    for (int i=0; i < NUM_BUTTONS; i++) {
        if (_backendInterface->getSamplePlaybackStatus(i)) {
            _backendInterface->startPlayback(i);
        }
    }
    
    
    [_metronome setTempo:m_iTempo];
    [tempoLabel setText:[@(m_iTempo) stringValue]];
    [tempoSlider setValue:m_iTempo];
    
}




- (IBAction)fxPackClicked0:(UIButton *)sender {
    m_iCurrentFXPack = 0;
    [self loadFXPack];
    [self updateFXPackButtons];
}


- (IBAction)fxPackClicked1:(UIButton *)sender {
    m_iCurrentFXPack = 1;
    [self loadFXPack];
    [self updateFXPackButtons];
}

- (IBAction)fxPackClicked2:(UIButton *)sender {
    m_iCurrentFXPack = 2;
    [self loadFXPack];
    [self updateFXPackButtons];
}

- (IBAction)fxPackClicked3:(UIButton *)sender {
    m_iCurrentFXPack = 3;
    [self loadFXPack];
    [self updateFXPackButtons];
}

- (IBAction)fxPackClicked4:(UIButton *)sender {
    m_iCurrentFXPack = 4;
    [self loadFXPack];
    [self updateFXPackButtons];
}



- (void) updateFXPackButtons {
    
    switch (m_iCurrentFXPack) {
        
        case 0:
            [fxPackButton0 setAlpha:1.0f];
            [fxPackButton1 setAlpha:0.2f];
            [fxPackButton2 setAlpha:0.2f];
            [fxPackButton3 setAlpha:0.2f];
            [fxPackButton4 setAlpha:0.2f];
            break;
        
        case 1:
            [fxPackButton0 setAlpha:0.2f];
            [fxPackButton1 setAlpha:1.0f];
            [fxPackButton2 setAlpha:0.2f];
            [fxPackButton3 setAlpha:0.2f];
            [fxPackButton4 setAlpha:0.2f];
            break;
            
        case 2:
            [fxPackButton0 setAlpha:0.2f];
            [fxPackButton1 setAlpha:0.2f];
            [fxPackButton2 setAlpha:1.0f];
            [fxPackButton3 setAlpha:0.2f];
            [fxPackButton4 setAlpha:0.2f];
            break;
            
        case 3:
            [fxPackButton0 setAlpha:0.2f];
            [fxPackButton1 setAlpha:0.2f];
            [fxPackButton2 setAlpha:0.2f];
            [fxPackButton3 setAlpha:1.0f];
            [fxPackButton4 setAlpha:0.2f];
            break;
            
        case 4:
            [fxPackButton0 setAlpha:0.2f];
            [fxPackButton1 setAlpha:0.2f];
            [fxPackButton2 setAlpha:0.2f];
            [fxPackButton3 setAlpha:0.2f];
            [fxPackButton4 setAlpha:1.0f];
            break;
            
        default:
            break;
    }
}


- (void) loadFXPack {
    
    switch (m_iCurrentFXPack) {
            
        case 0:
            fxPackPath = [[NSBundle mainBundle] pathForResource:@"Percs_Delay" ofType:@"json"];
            break;
            
        case 1:
            fxPackPath = [[NSBundle mainBundle] pathForResource:@"Wah_Tremolo" ofType:@"json"];
            break;
            
        case 2:
            fxPackPath = [[NSBundle mainBundle] pathForResource:@"BeatRepeat" ofType:@"json"];
            [_metronome startClock];
            break;
            
        case 3:
            fxPackPath = [[NSBundle mainBundle] pathForResource:@"Template" ofType:@"json"];
            break;
            
        case 4:
            fxPackPath = [[NSBundle mainBundle] pathForResource:@"DelayWah" ofType:@"json"];
            break;
            
        default:
            break;
    }
    
    _backendInterface->loadFXPreset(m_iCurrentFXPack, fxPackPath);
}



@end
