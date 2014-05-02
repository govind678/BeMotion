//
//  SharedLibraryViewController.h
//  SharedLibrary
//
//  Created by Govinda Ram Pingali on 3/8/14.
//  Copyright (c) 2014 GTCMT. All rights reserved.
//

#import  <UIKit/UIKit.h>

#include "GestureControllerInterface.h"
#import  "EffectSettingsViewController.h"
#import  "GlobalSettingsViewController.h"

#import "Metronome.h"
#import <CoreMotion/CoreMotion.h>


#define METRO_GUI_COUNT     8

@interface SharedLibraryViewController : UIViewController
{
    int                             m_iButtonMode;       // playback = 0 , settings = 1, record = 2
    
    bool*                           m_pbMasterRecordToggle;
    bool*                           m_pbMasterBeginRecording;
    
    bool*                           m_pbAudioRecordToggle;
    bool*                           m_pbAudioCurrentlyRecording;
    
    bool*                           m_pbPlaybackStatus;
    
    float*                          motion;
}


//--- Reference To Backend and Metronome ---//
@property (nonatomic, assign) GestureControllerInterface*  backendInterface;
@property (nonatomic, assign) Metronome*  metronome;





//--- Motion Processing ---//

@property (strong, nonatomic) CMMotionManager *motionManager;
- (void)motionDeviceUpdate: (CMDeviceMotion*) deviceMotion;
- (void)processUserAcceleration: (CMAcceleration) userAcceleration;




//--- User Interaction Methods ---//

- (IBAction)RedTouchUp:(UIButton *)sender;
- (IBAction)RedTouchDown:(UIButton *)sender;

- (IBAction)BlueTouchUp:(UIButton *)sender;
- (IBAction)BlueTouchDown:(UIButton *)sender;

- (IBAction)GreenTouchUp:(UIButton *)sender;
- (IBAction)GreenTouchDown:(UIButton *)sender;

- (IBAction)YellowTouchUp:(UIButton *)sender;
- (IBAction)YellowTouchDown:(UIButton *)sender;


- (IBAction)redMasterRecord:(UIButton *)sender;
- (IBAction)blueMasterRecord:(UIButton *)sender;
- (IBAction)greenMasterRecord:(UIButton *)sender;
- (IBAction)yellowMasterRecord:(UIButton *)sender;



//--- Modifier Keys ---//
- (IBAction)settingsToggleClicked:(UIButton *)sender;
- (IBAction)recordToggleClicked:(UIButton *)sender;
- (IBAction)metronomeToggleClicked:(UIButton *)sender;



//--- Sample Buttons ---//
@property (retain, nonatomic) IBOutlet UIButton *sampleButton0;
@property (retain, nonatomic) IBOutlet UIButton *sampleButton1;
@property (retain, nonatomic) IBOutlet UIButton *sampleButton2;
@property (retain, nonatomic) IBOutlet UIButton *sampleButton3;


//--- Master Record Button Instances ---//
@property (retain, nonatomic) IBOutlet UIButton *masterRecord0;
@property (retain, nonatomic) IBOutlet UIButton *masterRecord1;
@property (retain, nonatomic) IBOutlet UIButton *masterRecord2;
@property (retain, nonatomic) IBOutlet UIButton *masterRecord3;




//--- Metronome Bars ---//
@property (retain, nonatomic) IBOutlet UIButton *metroBar0;
@property (retain, nonatomic) IBOutlet UIButton *metroBar1;
@property (retain, nonatomic) IBOutlet UIButton *metroBar2;
@property (retain, nonatomic) IBOutlet UIButton *metroBar3;
@property (retain, nonatomic) IBOutlet UIButton *metroBar4;
@property (retain, nonatomic) IBOutlet UIButton *metroBar5;
@property (retain, nonatomic) IBOutlet UIButton *metroBar6;
@property (retain, nonatomic) IBOutlet UIButton *metroBar7;



- (void) beat:  (int) beatNo;
- (void) guiBeat: (int) beatNo;
- (void) setTempo: (float) tempo;

@end
