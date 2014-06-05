//
//  SampleButton.m
//  BeMotion
//
//  Created by Govinda Ram Pingali on 6/3/14.
//  Copyright (c) 2014 BeMotionLLC. All rights reserved.
//

#import "SampleButton.h"

@implementation SampleButton

@synthesize buttonID, delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        // Initialization code
        
        switch (buttonID) {
            case 0:
                [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"SampleButton0.png"]]];
                break;
                
            case 1:
                [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"SampleButton1.png"]]];
                break;
                
            case 2:
                [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"SampleButton2.png"]]];
                break;
                
            case 3:
                [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"SampleButton3.png"]]];
                break;
                
            default:
                break;
        }
        
        
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

    [delegate startPlayback:buttonID];
    touchDownCount++;
    touchMovedStatus = NO;
    
//    NSLog(@"Touch Began: %d", buttonID);
//    NSLog(@"%d Move: %d, Count: %d", buttonID, touchMovedStatus, touchDownCount);
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {

    CGPoint touchPoint = [[touches anyObject] locationInView:self];
    
    if ([self pointInside:touchPoint withEvent:event]) {
        // Point inside
        touchMovedStatus = NO;
    }else {
        // Point isn't inside
        touchMovedStatus = YES;
    }
    
//    NSLog(@"%d Move: %d, Count: %d", buttonID, touchMovedStatus, touchDownCount);
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    touchDownCount--;
    
    if (touchDownCount <= 0) {
        if (touchMovedStatus == NO) {
            [delegate stopPlayback:buttonID];
        }
        
        touchDownCount = 0;
    }
    
//    NSLog(@"%d Move: %d, Count: %d", buttonID, touchMovedStatus, touchDownCount);
}



- (void)startPlayback:(int)sampleID {
    
}

- (void)stopPlayback:(int)sampleID {
    
}


@end
