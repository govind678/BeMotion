//
//  SharedLibraryViewController.mm
//  SharedLibrary
//
//  Created by Govinda Ram Pingali on 3/8/14.
//  Copyright (c) 2014 GTCMT. All rights reserved.
//

# define SAMPLING_RATE 0.05f
# define LIN_ACC_THRESHOLD  8.0f
#define  NUM_BUTTONS        4


#import "SharedLibraryViewController.h"


@interface SharedLibraryViewController () {
    SampleInfo *redSample;
    SampleInfo *blueSample;
    SampleInfo *greenSample;
    SampleInfo *yellowSample;

}

@end

@implementation SharedLibraryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    redSample                = [[SampleInfo alloc] init];
    redSample.delayEffect    = [[cDelay alloc] init];
    redSample.tremoloEffect  = [[cTremolo alloc] init];
    redSample.vibratoEffect  = [[cVibrato alloc] init];
    redSample.wahEffect      = [[cWah alloc] init];


    blueSample               = [[SampleInfo alloc] init];
    blueSample.delayEffect   = [[cDelay alloc] init];
    blueSample.tremoloEffect = [[cTremolo alloc] init];
    blueSample.vibratoEffect = [[cVibrato alloc] init];
    blueSample.wahEffect     = [[cWah alloc] init];
    

    greenSample                = [[SampleInfo alloc] init];
    greenSample.delayEffect    = [[cDelay alloc] init];
    greenSample.tremoloEffect  = [[cTremolo alloc] init];
    greenSample.vibratoEffect  = [[cVibrato alloc] init];
    greenSample.wahEffect      = [[cWah alloc] init];
    
    
    yellowSample               = [[SampleInfo alloc] init];
    yellowSample.delayEffect   = [[cDelay alloc] init];
    yellowSample.tremoloEffect = [[cTremolo alloc] init];
    yellowSample.vibratoEffect = [[cVibrato alloc] init];
    yellowSample.wahEffect     = [[cWah alloc] init];

//    redSample.sampleID = [NSNumber numberWithFloat:10];
//    redSample.delayEffect.time = [NSNumber numberWithFloat:0.5];
//    redSample.delayEffect.feedback = [NSNumber numberWithFloat:0.75];
//    

    
    backEndInterface          =   new GestureControllerInterface;
    
    m_pbPlaybackToggle        =   new bool [NUM_BUTTONS];
    m_pbRecordToggle          =   new bool [NUM_BUTTONS];
    
    for (int i=0; i < NUM_BUTTONS; i++)
    {
        m_pbRecordToggle[i]     = false;
        m_pbPlaybackToggle[i]   = false;
    }

    
    NSString *sample1Path = [[NSBundle mainBundle] pathForResource:@"Playback0" ofType:@"wav"];
    NSString *sample2Path = [[NSBundle mainBundle] pathForResource:@"Playback1" ofType:@"wav"];
    NSString *sample3Path = [[NSBundle mainBundle] pathForResource:@"Playback2" ofType:@"wav"];
    NSString *sample4Path = [[NSBundle mainBundle] pathForResource:@"Playback3" ofType:@"wav"];
    NSString *sample5Path = [[NSBundle mainBundle] pathForResource:@"Playback4" ofType:@"wav"];
    
    
    backEndInterface->loadAudioFile(0, sample1Path);
    backEndInterface->loadAudioFile(1, sample2Path);
    backEndInterface->loadAudioFile(2, sample3Path);
    backEndInterface->loadAudioFile(3, sample4Path);
    backEndInterface->loadAudioFile(4, sample5Path);
    
    
    m_bRedButtonToggleStatus  = false;
    m_bBlueButtonToggleStatus = false;
    m_bModeToggleStatus       = true; // settings mode by default
    
    
    
    
    metronome   =   [[Metronome alloc] init];
    [metronome setDelegate:self];
    
    
    
    
    self.motionManager = [[CMMotionManager alloc] init];
    self.motionManager.deviceMotionUpdateInterval = SAMPLING_RATE;
    
    
    [self.motionManager startDeviceMotionUpdatesToQueue: [NSOperationQueue currentQueue]
                                            withHandler:^ (CMDeviceMotion *deviceMotion, NSError *error) {
                                                [self motionDeviceUpdate:deviceMotion];
                                                if(error){
                                                    NSLog(@"%@", error);
                                                }
                                            }];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



//- (IBAction)redButtonPressed:(id)sender
//{
//    NSLog(@"Chain contents %@ %@ %@ %@",  [redSample.effectChain objectAtIndex:0], [redSample.effectChain objectAtIndex:1], [redSample.effectChain objectAtIndex:2], [redSample.effectChain objectAtIndex:3]);
//    NSLog(@"Bypass contents %@ %@ %@ %@",  redSample.delayEffect.bypass.stringValue,redSample.tremoloEffect.bypass.stringValue,redSample.vibratoEffect.bypass.stringValue,redSample.wahEffect.bypass.stringValue);
//    
//    if (!m_bModeToggleStatus)
//    {
//        if (!m_bRedButtonToggleStatus)
//        {
//            backEndInterface->startPlayback(0);
//            m_bRedButtonToggleStatus = true;
//        }
//        
//        else
//        {
//            backEndInterface->stopPlayback(0);
//            m_bRedButtonToggleStatus = false;
//        }
//        
//    }
//}


- (IBAction)redButtonTouchDown:(id)sender
{
    if (!m_bModeToggleStatus)
    {
        backEndInterface->startPlayback(0);
        self.view.backgroundColor = [UIColor redColor];
    }
}


- (IBAction)redButtonTouchUp:(id)sender
{
    if (!m_bModeToggleStatus)
    {
        backEndInterface->stopPlayback(0);
        self.view.backgroundColor = [UIColor whiteColor];
    }
}



- (IBAction)blueButtonTouchUp:(id)sender
{
    if (!m_bModeToggleStatus)
    {
        backEndInterface->stopPlayback(1);
        self.view.backgroundColor = [UIColor whiteColor];
    }
}


- (IBAction)blueButtonTouchDown:(id)sender
{
    if (!m_bModeToggleStatus)
    {
        backEndInterface->startPlayback(1);
        self.view.backgroundColor = [UIColor blueColor];
    }
}




- (IBAction)greenButtonTouchDown:(id)sender
{
    if (!m_bModeToggleStatus)
    {
        backEndInterface->startPlayback(2);
        self.view.backgroundColor = [UIColor greenColor];
    }
}


- (IBAction)greenButtonTouchUp:(id)sender
{
    if (!m_bModeToggleStatus)
    {
        backEndInterface->stopPlayback(2);
        self.view.backgroundColor = [UIColor whiteColor];
    }
}



- (IBAction)yellowButtonTouchDown:(id)sender
{
    if (!m_bModeToggleStatus)
    {
        backEndInterface->startPlayback(3);
        self.view.backgroundColor = [UIColor yellowColor];
    }
}

- (IBAction)yellowButtonTouchUp:(id)sender
{
    if (!m_bModeToggleStatus)
    {
        backEndInterface->stopPlayback(3);
        self.view.backgroundColor = [UIColor whiteColor];
    }
}





- (IBAction)modeSwitchToggled:(UISwitch *)sender
{
    if (sender.on)
    {
        m_bModeToggleStatus = true;
//        NSLog(m_bModeToggleStatus?@"Settings mode":@"Playback mode");
    }
    
    else
    {
        m_bModeToggleStatus = false;
//        NSLog(m_bModeToggleStatus?@"Settings mode":@"Playback mode");
    }
    
}



// conditional segue - Switch scenes only if we are in settings mode
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if (([identifier isEqualToString:@"conditionSegue1"]) && m_bModeToggleStatus) {
        return YES;
    }
    if (([identifier isEqualToString:@"conditionSegue2"]) && m_bModeToggleStatus) {
        return YES;
    }
    if (([identifier isEqualToString:@"conditionSegue3"]) && m_bModeToggleStatus) {
        return YES;
    }
    if (([identifier isEqualToString:@"conditionSegue4"]) && m_bModeToggleStatus) {
        return YES;
    }
    if ([identifier isEqualToString:@"settingsSegue"]) {
        return YES;
    }
    return NO;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    EffectSettingsViewController *EffectSettingsVC = segue.destinationViewController;
    if ([segue.identifier isEqualToString:@"conditionSegue1" ]) {
        EffectSettingsVC.view.backgroundColor = [UIColor redColor];
        EffectSettingsVC.currentData = redSample;
        EffectSettingsVC.m_iCurrentSampleID =   0;
        EffectSettingsVC.backEndInterface   =   backEndInterface;
    }
    else if ([segue.identifier isEqualToString:@"conditionSegue2" ]) {
        EffectSettingsVC.view.backgroundColor = [UIColor blueColor];
        EffectSettingsVC.currentData = blueSample;
        EffectSettingsVC.m_iCurrentSampleID =   1;
        EffectSettingsVC.backEndInterface   =   backEndInterface;
    }
    else if ([segue.identifier isEqualToString:@"conditionSegue3" ]) {
        EffectSettingsVC.view.backgroundColor = [UIColor greenColor];
        EffectSettingsVC.currentData = greenSample;
        EffectSettingsVC.m_iCurrentSampleID =   2;
        EffectSettingsVC.backEndInterface   =   backEndInterface;
    }
    else if ([segue.identifier isEqualToString:@"conditionSegue4" ]) {
        EffectSettingsVC.view.backgroundColor = [UIColor yellowColor];
        EffectSettingsVC.currentData = yellowSample;
        EffectSettingsVC.m_iCurrentSampleID =   3;
        EffectSettingsVC.backEndInterface   =   backEndInterface;
    }
}






//--- Motion Processing Methods ---//

- (void) motionDeviceUpdate: (CMDeviceMotion*) deviceMotion
{
    
//    double attitude[3];
    
//    attitude[0] = deviceMotion.attitude.roll;
//    attitude[1] = deviceMotion.attitude.pitch;
//    attitude[2] = deviceMotion.attitude.yaw;
//    [osc sendFloat:@"/attitude" : attitude : 3];
//    backEndInterface->setEffectParameter(0, 0, PARAM_1, ((deviceMotion.attitude.pitch + M_PI/2) * 2.0f));
//    backEndInterface->setEffectParameter(3, 0, PARAM_2, (deviceMotion.attitude.pitch + M_PI_2) / M_PI);
//    backEndInterface->setEffectParameter(2, 0, PARAM_2, (deviceMotion.attitude.pitch + M_PI_2) / M_PI);
//    backEndInterface->setEffectParameter(1, 0, PARAM_2, (deviceMotion.attitude.pitch + M_PI_2) / M_PI);
//    backEndInterface->setEffectParameter(0, 0, PARAM_2, (deviceMotion.attitude.pitch + M_PI_2) / M_PI);
    
//    backEndInterface->setSampleParameter(2, PARAM_QUANTIZATION, (((deviceMotion.attitude.roll + M_PI_2) / M_PI) * 2.0f) + 4.0f);
//    backEndInterface->setParameter(1, 1, 0, ((attitude[1] + M_PI/2) * 2.0f));
//    backEndInterface->setParameter(int sampleID, int effectPosition, int parameterID, float value
    
//    double acceleration[3];
    
//    acceleration[0] = deviceMotion.userAcceleration.x;
//    acceleration[1] = deviceMotion.userAcceleration.y;
//    acceleration[2] = deviceMotion.userAcceleration.z;
    [self processUserAcceleration:deviceMotion.userAcceleration];
//    [osc sendFloat:@"/acceleration" : acceleration : 3];
    
    
//    double quaternion[4];
    
//    quaternion[0] = deviceMotion.attitude.quaternion.w;
//    quaternion[1] = deviceMotion.attitude.quaternion.x;
//    quaternion[2] = deviceMotion.attitude.quaternion.y;
//    quaternion[3] = deviceMotion.attitude.quaternion.z;
//    [osc sendFloat:@"/quaternion" : quaternion : 4];
    
    
//    double rotationRate[3];
//    rotationRate[0] = deviceMotion.rotationRate.x;
//    rotationRate[1] = deviceMotion.rotationRate.y;
//    rotationRate[2] = deviceMotion.rotationRate.z;
//    [osc sendFloat:@"/rotationRate" : rotationRate : 3];
    
    
//    double gravity[3];
//    gravity[0] = deviceMotion.gravity.x;
//    gravity[1] = deviceMotion.gravity.y;
//    gravity[2] = deviceMotion.gravity.z;
//    [osc sendFloat:@"/gravity" : gravity : 3];
    
}




- (void)processUserAcceleration: (CMAcceleration) userAcceleration
{
    double amplitude = pow( (pow(userAcceleration.x, 2) + pow(userAcceleration.y, 2) + pow(userAcceleration.z, 2)), 0.5);
    
    if (amplitude > LIN_ACC_THRESHOLD || amplitude < -(LIN_ACC_THRESHOLD))
    {
//        [osc sendBang:@"/trigger"];
        backEndInterface->startPlayback(4);
    }
}


- (IBAction)redButtonRecordDown:(UIButton *)sender {
    
    sender.alpha = 1.0f;
    backEndInterface->startRecording(0);
    
}


- (IBAction)redButtonRecordUp:(UIButton *)sender {
    
    sender.alpha = 0.2f;
    backEndInterface->stopRecording(0);
}



- (IBAction)redButtonPlaybackFileToggle:(UIButton *)sender {
    
    if (m_pbPlaybackToggle[0])
    {
        sender.alpha = 0.2f;
        m_pbPlaybackToggle[0] = false;
        backEndInterface->togglePlaybackRecordingFile(0, true);
    }
    
    else
    {
        sender.alpha = 1.0f;
        m_pbPlaybackToggle[0] = true;
        backEndInterface->togglePlaybackRecordingFile(0, false);
    }
}

- (IBAction)redButtonMasterRecordDown:(UIButton *)sender {
    
    sender.alpha = 1.0f;
    backEndInterface->startRecordingOutput(0);
}

- (IBAction)redButtonMasterRecordUp:(UIButton *)sender {
    
    sender.alpha = 0.2f;
    backEndInterface->stopRecordingOutput(0);
}


- (IBAction)blueButtonRecordDown:(UIButton *)sender {
    
    sender.alpha = 1.0f;
    backEndInterface->startRecording(1);
    
}

- (IBAction)blueButtonRecordUp:(UIButton *)sender {
    
    sender.alpha = 0.2f;
    backEndInterface->stopRecording(1);
}



- (IBAction)blueButtonPlaybackFileToggle:(UIButton *)sender {
    
    if (m_pbPlaybackToggle[1])
    {
        sender.alpha = 0.4f;
        m_pbPlaybackToggle[1] = false;
        backEndInterface->togglePlaybackRecordingFile(1, true);
    }
    
    else
    {
        sender.alpha = 1.0f;
        m_pbPlaybackToggle[1] = true;
        backEndInterface->togglePlaybackRecordingFile(1, false);
    }

}

- (IBAction)blueButtonMasterRecordDown:(UIButton *)sender {

    sender.alpha = 1.0f;
    backEndInterface->startRecordingOutput(1);
}

- (IBAction)blueButtonMasterRecordUp:(UIButton *)sender {
    
    sender.alpha = 0.2f;
    backEndInterface->stopRecordingOutput(1);
}



- (IBAction)greenButtonRecordDown:(UIButton *)sender {
    
    sender.alpha = 1.0f;
    backEndInterface->startRecording(2);
}

- (IBAction)greenButtonRecordUp:(UIButton *)sender {
    
    sender.alpha = 0.4f;
    backEndInterface->stopRecording(2);
}


- (IBAction)greenButtonPlaybackFileToggle:(UIButton *)sender {
    
    if (m_pbPlaybackToggle[2])
    {
        sender.alpha = 0.4f;
        m_pbPlaybackToggle[2] = false;
        backEndInterface->togglePlaybackRecordingFile(2, true);
    }
    
    else
    {
        sender.alpha = 1.0f;
        m_pbPlaybackToggle[2] = true;
        backEndInterface->togglePlaybackRecordingFile(2, false);
    }

}

- (IBAction)greenButtonMasterRecordDown:(UIButton *)sender {
    
    sender.alpha = 1.0f;
    backEndInterface->startRecordingOutput(2);
}

- (IBAction)greenButtonMasterRecordUp:(UIButton *)sender {
    
    sender.alpha = 0.2f;
    backEndInterface->stopRecordingOutput(2);
}



- (IBAction)yellowButtonRecordDown:(UIButton *)sender {
    sender.alpha = 2.0f;
    backEndInterface->startRecording(3);
}


- (IBAction)yellowButtonRecordUp:(UIButton *)sender {
    sender.alpha = 0.4f;
    backEndInterface->stopRecording(3);
}


- (IBAction)yellowButtonPlaybackFileToggle:(UIButton *)sender {
    
    if (m_pbPlaybackToggle[3])
    {
        sender.alpha = 0.4f;
        m_pbPlaybackToggle[3] = false;
        backEndInterface->togglePlaybackRecordingFile(3, true);
    }
    
    else
    {
        sender.alpha = 1.0f;
        m_pbPlaybackToggle[3] = true;
        backEndInterface->togglePlaybackRecordingFile(3, false);
    }
    
}

- (IBAction)yellowButtonMasterRecordDown:(UIButton *)sender {
    
    sender.alpha = 1.0f;
    backEndInterface->startRecordingOutput(3);
}

- (IBAction)yellowButtonMasterRecordUp:(UIButton *)sender {
    
    sender.alpha = 0.2f;
    backEndInterface->stopRecordingOutput(3);
}




- (void)dealloc
{
    
//    [_toggleAudioButton release];
    
    [metronome dealloc];
    
    delete backEndInterface;
    delete [] m_pbPlaybackToggle;
    delete [] m_pbRecordToggle;
    
    [super dealloc];
}



- (IBAction)toggleMetronome:(UISwitch *)sender
{
    if (sender.on)
    {
        [metronome startClock];
    }
    
    else
    {
        [metronome stopClock];
    }
}


- (void) beat:(int)beatNo
{
    backEndInterface->beat(beatNo);
}


@end
