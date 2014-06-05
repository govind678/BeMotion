//
//  SampleButton.h
//  BeMotion
//
//  Created by Govinda Ram Pingali on 6/3/14.
//  Copyright (c) 2014 BeMotionLLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SampleButton : UIView
{
    int     touchDownCount;
    bool    touchMovedStatus;
}

@property (nonatomic, assign) int buttonID;
@property (nonatomic, assign) id  delegate;

//--- Touch Events ---//
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;


- (void) setDelegate        :   (id) newDelegate;


- (void) startPlayback : (int)sampleID;
- (void) stopPlayback : (int)sampleID;

@end
