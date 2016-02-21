//
//  BMHorizontalSlider.m
//  BeMotion
//
//  Created by Govinda Pingali on 2/17/16.
//  Copyright © 2016 Plasmatio Tech. All rights reserved.
//

#import "BMHorizontalSlider.h"
#import "UIFont+Additions.h"
#import <QuartzCore/QuartzCore.h>


#define BOUND(VALUE, UPPER, LOWER)	MIN(MAX(VALUE, LOWER), UPPER)

@interface BMHorizontalSlider()
{
    CALayer*            _onTrackLayer;
    CALayer*            _offTrackLayer;
    CAShapeLayer*       _borderLayer;
    UILabel*            _centerLabel;
    CGPoint             _previousPoint;
}
@end


@implementation BMHorizontalSlider

- (id)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        _maximumValue = 1.0f;
        _minimumValue = 0.0f;
        _value = 0.0f;
        
        _onTrackColor = [UIColor colorWithWhite:0.4f alpha:1.0f];
        
        _onTrackLayer = [CALayer layer];
        [_onTrackLayer setBackgroundColor:_onTrackColor.CGColor];
        [self.layer addSublayer:_onTrackLayer];
        
        _offTrackLayer = [CALayer layer];
        [_offTrackLayer setBackgroundColor:[UIColor colorWithWhite:0.0f alpha:0.5f].CGColor];
        [self.layer addSublayer:_offTrackLayer];
        
        
        CGMutablePathRef borderPath = CGPathCreateMutable();
        CGPathAddRect(borderPath, nil, CGRectMake(0.0f, 0.0f, frame.size.width, frame.size.height));
        
        _borderLayer = [CAShapeLayer layer];
        [_borderLayer setPath:borderPath];
        [_borderLayer setStrokeColor:[UIColor blackColor].CGColor];
        [_borderLayer setFillColor:[UIColor clearColor].CGColor];
        [_borderLayer setLineWidth:1.0f];
        [self.layer addSublayer:_borderLayer];
        
        _centerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, frame.size.width, frame.size.height)];
        [_centerLabel setBackgroundColor:[UIColor clearColor]];
        [_centerLabel setFont:[UIFont semiboldDefaultFontOfSize:12.0f]];
        [_centerLabel setTextColor:[UIColor colorWithWhite:1.0f alpha:0.5f]];
        [_centerLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:_centerLabel];
        
        
        [self setLayerFrames];
        
        [self setBackgroundColor:[UIColor clearColor]];
    }
    
    return self;
}


#pragma mark - Public Methods

- (void)setValue:(CGFloat)value {
    _value = value;
    _value = BOUND(_value, _maximumValue, _minimumValue);
    [self setLayerFrames];
}

- (void)setOnTrackColor:(UIColor *)onTrackColor {
    _onTrackColor = onTrackColor;
    [_onTrackLayer setBackgroundColor:_onTrackColor.CGColor];
    [_borderLayer setStrokeColor:_onTrackColor.CGColor];
}

- (void)setCenterText:(NSString *)centerText {
    _centerText = centerText;
    [_centerLabel setText:centerText];
}


#pragma mark - UIControl Methods

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    
    _previousPoint = [touch locationInView:self];
    
//    if (CGRectContainsPoint(_knobLayer.frame, _previousPoint)) {
//        //[_knobLayer setNeedsDisplay];
//        return YES;
//    }
    return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    
    CGPoint touchPoint = [touch locationInView:self];
    
    float delta = (touchPoint.x - _previousPoint.x) / self.bounds.size.width;
    
    float valueDelta = (_maximumValue - _minimumValue) * delta;
    
    _previousPoint = touchPoint;
    
    _value += valueDelta;
    _value = BOUND(_value, _maximumValue, _minimumValue);
    
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES] ;
    [self setLayerFrames];
    [CATransaction commit];
    
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    
    return YES;
}

-(void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    
}


#pragma mark - Private Methods

- (void)setLayerFrames {
    
    float scaledValue = (_value - _minimumValue) / (_maximumValue - _minimumValue);
    CGFloat sliderX = self.bounds.size.width * scaledValue;
    
    [_onTrackLayer setFrame:CGRectMake(0.0f, 0.0f, sliderX, self.bounds.size.height)];
    [_offTrackLayer setFrame:CGRectMake(sliderX, 0.0f, self.bounds.size.width - sliderX, self.bounds.size.height)];
    
    [_onTrackLayer setNeedsDisplay];
    [_offTrackLayer setNeedsDisplay];
}

@end
