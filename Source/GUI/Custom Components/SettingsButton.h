//
//  SettingsButton.h
//  BeMotion
//
//  Created by Govinda Ram Pingali on 6/2/14.
//  Copyright (c) 2014 BeMotionLLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "Macros.h"

@interface SettingsButton : UIView
{
    
}

@property (nonatomic, assign) int buttonID;
@property (nonatomic, assign) id  delegate;
@property (nonatomic, retain) UILabel* recordLabel;

- (void)startRecording : (int)sampleID;
- (void)stopRecording : (int)sampleID;
- (void)startResampling : (int)sampleID;
- (void)launchFXView : (int)sampleID;
- (void)launchImportView : (int)sampleID;

@end
