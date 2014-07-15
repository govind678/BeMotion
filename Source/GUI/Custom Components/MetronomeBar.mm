//
//  MetronomeBar.m
//  BeMotion
//
//  Created by Govinda Ram Pingali on 6/26/14.
//  Copyright (c) 2014 BeMotionLLC. All rights reserved.
//

#import "MetronomeBar.h"

@implementation MetronomeBar

@synthesize metroBars;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        metroBars = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < GUI_METRO_COUNT; i++) {
            float xPos = i * 36.0f;
            CGRect sq = CGRectMake(xPos, 0.0f, 28.0f, 5.0f);
            UIView* bar = [[UIView alloc] initWithFrame:sq];
            [bar setBackgroundColor:[UIColor colorWithRed:0.75f green:0.75f blue:0.75f alpha:0.75f]];
            [bar setAlpha:BUTTON_OFF_ALPHA];
            [self addSubview:bar];
            [metroBars addObject:bar];
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


- (void) beat:(int)count {
    
    for (int i = 0; i < count; i++) {
        [[metroBars objectAtIndex:i] setAlpha:1.0f];
    }
    
    for (int i = count; i < GUI_METRO_COUNT; i++) {
        [[metroBars objectAtIndex:i] setAlpha:BUTTON_OFF_ALPHA];
    }
}


- (void) turnOff {
    
    for (int i=0; i < GUI_METRO_COUNT; i++) {
        [[metroBars objectAtIndex:i] setAlpha:BUTTON_OFF_ALPHA];
    }
}



- (void) dealloc {
    
    [metroBars release];
    
    [super dealloc];
}

@end
