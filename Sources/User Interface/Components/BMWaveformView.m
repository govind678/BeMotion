//
//  BMWaveformView.m
//  BeMotion
//
//  Created by Govinda Pingali on 2/18/16.
//  Copyright © 2016 Plasmatio Tech. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "BMWaveformView.h"
#import "BMConstants.h"
#import "UIColor+Additions.h"

@interface BMWaveformView()
{
    const float*      _samples;
}

@end

@implementation BMWaveformView

- (id)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        _samples = nil;
        [self setBackgroundColor:[UIColor clearColor]];
        [self setUserInteractionEnabled:NO];
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    if (_samples == nil) {
        return;
    }
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGFloat xPos = 0.0f;
    CGFloat width = rect.size.width / kNumWaveformSamples;

    for (int i=0; i < kNumWaveformSamples; i++) {
        CGFloat height = (rect.size.height * _samples[i]) * 0.7071;
        CGPathAddRect(path, nil, CGRectMake(xPos, rect.size.height/2.0f, width, height));
        CGPathAddRect(path, nil, CGRectMake(xPos, (rect.size.height/2.0f) - height, width, height));
        xPos += width;
    }

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor colorWithWhite:0.0f alpha:0.2f].CGColor);
    CGContextAddPath(context, path);
    CGContextFillPath(context);

    CGPathRelease(path);
}

#pragma mark - Public Methods

- (void)drawWaveform:(const float*)samples {
    _samples = samples;
    [self setNeedsDisplay];
}

@end
