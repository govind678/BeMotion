//==============================================================================
//
//  BeMotionViewController.h
//  BeMotion
//
//  Created by Govinda Ram Pingali on 3/8/14.
//  Copyright (c) 2014 BeMotionLLC. All rights reserved.
//
//==============================================================================


#import  <UIKit/UIKit.h>

#include "BeMotionInterface.h"
#import  "EffectSettingsViewController.h"
#import  "GlobalSettingsViewController.h"
#import  "SettingsButton.h"

#import "Metronome.h"
#import <CoreMotion/CoreMotion.h>


#define METRO_GUI_COUNT     8

@interface BeMotionViewController : UIViewController
{
    bool                            m_bSettingsToggle;
    
    bool*                           m_pbMasterRecordToggle;
    bool*                           m_pbMasterBeginRecording;
    
    bool*                           m_pbAudioRecordToggle;
    bool*                           m_pbAudioCurrentlyRecording;
    
    bool*                           m_pbPlaybackStatus;
    int*                            m_piFingerDownStatus;
    bool*                           m_pbFingerMoveStatus;
    
    float*                          motion;
}


//--- Reference To Backend and Metronome ---//
@property (nonatomic, assign) BeMotionInterface*  backendInterface;
@property (nonatomic, assign) Metronome*  metronome;




//--- Motion Processing ---//

@property (strong, nonatomic) CMMotionManager *motionManager;
- (void)motionDeviceUpdate: (CMDeviceMotion*) deviceMotion;
- (void)processUserAcceleration: (CMAcceleration) userAcceleration;




//--- User Interaction Methods ---//


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;



//--- Modifier Keys ---//
- (IBAction)settingsToggleClicked:(UIButton *)sender;
- (IBAction)metronomeToggleClicked:(UIButton *)sender;


- (void)startRecording : (int)sampleID;
- (void)stopRecording : (int)sampleID;
- (void)startResampling : (int)sampleID;
- (void)launchFXView : (int)sampleID;



//--- Sample Buttons ---//
@property (retain, nonatomic) IBOutlet UIView *sampleButton0;
@property (retain, nonatomic) IBOutlet UIView *sampleButton1;
@property (retain, nonatomic) IBOutlet UIView *sampleButton2;
@property (retain, nonatomic) IBOutlet UIView *sampleButton3;

@property (retain, nonatomic) IBOutlet SettingsButton *settingsButton0;
@property (retain, nonatomic) IBOutlet SettingsButton *settingsButton1;
@property (retain, nonatomic) IBOutlet SettingsButton *settingsButton2;
@property (retain, nonatomic) IBOutlet SettingsButton *settingsButton3;




//--- Sample Progress Bars ---//
@property (retain, nonatomic) IBOutlet UIProgressView *progressBar0;
@property (retain, nonatomic) IBOutlet UIProgressView *progressBar1;
@property (retain, nonatomic) IBOutlet UIProgressView *progressBar2;
@property (retain, nonatomic) IBOutlet UIProgressView *progressBar3;


@property (retain, nonatomic) IBOutlet UIButton *metronomeButton;
@property (retain, nonatomic) IBOutlet UIButton *settingsButton;


//--- Metronome Bars ---//
@property (retain, nonatomic) IBOutlet UIButton *metroBar0;
@property (retain, nonatomic) IBOutlet UIButton *metroBar1;
@property (retain, nonatomic) IBOutlet UIButton *metroBar2;
@property (retain, nonatomic) IBOutlet UIButton *metroBar3;
@property (retain, nonatomic) IBOutlet UIButton *metroBar4;
@property (retain, nonatomic) IBOutlet UIButton *metroBar5;
@property (retain, nonatomic) IBOutlet UIButton *metroBar6;
@property (retain, nonatomic) IBOutlet UIButton *metroBar7;



- (void) guiBeat: (int) beatNo;
- (void) setTempo: (float) tempo;
- (void) updatePlaybackProgress;

@end
