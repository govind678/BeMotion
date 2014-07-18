//
//  SampleButton.h
//  SampleButton
//
//  Created by Govinda Ram Pingali on 7/6/14.
//  Copyright (c) 2014 BeMotionLLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayButton.h"
#import "SettingsButton.h"

#import "BeMotionInterface.h"
#import "Macros.h"

@interface SampleButton : UIScrollView
{
    PlayButton*         playButton;
    SettingsButton*     settingsButton;
    UIButton*           dragArrowButton;
    UIView*             dragArrowBack;
}

- (id)initWithFrame:(CGRect)frame : (int)identifier;
- (void)postInitialize;

@property (nonatomic, assign) BeMotionInterface*  backendInterface;
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

- (void) launchFXView : (int)sampleID;
- (void) launchImportView : (int)sampleID;
- (void) toggleGestureControl : (int)sampleID;

- (void) reloadFromBackground;

- (void) updateProgress : (float)value;

@end
