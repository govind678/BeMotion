//
//  ModeButton.h
//  BeatMotion
//
//  Created by Govinda Ram Pingali on 7/21/14.
//  Copyright (c) 2014 BeatMotion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ModeButton : UIView
{
    UIView* sideBar;
    
    UIButton* loopModeButton;
    UIButton* oneShotModeButton;
    UIButton* beatRepeatModeButton;
    
    int     currentMode;
}

- (id)initWithFrame:(CGRect)frame : (int)identifier;
- (void)postInitialize :(int)buttonMode;

@property (nonatomic, assign) int buttonID;
@property (nonatomic, assign) id  delegate;

- (void)setButtonMode : (int)mode;
- (void)displayCurrentMode;

@end
