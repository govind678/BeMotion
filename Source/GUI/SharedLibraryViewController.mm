//
//  SharedLibraryViewController.mm
//  SharedLibrary
//
//  Created by Govinda Ram Pingali on 3/8/14.
//  Copyright (c) 2014 GTCMT. All rights reserved.
//

#import "SharedLibraryViewController.h"
#import "GestureControllerAppDelegate.h"


@interface SharedLibraryViewController ()
{
    GestureControllerAppDelegate*   appDelegate;
}

@end



@implementation SharedLibraryViewController

@synthesize metroBar0, metroBar1, metroBar2, metroBar3, metroBar4, metroBar5, metroBar6, metroBar7;
@synthesize masterRecord0, masterRecord1, masterRecord2, masterRecord3;
@synthesize sampleButton0, sampleButton1, sampleButton2, sampleButton3;
@synthesize progressBar0, progressBar1, progressBar2, progressBar3;



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
    
    m_pbPlaybackStatus          =   new bool [NUM_BUTTONS];
    
    
    
    //--- Reset Toggles ---//
    for (int i=0; i< NUM_BUTTONS; i++)
    {
        m_pbMasterRecordToggle[i]       =   false;
        m_pbMasterBeginRecording[i]     =   false;
        m_pbAudioRecordToggle[i]        =   false;
        m_pbAudioCurrentlyRecording[i]  =   false;
        m_pbPlaybackStatus[i]           =   false;
    }
    
    
    
    m_iButtonMode                       = MODE_PLAYBACK; // playback mode by default
    
    
    
    //--- Turn off Metronome Bars ---//
    metroBar0.alpha                 =   0.2;
    metroBar1.alpha                 =   0.2;
    metroBar2.alpha                 =   0.2;
    metroBar3.alpha                 =   0.2;
    metroBar4.alpha                 =   0.2;
    metroBar5.alpha                 =   0.2;
    metroBar6.alpha                 =   0.2;
    metroBar7.alpha                 =   0.2;
    
    
    
    //--- Turn off Sample and Progress Buttons ---//
    sampleButton0.alpha             =   0.2f;
    sampleButton1.alpha             =   0.2f;
    sampleButton2.alpha             =   0.2f;
    sampleButton3.alpha             =   0.2f;
    
    progressBar0.alpha              =   0.2f;
    progressBar1.alpha              =   0.2f;
    progressBar2.alpha              =   0.2f;
    progressBar3.alpha              =   0.2f;
    
    
    
    
    
    //--- Turn off Master Record Buttons ---//
    masterRecord0.alpha             =   0.2;
    masterRecord1.alpha             =   0.2;
    masterRecord2.alpha             =   0.2;
    masterRecord3.alpha             =   0.2;
    
    
    
    
    
    //--- Initialize Timer for Progress Bar Updates ---//
    [NSTimer scheduledTimerWithTimeInterval:PROGRESS_UPDATE_RATE
                                   target:self
                                   selector:@selector(updatePlaybackProgress)
                                   userInfo:nil
                                   repeats:YES];
    
    
    
    
    
    //--- Initialize Motion Manager ---//
    
    self.motionManager = [[CMMotionManager alloc] init];
    self.motionManager.deviceMotionUpdateInterval = MOTION_UPDATE_RATE;
    
    
    [self.motionManager startDeviceMotionUpdatesToQueue: [NSOperationQueue currentQueue]
                                            withHandler:^ (CMDeviceMotion *deviceMotion, NSError *error) {
                                                [self motionDeviceUpdate:deviceMotion];
                                                if(error){
                                                    NSLog(@"%@", error);
                                                }
                                            }];
    
    motion  =   new float [NUM_MOTION_PARAMS];

    
}



- (void) viewDidAppear:(BOOL)animated
{
    
    //--- Update Sample Buttons and Progress Bars ---//
    
    for (int i = 0; i< NUM_BUTTONS; i++)
    {
        if (_backendInterface->getSamplePlaybackStatus(i))
        {
            m_pbPlaybackStatus[i] = true;
            
            switch (i)
            {
                case 0:
                    sampleButton0.alpha             =   1.0f;
                    progressBar0.alpha              =   1.0f;
                    break;
                    
                case 1:
                    sampleButton1.alpha             =   1.0f;
                    progressBar1.alpha              =   1.0f;
                    break;
                    
                case 2:
                    sampleButton2.alpha             =   1.0f;
                    progressBar2.alpha              =   1.0f;
                    break;
                    
                case 3:
                    sampleButton3.alpha             =   1.0f;
                    progressBar3.alpha              =   1.0f;
                    break;
                    
                    
                default:
                    break;
            }
        }
        
        else
        {
            m_pbPlaybackStatus[i] = false;
            
            switch (i)
            {
                case 0:
                    sampleButton0.alpha             =   0.2f;
                    progressBar0.alpha              =   0.2f;
                    break;
                    
                case 1:
                    sampleButton1.alpha             =   0.2f;
                    progressBar1.alpha              =   0.2f;
                    break;
                    
                case 2:
                    sampleButton2.alpha             =   0.2f;
                    progressBar2.alpha              =   0.2f;
                    break;
                    
                case 3:
                    sampleButton3.alpha             =   0.2f;
                    progressBar3.alpha              =   0.2f;
                    break;
                    
                    
                default:
                    break;
            }
            
        }
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
    
    [metroBar0 release];
    [metroBar1 release];
    [metroBar2 release];
    [metroBar3 release];
    [metroBar4 release];
    [metroBar5 release];
    [metroBar6 release];
    [metroBar7 release];
    
    
    [masterRecord0 release];
    [masterRecord1 release];
    [masterRecord2 release];
    [masterRecord3 release];

    
    
    [sampleButton0 release];
    [sampleButton1 release];
    [sampleButton2 release];
    [sampleButton3 release];
    
    [progressBar0 release];
    [progressBar1 release];
    [progressBar2 release];
    [progressBar3 release];
    
    
    
    [super dealloc];
}





//--- Conditional Segue ---//

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if (([identifier isEqualToString:@"conditionSegue1"]) && (m_iButtonMode == MODE_SETTINGS))
    {
        return YES;
    }
    
    if (([identifier isEqualToString:@"conditionSegue2"]) && (m_iButtonMode == MODE_SETTINGS))
    {
        return YES;
    }
    
    if (([identifier isEqualToString:@"conditionSegue3"]) && (m_iButtonMode == MODE_SETTINGS))
    {
        return YES;
    }
    
    if (([identifier isEqualToString:@"conditionSegue4"]) && (m_iButtonMode == MODE_SETTINGS))
    {
        return YES;
    }
    
    if ([identifier isEqualToString:@"settingsSegue"])
    {
        return YES;
    }
    return NO;
}




- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"settingsSegue" ])
    {
        GlobalSettingsViewController *globalSettingsVC  = segue.destinationViewController;
        globalSettingsVC.backendInterface               =   _backendInterface;
        globalSettingsVC.metronome                      =   _metronome;
    }
    
    else
    {
        EffectSettingsViewController *EffectSettingsVC = segue.destinationViewController;
        
        if ([segue.identifier isEqualToString:@"conditionSegue1" ])
        {
            EffectSettingsVC.view.backgroundColor   = [UIColor colorWithRed:0.5f green:0.2f blue:0.2f alpha:1.0f];
            EffectSettingsVC.m_iCurrentSampleID     =   0;
            EffectSettingsVC.backEndInterface       =   _backendInterface;
        }
        
        else if ([segue.identifier isEqualToString:@"conditionSegue2" ])
        {
            EffectSettingsVC.view.backgroundColor   = [UIColor colorWithRed:0.2f green:0.2f blue:0.5f alpha:1.0f];
            EffectSettingsVC.m_iCurrentSampleID     =   1;
            EffectSettingsVC.backEndInterface       =   _backendInterface;
        }
        
        else if ([segue.identifier isEqualToString:@"conditionSegue3" ])
        {
            EffectSettingsVC.view.backgroundColor   = [UIColor colorWithRed:0.2f green:0.5f blue:0.2f alpha:1.0f];
            EffectSettingsVC.m_iCurrentSampleID     =   2;
            EffectSettingsVC.backEndInterface       =   _backendInterface;
        }
        
        else if ([segue.identifier isEqualToString:@"conditionSegue4" ])
        {
            EffectSettingsVC.view.backgroundColor   = [UIColor colorWithRed:0.5f green:0.5f blue:0.2f alpha:1.0f];
            EffectSettingsVC.m_iCurrentSampleID     =   3;
            EffectSettingsVC.backEndInterface       =   _backendInterface;
        }
    }
    
}






//--- Motion Processing Methods ---//

- (void) motionDeviceUpdate: (CMDeviceMotion*) deviceMotion
{
    
    motion[ATTITUDE_PITCH]  = (((deviceMotion.attitude.pitch + M_PI) / (2 * M_PI)) - 0.25f) * 2.0f;
    motion[ATTITUDE_ROLL]   = (deviceMotion.attitude.roll + M_PI) / (2 * M_PI);
    motion[ATTITUDE_YAW]    = (deviceMotion.attitude.yaw + M_PI) / (2 * M_PI);
    motion[ACCEL_X]         = deviceMotion.userAcceleration.x;
    motion[ACCEL_Y]         = deviceMotion.userAcceleration.y;
    motion[ACCEL_Z]         = deviceMotion.userAcceleration.z;
    
    [self processUserAcceleration:deviceMotion.userAcceleration];
    
    _backendInterface->motionUpdate(motion);
}




- (void)processUserAcceleration: (CMAcceleration) userAcceleration
{
    double amplitude = pow( (pow(userAcceleration.x, 2) + pow(userAcceleration.y, 2) + pow(userAcceleration.z, 2)), 0.5);
    
    if (amplitude > LIN_ACC_THRESHOLD || amplitude < -(LIN_ACC_THRESHOLD))
    {
        _backendInterface->startPlayback(4);
    }
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
    
    
    
    //--- Display Metronome Ticks ---//
    //--- Ugly Ass Code Below! Maybe use NS Dictionary, But later, not tonight!! ---//
    
    switch (beatNo)
    {
        case 1:
            
            //--- Quantized Resampling ---//
            for (int i=0; i < NUM_BUTTONS; i++)
            {
                if (m_pbMasterBeginRecording[i])
                {
                    _backendInterface->stopRecordingOutput(i);
                    m_pbMasterBeginRecording[i] = false;
                    m_pbMasterRecordToggle[i]   = false;
                    
                    switch (i)
                    {
                        case 0:
                            masterRecord0.alpha =   0.2f;
                            break;
                            
                        case 1:
                            masterRecord1.alpha =   0.2f;
                            break;
                            
                        case 2:
                            masterRecord2.alpha =   0.2f;
                            break;
                            
                        case 3:
                            masterRecord3.alpha =   0.2f;
                            break;
                            
                        default:
                            break;
                    }
                }
                
                
                //--- Quantize Recording ---//
                if (m_pbMasterRecordToggle[i])
                {
                    _backendInterface->startRecordingOutput(i);
                    m_pbMasterBeginRecording[i] = true;
                    
                    switch (i)
                    {
                        case 0:
                            masterRecord0.alpha =   1.0f;
                            break;
                            
                        case 1:
                            masterRecord1.alpha =   1.0f;
                            break;
                            
                        case 2:
                            masterRecord2.alpha =   1.0f;
                            break;
                            
                        case 3:
                            masterRecord3.alpha =   1.0f;
                            break;
                            
                        default:
                            break;
                    }
                    
                    
                }
            }
            
            metroBar0.alpha = 1.0f;
            metroBar1.alpha = 0.2f;
            metroBar2.alpha = 0.2f;
            metroBar3.alpha = 0.2f;
            metroBar4.alpha = 0.2f;
            metroBar5.alpha = 0.2f;
            metroBar6.alpha = 0.2f;
            metroBar7.alpha = 0.2f;
            
            break;
            
            
        case 2:
            
            metroBar0.alpha = 1.0f;
            metroBar1.alpha = 1.0f;
            metroBar2.alpha = 0.2f;
            metroBar3.alpha = 0.2f;
            metroBar4.alpha = 0.2f;
            metroBar5.alpha = 0.2f;
            metroBar6.alpha = 0.2f;
            metroBar7.alpha = 0.2f;
            
            break;
            
            
        case 3:
            
            metroBar0.alpha = 1.0f;
            metroBar1.alpha = 1.0f;
            metroBar2.alpha = 1.0f;
            metroBar3.alpha = 0.2f;
            metroBar4.alpha = 0.2f;
            metroBar5.alpha = 0.2f;
            metroBar6.alpha = 0.2f;
            metroBar7.alpha = 0.2f;
            
            break;
            
            
            
        case 4:
            
            metroBar0.alpha = 1.0f;
            metroBar1.alpha = 1.0f;
            metroBar2.alpha = 1.0f;
            metroBar3.alpha = 1.0f;
            metroBar4.alpha = 0.2f;
            metroBar5.alpha = 0.2f;
            metroBar6.alpha = 0.2f;
            metroBar7.alpha = 0.2f;
            
            break;
            
            
            
        case 5:
            
            metroBar0.alpha = 1.0f;
            metroBar1.alpha = 1.0f;
            metroBar2.alpha = 1.0f;
            metroBar3.alpha = 1.0f;
            metroBar4.alpha = 1.0f;
            metroBar5.alpha = 0.2f;
            metroBar6.alpha = 0.2f;
            metroBar7.alpha = 0.2f;
            
            break;
            
            
            
        case 6:
            
            metroBar0.alpha = 1.0f;
            metroBar1.alpha = 1.0f;
            metroBar2.alpha = 1.0f;
            metroBar3.alpha = 1.0f;
            metroBar4.alpha = 1.0f;
            metroBar5.alpha = 1.0f;
            metroBar6.alpha = 0.2f;
            metroBar7.alpha = 0.2f;
            
            break;
            
            
            
        case 7:
            
            metroBar0.alpha = 1.0f;
            metroBar1.alpha = 1.0f;
            metroBar2.alpha = 1.0f;
            metroBar3.alpha = 1.0f;
            metroBar4.alpha = 1.0f;
            metroBar5.alpha = 1.0f;
            metroBar6.alpha = 1.0f;
            metroBar7.alpha = 0.2f;
            
            break;
            
            
        case 8:
            
            metroBar0.alpha = 1.0f;
            metroBar1.alpha = 1.0f;
            metroBar2.alpha = 1.0f;
            metroBar3.alpha = 1.0f;
            metroBar4.alpha = 1.0f;
            metroBar5.alpha = 1.0f;
            metroBar6.alpha = 1.0f;
            metroBar7.alpha = 1.0f;
            
            break;
            
        default:
            break;
    }
    
}



- (void) beat:(int)beatNo
{
    _backendInterface->beat(beatNo);
}








//--- User Interface Methods ---//

- (IBAction)RedTouchUp:(UIButton *)sender
{
    if (m_iButtonMode == MODE_PLAYBACK)
    {
        _backendInterface->stopPlayback(0);
        m_pbPlaybackStatus[0] = false;
    }
    
    
    else if (m_iButtonMode == MODE_RECORD)
    {
        if ([_metronome isRunning] == YES)
        {
           m_pbAudioRecordToggle[0] = false;
        }
        
        else
        {
            _backendInterface->stopRecording(0);
        }
    }
    
    sender.alpha = 0.2f;
    progressBar0.alpha  = 0.2f;
}

- (IBAction)RedTouchDown:(UIButton *)sender
{
    if (m_iButtonMode == MODE_PLAYBACK)
    {
        if (!m_pbPlaybackStatus[0])
        {
            _backendInterface->startPlayback(0);
            m_pbPlaybackStatus[0] = true;
        }
    }
    
    
    else if (m_iButtonMode == MODE_RECORD)
    {
        if ([_metronome isRunning] == YES)
        {
            m_pbAudioRecordToggle[0] = true;
        }
        
        else
        {
            _backendInterface->startRecording(0);
        }
    }
    
    sender.alpha = 1.0f;
    progressBar0.alpha  = 1.0f;
}

- (IBAction)redMasterRecord:(UIButton *)sender
{
    if ([_metronome isRunning])
    {
        sender.alpha = 0.5f;
        m_pbMasterRecordToggle[0] = true;
    }
    
}




- (IBAction)BlueTouchUp:(UIButton *)sender
{
    if (m_iButtonMode == MODE_PLAYBACK)
    {
        _backendInterface->stopPlayback(1);
        m_pbPlaybackStatus[1] = false;
    }
    
    else if (m_iButtonMode == MODE_RECORD)
    {
        if ([_metronome isRunning] == YES)
        {
            m_pbAudioRecordToggle[1] = false;
        }
        
        else
        {
            _backendInterface->stopRecording(1);
        }
    }
    
    sender.alpha = 0.2f;
    progressBar1.alpha  = 0.2f;

}

- (IBAction)BlueTouchDown:(UIButton *)sender
{
    if (m_iButtonMode == MODE_PLAYBACK)
    {
        if (! m_pbPlaybackStatus[1])
        {
            _backendInterface->startPlayback(1);
            m_pbPlaybackStatus[1] = true;
        }
        
    }
    
    else if (m_iButtonMode == MODE_RECORD)
    {
        if ([_metronome isRunning] == YES)
        {
            m_pbAudioRecordToggle[1] = true;
        }
        
        else
        {
            _backendInterface->startRecording(1);
        }
    }
    
    sender.alpha = 1.0f;
    progressBar1.alpha  = 1.0f;
}

- (IBAction)blueMasterRecord:(UIButton *)sender
{
    if ([_metronome isRunning])
    {
        sender.alpha = 0.5f;
        m_pbMasterRecordToggle[1] = true;
    }
    
}




- (IBAction)GreenTouchUp:(UIButton *)sender
{
    if (m_iButtonMode == MODE_PLAYBACK)
    {
        _backendInterface->stopPlayback(2);
        m_pbPlaybackStatus[2] = false;
    }
    
    else if (m_iButtonMode == MODE_RECORD)
    {
        if ([_metronome isRunning] == YES)
        {
            m_pbAudioRecordToggle[2] = false;
        }
        
        else
        {
            _backendInterface->stopRecording(2);
        }
    }
    
    sender.alpha = 0.2f;
    progressBar2.alpha  = 0.2f;
}

- (IBAction)GreenTouchDown:(UIButton *)sender
{
    if (m_iButtonMode == MODE_PLAYBACK)
    {
        if (! m_pbPlaybackStatus[2])
        {
            _backendInterface->startPlayback(2);
            m_pbPlaybackStatus[2] = true;
        }
        
    }
    
    else if (m_iButtonMode == MODE_RECORD)
    {
        if ([_metronome isRunning] == YES)
        {
            m_pbAudioRecordToggle[2] = true;
        }
        
        else
        {
            _backendInterface->startRecording(2);
        }
    }
    
    sender.alpha = 1.0f;
    progressBar2.alpha  = 1.0f;
}

- (IBAction)greenMasterRecord:(UIButton *)sender
{
    if ([_metronome isRunning])
    {
        sender.alpha = 0.5f;
        m_pbMasterRecordToggle[2] = true;
    }
    
}




- (IBAction)YellowTouchUp:(UIButton *)sender
{
    if (m_iButtonMode == MODE_PLAYBACK)
    {
        _backendInterface->stopPlayback(3);
        m_pbPlaybackStatus[3] = false;
    }
    
    else if (m_iButtonMode == MODE_RECORD)
    {
        if ([_metronome isRunning] == YES)
        {
            m_pbAudioRecordToggle[3] = false;
        }
        
        else
        {
            _backendInterface->stopRecording(3);
        }
    }
    
    sender.alpha = 0.2f;
    progressBar3.alpha  = 0.2f;
}

- (IBAction)YellowTouchDown:(UIButton *)sender
{
    
    if (m_iButtonMode == MODE_PLAYBACK)
    {
        if (! m_pbPlaybackStatus[3])
        {
            _backendInterface->startPlayback(3);
            m_pbPlaybackStatus[3] = true;
        }
        
    }
    
    else if (m_iButtonMode == MODE_RECORD)
    {
        if ([_metronome isRunning] == YES)
        {
            m_pbAudioRecordToggle[3] = true;
        }
        
        else
        {
            _backendInterface->startRecording(3);
        }
    }
    
    sender.alpha = 1.0f;
    progressBar3.alpha  = 1.0f;
}

- (IBAction)yellowMasterRecord:(UIButton *)sender
{
    if ([_metronome isRunning])
    {
        sender.alpha = 0.5f;
        m_pbMasterRecordToggle[3] = true;
    }
}





//--- Modifier Keys ---//


- (IBAction)settingsToggleClicked:(UIButton *)sender
{
    if (m_iButtonMode != MODE_SETTINGS)
    {
        m_iButtonMode   =   MODE_SETTINGS;
        [[self view] setBackgroundColor:[UIColor colorWithRed:0.1f green:0.2f blue:0.1f alpha:1.0f]];
    }
    
    else
    {
        m_iButtonMode   =   MODE_PLAYBACK;
        [[self view] setBackgroundColor:[UIColor colorWithRed:0.125 green:0.125f blue:0.125f alpha:1.0f]];
    }
}



- (IBAction)recordToggleClicked:(UIButton *)sender
{
    if (m_iButtonMode != MODE_RECORD)
    {
        m_iButtonMode   =   MODE_RECORD;
        [[self view] setBackgroundColor:[UIColor colorWithRed:0.2f green:0.1f blue:0.1f alpha:1.0f]];
    }
    
    else
    {
        m_iButtonMode   =   MODE_PLAYBACK;
        [[self view] setBackgroundColor:[UIColor colorWithRed:0.125 green:0.125f blue:0.125f alpha:1.0f]];
    }
    
}


- (IBAction)metronomeToggleClicked:(UIButton *)sender
{
    if ([_metronome isRunning] == NO)
    {
        [_metronome startClock];
    }
    
    else
    {
        [_metronome stopClock];
        
        metroBar0.alpha = 0.2f;
        metroBar1.alpha = 0.2f;
        metroBar2.alpha = 0.2f;
        metroBar3.alpha = 0.2f;
        metroBar4.alpha = 0.2f;
        metroBar5.alpha = 0.2f;
        metroBar6.alpha = 0.2f;
        metroBar7.alpha = 0.2f;
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


@end
