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

static NSString* const kOverlayImage                = @"SampleButtonOverlay.png";
static NSString* const kBackgroundImagePrefix       = @"SampleButton";
static NSString* const kHitImagePrefix              = @"SampleButtonHit";

static float const kHitAnimationTime                = 0.1f;
static float const kProgressViewWidth               = 5.0f;
static float const kProgressTimeInterval            = 0.01f;

@interface BMPlayButton()
{
    UIView*             _overlay;
    UIView*             _hit;
//    BMWaveformView*     _waveformView;
    
    UIView*             _progress;
    CGRect              _progressRect;
    
    int                 _touchDownCount;
    BOOL                _touchMovedStatus;
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

- (void)updatePlaybackProgress {
    
    if (![_progress isHidden]) {
        
        float progress = [[BMAudioController sharedController] getNormalizedPlaybackProgress:_trackID];
        _progressRect.origin.x = progress * self.frame.size.width;
        
        [UIView animateWithDuration:kProgressTimeInterval animations:^{
            [_progress setFrame:_progressRect];
        }];
    }
}

- (void)reloadWaveform {
//    [_waveformView reloadWaveform];
}

#pragma mark - Touch Events

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [[BMAudioController sharedController] startPlaybackOfTrack:_trackID];
    
    [_overlay setHidden:NO];
    [_progress setHidden:NO];
    
    [_hit setAlpha:kHitAnimationTime];
    [UIView animateWithDuration:0.1f animations:^{
        [_hit setAlpha:0.0f];
    }];
    
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
            
            [[BMAudioController sharedController] stopPlaybackOfTrack:_trackID];
            
            [_overlay setHidden:YES];
            
            [_progress setHidden:YES];
            _progressRect.origin.x = 0.0f;
            [_progress setFrame:_progressRect];
        }
        
        
        _touchDownCount = 0;
    }
}

@end
