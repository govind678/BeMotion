//
//  PlayButton.m
//  SampleButton
//
//  Created by Govinda Ram Pingali on 7/6/14.
//  Copyright (c) 2014 BeMotionLLC. All rights reserved.
//

#import "PlayButton.h"

@implementation PlayButton

@synthesize buttonID;

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
//    NSLog(@"Touch Began: %d", buttonID);
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    CGPoint touchPoint = [[touches anyObject] locationInView:self];
    
    if ([self pointInside:touchPoint withEvent:event]) {
        // Point inside
//        NSLog(@"Move Inside: %d", buttonID);
    }else {
        // Point isn't inside
//        NSLog(@"Move Outside: %d", buttonID);
    }
    
    
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
//    NSLog(@"Touch Ended: %d", buttonID);
}


@end
