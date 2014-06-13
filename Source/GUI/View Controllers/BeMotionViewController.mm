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

@synthesize metroBar0, metroBar1, metroBar2, metroBar3, metroBar4, metroBar5, metroBar6, metroBar7;
@synthesize progressBar0, progressBar1, progressBar2, progressBar3;
@synthesize sampleButton0, sampleButton1, sampleButton2, sampleButton3;
@synthesize settingsButton0, settingsButton1, settingsButton2, settingsButton3;
@synthesize metronomeButton, settingsButton;



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
    
    
    m_bSettingsToggle                   =   true;
    
    
    
    
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
    
    
    
    
    //--- Turn off Metronome Bars ---//
    [metroBar0 setAlpha:BUTTON_OFF_ALPHA];
    [metroBar1 setAlpha:BUTTON_OFF_ALPHA];
    [metroBar2 setAlpha:BUTTON_OFF_ALPHA];
    [metroBar3 setAlpha:BUTTON_OFF_ALPHA];
    [metroBar4 setAlpha:BUTTON_OFF_ALPHA];
    [metroBar5 setAlpha:BUTTON_OFF_ALPHA];
    [metroBar6 setAlpha:BUTTON_OFF_ALPHA];
    [metroBar7 setAlpha:BUTTON_OFF_ALPHA];
    
    
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
    
    
    [metroBar0 release];
    [metroBar1 release];
    [metroBar2 release];
    [metroBar3 release];
    [metroBar4 release];
    [metroBar5 release];
    [metroBar6 release];
    [metroBar7 release];
    
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
    
    [super dealloc];
}





//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    UITouch *touch = [touches anyObject];
//    
//    //--- Red Sample ---//
//    if ([touch view] == sampleButton0)
//    {
//        _backendInterface->startPlayback(0);
//        
//        m_pbPlaybackStatus[0] = true;
//        m_piFingerDownStatus[0] ++;
//        
//        [sampleButton0 setAlpha:1.0f];
//        [progressBar0 setAlpha:1.0f];
//    }
//    
//    
//    //--- Blue Sample ---//
//    if ([touch view] == sampleButton1)
//    {
//        _backendInterface->startPlayback(1);
//        m_pbPlaybackStatus[1] = true;
//        
//        m_piFingerDownStatus[1] ++;
//        
//        [sampleButton1 setAlpha:1.0f];
//        [progressBar1 setAlpha:1.0f];
//    }
//    
//    
//    //--- Green Sample ---//
//    if ([touch view] == sampleButton2)
//    {
//        _backendInterface->startPlayback(2);
//        m_pbPlaybackStatus[2] = true;
//        
//        m_piFingerDownStatus[2] ++;
//        
//        [sampleButton2 setAlpha:1.0f];
//        [progressBar2 setAlpha:1.0f];
//    }
//    
//    
//    //--- Yellow Sample ---//
//    if ([touch view] == sampleButton3)
//    {
//        _backendInterface->startPlayback(3);
//        m_pbPlaybackStatus[3] = true;
//        
//        m_piFingerDownStatus[3] ++;
//        
//        [sampleButton3 setAlpha:1.0f];
//        [progressBar3 setAlpha:1.0f];
//    }
//    
//    for (int i=0; i < NUM_BUTTONS; i++)
//    {
//        NSLog(@"Finger Down %i: %i", i, m_piFingerDownStatus[i]);
//    }
//}
//
//
//
//- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
//{
////    UITouch *touch = [touches anyObject];
//    
////    NSSet* touches0 = [event touchesForView:sampleButton0];
////    NSSet* touches1 = [event touchesForView:sampleButton1];
////    NSSet* touches2 = [event touchesForView:sampleButton2];
////    NSSet* touches3 = [event touchesForView:sampleButton3];
////    
////    CGPoint pointToMove0 = [[touches0 anyObject] locationInView:sampleButton0];
////    CGPoint pointToMove1 = [[touches1 anyObject] locationInView:sampleButton1];
////    CGPoint pointToMove2 = [[touches2 anyObject] locationInView:sampleButton2];
////    CGPoint pointToMove3 = [[touches3 anyObject] locationInView:sampleButton3];
//    
////    if (([sampleButton0 pointInside:pointToMove0 withEvent:event]) && (m_piFingerDownStatus[0] > 0)) {
////    if ([sampleButton0 pointInside:pointToMove0 withEvent:event]) {
////        m_pbFingerMoveStatus[0] = NO;
////        NSLog(@"Moved inside Red: %i", m_pbFingerMoveStatus[0]);
////    } else {
////        m_pbFingerMoveStatus[0] = YES;
////        NSLog(@"Moved outside Red: %i", m_pbFingerMoveStatus[0]);
////    }
//
//    
////    if (([sampleButton1 pointInside:pointToMove1 withEvent:event]) && (m_piFingerDownStatus[1] > 0)) {
////        m_pbFingerMoveStatus[1] = NO;
////        NSLog(@"Moved inside Blue: %i", m_pbFingerMoveStatus[1]);
////    } else {
////        m_pbFingerMoveStatus[1] = YES;
////        NSLog(@"Moved outside Blue: %i", m_pbFingerMoveStatus[1]);
////    }
////    
//    
////    if ([sampleButton2 pointInside:pointToMove2 withEvent:event]) {
//////        NSLog(@"Moved inside Green");
////        m_pbFingerMoveStatus[2] = NO;
////    } else {
//////        NSLog(@"Moved outside Green");
////        m_pbFingerMoveStatus[2] = YES;
////    }
////    
////    
////    if ([sampleButton3 pointInside:pointToMove3 withEvent:event]) {
//////        NSLog(@"Moved inside Yellow");
////        m_pbFingerMoveStatus[3] = NO;
////    } else {
//////        NSLog(@"Moved outside Yellow");
////        m_pbFingerMoveStatus[3] = YES;
////    }
//}
//
//
//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    UITouch *touch = [touches anyObject];
//    
//    
//    //--- Red Sample ---//
//    if ([touch view] == sampleButton0)
//    {
//        m_piFingerDownStatus[0] --;
//        
//        if ((m_piFingerDownStatus[0] <= 0) && (!m_pbFingerMoveStatus[0]))
//        {
//            _backendInterface->stopPlayback(0);
//            m_pbPlaybackStatus[0] = false;
//            
//            [sampleButton0 setAlpha:BUTTON_OFF_ALPHA];
//            [progressBar0 setAlpha:BUTTON_OFF_ALPHA];
//            
//            m_piFingerDownStatus[0] = 0;
//        }
//    }
//    
//    
//    //--- Blue Sample ---//
//    if ([touch view] == sampleButton1)
//    {
//        m_piFingerDownStatus[1] --;
//        
//        if ((m_piFingerDownStatus[1] <= 0)  && (!m_pbFingerMoveStatus[1]))
//        {
//            _backendInterface->stopPlayback(1);
//            m_pbPlaybackStatus[1] = false;
//            
//            [sampleButton1 setAlpha:BUTTON_OFF_ALPHA];
//            [progressBar1 setAlpha:BUTTON_OFF_ALPHA];
//            
//            m_piFingerDownStatus[1] = 0;
//        }
//    }
//    
//    
//    //--- Green Sample ---//
//    if ([touch view] == sampleButton2)
//    {
//        m_piFingerDownStatus[2] --;
//        
//        if ((m_piFingerDownStatus[2] <= 0)  && (!m_pbFingerMoveStatus[2]))
//        {
//            _backendInterface->stopPlayback(2);
//            m_pbPlaybackStatus[2] = false;
//            
//            [sampleButton2 setAlpha:BUTTON_OFF_ALPHA];
//            [progressBar2 setAlpha:BUTTON_OFF_ALPHA];
//            
//            m_piFingerDownStatus[2] = 0;
//        }
//    }
//    
//    
//    //--- Yellow Sample ---//
//    if ([touch view] == sampleButton3)
//    {
//        m_piFingerDownStatus[3] --;
//        
//        if ((m_piFingerDownStatus[3] <= 0)  && (!m_pbFingerMoveStatus[3]))
//        {
//            _backendInterface->stopPlayback(3);
//            m_pbPlaybackStatus[3] = false;
//            
//            [sampleButton3 setAlpha:BUTTON_OFF_ALPHA];
//            [progressBar3 setAlpha:BUTTON_OFF_ALPHA];
//            
//            m_piFingerDownStatus[3] = 0;
//        }
//    }
//}





//--- Motion Processing Methods ---//

- (void) motionDeviceUpdate: (CMDeviceMotion*) deviceMotion
{
    
//    motion[ATTITUDE_PITCH]  = (((deviceMotion.attitude.pitch + M_PI) / (2 * M_PI)) - 0.25f) * 2.0f;
    motion[ATTITUDE_PITCH]  = (deviceMotion.attitude.pitch + 1.0f) * 0.5f;
//    motion[ATTITUDE_ROLL]   = (deviceMotion.attitude.roll + M_PI) / (2 * M_PI);
    
    if (deviceMotion.attitude.roll > M_PI_4) {
        motion[ATTITUDE_ROLL]   = 1.25f - (deviceMotion.attitude.roll * M_1_PI);
    } else if (deviceMotion.attitude.roll < -0.15f) {
        motion[ATTITUDE_ROLL]   = (deviceMotion.attitude.roll * M_1_PI * -1.0f) - 0.25f;
    } else {
        motion[ATTITUDE_ROLL]   = 0.0f;
    }
    
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
                    NSLog(@"Stop Recording %i", i);
                    m_pbMasterBeginRecording[i] = false;
                    m_pbMasterRecordToggle[i]   = false;
                    
                    switch (i)
                    {
//                        case 0:
//                            masterRecord0.alpha =   0.2f;
//                            break;
//                            
//                        case 1:
//                            masterRecord1.alpha =   0.2f;
//                            break;
//                            
//                        case 2:
//                            masterRecord2.alpha =   0.2f;
//                            break;
//                            
//                        case 3:
//                            masterRecord3.alpha =   0.2f;
//                            break;
                            
                        default:
                            break;
                    }
                }
                
                
                //--- Quantize Recording ---//
                if (m_pbMasterRecordToggle[i])
                {
                    NSLog(@"Start Resampling %d", i);
                    _backendInterface->startRecordingOutput(i);
                    m_pbMasterBeginRecording[i] = true;
                    
                    switch (i)
                    {
//                        case 0:
//                            masterRecord0.alpha =   1.0f;
//                            break;
//                            
//                        case 1:
//                            masterRecord1.alpha =   1.0f;
//                            break;
//                            
//                        case 2:
//                            masterRecord2.alpha =   1.0f;
//                            break;
//                            
//                        case 3:
//                            masterRecord3.alpha =   1.0f;
//                            break;
                            
                        default:
                            break;
                    }
                    
                    
                }
            }
            
            [metroBar0 setAlpha:1.0f];
            [metroBar1 setAlpha:BUTTON_OFF_ALPHA];
            [metroBar2 setAlpha:BUTTON_OFF_ALPHA];
            [metroBar3 setAlpha:BUTTON_OFF_ALPHA];
            [metroBar4 setAlpha:BUTTON_OFF_ALPHA];
            [metroBar5 setAlpha:BUTTON_OFF_ALPHA];
            [metroBar6 setAlpha:BUTTON_OFF_ALPHA];
            [metroBar7 setAlpha:BUTTON_OFF_ALPHA];
            
            break;
            
            
        case 2:
            
            [metroBar0 setAlpha:1.0f];
            [metroBar1 setAlpha:1.0f];
            [metroBar2 setAlpha:BUTTON_OFF_ALPHA];
            [metroBar3 setAlpha:BUTTON_OFF_ALPHA];
            [metroBar4 setAlpha:BUTTON_OFF_ALPHA];
            [metroBar5 setAlpha:BUTTON_OFF_ALPHA];
            [metroBar6 setAlpha:BUTTON_OFF_ALPHA];
            [metroBar7 setAlpha:BUTTON_OFF_ALPHA];
            
            break;
            
            
        case 3:
            
            [metroBar0 setAlpha:1.0f];
            [metroBar1 setAlpha:1.0f];
            [metroBar2 setAlpha:1.0f];
            [metroBar3 setAlpha:BUTTON_OFF_ALPHA];
            [metroBar4 setAlpha:BUTTON_OFF_ALPHA];
            [metroBar5 setAlpha:BUTTON_OFF_ALPHA];
            [metroBar6 setAlpha:BUTTON_OFF_ALPHA];
            [metroBar7 setAlpha:BUTTON_OFF_ALPHA];
            
            break;
            
            
            
        case 4:
            
            [metroBar0 setAlpha:1.0f];
            [metroBar1 setAlpha:1.0f];
            [metroBar2 setAlpha:1.0f];
            [metroBar3 setAlpha:1.0f];
            [metroBar4 setAlpha:BUTTON_OFF_ALPHA];
            [metroBar5 setAlpha:BUTTON_OFF_ALPHA];
            [metroBar6 setAlpha:BUTTON_OFF_ALPHA];
            [metroBar7 setAlpha:BUTTON_OFF_ALPHA];
            
            break;
            
            
            
        case 5:
            
            [metroBar0 setAlpha:1.0f];
            [metroBar1 setAlpha:1.0f];
            [metroBar2 setAlpha:1.0f];
            [metroBar3 setAlpha:1.0f];
            [metroBar4 setAlpha:1.0f];
            [metroBar5 setAlpha:BUTTON_OFF_ALPHA];
            [metroBar6 setAlpha:BUTTON_OFF_ALPHA];
            [metroBar7 setAlpha:BUTTON_OFF_ALPHA];
            
            break;
            
            
            
        case 6:
            
            [metroBar0 setAlpha:1.0f];
            [metroBar1 setAlpha:1.0f];
            [metroBar2 setAlpha:1.0f];
            [metroBar3 setAlpha:1.0f];
            [metroBar4 setAlpha:1.0f];
            [metroBar5 setAlpha:1.0f];
            [metroBar6 setAlpha:BUTTON_OFF_ALPHA];
            [metroBar7 setAlpha:BUTTON_OFF_ALPHA];
            
            break;
            
            
            
        case 7:
            
            [metroBar0 setAlpha:1.0f];
            [metroBar1 setAlpha:1.0f];
            [metroBar2 setAlpha:1.0f];
            [metroBar3 setAlpha:1.0f];
            [metroBar4 setAlpha:1.0f];
            [metroBar5 setAlpha:1.0f];
            [metroBar6 setAlpha:1.0f];
            [metroBar7 setAlpha:BUTTON_OFF_ALPHA];
            
            break;
            
            
        case 8:
            
            [metroBar0 setAlpha:1.0f];
            [metroBar1 setAlpha:1.0f];
            [metroBar2 setAlpha:1.0f];
            [metroBar3 setAlpha:1.0f];
            [metroBar4 setAlpha:1.0f];
            [metroBar5 setAlpha:1.0f];
            [metroBar6 setAlpha:1.0f];
            [metroBar7 setAlpha:1.0f];
            
            break;
            
        default:
            break;
    }
    
}






//--- User Interface Methods ---//

//- (IBAction)redMasterRecord:(UIButton *)sender
//{
//    if ([_metronome isRunning])
//    {
//        sender.alpha = 0.5f;
//        m_pbMasterRecordToggle[0] = true;
//    }
//
//}
//
//- (IBAction)blueMasterRecord:(UIButton *)sender
//{
//    if ([_metronome isRunning])
//    {
//        sender.alpha = 0.5f;
//        m_pbMasterRecordToggle[1] = true;
//    }
//    
//}
//
//- (IBAction)greenMasterRecord:(UIButton *)sender
//{
//    if ([_metronome isRunning])
//    {
//        sender.alpha = 0.5f;
//        m_pbMasterRecordToggle[2] = true;
//    }
//    
//}
//
//
//- (IBAction)yellowMasterRecord:(UIButton *)sender
//{
//    if ([_metronome isRunning])
//    {
//        sender.alpha = 0.5f;
//        m_pbMasterRecordToggle[3] = true;
//    }
//}
//




//--- Modifier Keys ---//


- (IBAction)settingsToggleClicked:(UIButton *)sender
{
    if (m_bSettingsToggle) {
        
        //--- Display Settings Buttons ---//
        [self toggleSettings:true];
        m_bSettingsToggle = false;
        
    } else {
        
        //--- Hide Settings Buttons ---//
        [self toggleSettings:false];
        m_bSettingsToggle   =   true;
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
        [metroBar0 setAlpha:BUTTON_OFF_ALPHA];
        [metroBar1 setAlpha:BUTTON_OFF_ALPHA];
        [metroBar2 setAlpha:BUTTON_OFF_ALPHA];
        [metroBar3 setAlpha:BUTTON_OFF_ALPHA];
        [metroBar4 setAlpha:BUTTON_OFF_ALPHA];
        [metroBar5 setAlpha:BUTTON_OFF_ALPHA];
        [metroBar6 setAlpha:BUTTON_OFF_ALPHA];
        [metroBar7 setAlpha:BUTTON_OFF_ALPHA];
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



- (void) launchImportView:(int)sampleID {
    
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
