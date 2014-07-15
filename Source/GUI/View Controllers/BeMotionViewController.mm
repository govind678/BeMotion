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
@synthesize metronomeButton;
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
    sampleButton0 = [[SampleButton alloc] initWithFrame:CGRectMake(0.0f, 20.0f, 320.0f, 100.0f) : 0];
    [sampleButton0 setBackendInterface:_backendInterface];
    [sampleButton0 postInitialize];
    [sampleButton0 setDelegate:self];
    [[self view] addSubview:sampleButton0];
    
    
    sampleButton1 = [[SampleButton alloc] initWithFrame:CGRectMake(0.0f, 135.0f, 320.0f, 100.0f) : 1];
    [sampleButton1 setBackendInterface:_backendInterface];
    [sampleButton1 postInitialize];
    [sampleButton1 setDelegate:self];
    [[self view] addSubview:sampleButton1];
    
    sampleButton2 = [[SampleButton alloc] initWithFrame:CGRectMake(0.0f, 250.0f, 320.0f, 100.0f) : 2];
    [sampleButton2 setBackendInterface:_backendInterface];
    [sampleButton2 postInitialize];
    [sampleButton2 setDelegate:self];
    [[self view] addSubview:sampleButton2];
    
    sampleButton3 = [[SampleButton alloc] initWithFrame:CGRectMake(0.0f, 365.0f, 320.0f, 100.0f) : 3];
    [sampleButton3 setBackendInterface:_backendInterface];
    [sampleButton3 postInitialize];
    [sampleButton3 setDelegate:self];
    [[self view] addSubview:sampleButton3];
    
    
    
    if ([_metronome isRunning]) {
        [metronomeButton setSelected:YES];
    } else {
        [metronomeButton setSelected:NO];
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
    
    
    [metronomeButton release];
    
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

- (IBAction)metronomeToggleClicked:(UIButton *)sender
{
    //    if ([_metronome isRunning] == NO) {
    if (_backendInterface->getMetronomeStatus() == false) {
        //        [_metronome startClock];
        _backendInterface->startMetronome();
        [metronomeButton setSelected:YES];
    }
    
    else {
        //        [_metronome stopClock];
        _backendInterface->stopMetronome();
        [metronomeButton setSelected:NO];
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




//--- Sample Buttons Delegate Methods ---//

//- (void)startPlayback:(int)sampleID {
//
//    _backendInterface->startPlayback(sampleID);
//
//    switch (sampleID) {
//        case 0:
//            [sampleButton0 setAlpha:1.0f];
//            break;
//
//        case 1:
//            [sampleButton1 setAlpha:1.0f];
//            break;
//
//        case 2:
//            [sampleButton2 setAlpha:1.0f];
//            break;
//
//        case 3:
//            [sampleButton3 setAlpha:1.0f];
//            break;
//
//        default:
//            break;
//    }
//}
//
//
//- (void)stopPlayback:(int)sampleID {
//
//    _backendInterface->stopPlayback(sampleID);
//
//    switch (sampleID) {
//        case 0:
//            [sampleButton0 setAlpha:BUTTON_OFF_ALPHA];
//            break;
//
//        case 1:
//            [sampleButton1 setAlpha:BUTTON_OFF_ALPHA];
//            break;
//
//        case 2:
//            [sampleButton2 setAlpha:BUTTON_OFF_ALPHA];
//            break;
//
//        case 3:
//            [sampleButton3 setAlpha:BUTTON_OFF_ALPHA];
//            break;
//
//        default:
//            break;
//    }
//}





//--- Settings Buttons Delegate Methods ---//

//- (void) startRecording:(int)sampleID {
//
//    if ([_metronome isRunning] == YES) {
//        m_pbAudioRecordToggle[sampleID] = true;
//    } else {
//        _backendInterface->startRecording(sampleID);
//    }
//}
//
//
//- (void) stopRecording:(int)sampleID {
//
//    if ([_metronome isRunning] == YES) {
//        m_pbAudioRecordToggle[sampleID] = false;
//    } else {
//        _backendInterface->stopRecording(sampleID);
//    }
//}


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


@end
