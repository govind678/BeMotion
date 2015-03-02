//
//  PlayButton.h
//  SampleButton
//
//  Created by Govinda Ram Pingali on 7/6/14.
//  Copyright (c) 2014 PlasmatioTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayButton : UIView
{
    int     touchDownCount;
    bool    touchMovedStatus;
    
    UIView* overlay;
    UIView* hit;
    UIProgressView* progress;
}


- (id)initWithFrame:(CGRect)frame : (int)identifier;


@property (nonatomic, assign) int buttonID;
@property (nonatomic, assign) id  delegate;


//--- Touch Events ---//
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;

- (void) postInitialize : (BOOL)playbackStatus;
- (void) startPlayback;
- (void) stopPlayback;

- (void) updateProgress : (float)value;

- (void) reloadFromBackground;


@end
