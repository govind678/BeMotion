//
//  SettingsButton.m
//  SampleButton
//
//  Created by Govinda Ram Pingali on 7/6/14.
//  Copyright (c) 2014 BeMotionLLC. All rights reserved.
//

#import "SettingsButton.h"

@implementation SettingsButton

@synthesize buttonID;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        // Initialization code
        
        switch (buttonID) {
            case 0:
                [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"SettingsButton0.png"]]];
                break;
                
            case 1:
                [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"SettingsButton1.png"]]];
                break;
                
            case 2:
                [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"SettingsButton2.png"]]];
                break;
                
            case 3:
                [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"SettingsButton3.png"]]];
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

@end
