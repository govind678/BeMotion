//
//  BMPlayButton.m
//  BeMotion
//
//  Created by Govinda Pingali on 2/15/16.
//  Copyright © 2016 Plasmatio Tech. All rights reserved.
//

#import "BMPlayButton.h"
#import "BMAudioController.h"
#import "BMWaveformView.h"
#import "BMSequencer.h"
#import <QuartzCore/QuartzCore.h>

static NSString* const kOverlayImage                = @"SampleButtonOverlay.png";
static NSString* const kBackgroundImagePrefix       = @"SampleButton";
static NSString* const kHitImagePrefix              = @"SampleButtonHit";

static float const kHitAnimationTime                = 0.1f;
static float const kProgressViewWidth               = 5.0f;

@interface BMPlayButton()
{
    UIView*             _overlay;
    UIView*             _hit;
//    BMWaveformView*     _waveformView;
    
    UIView*             _progress;
    CGRect              _progressRect;
    
    int                 _touchDownCount;
    BOOL                _touchMovedStatus;
    
    BOOL                _awaitingStart;
    BOOL                _awaitingStop;
    int                 _triggerCount;
}
@end


@implementation BMPlayButton

- (id)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        _overlay = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, frame.size.width, frame.size.height)];
        [_overlay setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:kOverlayImage]]];
        [_overlay setUserInteractionEnabled:NO];
        [_overlay setHidden:YES];
        [self addSubview:_overlay];
        
        _hit = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, frame.size.width, frame.size.height)];
        [_hit setUserInteractionEnabled:NO];
        [_hit setAlpha:0.0f];
        [self addSubview:_hit];
        
//        _waveformView = [[BMWaveformView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, frame.size.width, frame.size.height)];
//        [self addSubview:_waveformView];
        
        _progressRect = CGRectMake(0.0f, 0.0f, kProgressViewWidth, frame.size.height);
        _progress = [[UIView alloc] initWithFrame:_progressRect];
        [_progress setUserInteractionEnabled:NO];
        [_progress setBackgroundColor:[UIColor colorWithWhite:0.0f alpha:0.5f]];
        [_progress setHidden:YES];
        [self addSubview:_progress];
        
        _awaitingStart = NO;
        _awaitingStop = NO;
        _triggerCount = 0;
        
        [self setMultipleTouchEnabled:YES];
    }
    
    return self;
}

#pragma mark - Public Methods

- (void)setTrackID:(int)trackID {
    
    _trackID = trackID;
    
    NSString* backgroundImageName = [NSString stringWithFormat:@"%@%d.png", kBackgroundImagePrefix, trackID];
    [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:backgroundImageName]]];
    
    NSString* hitImageName = [NSString stringWithFormat:@"%@%d.png", kHitImagePrefix, trackID];
    [_hit setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:hitImageName]]];
    
//    [_waveformView setTrackID:trackID];
}

- (void)reloadWaveform {
//    [_waveformView reloadWaveform];
}

- (void)tick:(int)count {
    
    if (count == _triggerCount) {
        
        if (_awaitingStart) {
            [[BMAudioController sharedController] startPlaybackOfTrack:_trackID];
            
            [_overlay setHidden:NO];
            [self startPlaybackProgress];
            [self pulseHit];
            _awaitingStart = NO;
        }
        
        if (_awaitingStop) {
            [[BMAudioController sharedController] stopPlaybackOfTrack:_trackID];
            
            [_overlay setHidden:YES];
            [self stopPlaybackProgress];
            _awaitingStop = NO;
        }
    }
    
    if ((_awaitingStart) || (_awaitingStop)) {
        [self pulseHit];
    }
    
}

- (void)reset {
    [_overlay setHidden:YES];
    [self stopPlaybackProgress];
}

- (void)updatePlaybackProgress:(float)timeInterval {
    
    _progressRect.origin.x = self.frame.size.width * [[BMAudioController sharedController] getNormalizedPlaybackProgress:_trackID];
    
    [UIView animateWithDuration:timeInterval
                          delay:0.0f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         [_progress setFrame:_progressRect];
                     } completion:^(BOOL finished) {}];
}


#pragma mark - Touch Events

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if ([[BMSequencer sharedSequencer] isClockRunning] && [[BMSequencer sharedSequencer] quantization]) {
        [self sequenceStartOnNextClock];
    } else {
        [[BMAudioController sharedController] startPlaybackOfTrack:_trackID];
        [_overlay setHidden:NO];
        [self startPlaybackProgress];
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
            
            if ([[BMSequencer sharedSequencer] isClockRunning] && [[BMSequencer sharedSequencer] quantization]) {
                [self sequenceStopOnNextClock];
            } else {
                [[BMAudioController sharedController] stopPlaybackOfTrack:_trackID];
                
                [_overlay setHidden:YES];
                [self stopPlaybackProgress];
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
    _triggerCount = 0;
    _awaitingStart = YES;
}

- (void)sequenceStopOnNextClock {
    
    _triggerCount = 0;
    
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

- (void)startPlaybackProgress {
    [_progress.layer removeAllAnimations];
    _progressRect.origin.x = 0.0f;
    [_progress setFrame:_progressRect];
    [_progress setHidden:NO];
}

- (void)stopPlaybackProgress {
    [_progress setHidden:YES];
    _progressRect.origin.x = 0.0f;
    [_progress setFrame:_progressRect];
    [_progress.layer removeAllAnimations];
}

@end
