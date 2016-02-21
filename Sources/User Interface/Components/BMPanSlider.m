//
//  BMPanSlider.m
//  BeMotion
//
//  Created by Govinda Pingali on 2/17/16.
//  Copyright © 2016 Plasmatio Tech. All rights reserved.
//

#import "BMPanSlider.h"
#import "UIFont+Additions.h"
#import <QuartzCore/QuartzCore.h>

#define BOUND(VALUE, UPPER, LOWER)	MIN(MAX(VALUE, LOWER), UPPER)

static const float kMaximumValue = 1.0f;
static const float kMinimumValue = 0.0f;
static const float kCenterWidth  = 5.0f;

@interface BMPanSlider()
{
    CALayer*            _onTrackLayer;
    CALayer*            _centerLayer;
    CAShapeLayer*       _borderLayer;
    
    UILabel*            _leftLabel;
    UILabel*            _rightLabel;
    UILabel*            _centerLabel;
    
    CGPoint             _previousPoint;
}
@end


@implementation BMPanSlider

- (id)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        _value = kMaximumValue / 2.0f;
        
        _onTrackColor = [UIColor colorWithWhite:0.4f alpha:1.0f];
        
        CALayer* offTrackLayer = [CALayer layer];
        [offTrackLayer setBackgroundColor:[UIColor colorWithWhite:0.0f alpha:0.5f].CGColor];
        [offTrackLayer setFrame:CGRectMake(0.0f, 0.0f, frame.size.width, frame.size.height)];
        [self.layer addSublayer:offTrackLayer];
        
        _centerLayer = [CALayer layer];
        [_centerLayer setBackgroundColor:_onTrackColor.CGColor];
        [_centerLayer setFrame:CGRectMake((frame.size.width - kCenterWidth) / 2.0f, 0.0f, kCenterWidth, frame.size.height)];
        [self.layer addSublayer:_centerLayer];
        
        _onTrackLayer = [CALayer layer];
        [_onTrackLayer setBackgroundColor:_onTrackColor.CGColor];
        [self.layer addSublayer:_onTrackLayer];
        
        CGMutablePathRef borderPath = CGPathCreateMutable();
        CGPathAddRect(borderPath, nil, CGRectMake(0.0f, 0.0f, frame.size.width, frame.size.height));
        
        _borderLayer = [CAShapeLayer layer];
        [_borderLayer setPath:borderPath];
        [_borderLayer setStrokeColor:[UIColor blackColor].CGColor];
        [_borderLayer setFillColor:[UIColor clearColor].CGColor];
        [_borderLayer setLineWidth:1.0f];
        [self.layer addSublayer:_borderLayer];
        
        
        CGAffineTransform transform = CGAffineTransformMakeRotation(-M_PI * 0.5f);
        
        _leftLabel = [[UILabel alloc] init];
        [_leftLabel setFont:[UIFont semiboldDefaultFontOfSize:10.0f]];
        [_leftLabel setTextColor:[UIColor colorWithWhite:1.0f alpha:0.5f]];
        [_leftLabel setText:@"Left"];
        [_leftLabel setTextAlignment:NSTextAlignmentCenter];
        [_leftLabel setTransform:transform];;
        [self addSubview:_leftLabel];
        
        _rightLabel = [[UILabel alloc] init];
        [_rightLabel setFont:[UIFont semiboldDefaultFontOfSize:10.0f]];
        [_rightLabel setTextColor:[UIColor colorWithWhite:1.0f alpha:0.5f]];
        [_rightLabel setText:@"Right"];
        [_rightLabel setTextAlignment:NSTextAlignmentCenter];
        [_rightLabel setTransform:transform];
        [self addSubview:_rightLabel];
        
        _centerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, frame.size.width, frame.size.height)];
        [_centerLabel setBackgroundColor:[UIColor clearColor]];
        [_centerLabel setFont:[UIFont semiboldDefaultFontOfSize:12.0f]];
        [_centerLabel setTextColor:[UIColor colorWithWhite:1.0f alpha:0.5f]];
        [_centerLabel setTextAlignment:NSTextAlignmentCenter];
        [_centerLabel setText:@"Pan"];
        [self addSubview:_centerLabel];
        
        
        [self setLayerFrames];
        
        [self setBackgroundColor:[UIColor clearColor]];
    }
    
    return self;
}


#pragma mark - Public Methods

- (void)setValue:(CGFloat)value {
    _value = value;
    _value = BOUND(_value, kMaximumValue, kMinimumValue);
    [self setLayerFrames];
}

- (void)setOnTrackColor:(UIColor *)onTrackColor {
    _onTrackColor = onTrackColor;
    [_onTrackLayer setBackgroundColor:_onTrackColor.CGColor];
    [_centerLayer setBackgroundColor:_onTrackColor.CGColor];
    [_borderLayer setStrokeColor:_onTrackColor.CGColor];
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
    
    float valueDelta = (kMaximumValue - kMinimumValue) * delta;
    
    _previousPoint = touchPoint;
    
    _value += valueDelta;
    _value = BOUND(_value, kMaximumValue, kMinimumValue);
    
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES] ;
    [self setLayerFrames];
    [CATransaction commit];
    
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    
    return YES;
}

-(void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    
}


- (void)layoutSubviews {
    [_leftLabel setFrame:CGRectMake(0.0f, 0.0f, 20.0f, self.frame.size.height)];
    [_rightLabel setFrame:CGRectMake(self.frame.size.width - 20.0f, 0.0f, 20.0f, self.frame.size.height)];
}


#pragma mark - Private Methods

- (void)setLayerFrames {
    
    float scaledValue = (_value - kMinimumValue) / (kMaximumValue - kMinimumValue);
    CGFloat sliderX = self.bounds.size.width * (scaledValue - (kMaximumValue / 2.0f));
    
    [_onTrackLayer setFrame:CGRectMake(self.bounds.size.width/2.0f, 0.0f, sliderX, self.bounds.size.height)];
    
    [_onTrackLayer setNeedsDisplay];
}



@end
