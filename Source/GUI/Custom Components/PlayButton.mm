//
//  PlayButton.m
//  SampleButton
//
//  Created by Govinda Ram Pingali on 7/6/14.
//  Copyright (c) 2014 BeMotionLLC. All rights reserved.
//

#import "PlayButton.h"

@implementation PlayButton

@synthesize buttonID, delegate;

- (id)initWithFrame:(CGRect)frame : (int)identifier
{
    self = [super initWithFrame:frame];
    
    if (self) {
        // Initialization code
        
        buttonID = identifier;
        
        overlay = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, frame.size.width, frame.size.height)];
        [overlay setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"SampleButtonOverlay.png"]]];
        [self addSubview:overlay];
        [overlay setUserInteractionEnabled:NO];
        [overlay setHidden:YES];
        
        hit = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, frame.size.width, frame.size.height)];
        [self addSubview:hit];
        [hit setUserInteractionEnabled:NO];
        [hit setAlpha:0.0f];
        
        
        switch (buttonID) {
            case 0:
                [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"SampleButton0.png"]]];
                [hit setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"SampleButtonHit0.png"]]];
                break;
                
            case 1:
                [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"SampleButton1.png"]]];
                [hit setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"SampleButtonHit1.png"]]];
                break;
                
            case 2:
                [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"SampleButton2.png"]]];
                [hit setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"SampleButtonHit2.png"]]];
                break;
                
            case 3:
                [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"SampleButton3.png"]]];
                [hit setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"SampleButtonHit3.png"]]];
                break;
                
            default:
                break;
        }
        
        
        [self setMultipleTouchEnabled:YES];
        
        touchDownCount      =   0;
        touchMovedStatus    =   NO;
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



- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [delegate startPlayback];
    [overlay setHidden:NO];
    
    [hit setAlpha:1.0f];
    [UIView animateWithDuration:0.1f
                     animations:^{
                         [hit setAlpha:0.0f];
                     }
                     completion:^(BOOL finished){}];
    
    touchDownCount++;
    touchMovedStatus = NO;
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    CGPoint touchPoint = [[touches anyObject] locationInView:self];
    
    if ([self pointInside:touchPoint withEvent:event]) {
        // Point inside
        touchMovedStatus = NO;
    } else {
        // Point isn't inside
        touchMovedStatus = YES;
    }
    
    
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    touchDownCount--;
    
    if (touchDownCount <= 0) {
        
        if (touchMovedStatus == NO) {
            [delegate stopPlayback];
            [overlay setHidden:YES];
        }
        
        touchDownCount = 0;
    }
}


- (void)postInitialize:(BOOL)playbackStatus {
    
    if (playbackStatus) {
        [overlay setHidden:NO];
    } else {
        [overlay setHidden:YES];
    }
}

- (void)startPlayback {
    
    // Start Playback
}

- (void)stopPlayback {
    
    //Stop Playback
}


- (void) reloadFromBackground {
    [overlay setHidden:YES];
}

@end
