//
//  BMSampleButton.m
//  BeMotion
//
//  Created by Govinda Ram Pingali on 9/26/17.
//  Copyright © 2017 Plasmatio Tech. All rights reserved.
//

#import "BMSampleButton.h"
#import "BMAudioController.h"
#import "BMSequencer.h"
#import "BMWaveformView.h"
#import "BMHorizontalSlider.h"
#import "BMPanSlider.h"
#import "UIColor+Additions.h"
#import "UIFont+Additions.h"
#import <QuartzCore/QuartzCore.h>


static NSString* const kBackgroundImagePrefix       = @"SampleButton-";
static NSString* const kOverlayImage                = @"SampleButton-Overlay.png";
static NSString* const kHitImage                    = @"SampleButton-Hit.png";
static NSString* const kMicRecordImage              = @"Sample-Option-MicRecord.png";
static NSString* const kFxImage                     = @"Sample-Option-Fx.png";
static NSString* const kImportImage                 = @"Sample-Option-Import.png";

static float const kHitAnimationTime                = 0.1f;
static float const kToggleDisplayAnimationTime      = 0.1f;
static float const kProgressViewWidth               = 4.0f;

@interface BMSampleButton()
{
    UIView*                 _overlay;
    UIView*                 _hit;
    UIView*                 _disable;
    
    UIView*                 _progress;
    CGRect                  _progressRect;
    
    UIView*                 _micRecordingView;
    UIView*                 _fxLaunchView;
    UIView*                 _loadSampleView;
    
    UILabel*                _titleLabel;
    UILabel*                _recordingLabel;
    UILabel*                _countdownLabel;
    
    BMHorizontalSlider*      _gainSlider;
    BMPanSlider*            _panSlider;
    
    BMWaveformView*         _waveformView;
    
    int                     _touchDownCount;
    BOOL                    _touchMovedStatus;
    
    BOOL                    _awaitingStart;
    BOOL                    _awaitingStop;
    
    BOOL                    _isRecording;
}
@end


@implementation BMSampleButton

- (id)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        float width = frame.size.width;
        float height = frame.size.height;
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(4.0f, height - 17.0f, 140.0f, 15.0f)];
        [_titleLabel setTextColor:[UIColor colorWithWhite:0.0f alpha:1.0f]];
        [_titleLabel setFont:[UIFont lightDefaultFontOfSize:9.0f]];
        [_titleLabel setTextAlignment:NSTextAlignmentLeft];
        [_titleLabel setText:@"<name>"];
        [_titleLabel setUserInteractionEnabled:NO];
        [self addSubview:_titleLabel];
        
        _overlay = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, width, height)];
        [_overlay setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:kOverlayImage]]];
        [_overlay setUserInteractionEnabled:NO];
        [_overlay setHidden:YES];
        [self addSubview:_overlay];
        
        _hit = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, width, height)];
        [_hit setUserInteractionEnabled:NO];
        [_hit setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:kHitImage]]];
        [_hit setAlpha:0.0f];
        [self addSubview:_hit];
        
        _waveformView = [[BMWaveformView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, frame.size.width, frame.size.height)];
        [self addSubview:_waveformView];

        _progressRect = CGRectMake(0.0f, 0.0f, kProgressViewWidth, height);
        _progress = [[UIView alloc] initWithFrame:_progressRect];
        [_progress setUserInteractionEnabled:NO];
        [_progress setBackgroundColor:[UIColor colorWithWhite:0.0f alpha:0.5f]];
        [_progress setHidden:YES];
        [self addSubview:_progress];
        
        _disable = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, width, height)];
        [_disable setBackgroundColor:[UIColor colorWithWhite:0.28f alpha:0.8f]];
        [_disable setUserInteractionEnabled:NO];
        [_disable setAlpha:0.0f];
        [self addSubview:_disable];
        
        _gainSlider = [[BMHorizontalSlider alloc] initWithFrame:CGRectMake(0.0f, 0.0f, width, (height / 2.0f) - 5.0f)];
        [_gainSlider addTarget:self action:@selector(gainSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        [_gainSlider setAlpha:0.0f];
        [_gainSlider setCenterText:@"Level"];
        [self addSubview:_gainSlider];
        
        _panSlider = [[BMPanSlider alloc] initWithFrame:CGRectMake(0.0f, (height / 2.0f) + 5.0f, width, (height / 2.0f) - 5.0f)];
        [_panSlider addTarget:self action:@selector(panSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        [_panSlider setAlpha:0.0f];
        [self addSubview:_panSlider];
        
        _recordingLabel = [[UILabel alloc] initWithFrame:CGRectMake(3.0f, 3.0f, 60.0f, 15.0f)];
        [_recordingLabel setTextColor:[UIColor colorWithWhite:0.0f alpha:1.0f]];
        [_recordingLabel setFont:[UIFont lightDefaultFontOfSize:10.0f]];
        [_recordingLabel setTextAlignment:NSTextAlignmentLeft];
        [_recordingLabel setText:@"Recording..."];
        [_recordingLabel setUserInteractionEnabled:NO];
        [_recordingLabel setHidden:YES];
        [self addSubview:_recordingLabel];
        
        _countdownLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width - 30.0f, 10.0f, 20.0f, 15.0f)];
        [_countdownLabel setTextColor:[UIColor colorWithWhite:0.0f alpha:1.0f]];
        [_countdownLabel setFont:[UIFont lightDefaultFontOfSize:12.0f]];
        [_countdownLabel setTextAlignment:NSTextAlignmentCenter];
        [_countdownLabel setText:@"0"];
        [_countdownLabel setUserInteractionEnabled:NO];
        [_countdownLabel setAlpha:0.0f];
        [self addSubview:_countdownLabel];
        
        _micRecordingView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, width, height)];
        [_micRecordingView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:kMicRecordImage]]];
        [_micRecordingView setUserInteractionEnabled:NO];
        [_micRecordingView setAlpha:0.0f];
        [self addSubview:_micRecordingView];
        
        _fxLaunchView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, width, height)];
        [_fxLaunchView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:kFxImage]]];
        [_fxLaunchView setUserInteractionEnabled:NO];
        [_fxLaunchView setAlpha:0.0f];
        [self addSubview:_fxLaunchView];
        
        _loadSampleView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, width, height)];
        [_loadSampleView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:kImportImage]]];
        [_loadSampleView setUserInteractionEnabled:NO];
        [_loadSampleView setAlpha:0.0f];
        [self addSubview:_loadSampleView];
        
        
        _awaitingStart = NO;
        _awaitingStop = NO;
        _isRecording = NO;
        _currentMode = 0;
        
        [self setMultipleTouchEnabled:YES];
    }
    
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


#pragma mark - Public Methods

- (void)setTrackID:(int)trackID {
    
    _trackID = trackID;
    UIColor* trackColor = (UIColor*)[[UIColor trackColors] objectAtIndex:_trackID];
    
    NSString* backgroundImageName = [NSString stringWithFormat:@"%@%d.png", kBackgroundImagePrefix, trackID];
    [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:backgroundImageName]]];
    
    [_gainSlider setOnTrackColor:trackColor];
    [_panSlider setOnTrackColor:trackColor];
}

- (void)setCurrentMode:(BMSampleMode)newMode {
    _currentMode = newMode;
    [self updateWithNewMode];
}

- (void)reset {
    [_overlay setHidden:YES];
    [_recordingLabel setHidden:YES];
    [_countdownLabel setHidden:YES];
    _currentMode = BMSampleMode_Playback;
    [self stopPlaybackProgress];
}


- (void)viewWillAppear {
    
    _currentMode = BMSampleMode_Playback;
    _isRecording = [[BMAudioController sharedController] isTrackRecording:_trackID];
    [self updateWithNewMode];
    
    _touchDownCount = 0;
    _awaitingStop = NO;
    _awaitingStart = NO;
    
    [_gainSlider setValue:[[BMAudioController sharedController] getGainOnTrack:_trackID]];
    [_panSlider setValue:[[BMAudioController sharedController] getPanOnTrack:_trackID]];
    
    if ([[BMAudioController sharedController] isTrackPlaying:_trackID]) {
        [self startPlaybackProgress];
        [_overlay setHidden:NO];
    } else {
        [self stopPlaybackProgress];
        [_overlay setHidden:YES];
    }
}


- (void)updatePlaybackProgress:(float)timeInterval {
    
    if (!_progress.isHidden) {
        
        _progressRect.origin.x = (self.frame.size.width - _progressRect.size.width) * [[BMAudioController sharedController] getNormalizedPlaybackProgress:_trackID];
        
        [UIView animateWithDuration:timeInterval
                              delay:0.0f
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             [_progress setFrame:_progressRect];
                         } completion:^(BOOL finished) {}];
    }
}

- (void)tick:(int)count {
    if (_awaitingStop) {
        [self stopPulse:count];
    } else if (_awaitingStart) {
        [self startPulse:count];
    }
}

- (void)updateWaveform:(BOOL)shouldDraw {
    const float* samples = shouldDraw ? [[BMAudioController sharedController] getSamplesForWaveformAtTrack:_trackID] : nil;
    [_waveformView drawWaveform:samples];
}

- (void)updateTitle {
    [_titleLabel setText:[[BMAudioController sharedController] getAudioFileNameOnTrack:_trackID]];
}

#pragma mark - Touch Events

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self performSampleStartAction];
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
            [self performSampleEndAction];
        }
        _touchDownCount = 0;
    }
}



- (void)gainSliderValueChanged:(BMHorizontalSlider*)sender {
    [[BMAudioController sharedController] setGainOnTrack:_trackID withGain:sender.value];
}

- (void)panSliderValueChanged:(BMHorizontalSlider*)sender {
    [[BMAudioController sharedController] setPanOnTrack:_trackID withPan:sender.value];
}



#pragma mark - Private Methods

- (void)performSampleStartAction {
    
    switch (_currentMode) {
            
        case BMSampleMode_Playback:
        {
            _awaitingStart = YES;
            [[BMSequencer sharedSequencer] sequenceEvent:^{
                [[BMAudioController sharedController] startPlaybackOfTrack:_trackID];
                [self startPlaybackProgress];
            } withCompletion:^{
                _awaitingStart = NO;
            }];
            [_overlay setHidden:NO];
            [self hit];
        }
            break;
        
        case BMSampleMode_Recording:
        {
            _awaitingStart = YES;
            [[BMSequencer sharedSequencer] sequenceEvent:^{
                [[BMAudioController sharedController] startRecordingAtTrack:_trackID];
                [_recordingLabel setHidden:NO];
                [self stopPlaybackProgress];
            } withCompletion:^{
                _awaitingStart = NO;
            }];
            _isRecording = YES;
            [_overlay setHidden:NO];
            [self hit];
        }
            break;
            
        case BMSampleMode_LoadFX:
            [self hitAndRun];
            break;
            
        case BMSampleMode_LoadFile:
            [self hitAndRun];
            break;
            
        default:
            break;
    }
}

- (void)performSampleEndAction {
    
    switch (_currentMode) {
            
        case BMSampleMode_Playback:
        {
            _awaitingStop = YES;
            [[BMSequencer sharedSequencer] sequenceEvent:^{
                if ([[BMAudioController sharedController] getPlaybackModeOnTrack:_trackID] != BMPlaybackMode_OneShot) {
                    [[BMAudioController sharedController] stopPlaybackOfTrack:_trackID];
                    [self stopPlaybackProgress];
                }
            }  withCompletion:^{
                _awaitingStop = NO;
            }];
            [_overlay setHidden:YES];
        }
            break;
            
        case BMSampleMode_Recording:
        {
            [self sequenceStopRecording];
        }
            break;
            
        default:
            break;
    }
}



#pragma mark - UI Utility

- (void)hit {
    [_hit setAlpha:1.0f];
    [UIView animateWithDuration:kHitAnimationTime animations:^{
        [_hit setAlpha:0.0f];
    }];
}

- (void)hitAndRun {
    [_hit setAlpha:1.0f];
    [UIView animateWithDuration:kHitAnimationTime animations:^{
        [_hit setAlpha:0.0f];
    } completion:^(BOOL finished) {
        if (_currentMode == BMSampleMode_LoadFX) {
            [_sampleDelegate effectsButtonTappedAtTrack:_trackID];
        } else if (_currentMode == BMSampleMode_LoadFile) {
            [_sampleDelegate loadSampleButtonTappedAtTrack:_trackID];
        }
    }];
}

- (void)startPulse:(int)count {
    [_countdownLabel setText:[NSString stringWithFormat:@"%d", ([[BMSequencer sharedSequencer] meter] - count)]];
    float timeInterval = [[BMSequencer sharedSequencer] timeInterval_s];
    
    [UIView animateWithDuration:(timeInterval / 2.0) animations:^{
        [_countdownLabel setAlpha:1.0f];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:(timeInterval / 4.0f) animations:^{
            [_countdownLabel setAlpha:0.0f];
        }];
    }];
}

- (void)stopPulse:(int)count {
    [_countdownLabel setText:[NSString stringWithFormat:@"%d", ([[BMSequencer sharedSequencer] meter] - count)]];
    float timeInterval = [[BMSequencer sharedSequencer] timeInterval_s];
    
    [UIView animateWithDuration:(timeInterval / 4.0) animations:^{
        [_countdownLabel setAlpha:1.0f];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:(timeInterval / 2.0f) animations:^{
            [_countdownLabel setAlpha:0.0f];
        }];
    }];
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


- (void)updateWithNewMode {
    
    switch (_currentMode) {
            
        case BMSampleMode_Playback:
            [self displayDisablePlaybackUI:NO];
            [self displayMixerSliders:NO];
            [self displayMicRecordingUI:NO];
            [self displayFXLaunchUI:NO];
            [self displayLoadSampleUI:NO];
            [self sequenceStopRecording];
            break;
            
        case BMSampleMode_Recording:
            [self displayMicRecordingUI:YES];
//            [self displayDisablePlaybackUI:YES];
            break;
            
        case BMSampleMode_LoadFX:
            [self displayFXLaunchUI:YES];
//            [self displayDisablePlaybackUI:YES];
            break;
            
        case BMSampleMode_Mix:
            [self displayMixerSliders:YES];
            [self displayDisablePlaybackUI:YES];
            break;
            
        case BMSampleMode_LoadFile:
            [self displayLoadSampleUI:YES];
//            [self displayDisablePlaybackUI:YES];
            break;
            
        default:
            break;
    }
    
}

- (void)displayDisablePlaybackUI:(BOOL)display {
    [UIView animateWithDuration:kToggleDisplayAnimationTime animations:^{
        [_disable setAlpha:(display ? 1.0f : 0.0f)];
    }];
}

- (void)displayMicRecordingUI:(BOOL)display {
    [UIView animateWithDuration:kToggleDisplayAnimationTime animations:^{
        [_micRecordingView setAlpha:(display ? 1.0f : 0.0f)];
    }];
}

- (void)displayFXLaunchUI:(BOOL)display {
    [UIView animateWithDuration:kToggleDisplayAnimationTime animations:^{
        [_fxLaunchView setAlpha:(display ? 1.0f : 0.0f)];
    }];
}

- (void)displayMixerSliders:(BOOL)display {
    float targetAlpha = display ? 1.0f : 0.0f;
    [UIView animateWithDuration:kToggleDisplayAnimationTime animations:^{
        [_gainSlider setAlpha:targetAlpha];
        [_panSlider setAlpha:targetAlpha];
    }];
}

- (void)displayLoadSampleUI:(BOOL)display {
    [UIView animateWithDuration:kToggleDisplayAnimationTime animations:^{
        [_loadSampleView setAlpha:(display ? 1.0f : 0.0f)];
    }];
}


- (void)sequenceStopRecording {
    
    if (!_isRecording) {
        return;
    }
    
    _awaitingStop = YES;
    [[BMSequencer sharedSequencer] sequenceEvent:^{
        [[BMAudioController sharedController] stopRecordingAtTrack:_trackID];
        [_recordingLabel setHidden:YES];
    } withCompletion:^{
        _awaitingStop = NO;
        [_titleLabel setText:[[BMAudioController sharedController] getAudioFileNameOnTrack:_trackID]];
    }];
    _isRecording = NO;
    [_overlay setHidden:YES];
    
}

@end
