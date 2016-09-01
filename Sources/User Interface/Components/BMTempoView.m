//
//  BMTempoView.m
//  BeMotion
//
//  Created by Govinda Pingali on 2/21/16.
//  Copyright © 2016 Plasmatio Tech. All rights reserved.
//

#import "BMTempoView.h"

static const int kDefaultMeter = 8;
static const float kMargin = 5.0f;

@interface BMTempoView()
{
    NSMutableArray*     _steps;
}

@end

@implementation BMTempoView

- (id)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        _steps = [[NSMutableArray alloc] init];
        [self setMeter:kDefaultMeter];
        
        [self setBackgroundColor:[UIColor clearColor]];
    }
    
    return self;
}

- (void)setMeter:(int)meter {
    
    _meter = meter;
    
    for (CALayer* layer in _steps) {
        [layer removeFromSuperlayer];
    }
    [_steps removeAllObjects];
    
    
    
    float stepWidth = (self.frame.size.width - ((meter - 1) * kMargin)) / meter;
    
    for (int i=0; i < meter; i++) {
        
        float xPos = i * (stepWidth + kMargin);
        
        CALayer* layer = [CALayer layer];
        [layer setFrame:CGRectMake(xPos, 0.0f, stepWidth, self.frame.size.height)];
        [layer setBackgroundColor:[UIColor colorWithWhite:0.0f alpha:0.5f].CGColor];
        [_steps addObject:layer];
        [self.layer addSublayer:layer];
    }
    
}

- (void)tick:(int)count {
    
    for (int i=0; i < _steps.count; i++) {
        
        CALayer* layer = (CALayer*)[_steps objectAtIndex:i];
        
        if (i == count) {
            [layer setBackgroundColor:[UIColor colorWithWhite:1.0f alpha:0.5f].CGColor];
        } else {
            [layer setBackgroundColor:[UIColor colorWithWhite:0.0f alpha:0.5f].CGColor];
        }
    }
}

@end
