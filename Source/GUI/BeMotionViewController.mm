//
//  BeMotionViewController.m
//  GestureController
//
//  Created by Govinda Ram Pingali on 4/28/14.
//  Copyright (c) 2014 GTCMT. All rights reserved.
//

#import "BeMotionViewController.h"
#import "SampleSettingsViewController.h"


@interface BeMotionViewController ()
{
    GestureControllerInterface*     m_pcBackendInterface;
}

@end

@implementation BeMotionViewController

@synthesize m_pcBackendInterface;


//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    
//    if (self)
//    {
//        
//        // Custom initialization
//    }
//    
//    return self;
//}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    static BOOL didInitialize   =   NO;
    
    if (didInitialize == YES)
    {
        // Do Stuff Here On Every View Load After Initialization
        
        return;
    }
    
    
    [self initializeApplication];
    
    didInitialize               =   YES;
    
}


- (void)initializeApplication
{
    
//    m_pcBackendInterface        =   NULL;
    m_pcBackendInterface        =   new GestureControllerInterface;
    
    m_bSettingsToggle           =   NO;
    m_bRecordToggle             =   NO;
    m_bMicrophoneToggle         =   NO;
    
    
    
    //--- Initialize With Audio Samples ---//
    NSString *sample1Path = [[NSBundle mainBundle] pathForResource:@"Playback0" ofType:@"wav"];
    NSString *sample2Path = [[NSBundle mainBundle] pathForResource:@"Playback1" ofType:@"wav"];
    NSString *sample3Path = [[NSBundle mainBundle] pathForResource:@"Playback2" ofType:@"wav"];
    NSString *sample4Path = [[NSBundle mainBundle] pathForResource:@"Playback3" ofType:@"wav"];
    NSString *sample5Path = [[NSBundle mainBundle] pathForResource:@"Playback4" ofType:@"wav"];
    
    m_pcBackendInterface->loadAudioFile(0, sample1Path);
    m_pcBackendInterface->loadAudioFile(1, sample2Path);
    m_pcBackendInterface->loadAudioFile(2, sample3Path);
    m_pcBackendInterface->loadAudioFile(3, sample4Path);
    m_pcBackendInterface->loadAudioFile(4, sample5Path);
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if (m_bSettingsToggle)
    {
        SampleSettingsViewController* vc = [segue destinationViewController];
        
        if ([[segue identifier]  isEqual: @"redButtonSettings"])
        {
            vc.m_iSampleID = 0;
        }
        
        else if ([[segue identifier]  isEqual: @"blueButtonSettings"])
        {
            vc.m_iSampleID = 1;
        }
        
        else if ([[segue identifier]  isEqual: @"greenButtonSettings"])
        {
            vc.m_iSampleID = 2;
        }
        
        else if ([[segue identifier]  isEqual: @"yellowButtonSettings"])
        {
            vc.m_iSampleID = 3;
        }
    }
    
    
}


- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if (([identifier isEqualToString:@"redButtonSettings"]) && m_bSettingsToggle)
    {
        return YES;
    }
    
    if (([identifier isEqualToString:@"blueButtonSettings"]) && m_bSettingsToggle)
    {
        return YES;
    }
    
    if (([identifier isEqualToString:@"greenButtonSettings"]) && m_bSettingsToggle)
    {
        return YES;
    }
    
    if (([identifier isEqualToString:@"yellowButtonSettings"]) && m_bSettingsToggle) {
        return YES;
    }
    
    if ([identifier isEqualToString:@"globalSettingsSegue"]) {
        return YES;
    }
    
    
    return NO;
}





//--- UI Button Actions ---//

- (IBAction)redButtonTouchDown:(UIButton *)sender
{
    sender.alpha    =   0.2;
    
    if ((m_bRecordToggle == NO) && (m_bSettingsToggle == NO) && (m_bMicrophoneToggle == NO))
    {
         m_pcBackendInterface->startPlayback(0);
    }
    
    else if ((m_bRecordToggle == NO) && (m_bSettingsToggle == NO) && (m_bMicrophoneToggle == YES))
    {
        m_pcBackendInterface->startRecordingFromMicrophone(0);
    }
    
    else if ((m_bRecordToggle == YES) && (m_bSettingsToggle == NO) && (m_bMicrophoneToggle == NO))
    {
        m_pcBackendInterface->startRecordingOutput(0);
    }
}


- (IBAction)redButtonTouchUp:(UIButton *)sender
{
    sender.alpha    =   1.0;
    
    if ((m_bRecordToggle == NO) && (m_bSettingsToggle == NO) && (m_bMicrophoneToggle == NO))
    {
        m_pcBackendInterface->stopPlayback(0);
    }
    
    else if ((m_bRecordToggle == NO) && (m_bSettingsToggle == NO) && (m_bMicrophoneToggle == YES))
    {
        m_pcBackendInterface->stopRecordingFromMicrophone(0);
    }
    
    else if ((m_bRecordToggle == YES) && (m_bSettingsToggle == NO) && (m_bMicrophoneToggle == NO))
    {
        m_pcBackendInterface->stopRecordingOutput(0);
    }
}



- (IBAction)blueButtonTouchDown:(UIButton *)sender
{
    sender.alpha    =   0.2;
    
    if ((m_bRecordToggle == NO) && (m_bSettingsToggle == NO) && (m_bMicrophoneToggle == NO))
    {
//        m_pcBackEndInterface->startPlayback(1);
    }
    
    else if ((m_bRecordToggle == NO) && (m_bSettingsToggle == NO) && (m_bMicrophoneToggle == YES))
    {
//        m_pcBackEndInterface->startRecordingFromMicrophone(1);
    }
    
    else if ((m_bRecordToggle == YES) && (m_bSettingsToggle == NO) && (m_bMicrophoneToggle == NO))
    {
//        m_pcBackEndInterface->startRecordingOutput(1);
    }
    
}

- (IBAction)blueButtonTouchUp:(UIButton *)sender
{
    sender.alpha    =   1.0;
    
    if ((m_bRecordToggle == NO) && (m_bSettingsToggle == NO) && (m_bMicrophoneToggle == NO))
    {
//        m_pcBackEndInterface->stopPlayback(1);
    }
    
    else if ((m_bRecordToggle == NO) && (m_bSettingsToggle == NO) && (m_bMicrophoneToggle == YES))
    {
//        m_pcBackEndInterface->stopRecordingFromMicrophone(1);
    }
    
    else if ((m_bRecordToggle == YES) && (m_bSettingsToggle == NO) && (m_bMicrophoneToggle == NO))
    {
//        m_pcBackEndInterface->stopRecordingOutput(1);
    }
}



- (IBAction)greenButtonTouchDown:(UIButton *)sender
{
    sender.alpha    =   0.2;
    
    if ((m_bRecordToggle == NO) && (m_bSettingsToggle == NO) && (m_bMicrophoneToggle == NO))
    {
//        m_pcBackEndInterface->startPlayback(2);
    }
    
    else if ((m_bRecordToggle == NO) && (m_bSettingsToggle == NO) && (m_bMicrophoneToggle == YES))
    {
//        m_pcBackEndInterface->startRecordingFromMicrophone(2);
    }
    
    else if ((m_bRecordToggle == YES) && (m_bSettingsToggle == NO) && (m_bMicrophoneToggle == NO))
    {
//        m_pcBackEndInterface->startRecordingOutput(2);
    }
}

- (IBAction)greenButtonTouchUp:(UIButton *)sender
{
    sender.alpha    =   1.0;
    
    if ((m_bRecordToggle == NO) && (m_bSettingsToggle == NO) && (m_bMicrophoneToggle == NO))
    {
//        m_pcBackEndInterface->stopPlayback(2);
    }
    
    else if ((m_bRecordToggle == NO) && (m_bSettingsToggle == NO) && (m_bMicrophoneToggle == YES))
    {
//        m_pcBackEndInterface->stopRecordingFromMicrophone(2);
    }
    
    else if ((m_bRecordToggle == YES) && (m_bSettingsToggle == NO) && (m_bMicrophoneToggle == NO))
    {
//        m_pcBackEndInterface->stopRecordingOutput(2);
    }
}



- (IBAction)yellowButtonTouchDown:(UIButton *)sender
{
    sender.alpha    =   0.2;
    
    if ((m_bRecordToggle == NO) && (m_bSettingsToggle == NO) && (m_bMicrophoneToggle == NO))
    {
//        m_pcBackEndInterface->startPlayback(3);
    }
    
    else if ((m_bRecordToggle == NO) && (m_bSettingsToggle == NO) && (m_bMicrophoneToggle == YES))
    {
//        m_pcBackEndInterface->startRecordingFromMicrophone(3);
    }
    
    else if ((m_bRecordToggle == YES) && (m_bSettingsToggle == NO) && (m_bMicrophoneToggle == NO))
    {
//        m_pcBackEndInterface->startRecordingOutput(3);
    }
}

- (IBAction)yellowButtonTouchUp:(UIButton *)sender
{
    sender.alpha    =   1.0;
    
    if ((m_bRecordToggle == NO) && (m_bSettingsToggle == NO) && (m_bMicrophoneToggle == NO))
    {
//        m_pcBackEndInterface->stopPlayback(3);
    }
    
    else if ((m_bRecordToggle == NO) && (m_bSettingsToggle == NO) && (m_bMicrophoneToggle == YES))
    {
//        m_pcBackEndInterface->stopRecordingFromMicrophone(3);
    }
    
    else if ((m_bRecordToggle == YES) && (m_bSettingsToggle == NO) && (m_bMicrophoneToggle == NO))
    {
//        m_pcBackEndInterface->stopRecordingOutput(3);
    }
}





//--- Modifier Keys ---//

- (IBAction)settingsButtonClicked:(UIButton *)sender
{
    if (m_bSettingsToggle == YES)
    {
        sender.alpha    =   1.0f;
        [[self view] setBackgroundColor:[UIColor colorWithRed:0.0f green:0.121f blue:0.179f alpha:1.0f]];
        m_bSettingsToggle   =   NO;
    }
    
    else
    {
        sender.alpha    =   0.5f;
        
        // UnToggle Other Modifiers
        m_bRecordToggle         =   NO;
        m_bMicrophoneToggle     =   NO;
        
        [[self view] setBackgroundColor:[UIColor colorWithRed:0.1f green:0.1f blue:0.4f alpha:1.0f]];
        m_bSettingsToggle       =   YES;
    }
}



- (IBAction)recordButtonClicked:(UIButton *)sender
{
    if (m_bRecordToggle == YES)
    {
        sender.alpha    =   1.0f;
        [[self view] setBackgroundColor:[UIColor colorWithRed:0.0f green:0.121f blue:0.179f alpha:1.0f]];
        m_bRecordToggle             =   NO;
    }
    
    else
    {
        sender.alpha    =   0.5f;
        
        // UnToggle Other Modifiers
        m_bSettingsToggle       =   NO;
        m_bMicrophoneToggle     =   NO;
        
        [[self view] setBackgroundColor:[UIColor colorWithRed:0.3f green:0.1f blue:0.1f alpha:1.0f]];
        m_bRecordToggle             =   YES;
    }
}



- (IBAction)microphoneButtonClicked:(UIButton *)sender
{
    if (m_bMicrophoneToggle == YES)
    {
        sender.alpha    =   1.0f;
        [[self view] setBackgroundColor:[UIColor colorWithRed:0.0f green:0.121f blue:0.179f alpha:1.0f]];
        m_bMicrophoneToggle         =   NO;
    }
    
    else
    {
        sender.alpha    =   0.5f;
        
        // UnToggle Other Modifiers
        m_bSettingsToggle       =   NO;
        m_bRecordToggle         =   NO;
        
        [[self view] setBackgroundColor:[UIColor colorWithRed:0.1f green:0.3f blue:0.1f alpha:1.0f]];
        m_bMicrophoneToggle         =   YES;
    }
}




-(void)setBackendInterface:(GestureControllerInterface *)backendInterface
{
    m_pcBackendInterface    =   backendInterface;
}


- (void)dealloc
{
     
//    [metronome dealloc];
    delete m_pcBackendInterface;
    
    [super dealloc];
}



@end
