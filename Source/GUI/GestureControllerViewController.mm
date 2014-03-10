//==============================================================================
//
//  GestureControllerViewController.mm
//  GestureController
//
//  Created by Anand Mahadevan on 3/8/14.
//  Copyright (c) 2014 GTCMT. All rights reserved.
//
//==============================================================================


#import "GestureControllerViewController.h"

@interface GestureControllerViewController ()

@end

@implementation GestureControllerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    backEndInterface    =   new GestureControllerInterface;
    
    m_bAudioToggleStatus_1  =   false;
    m_bAudioToggleStatus_2  =   false;
    m_iAudioEffectsStatus_1 =   0;
    m_iAudioEffectsStatus_2 =   0;
    m_iPlayRecordStatus     =   0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)toggleAudioButtonClicked:(UIButton *)sender
{
    if (!m_bAudioToggleStatus_1)
    {
        backEndInterface->startPlayback(0);
        m_bAudioToggleStatus_1    =   true;
    }
    
    else
    {
        backEndInterface->stopPlayback(0);
        m_bAudioToggleStatus_1    =   false;
    }
    
}

- (IBAction)addEffectButtonClicked:(UIButton *)sender
{
    //--- Sample 0 ---//
    
    // Add Audio Effect :   Sample ID, Audio Effect Position, Audio Effect ID
    // Remove Audio Effect: Sample ID, Effect Position
    
    if (m_iAudioEffectsStatus_1 == 0)
    {
        // Add Tremolo at 0
        backEndInterface->addAudioEffect(0, 0, 0);
    }
    
    else if (m_iAudioEffectsStatus_1 == 1)
    {
        // Add Delay at 0
        backEndInterface->addAudioEffect(0, 0, 1);
    }
    
    else if (m_iAudioEffectsStatus_1 == 2)
    {
        // Add Tremolo at 0 and Delay at 1
        backEndInterface->addAudioEffect(0, 0, 0);
        backEndInterface->addAudioEffect(0, 1, 1);
    }
    
    else if (m_iAudioEffectsStatus_1 == 3)
    {
        // Add Delay at 0 and Tremolo at 1
        backEndInterface->addAudioEffect(0, 0, 1);
        backEndInterface->addAudioEffect(0, 1, 0);
    }
    
    else if (m_iAudioEffectsStatus_1 == 4)
    {
        // Remove all effects
        backEndInterface->removeAudioEffect(0, 0);
        backEndInterface->removeAudioEffect(0, 1);
    }

    m_iAudioEffectsStatus_1   =   (m_iAudioEffectsStatus_1 + 1) % 5;
}




- (IBAction)removeEffectButtonClicked:(UIButton *)sender
{
    //--- Sample 1 ---//
    
    // Add Audio Effect :   Sample ID, Audio Effect Position, Audio Effect ID
    // Remove Audio Effect: Sample ID, Effect Position
    
    if (m_iAudioEffectsStatus_2 == 0)
    {
        // Add Tremolo at 0
        backEndInterface->addAudioEffect(1, 0, 0);
    }
    
    else if (m_iAudioEffectsStatus_2 == 1)
    {
        // Add Delay at 0
        backEndInterface->addAudioEffect(1, 0, 1);
    }
    
    else if (m_iAudioEffectsStatus_2 == 2)
    {
        // Add Tremolo at 0 and Delay at 1
        backEndInterface->addAudioEffect(1, 0, 0);
        backEndInterface->addAudioEffect(1, 1, 1);
    }
    
    else if (m_iAudioEffectsStatus_2 == 3)
    {
        // Add Delay at 0 and Tremolo at 1
        backEndInterface->addAudioEffect(1, 0, 1);
        backEndInterface->addAudioEffect(1, 1, 0);
    }
    
    else if (m_iAudioEffectsStatus_2 == 4)
    {
        // Remove all effects
        backEndInterface->removeAudioEffect(1, 0);
        backEndInterface->removeAudioEffect(1, 1);
    }
    
    m_iAudioEffectsStatus_2   =   (m_iAudioEffectsStatus_2 + 1) % 5;
}




- (IBAction)playRecordButtonClicked:(UIButton *)sender
{
    if (!m_bAudioToggleStatus_2)
    {
        backEndInterface->startPlayback(1);
        m_bAudioToggleStatus_2   =   true;
    }
    
    else
    {
        backEndInterface->stopPlayback(1);
        m_bAudioToggleStatus_2   =   false;
    }
}



- (void)dealloc
{
    
    [_toggleAudioButton release];
    
    delete backEndInterface;
    
    
    [_removeEffectButton release];
    [super dealloc];
}
@end
