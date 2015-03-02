//
//  SettingsButton.h
//  SampleButton
//
//  Created by Govinda Ram Pingali on 7/6/14.
//  Copyright (c) 2014 PlasmatioTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsButton : UIView
{
    UIView* sideBar;
    UIButton* recordButton;
}

- (id)initWithFrame:(CGRect)frame : (int)identifier;

@property (nonatomic, assign) int buttonID;
@property (nonatomic, assign) id  delegate;

- (void)startRecording;
- (void)stopRecording;
- (void)launchFXView;
- (void)launchImportView;
//- (void)toggleGestureControl;

@end
