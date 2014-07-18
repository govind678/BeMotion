//
//  SampleButton.m
//  SampleButton
//
//  Created by Govinda Ram Pingali on 7/6/14.
//  Copyright (c) 2014 BeMotionLLC. All rights reserved.
//

#import "SampleButton.h"


@implementation SampleButton

@synthesize buttonID, delegate;

- (id)initWithFrame:(CGRect)frame : (int)identifier
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        // Initialization code
        
        buttonID = identifier;
        
        playButton = [[PlayButton alloc] initWithFrame:CGRectMake(20.0f, 0.0f, frame.size.width - 40.0f, frame.size.height) : buttonID];
        [playButton setTag:(buttonID + 100)];
        [playButton setDelegate:self];
        [self addSubview:playButton];
        
        settingsButton = [[SettingsButton alloc] initWithFrame:CGRectMake(frame.size.width + 20.0f, 0.0f, frame.size.width - 40.0f, frame.size.height) : buttonID];
        [settingsButton setDelegate:self];
        [self addSubview:settingsButton];
        
        
        dragArrowBack = [[UIView alloc] initWithFrame:CGRectMake(frame.size.width - 20.0f, 0.0f, 20.0f, 100.0f)];
        [dragArrowBack setUserInteractionEnabled:NO];
        switch (buttonID) {
            case 0:
                [dragArrowBack setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"DragArrowBack0.png"]]];
                break;
                
            case 1:
                [dragArrowBack setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"DragArrowBack1.png"]]];
                break;
                
            case 2:
                [dragArrowBack setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"DragArrowBack2.png"]]];
                break;
                
            case 3:
                [dragArrowBack setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"DragArrowBack3.png"]]];
                break;
                
            default:
                break;
        }
        [self addSubview:dragArrowBack];
        
        
        dragArrowButton = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width - 20.0f, 0.0f, 20.0f, 100.0f)];
        [dragArrowButton setImage:[UIImage imageNamed:@"DragArrowUp.png"] forState:UIControlStateNormal];
        [dragArrowButton setImage:[UIImage imageNamed:@"DragArrowDown.png"] forState:UIControlStateHighlighted];
        [dragArrowButton setAlpha:0.8f];
        [self addSubview:dragArrowButton];
        
        
        [self setContentSize:CGSizeMake(frame.size.width * 3.0, frame.size.height)];
        [self setPagingEnabled:YES];
        [self setShowsHorizontalScrollIndicator:NO];
        [self setShowsVerticalScrollIndicator:NO];
        [self setDelaysContentTouches:NO];
        [self setCanCancelContentTouches:YES];
        
        
        //        CGRect initialFrame = frame;
        //        initialFrame.origin.x = frame.size.width;
        //        initialFrame.origin.y = 0.0f;
        //        [self scrollRectToVisible:initialFrame animated:NO];
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

- (void)postInitialize {
    [playButton postInitialize:_backendInterface->getSamplePlaybackStatus(buttonID)];
}

- (BOOL)touchesShouldBegin:(NSSet *)touches withEvent:(UIEvent *)event inContentView:(UIView *)view {
    
    return YES;
}


- (BOOL)touchesShouldCancelInContentView:(UIView *)view
{
    BOOL returnVal = YES;
    
    if(view.tag == (buttonID+100))
    {
        returnVal = NO;
    }
    
    return returnVal;
}


- (void)startPlayback {
    _backendInterface->startPlayback(buttonID);
}

- (void)stopPlayback {
    _backendInterface->stopPlayback(buttonID);
}


- (void)startRecording {
    _backendInterface->startRecording(buttonID);
}

- (void)stopRecording {
    _backendInterface->stopRecording(buttonID);
}

- (void)startResampling {
    
}


- (void)launchFXView {
    [delegate launchFXView:buttonID];
}

- (void)launchImportView {
    [delegate launchImportView:buttonID];
}

- (void)toggleGestureControl {
    [delegate toggleGestureControl:buttonID];
}



- (void)launchFXView:(int)sampleID {
    
}

- (void)launchImportView:(int)sampleID {
    
}

- (void) toggleGestureControl:(int)sampleID {
    
}


- (void) updateProgress:(float)value {
    [playButton updateProgress:value];
}

- (void)reloadFromBackground {
    [playButton reloadFromBackground];
}
@end
