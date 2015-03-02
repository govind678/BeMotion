//
//  SampleButton.h
//  SampleButton
//
//  Created by Govinda Ram Pingali on 7/6/14.
//  Copyright (c) 2014 PlasmatioTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayButton.h"
#import "SettingsButton.h"
#import "ModeButton.h"

#import "BeatMotionInterface.h"
#import "Macros.h"

@interface SampleButton : UIScrollView
{
    PlayButton*         playButton;
    SettingsButton*     settingsButton;
    ModeButton*         modeButton;
    
    UIButton*           dragArrowButton0;
    UIView*             dragArrowBack0;
    
    UIButton*           dragArrowButton1;
//    UIView*             dragArrowBack1;
    
    UILabel*            statusLabel1;
    UILabel*            statusLabel2;
}

- (id)initWithFrame:(CGRect)frame;
- (void) setIdentifier : (int)identifier;
- (void)postInitialize;

@property (nonatomic, assign) BeatMotionInterface*  backendInterface;
@property (nonatomic, assign) int buttonID;
@property (nonatomic, assign) id  delegate;



- (void) startPlayback;
- (void) stopPlayback;
- (void) startRecording;
- (void) stopRecording;
- (void) startResampling;
- (void) launchFXView;
- (void) launchImportView;
- (void) toggleGestureControl;
- (void) setButtonMode :(int)mode;


- (void) launchFXView : (int)sampleID;
- (void) launchImportView : (int)sampleID;
- (void) toggleGestureControl : (int)sampleID;
- (void) buttonModeChanged :(int)sampleID :(int)buttonMode;

- (void) reloadFromBackground;

- (void) updateProgress : (float)value;

@end
