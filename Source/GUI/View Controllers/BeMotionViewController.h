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
#import  "Metronome.h"

#import  "EffectSettingsViewController.h"
#import  "GlobalSettingsViewController.h"
#import  "LoadSampleViewController.h"

#import  "SampleButton.h"
#import  "MetronomeBar.h"
#import  "TempoPicker.h"

#import  "MotionControl.h"

//#import <CoreMotion/CoreMotion.h>



#define METRO_GUI_COUNT     8

@interface BeMotionViewController : UIViewController
{
    bool*                           m_pbMasterRecordToggle;
    bool*                           m_pbMasterBeginRecording;
    
    bool*                           m_pbAudioRecordToggle;
    bool*                           m_pbAudioCurrentlyRecording;
    
    float*                          motion;
    
    MotionControl*                  motionControl;
    
    //--- Sample Buttons ---//
    SampleButton* sampleButton0;
    SampleButton* sampleButton1;
    SampleButton* sampleButton2;
    SampleButton* sampleButton3;
    
    BOOL                            tempoDisplayToggle;
}


//--- Reference To Backend and Metronome ---//
@property (nonatomic, assign) BeMotionInterface*  backendInterface;
@property (nonatomic, assign) Metronome*  metronome;




//--- Modifier Keys ---//
- (IBAction)metronomeToggleClicked:(UIButton *)sender;

@property (retain, nonatomic) IBOutlet UIButton *metronomeButton;


//--- Metronome Bars ---//
@property (retain, nonatomic) MetronomeBar *metronomeBar;


//--- Tempo Picker ---//
@property (retain, nonatomic) TempoPicker *tempoPicker;


//--- View Methods ---//
- (void) guiBeat: (int) beatNo;
- (void) updatePlaybackProgress;


//--- Tempo Picker Methods ---//
- (void) toggleMetronome : (BOOL) value;
- (void) toggleMetronomeAudio : (BOOL) value;
- (void) setTempo : (int)tempo;
- (BOOL) getMetronomeStatus;


//--- Sample Button Delegate Methods ---//
//- (void)startPlayback: (int)sampleID;
//- (void)stopPlayback: (int)sampleID;
//
//
//--- Settings Button Delegate Methods ---//
//- (void)startRecording: (int)sampleID;
//- (void)stopRecording: (int)sampleID;
//- (void)startResampling: (int)sampleID;
- (void)launchFXView: (int)sampleID;
- (void)launchImportView: (int)sampleID;
- (void)toggleGestureControl: (int)sampleID;


@end
