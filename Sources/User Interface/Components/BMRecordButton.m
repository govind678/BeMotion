//
//  BMRecordButton.m
//  BeMotion
//
//  Created by Govinda Pingali on 2/24/16.
//  Copyright © 2016 Plasmatio Tech. All rights reserved.
//

#import "BMRecordButton.h"
#import "BMAudioController.h"
#import "BMSequencer.h"
#import "UIColor+Additions.h"
#import "UIFont+Additions.h"

static NSString* const kBackgroundImage             = @"MicRecord-Normal.png";
static NSString* const kOverlayImage                = @"MicRecord-Overlay.png";
static NSString* const kHitImage                    = @"MicRecord-Hit.png";

static float const kHitAnimationTime                = 0.05f;

@interface BMRecordButton()
{
    UIView*             _overlay;
    UIView*             _hit;
    
    int                 _touchDownCount;
    BOOL                _touchMovedStatus;
    
    BOOL                _awaitingStart;
    BOOL                _awaitingStop;
    int                 _triggerCount;
}
@end


@implementation BMRecordButton


- (id)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        _overlay = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, frame.size.width, frame.size.height)];
        [_overlay setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:kOverlayImage]]];
        [_overlay setUserInteractionEnabled:NO];
        [_overlay setHidden:YES];
        [self addSubview:_overlay];
        
        UILabel* recordingLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.0f, 5.0f, frame.size.width, 20.0f)];
        [recordingLabel setTextColor:[UIColor blackColor]];
        [recordingLabel setFont:[UIFont lightDefaultFontOfSize:10.0f]];
        [recordingLabel setTextAlignment:NSTextAlignmentLeft];
        [recordingLabel setText:@"Recording..."];
        [_overlay addSubview:recordingLabel];
        
        _hit = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, frame.size.width, frame.size.height)];
        [_hit setUserInteractionEnabled:NO];
        [_hit setAlpha:0.0f];
        [_hit setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:kHitImage]]];
        [self addSubview:_hit];
        
        _awaitingStart = NO;
        _awaitingStop = NO;
        _triggerCount = 0;
        
        [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:kBackgroundImage]]];
    }
    
    return self;
}


#pragma mark - Public Methods

- (void)tick:(int)count {
    
    if (count == _triggerCount) {
        
        if (_awaitingStart) {
            [[BMAudioController sharedController] startRecordingAtTrack:_trackID];
            [_overlay setHidden:NO];
            [self pulseHit];
            _awaitingStart = NO;
        }
        
        if (_awaitingStop) {
            [[BMAudioController sharedController] stopRecordingAtTrack:_trackID];
            [_overlay setHidden:YES];
            _awaitingStop = NO;
        }
    }
    
    if ((_awaitingStart) || (_awaitingStop)) {
        [self pulseHit];
    }
    
}


#pragma mark - Touch Events

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if ([[BMSequencer sharedSequencer] isClockRunning]) {
        [self sequenceStartOnNextClock];
    } else {
        [[BMAudioController sharedController] startRecordingAtTrack:_trackID];
        [_overlay setHidden:NO];
        [self hit];
    }
    
    _touchDownCount++;
    _touchMovedStatus = NO;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    CGPoint touchPoint = [[touches anyObject] locationInView:self];
    
    if ([self pointInside:touchPoint withEvent:event]) {
        // Point inside
        _touchMovedStatus = NO;
    } else {
        // Point isn't inside
        _touchMovedStatus = YES;
    }
    
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    _touchDownCount--;
    
    if (_touchDownCount <= 0) {
        
        if (_touchMovedStatus == NO) {
            
            if ([[BMSequencer sharedSequencer] isClockRunning]) {
                [self sequenceStopOnNextClock];
            } else {
                [[BMAudioController sharedController] stopRecordingAtTrack:_trackID];
                [_overlay setHidden:YES];
            }
        }
        
        _touchDownCount = 0;
    }
}


#pragma mark - Private Methods

- (void)hit {
    [_hit setAlpha:1.0f];
    [UIView animateWithDuration:kHitAnimationTime animations:^{
        [_hit setAlpha:0.0f];
    }];
}

- (void)pulseHit {
    float timeInterval = [[BMSequencer sharedSequencer] timeInterval] / 2.0f;
    [_hit setAlpha:1.0f];
    [UIView animateWithDuration:timeInterval animations:^{
        [_hit setAlpha:0.0f];
    }];
}

- (void)sequenceStartOnNextClock {
    int next = (int)[[BMSequencer sharedSequencer] nextTriggerCount];
    _triggerCount = next;
    _awaitingStart = YES;
}

- (void)sequenceStopOnNextClock {
    int next = (int)[[BMSequencer sharedSequencer] nextTriggerCount];
    _triggerCount = next;
    
    if ([_overlay isHidden]) {
        if (_awaitingStart) {
            _awaitingStart = NO;
        } else {
            _awaitingStop = YES;
        }
    } else {
        _awaitingStop = YES;
    }

}


@end
