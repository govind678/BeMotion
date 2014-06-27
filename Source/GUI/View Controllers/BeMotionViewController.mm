//==============================================================================
//
//  BeMotionViewController.mm
//  BeMotion
//
//  Created by Govinda Ram Pingali on 3/8/14.
//  Copyright (c) 2014 BeMotionLLC. All rights reserved.
//
//==============================================================================



#import "BeMotionViewController.h"
#import "BeMotionAppDelegate.h"


@interface BeMotionViewController ()
{
    BeMotionAppDelegate*   appDelegate;
}

@end



@implementation BeMotionViewController

@synthesize progressBar0, progressBar1, progressBar2, progressBar3;
@synthesize sampleButton0, sampleButton1, sampleButton2, sampleButton3;
@synthesize settingsButton0, settingsButton1, settingsButton2, settingsButton3;
@synthesize metronomeButton, settingsButton;
@synthesize metronomeBar;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    //--- Get Reference to Backend ---//
    appDelegate = [[UIApplication sharedApplication] delegate];
    _backendInterface   =  [appDelegate getBackendReference];
    
    
    //--- Get Reference to Metronome ---//
    _metronome          =   [appDelegate getMetronomeReference];
    [_metronome setDelegate:self];
    
    
    //--- Initialize Master Record Toggles ---//
    m_pbMasterRecordToggle      =   new bool [NUM_BUTTONS];
    m_pbMasterBeginRecording    =   new bool [NUM_BUTTONS];
    
    m_pbAudioRecordToggle       =   new bool [NUM_BUTTONS];
    m_pbAudioCurrentlyRecording =   new bool [NUM_BUTTONS];
    
    
    //--- Reset Toggles ---//
    for (int i=0; i< NUM_BUTTONS; i++)
    {
        m_pbMasterRecordToggle[i]       =   false;
        m_pbMasterBeginRecording[i]     =   false;
        m_pbAudioRecordToggle[i]        =   false;
        m_pbAudioCurrentlyRecording[i]  =   false;
    }

    
    
    
    
    //--- Sample Buttons Init ---//
    
    [sampleButton0 setButtonID:0];
    [sampleButton0 setDelegate:self];
    [sampleButton0 init];
    
    [sampleButton1 setButtonID:1];
    [sampleButton1 setDelegate:self];
    [sampleButton1 init];
    
    [sampleButton2 setButtonID:2];
    [sampleButton2 setDelegate:self];
    [sampleButton2 init];
    
    [sampleButton3 setButtonID:3];
    [sampleButton3 setDelegate:self];
    [sampleButton3 init];
    
    
    //--- Set Sample Button and Progress Bar States ---//
    [self setSamplePlaybackAlpha];
    
    
    
    //--- Settings Buttons Init ---//
    
    [settingsButton0 setButtonID:0];
    [settingsButton0 setUserInteractionEnabled:NO];
    [settingsButton0 setHidden:YES];
    [settingsButton0 setDelegate:self];
    [settingsButton0 init];
    
    [settingsButton1 setButtonID:1];
    [settingsButton1 setUserInteractionEnabled:NO];
    [settingsButton1 setHidden:YES];
    [settingsButton1 setDelegate:self];
    [settingsButton1 init];
    
    [settingsButton2 setButtonID:2];
    [settingsButton2 setUserInteractionEnabled:NO];
    [settingsButton2 setHidden:YES];
    [settingsButton2 setDelegate:self];
    [settingsButton2 init];
    
    [settingsButton3 setButtonID:3];
    [settingsButton3 setUserInteractionEnabled:NO];
    [settingsButton3 setHidden:YES];
    [settingsButton3 setDelegate:self];
    [settingsButton3 init];
    
    
    
    
    //--- TODO: Retain Settings Status? ---//
    [settingsButton setAlpha:BUTTON_OFF_ALPHA];
    
    if ([_metronome isRunning]) {
        [metronomeButton setAlpha:1.0f];
    } else {
        [metronomeButton setAlpha:BUTTON_OFF_ALPHA];
    }
    
    
    
    //--- Initialize Timer for Progress Bar Updates ---//
    [NSTimer scheduledTimerWithTimeInterval:PROGRESS_UPDATE_RATE
                                     target:self
                                   selector:@selector(updatePlaybackProgress)
                                   userInfo:nil
                                    repeats:YES];
    
    
    
    //--- Initialize Metronome Bar ---//
    metronomeBar = [[MetronomeBar alloc] initWithFrame:CGRectMake(20.0f, 480.0f, 280.0f, 5.0f)];
    [[self view] addSubview:metronomeBar];
    
    
    //--- Initialize Motion Control ---//
    motionControl = [[MotionControl alloc] init];
    
    
    
    
    //--- Set Background Image ---//
    [[self view] setBackgroundColor: [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background.png"]]];
    
    
    m_bSettingsToggle   =   false;
    //--- Retain Settings Status ---//
    if (_backendInterface->getSettingsToggle()) {
        
        //--- Display Settings Buttons ---//
        [self toggleSettings:true];
//        _backendInterface->setSettingsToggle(false);
        
    } else {
        
        //--- Hide Settings Buttons ---//
        [self toggleSettings:false];
//        _backendInterface->setSettingsToggle(true);
    }

}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (void)dealloc
{
    delete [] m_pbMasterRecordToggle;
    delete [] m_pbMasterBeginRecording;
    delete [] motion;
    
    delete [] m_pbAudioCurrentlyRecording;
    delete [] m_pbAudioRecordToggle;
    
    [motionControl release];
    
    [progressBar0 release];
    [progressBar1 release];
    [progressBar2 release];
    [progressBar3 release];
    
    
  
    [sampleButton0 release];
    [sampleButton1 release];
    [sampleButton2 release];
    [sampleButton3 release];
    
    [settingsButton0 release];
    [settingsButton1 release];
    [settingsButton2 release];
    [settingsButton3 release];
    
    
    [metronomeButton release];
    [settingsButton release];
    
    [metronomeBar release];
    
    [super dealloc];
}




//--- Metronome Methods ---//

- (void) guiBeat:(int)beatNo
{
    
    //--- Quantized Microphone Recording ---//
    for (int i=0; i < NUM_BUTTONS; i++)
    {
        if (m_pbAudioRecordToggle[i])
        {
            if (! m_pbAudioCurrentlyRecording[i])
            {
                _backendInterface->startRecording(i);
                m_pbAudioCurrentlyRecording[i] = true;
            }
        }
        
        else
        {
            if (m_pbAudioCurrentlyRecording[i])
            {
                _backendInterface->stopRecording(i);
                m_pbAudioCurrentlyRecording[i] = false;
            }
        }
    }
    
    
    
    //--- Display Metronome Ticks and Quantize Resampling ---//
    
    if (beatNo == 1)
    {
        //--- Quantized Resampling ---//
        for (int i=0; i < NUM_BUTTONS; i++)
        {
            if (m_pbMasterBeginRecording[i])
            {
                _backendInterface->stopRecordingOutput(i);
                NSLog(@"Stop Resampling %i", i);
                m_pbMasterBeginRecording[i] = false;
                m_pbMasterRecordToggle[i]   = false;
                
                
                //--- Quantize Recording ---//
                if (m_pbMasterRecordToggle[i])
                {
                    NSLog(@"Start Resampling %d", i);
                    _backendInterface->startRecordingOutput(i);
                    m_pbMasterBeginRecording[i] = true;
                }
            }
        }

    }
        
    [metronomeBar beat:beatNo];
}








//--- Modifier Keys ---//


- (IBAction)settingsToggleClicked:(UIButton *)sender
{
    if (m_bSettingsToggle) {
        
        //--- Display Settings Buttons ---//
        [self toggleSettings:true];
        _backendInterface->setSettingsToggle(true);
        m_bSettingsToggle = false;
        
    } else {
        
        //--- Hide Settings Buttons ---//
        [self toggleSettings:false];
        _backendInterface->setSettingsToggle(false);
        m_bSettingsToggle = true;
    }
}



- (IBAction)metronomeToggleClicked:(UIButton *)sender
{
    if ([_metronome isRunning] == NO) {
        [_metronome startClock];
        [metronomeButton setAlpha:1.0f];
    }
    
    else {
        [_metronome stopClock];
        [metronomeButton setAlpha:BUTTON_OFF_ALPHA];
        [metronomeBar turnOff];
    }
}


- (void) setTempo:(float)tempo
{
    _backendInterface->setTempo(tempo);
}



- (void) updatePlaybackProgress
{
    for (int i=0; i < NUM_BUTTONS; i++)
    {
        switch (i)
        {
            case 0:
                progressBar0.progress = _backendInterface->getSampleCurrentPlaybackTime(i);
                break;
                
            case 1:
                progressBar1.progress = _backendInterface->getSampleCurrentPlaybackTime(i);
                break;
                
            case 2:
                progressBar2.progress = _backendInterface->getSampleCurrentPlaybackTime(i);
                break;
                
            case 3:
                progressBar3.progress = _backendInterface->getSampleCurrentPlaybackTime(i);
                break;
                
            default:
                break;
        }
    }
    
}


//--- Settings Button Methods ---//

- (void)toggleSettings:(bool)toggle {
    
    if (toggle == YES) {
        
        [settingsButton setAlpha:1.0f];
        
        [sampleButton0 setHidden:YES];
        [sampleButton1 setHidden:YES];
        [sampleButton2 setHidden:YES];
        [sampleButton3 setHidden:YES];
        
        [sampleButton0 setUserInteractionEnabled:NO];
        [sampleButton1 setUserInteractionEnabled:NO];
        [sampleButton2 setUserInteractionEnabled:NO];
        [sampleButton3 setUserInteractionEnabled:NO];
        
        [progressBar0 setHidden:YES];
        [progressBar1 setHidden:YES];
        [progressBar2 setHidden:YES];
        [progressBar3 setHidden:YES];
            
        [settingsButton0 setHidden:NO];
        [settingsButton0 setUserInteractionEnabled:YES];
        
        [settingsButton1 setHidden:NO];
        [settingsButton1 setUserInteractionEnabled:YES];
        
        [settingsButton2 setHidden:NO];
        [settingsButton2 setUserInteractionEnabled:YES];
        
        [settingsButton3 setHidden:NO];
        [settingsButton3 setUserInteractionEnabled:YES];

    }
    
    else {
        
        [settingsButton setAlpha:BUTTON_OFF_ALPHA];
        
        [progressBar0 setHidden:NO];
        [progressBar1 setHidden:NO];
        [progressBar2 setHidden:NO];
        [progressBar3 setHidden:NO];
        
        [self setSamplePlaybackAlpha];
        
        [sampleButton0 setHidden:NO];
        [sampleButton1 setHidden:NO];
        [sampleButton2 setHidden:NO];
        [sampleButton3 setHidden:NO];
        
        [sampleButton0 setUserInteractionEnabled:YES];
        [sampleButton1 setUserInteractionEnabled:YES];
        [sampleButton2 setUserInteractionEnabled:YES];
        [sampleButton3 setUserInteractionEnabled:YES];
        

            
        [settingsButton0 setHidden:YES];
        [settingsButton0 setUserInteractionEnabled:NO];
        
        [settingsButton1 setHidden:YES];
        [settingsButton1 setUserInteractionEnabled:NO];
        
        [settingsButton2 setHidden:YES];
        [settingsButton2 setUserInteractionEnabled:NO];
        
        [settingsButton3 setHidden:YES];
        [settingsButton3 setUserInteractionEnabled:NO];

    }
    
}





//--- Sample Buttons Delegate Methods ---//

- (void)startPlayback:(int)sampleID {
    
    _backendInterface->startPlayback(sampleID);
    
    switch (sampleID) {
        case 0:
            [sampleButton0 setAlpha:1.0f];
            break;
            
        case 1:
            [sampleButton1 setAlpha:1.0f];
            break;
            
        case 2:
            [sampleButton2 setAlpha:1.0f];
            break;
            
        case 3:
            [sampleButton3 setAlpha:1.0f];
            break;
            
        default:
            break;
    }
}


- (void)stopPlayback:(int)sampleID {
    
    _backendInterface->stopPlayback(sampleID);
    
    switch (sampleID) {
        case 0:
            [sampleButton0 setAlpha:BUTTON_OFF_ALPHA];
            break;
            
        case 1:
            [sampleButton1 setAlpha:BUTTON_OFF_ALPHA];
            break;
            
        case 2:
            [sampleButton2 setAlpha:BUTTON_OFF_ALPHA];
            break;
            
        case 3:
            [sampleButton3 setAlpha:BUTTON_OFF_ALPHA];
            break;
            
        default:
            break;
    }
}





//--- Settings Buttons Delegate Methods ---//

- (void) startRecording:(int)sampleID {
    
    if ([_metronome isRunning] == YES) {
        m_pbAudioRecordToggle[sampleID] = true;
    } else {
        _backendInterface->startRecording(sampleID);
    }
}


- (void) stopRecording:(int)sampleID {
    
    if ([_metronome isRunning] == YES) {
        m_pbAudioRecordToggle[sampleID] = false;
    } else {
        _backendInterface->stopRecording(sampleID);
    }
}


- (void) launchFXView:(int)sampleID {
    
    EffectSettingsViewController *effectSettingsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"EffectSettingsViewController"];
    [effectSettingsVC setCurrentSampleID:sampleID];
    [[self navigationController] pushViewController:effectSettingsVC animated:YES];
}



//--- Media Picker ---//

- (void) launchImportView:(int)sampleID
{
    LoadSampleViewController *loadSampleVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LoadSampleViewController"];
    [loadSampleVC setSampleID:sampleID];
    [[self navigationController] pushViewController:loadSampleVC animated:YES];
}



- (void) startCopyingMediaFile
{
    //    [[self view] setAlpha:0.4f];
    //    [activityIndicator startAnimating];
}


- (void) stopCopyingMediaFile
{
    //    [[self view] setAlpha:1.0f];
    //    [activityIndicator stopAnimating];
}







- (void) startResampling:(int)sampleID
{
    if ([_metronome isRunning])
    {
        m_pbMasterRecordToggle[sampleID] = true;
    }

}



//--- Utility Methods ---//

- (void) setSamplePlaybackAlpha {
    
    if (_backendInterface->getSamplePlaybackStatus(0)) {
        [sampleButton0 setAlpha:1.0f];
        [progressBar0 setAlpha:1.0f];
    } else {
        [sampleButton0 setAlpha:BUTTON_OFF_ALPHA];
        [progressBar0 setAlpha:0.0f];
    }
    
    if (_backendInterface->getSamplePlaybackStatus(1)) {
        [sampleButton1 setAlpha:1.0f];
        [progressBar1 setAlpha:1.0f];
    } else {
        [sampleButton1 setAlpha:BUTTON_OFF_ALPHA];
        [progressBar1 setAlpha:0.0f];
    }
    
    if (_backendInterface->getSamplePlaybackStatus(2)) {
        [sampleButton2 setAlpha:1.0f];
        [progressBar2 setAlpha:1.0f];
    } else {
        [sampleButton2 setAlpha:BUTTON_OFF_ALPHA];
        [progressBar2 setAlpha:0.0f];
    }
    
    if (_backendInterface->getSamplePlaybackStatus(3)) {
        [sampleButton3 setAlpha:1.0f];
        [progressBar2 setAlpha:1.0f];
    } else {
        [sampleButton3 setAlpha:BUTTON_OFF_ALPHA];
        [progressBar3 setAlpha:0.0f];
    }
}



@end
