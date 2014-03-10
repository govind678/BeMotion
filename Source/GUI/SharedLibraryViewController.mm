//
//  SharedLibraryViewController.mm
//  SharedLibrary
//
//  Created by Govinda Ram Pingali on 3/8/14.
//  Copyright (c) 2014 GTCMT. All rights reserved.
//

#import "SharedLibraryViewController.h"


@interface SharedLibraryViewController () {
    SampleInfo *redSample;
    SampleInfo *blueSample;

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


//    redSample.sampleID = [NSNumber numberWithFloat:10];
//    redSample.delayEffect.time = [NSNumber numberWithFloat:0.5];
//    redSample.delayEffect.feedback = [NSNumber numberWithFloat:0.75];
//    

    
    backEndInterface          =   new SharedLibraryInterface;

    
    m_bRedButtonToggleStatus  = false;
    m_bBlueButtonToggleStatus = false;
    m_bModeToggleStatus       = true; // settings mode by default

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)redButtonPressed:(id)sender {
    NSLog(@"Chain contents %@ %@ %@ %@",  [redSample.effectChain objectAtIndex:0], [redSample.effectChain objectAtIndex:1], [redSample.effectChain objectAtIndex:2], [redSample.effectChain objectAtIndex:3]);
    NSLog(@"Bypass contents %@ %@ %@ %@",  redSample.delayEffect.bypass.stringValue,redSample.tremoloEffect.bypass.stringValue,redSample.vibratoEffect.bypass.stringValue,redSample.wahEffect.bypass.stringValue);
}
- (IBAction)blueButtonPressed:(id)sender {
    
}
- (IBAction)modeSwitchToggled:(UISwitch *)sender {
    if (sender.on){
        m_bModeToggleStatus = true;
        NSLog(m_bModeToggleStatus?@"Settings mode":@"Playback mode");
    }
    else {
        m_bModeToggleStatus = false;
        NSLog(m_bModeToggleStatus?@"Settings mode":@"Playback mode");
    }
    
}

//- (IBAction)toggleAudioButtonClicked:(UIButton *)sender
//{
//    if (!m_bAudioToggleStatus)
//    {
//        backEndInterface->toggleAudioButtonClicked(true);
//        m_bAudioToggleStatus    =   true;
//    }
//    else
//    {
//        backEndInterface->toggleAudioButtonClicked(false);
//        m_bAudioToggleStatus    =   false;
//    }
//    
//}
//
//- (IBAction)addEffectButtonClicked:(UIButton *)sender
//{
//    if (!m_bTempEffectStatusToggle)
//    {
//        // Add Audio Effect :   Sample ID, Audio Effect Position, Audio Effect ID
//        backEndInterface->addAudioEffect(0, 0, 0);
//        m_bTempEffectStatusToggle   =   true;
//    }
//    
//    else
//    {
//        // Remove Audio Effect :   Sample ID, Audio Effect Position
//        backEndInterface->removeAudioEffect(0, 0);
//        m_bTempEffectStatusToggle   =   false;
//    }
//}

// conditional segue - Switch scenes only if we are in settings mode
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if (([identifier isEqualToString:@"conditionSegue1"]) && m_bModeToggleStatus) {
        return YES;
    }
    if (([identifier isEqualToString:@"conditionSegue2"]) && m_bModeToggleStatus) {
        return YES;
    }
    return NO;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    EffectSettingsViewController *EffectSettingsVC = segue.destinationViewController;
    if ([segue.identifier isEqualToString:@"conditionSegue1" ]) {
        EffectSettingsVC.view.backgroundColor = [UIColor redColor];
        EffectSettingsVC.currentData = redSample;
    }
    else if ([segue.identifier isEqualToString:@"conditionSegue2" ]) {
        EffectSettingsVC.view.backgroundColor = [UIColor blueColor];
        EffectSettingsVC.currentData = blueSample;
    }
}

- (void)dealloc
{
    
//    [_toggleAudioButton release];
    
    delete backEndInterface;

    
    [super dealloc];
}

@end
