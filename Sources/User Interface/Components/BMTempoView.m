//
//  BMTempoView.m
//  BeMotion
//
//  Created by Govinda Pingali on 2/21/16.
//  Copyright © 2016 Plasmatio Tech. All rights reserved.
//

#import "BMTempoView.h"
#import <QuartzCore/QuartzCore.h>

static const int kDefaultMeter = 8;
static const float kMargin = 5.0f;

@interface BMTempoView()
{
    NSMutableArray*     _steps;
    CALayer*           _animatedLayer;
}

@end

@implementation BMTempoView

- (id)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        _steps = [[NSMutableArray alloc] init];
        [self setMeter:kDefaultMeter];
        [self setBackgroundColor:[UIColor clearColor]];
        _timeDuration = 0.5f;
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
        
        if (i == 0) {
            _animatedLayer = [[CALayer alloc] initWithLayer:layer];
            [_animatedLayer setBackgroundColor:[UIColor colorWithWhite:1.0f alpha:0.5f].CGColor];
            [_animatedLayer setHidden:YES];
            [self.layer addSublayer:_animatedLayer];
        }
        
        [self.layer addSublayer:layer];
    }
    
}

- (void)tick:(int)count {
    
    for (int i=0; i < _steps.count; i++) {
        
        CALayer* layer = (CALayer*)[_steps objectAtIndex:i];
        
        if (i == count) {
            if (i == 0) {
                [self animateLayer:layer];
            }
            [layer setBackgroundColor:[UIColor colorWithWhite:1.0f alpha:0.5f].CGColor];
        }
        
        else {
            [layer setBackgroundColor:[UIColor colorWithWhite:0.0f alpha:0.5f].CGColor];
        }
    }
}

//- (void)animateLayer:(CALayer*)layer {
//    CGRect originalFrame = layer.frame;
//    CGRect newFrame = CGRectInset(originalFrame, -4.0f, -3.0f);
//
//    [CATransaction begin];
//    [CATransaction setAnimationDuration:(_timeDuration * 0.5f)];
//    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
//    [CATransaction setCompletionBlock:^{
//        [CATransaction begin];
//        [CATransaction setAnimationDuration:(_timeDuration * 0.5f)];
//        [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
//        layer.frame = originalFrame;
//        [CATransaction commit];
//    }];
//    layer.frame = newFrame;
//    [CATransaction commit];
//}

- (void)animateLayer:(CALayer*)layer {
    
    CGRect fromFrame = layer.frame;
    CGRect toFrame = CGRectInset(fromFrame, -16.0f, -12.0f);
    
    [_animatedLayer setHidden:NO];
    
    [CATransaction begin];
    [CATransaction setAnimationDuration:_timeDuration];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [CATransaction setCompletionBlock:^{
        [_animatedLayer setFrame:fromFrame];
        [_animatedLayer setBackgroundColor:[UIColor colorWithWhite:1.0f alpha:0.5f].CGColor];
        [_animatedLayer setHidden:YES];
    }];
    [_animatedLayer setFrame:toFrame];
    [_animatedLayer setBackgroundColor:[UIColor colorWithWhite:1.0f alpha:0.0f].CGColor];
    [CATransaction commit];
}
@end
