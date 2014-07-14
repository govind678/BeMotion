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
#import "RecordingsButton.h"

@interface SampleButton : UIScrollView
{
    PlayButton* playButton;
    SettingsButton* settingsButton;
    RecordingsButton* recordingsButton;
    
    UIView* dragLeft;
    UIView* dragRight;
}

@property (nonatomic, assign) int buttonID;

@end
