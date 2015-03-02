//==============================================================================
//
//  BeatMotionViewController.mm
//  BeatMotion
//
//  Created by Govinda Ram Pingali on 3/8/14.
//  Copyright (c) 2014 BeatMotion. All rights reserved.
//
//==============================================================================



#import "BeatMotionViewController.h"
#import "BMAppDelegate.h"


@interface BeatMotionViewController ()
{
    BMAppDelegate*   appDelegate;
}

@end



@implementation BeatMotionViewController

@synthesize metronomeButton;
@synthesize recordButton;
@synthesize metronomeBar;
//@synthesize tempoPicker;
@synthesize sampleButton0, sampleButton1, sampleButton2, sampleButton3;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    //--- Get Reference to Backend ---//
    appDelegate = [[UIApplication sharedApplication] delegate];
    _backendInterface   =  [appDelegate getBackendReference];
    
    
    //--- Get Reference to Metronome ---//
    _metronome          =   [appDelegate getMetronomeReference];
    [_metronome setDelegate:self];
    
    
    
    //--- Subscribe to OS Notifications ---//
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadFromBackground)
                                                 name:UIApplicationDidBecomeActiveNotification object:nil];
    
    
    
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
    
    recordingToggle = NO;
    
    
    
    //--- Sample Buttons Init ---//
    [sampleButton0 setIdentifier:0];
    [sampleButton0 setBackendInterface:_backendInterface];
    [sampleButton0 postInitialize];
    [sampleButton0 setDelegate:self];
    
    
    [sampleButton1 setIdentifier:1];
    [sampleButton1 setBackendInterface:_backendInterface];
    [sampleButton1 postInitialize];
    [sampleButton1 setDelegate:self];
    
    [sampleButton2 setIdentifier:2];
    [sampleButton2 setBackendInterface:_backendInterface];
    [sampleButton2 postInitialize];
    [sampleButton2 setDelegate:self];
    
    [sampleButton3 setIdentifier:3];
    [sampleButton3 setBackendInterface:_backendInterface];
    [sampleButton3 postInitialize];
    [sampleButton3 setDelegate:self];
    
    
    if ([_metronome isRunning]) {
        [metronomeButton setSelected:YES];
    } else {
        [metronomeButton setSelected:NO];
    }
    
    
    
    
//    //--- Tempo Picker Init ---//
//    tempoPicker = [[TempoPicker alloc] initWithFrame:CGRectMake(60.0f, 210.0f, 200.0f, 260.0f)];
//    [tempoPicker setDelegate:self];
//    [tempoPicker setTempo:_backendInterface->getTempo()];
//    [tempoPicker setAlpha:0.95];
//    [[self view] addSubview:tempoPicker];
//    [tempoPicker setUserInteractionEnabled:NO];
//    [tempoPicker setHidden:YES];
//    tempoDisplayToggle = NO;
    
    
    //--- Initialize Timer for Progress Bar Updates ---//
    timer = [NSTimer scheduledTimerWithTimeInterval:PROGRESS_UPDATE_RATE
                                     target:self
                                   selector:@selector(updatePlaybackProgress)
                                   userInfo:nil
                                    repeats:YES];
    
    
    
    //--- Initialize Metronome Bar ---//
    [metronomeBar initialize];
    
    
    //--- Initialize Motion Control ---//
    motionControl = [[MotionControl alloc] init];
    
    
    
    //--- Set Background Image ---//
    [[self view] setBackgroundColor: [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background.png"]]];
    
    
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    NSLog(@"Memory Warning in BeatMotionViewController");
}




- (void)dealloc
{
    
    [timer invalidate];
    
    delete [] m_pbMasterRecordToggle;
    delete [] m_pbMasterBeginRecording;
    delete [] motion;
    
    delete [] m_pbAudioCurrentlyRecording;
    delete [] m_pbAudioRecordToggle;
    
    [motionControl release];
    
    
    
    [sampleButton0 release];
    [sampleButton1 release];
    [sampleButton2 release];
    [sampleButton3 release];
    
    
    [metronomeButton release];
    
    [metronomeBar release];
    
//    [tempoPicker release];
    [recordButton release];
    
    [super dealloc];
}




- (void) viewWillDisappear:(BOOL)animated {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidBecomeActiveNotification
                                                  object:nil];
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
                _backendInterface->stopRecordingOutput();
                NSLog(@"Stop Resampling %i", i);
                m_pbMasterBeginRecording[i] = false;
                m_pbMasterRecordToggle[i]   = false;
                
                
                //--- Quantize Recording ---//
                if (m_pbMasterRecordToggle[i])
                {
                    NSLog(@"Start Resampling %d", i);
                    _backendInterface->startRecordingOutput();
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
    if ([_metronome isRunning] == NO) {
        [_metronome startClock];
        [metronomeButton setSelected:YES];
    } else {
        [_metronome stopClock];
        [metronomeButton setSelected:NO];
        [metronomeBar turnOff];
    }
//    if (tempoDisplayToggle == NO) {
    
//        [tempoPicker setUserInteractionEnabled:YES];
//        [tempoPicker setHidden:NO];
//        tempoDisplayToggle = YES;
        
        //        if (_backendInterface->getMetronomeStatus() == false) {
        //            //        [_metronome startClock];
        //            _backendInterface->startMetronome();
        //            [metronomeButton setSelected:YES];
        //        }
        //
        //        else {
        //            //        [_metronome stopClock];
        //            _backendInterface->stopMetronome();
        //            [metronomeButton setSelected:NO];
        //            [metronomeBar turnOff];
        //        }
    }
    
//    else {
//        [tempoPicker setUserInteractionEnabled:NO];
//        [tempoPicker setHidden:YES];
//        tempoDisplayToggle = NO;
//    }


- (void) setTempo:(int)tempo
{
    [_metronome setTempo:tempo];
//    [tempoPicker setTempo:tempo];
    //    _backendInterface->setTempo(tempo);
}



- (void) updatePlaybackProgress
{
    [sampleButton0 updateProgress:_backendInterface->getSampleCurrentPlaybackTime(0)];
    [sampleButton1 updateProgress:_backendInterface->getSampleCurrentPlaybackTime(1)];
    [sampleButton2 updateProgress:_backendInterface->getSampleCurrentPlaybackTime(2)];
    [sampleButton3 updateProgress:_backendInterface->getSampleCurrentPlaybackTime(3)];
    
    //    for (int i=0; i < NUM_BUTTONS; i++)
    //    {
    //        switch (i)
    //        {
    //            case 0:
    //                progressBar0.progress = _backendInterface->getSampleCurrentPlaybackTime(i);
    //                break;
    //
    //            case 1:
    //                progressBar1.progress = _backendInterface->getSampleCurrentPlaybackTime(i);
    //                break;
    //
    //            case 2:
    //                progressBar2.progress = _backendInterface->getSampleCurrentPlaybackTime(i);
    //                break;
    //
    //            case 3:
    //                progressBar3.progress = _backendInterface->getSampleCurrentPlaybackTime(i);
    //                break;
    //
    //            default:
    //                break;
    //        }
    //    }
    //
}



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

- (void) toggleGestureControl:(int)sampleID
{
    
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




#pragma mark - Tempo Picker Methods

//- (void) toggleMetronome : (BOOL) value {
//    
//    if (value == YES) {
//        //        _backendInterface->startMetronome();
//        [_metronome startClock];
//        [metronomeButton setSelected:YES];
//    } else {
//        //        _backendInterface->stopMetronome();
//        [_metronome stopClock];
//        [metronomeBar turnOff];
//        [metronomeButton setSelected:NO];
//    }
//}
//
//
//- (void) toggleMetronomeAudio : (BOOL) value {
//    
//}


- (BOOL) getMetronomeStatus {
    return [_metronome isRunning];
}



- (void)reloadFromBackground {
    [sampleButton0 reloadFromBackground];
    [sampleButton1 reloadFromBackground];
    [sampleButton2 reloadFromBackground];
    [sampleButton3 reloadFromBackground];
}


- (IBAction)recordButtonClicked:(UIButton *)sender {
    
    if (recordingToggle == NO)
    {
        _backendInterface->startRecordingOutput();
        [recordButton setSelected:YES];
        recordingToggle = YES;
    }
    
   
    else
    {
        _backendInterface->stopRecordingOutput();
        [recordButton setSelected:NO];
        recordingToggle = NO;
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Save Song?" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Save", nil];
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        UITextField * alertTextField = [alert textFieldAtIndex:0];
        alertTextField.keyboardType = UIKeyboardTypeNamePhonePad;
        alertTextField.placeholder = @"Name of Song";
        [alert show];
        [alert release];
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
        _backendInterface->saveCurrentRecording([[alertView textFieldAtIndex:0] text]);
    }
    
}


- (void)buttonModeChanged:(int)sampleID :(int)buttonMode {
    _backendInterface->setSampleParameter(sampleID, PARAM_PLAYBACK_MODE, buttonMode);
    
    if (buttonMode == MODE_BEATREPEAT) {
        [_metronome startClock];
    }
}


@end
