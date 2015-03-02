//
//  BeatMotionViewController.h
//  BeatMotion
//
//  Created by Govinda Ram Pingali on 3/8/14.
//  Copyright (c) 2014 BeatMotion. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "BeatMotionInterface.h"
#import  "Metronome.h"

#import  "EffectSettingsViewController.h"
#import  "GlobalSettingsViewController.h"
#import  "LoadSampleViewController.h"

#import  "SampleButton.h"
#import  "MetronomeBar.h"
//#import  "TempoPicker.h"

#import  "MotionControl.h"

#define METRO_GUI_COUNT     8

@interface BeatMotionViewController : UIViewController
{
    bool*                           m_pbMasterRecordToggle;
    bool*                           m_pbMasterBeginRecording;
    
    bool*                           m_pbAudioRecordToggle;
    bool*                           m_pbAudioCurrentlyRecording;
    
    float*                          motion;
    
    MotionControl*                  motionControl;
    
//    BOOL                            tempoDisplayToggle;
    BOOL                            recordingToggle;
    
    NSTimer* timer;
}


//--- Reference To Backend and Metronome ---//
@property (nonatomic, assign) BeatMotionInterface*  backendInterface;
@property (nonatomic, assign) Metronome*  metronome;



//--- Sample Buttons ---//
@property (retain, nonatomic) IBOutlet SampleButton *sampleButton0;
@property (retain, nonatomic) IBOutlet SampleButton *sampleButton1;
@property (retain, nonatomic) IBOutlet SampleButton *sampleButton2;
@property (retain, nonatomic) IBOutlet SampleButton *sampleButton3;



//--- Modifier Keys ---//
- (IBAction)metronomeToggleClicked:(UIButton *)sender;
@property (retain, nonatomic) IBOutlet UIButton *metronomeButton;

- (IBAction)recordButtonClicked:(UIButton *)sender;
@property (retain, nonatomic) IBOutlet UIButton *recordButton;


//--- Metronome Bars ---//
@property (retain, nonatomic) IBOutlet MetronomeBar *metronomeBar;


//--- Tempo Picker ---//
//@property (retain, nonatomic) TempoPicker *tempoPicker;


//--- View Methods ---//
- (void) guiBeat: (int) beatNo;
- (void) updatePlaybackProgress;


//--- Tempo Picker Methods ---//
//- (void) toggleMetronome : (BOOL) value;
//- (void) toggleMetronomeAudio : (BOOL) value;
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
- (void) buttonModeChanged :(int)sampleID :(int)buttonMode;


@end





