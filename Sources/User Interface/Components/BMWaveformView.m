//
//  BMWaveformView.m
//  BeMotion
//
//  Created by Govinda Pingali on 2/18/16.
//  Copyright © 2016 Plasmatio Tech. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "BMWaveformView.h"
#import "BMAudioController.h"
#import "UIColor+Additions.h"

@interface BMWaveformView()
{
    
}

@end

@implementation BMWaveformView

- (id)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self setBackgroundColor:[UIColor clearColor]];
        [self setUserInteractionEnabled:NO];
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    CGPathRef halfPath = [self pathFromSamples];
    
    CGMutablePathRef path = CGPathCreateMutable();

    CGFloat halfHeight = self.frame.size.height / 2.0f;

    CGAffineTransform xf = CGAffineTransformIdentity;
    xf = CGAffineTransformTranslate(xf, 0.0, halfHeight);
    xf = CGAffineTransformScale( xf, 1.0, halfHeight);

    CGPathAddPath(path, &xf, halfPath);


//    xf = CGAffineTransformIdentity;
//    xf = CGAffineTransformTranslate(xf, 0.0, halfHeight);
//    xf = CGAffineTransformScale(xf, 1.0, -halfHeight);

//    CGPathAddPath(path, &xf, halfPath);
    CGPathAddRect(path, nil, CGRectMake(0.0f, halfHeight - 5.0, self.frame.size.width, 5.0f));
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor colorWithWhite:0.0f alpha:0.5f].CGColor);
    CGContextAddPath(context, path);
    CGContextFillPath(context);
}

#pragma mark - Public Methods

- (void)setTrackID:(int)trackID {
    _trackID = trackID;
}

- (void)reloadWaveform {
    [self setNeedsDisplay];
}


- (CGPathRef)pathFromSamples {
    
    float* samples = [[BMAudioController sharedController] getSamplesForWaveformAtTrack:_trackID];
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, nil, 0.0f, 0.0f);
    for (int i=0; i < 2000; i++) {
        CGPathAddLineToPoint(path, nil, i, samples[i]);
    }
    
    return path;
}

@end
