//
//  SharedLibraryViewController.mm
//  SharedLibrary
//
//  Created by Govinda Ram Pingali on 3/8/14.
//  Copyright (c) 2014 GTCMT. All rights reserved.
//

# define SAMPLING_RATE      0.05f
# define LIN_ACC_THRESHOLD  8.0f
#define  NUM_BUTTONS        4


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
    
    
    
    //--- Turn off Master Record Buttons ---//
    masterRecord0.alpha             =   0.2;
    masterRecord1.alpha             =   0.2;
    masterRecord2.alpha             =   0.2;
    masterRecord3.alpha             =   0.2;
    
    
    
    
    //--- Initialize Motion Manager ---//
    
    self.motionManager = [[CMMotionManager alloc] init];
    self.motionManager.deviceMotionUpdateInterval = SAMPLING_RATE;
    
    
    [self.motionManager startDeviceMotionUpdatesToQueue: [NSOperationQueue currentQueue]
                                            withHandler:^ (CMDeviceMotion *deviceMotion, NSError *error) {
                                                [self motionDeviceUpdate:deviceMotion];
                                                if(error){
                                                    NSLog(@"%@", error);
                                                }
                                            }];
    
    motion  =   new float [NUM_MOTION_PARAMS];

    
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
    
    motion[ATTITUDE_PITCH]  = (deviceMotion.attitude.pitch + M_PI) / (2 * M_PI);
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
    sender.alpha = 1.0f;
    
    if (m_iButtonMode == MODE_PLAYBACK)
    {
        _backendInterface->stopPlayback(0);
    }
    else if (m_iButtonMode == MODE_RECORD)
    {
        m_pbAudioRecordToggle[0] = false;
    }
    
}

- (IBAction)RedTouchDown:(UIButton *)sender
{
    sender.alpha = 0.4f;
    
    if (m_iButtonMode == MODE_PLAYBACK)
    {
        _backendInterface->startPlayback(0);
    }
    else if (m_iButtonMode == MODE_RECORD)
    {
        m_pbAudioRecordToggle[0] = true;
    }
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
    sender.alpha = 1.0f;
    
    if (m_iButtonMode == MODE_PLAYBACK)
    {
        _backendInterface->stopPlayback(1);
    }
    else if (m_iButtonMode == MODE_RECORD)
    {
        m_pbAudioRecordToggle[1] = false;
    }

}

- (IBAction)BlueTouchDown:(UIButton *)sender
{
    sender.alpha = 0.4f;

    if (m_iButtonMode == MODE_PLAYBACK)
    {
        _backendInterface->startPlayback(1);
    }
    else if (m_iButtonMode == MODE_RECORD)
    {
        m_pbAudioRecordToggle[1] = true;
    }
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
    sender.alpha = 1.0f;
    
    if (m_iButtonMode == MODE_PLAYBACK)
    {
        _backendInterface->stopPlayback(2);
    }
    else if (m_iButtonMode == MODE_RECORD)
    {
       m_pbAudioRecordToggle[2] = false;
    }
}

- (IBAction)GreenTouchDown:(UIButton *)sender
{
    sender.alpha = 0.4f;
    
    if (m_iButtonMode == MODE_PLAYBACK)
    {
        _backendInterface->startPlayback(2);
    }
    else if (m_iButtonMode == MODE_RECORD)
    {
        m_pbAudioRecordToggle[2] = true;
    }
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
    sender.alpha = 1.0f;
    
    if (m_iButtonMode == MODE_PLAYBACK)
    {
        _backendInterface->stopPlayback(3);
    }
    else if (m_iButtonMode == MODE_RECORD)
    {
        m_pbAudioRecordToggle[3] = false;
    }
}

- (IBAction)YellowTouchDown:(UIButton *)sender
{
    sender.alpha = 0.4f;
    
    if (m_iButtonMode == MODE_PLAYBACK)
    {
        _backendInterface->startPlayback(3);
    }
    else if (m_iButtonMode == MODE_RECORD)
    {
        m_pbAudioRecordToggle[3] = true;
    }
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
        [[self view] setBackgroundColor:[UIColor colorWithRed:0.152f green:0.246f blue:0.292f alpha:1.0f]];
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
        [[self view] setBackgroundColor:[UIColor colorWithRed:0.152f green:0.246f blue:0.292f alpha:1.0f]];
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


@end
