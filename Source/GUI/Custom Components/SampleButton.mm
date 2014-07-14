//
//  SampleButton.m
//  SampleButton
//
//  Created by Govinda Ram Pingali on 7/6/14.
//  Copyright (c) 2014 BeMotionLLC. All rights reserved.
//

#import "SampleButton.h"

@implementation SampleButton

@synthesize buttonID;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        // Initialization code
        
        [recordingsButton setButtonID:buttonID];
        recordingsButton = [[RecordingsButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, frame.size.width, frame.size.height)];
        [self addSubview:recordingsButton];
        
        [playButton setButtonID:buttonID];
        playButton = [[PlayButton alloc] initWithFrame:CGRectMake(frame.size.width, 0.0f, frame.size.width, frame.size.height)];
        [self addSubview:playButton];
        
        [settingsButton setButtonID:buttonID];
        settingsButton = [[SettingsButton alloc] initWithFrame:CGRectMake(2.0 * frame.size.width, 0.0f, frame.size.width, frame.size.height)];
        [self addSubview:settingsButton];
        
        
        [self setPagingEnabled:YES];
        [self setContentSize:CGSizeMake(frame.size.width * 3.0, frame.size.height)];
        [self setShowsHorizontalScrollIndicator:NO];
        [self setShowsVerticalScrollIndicator:NO];
        
        CGRect initialFrame = frame;
        initialFrame.origin.x = frame.size.width;
        [self scrollRectToVisible:initialFrame animated:NO];
        
        [self setBackgroundColor:[UIColor lightGrayColor]];
    }
    
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
