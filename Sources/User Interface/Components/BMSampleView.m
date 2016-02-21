//
//  BMSampleView.m
//  BeMotion
//
//  Created by Govinda Pingali on 2/14/16.
//  Copyright © 2016 Plasmatio Tech. All rights reserved.
//

#import "BMSampleView.h"
#import "BMPlayButton.h"
#import "BMAudioController.h"

static float const kMarginWidth     = 20.0f;
//static float const kSidebarWidth    = 5.0f;

static NSString* const kDragArrowBackPrefix                 = @"DragArrowBack";
static NSString* const kDragArrowLeftButtonNormalImage      = @"DragArrowLeft-Normal.png";
static NSString* const kDragArrowLeftButtonSelectedImage    = @"DragArrowLeft-Selected.png";
static NSString* const kDragArrowRightButtonNormalImage     = @"DragArrowRight-Normal.png";
static NSString* const kDragArrowRightButtonSelectedImage   = @"DragArrowRight-Selected.png";

static NSString* const kSettingsBackgroundImage             = @"SettingsBackground.png";

static NSString* const kEffectsNormalImage                  = @"Effects-Normal.png";
static NSString* const kEffectsSelectedImage                = @"Effects-Selected.png";
static NSString* const kImportNormalImage                   = @"ImportTrack-Normal.png";
static NSString* const kImportSelectedImage                 = @"ImportTrack-Selected.png";
static NSString* const kRecordNormalImage                   = @"MicRecord-Normal.png";
static NSString* const kRecordSelectedImage                 = @"MicRecord-Selected.png";

@interface BMSampleView()
{
    BMPlayButton*       _playButton;
    UIView*             _settingsView;
    
    UIButton*           _fxButton;
    UIButton*           _recordButton;
    UIButton*           _loadSampleButton;
    
    UIButton*           _dragArrowLeftButton;
    UIButton*           _dragArrowRightButton;
    
    UIView*             _dragArrowLeftBackgroundView;
    UIView*             _dragArrowRightBackgroundView;
}
@end


@implementation BMSampleView

- (id)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self setShowsHorizontalScrollIndicator:NO];
        [self setShowsVerticalScrollIndicator:NO];
        [self setPagingEnabled:YES];
        [self setDelaysContentTouches:NO];
        [self setContentSize:CGSizeMake(frame.size.width * 2.0f, frame.size.height)];
        [self setCanCancelContentTouches:YES];
        
        
        _playButton = [[BMPlayButton alloc] initWithFrame:CGRectMake(kMarginWidth, 0.0f, frame.size.width - (2.0f * kMarginWidth), frame.size.height)];
        [self addSubview:_playButton];
        
        
        _dragArrowLeftBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(frame.size.width - kMarginWidth, 0.0f, kMarginWidth, frame.size.height)];
        [_dragArrowLeftBackgroundView setUserInteractionEnabled:NO];
        [self addSubview:_dragArrowLeftBackgroundView];
        
        _dragArrowRightBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(frame.size.width, 0.0f, kMarginWidth, frame.size.height)];
        [_dragArrowRightBackgroundView setUserInteractionEnabled:NO];
        [self addSubview:_dragArrowRightBackgroundView];
        
        _dragArrowLeftButton = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width - kMarginWidth, 0.0f, kMarginWidth, frame.size.height)];
        [_dragArrowLeftButton setImage:[UIImage imageNamed:kDragArrowLeftButtonNormalImage] forState:UIControlStateNormal];
        [_dragArrowLeftButton setImage:[UIImage imageNamed:kDragArrowLeftButtonSelectedImage] forState:UIControlStateHighlighted];
        [_dragArrowLeftButton setAlpha:0.8f];
        [self addSubview:_dragArrowLeftButton];
        
        _dragArrowRightButton = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width, 0.0f, kMarginWidth, frame.size.height)];
        [_dragArrowRightButton setImage:[UIImage imageNamed:kDragArrowRightButtonNormalImage] forState:UIControlStateNormal];
        [_dragArrowRightButton setImage:[UIImage imageNamed:kDragArrowRightButtonSelectedImage] forState:UIControlStateHighlighted];
        [_dragArrowRightButton setAlpha:0.8f];
        [self addSubview:_dragArrowRightButton];
        
        
        float settingsWidth = frame.size.width - (2.0f * kMarginWidth);
        
        _settingsView = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width + kMarginWidth, 0.0f, settingsWidth, frame.size.height)];
        [_settingsView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:kSettingsBackgroundImage]]];
        [self addSubview:_settingsView];
        
        float buttonWidth = (settingsWidth) / 3.0f;
        
        _recordButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, buttonWidth, frame.size.height)];
        [_recordButton setImage:[UIImage imageNamed:kRecordNormalImage] forState:UIControlStateNormal];
        [_recordButton setImage:[UIImage imageNamed:kRecordSelectedImage] forState:UIControlStateHighlighted];
        [_recordButton addTarget:self action:@selector(recordButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
        [_recordButton addTarget:self action:@selector(recordButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [_recordButton addTarget:self action:@selector(recordButtonTouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
        [_recordButton setTag:300];
        [_settingsView addSubview:_recordButton];
        
        _fxButton = [[UIButton alloc] initWithFrame:CGRectMake(buttonWidth, 0.0f, buttonWidth, frame.size.height)];
        [_fxButton setImage:[UIImage imageNamed:kEffectsNormalImage] forState:UIControlStateNormal];
        [_fxButton setImage:[UIImage imageNamed:kEffectsSelectedImage] forState:UIControlStateSelected];
        [_fxButton setTag:300];
        [_fxButton addTarget:self action:@selector(fxButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        [_settingsView addSubview:_fxButton];
        
        _loadSampleButton = [[UIButton alloc] initWithFrame:CGRectMake(2.0f * buttonWidth, 0.0f, buttonWidth, frame.size.height)];
        [_loadSampleButton setImage:[UIImage imageNamed:kImportNormalImage] forState:UIControlStateNormal];
        [_loadSampleButton setImage:[UIImage imageNamed:kImportSelectedImage] forState:UIControlStateSelected];
        [_loadSampleButton setTag:300];
        [_loadSampleButton addTarget:self action:@selector(loadSampleButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        [_settingsView addSubview:_loadSampleButton];
        
        _recordingLock = NO;
    }
    
    return self;
}

#pragma mark - Public Methods

- (void)setTrackID:(int)trackID {
    _trackID = trackID;
    
    [_playButton setTrackID:trackID];
    [_playButton setTag:trackID + 100];
    
    [_settingsView setTag:trackID + 200];
    
    NSString* dragArrowbackgroundImage = [NSString stringWithFormat:@"%@%d.png", kDragArrowBackPrefix, trackID];
    [_dragArrowLeftBackgroundView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:dragArrowbackgroundImage]]];
    [_dragArrowRightBackgroundView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:dragArrowbackgroundImage]]];
}

- (void)updatePlaybackProgress {
    [_playButton updatePlaybackProgress];
}

- (void)reloadWaveform {
    [_playButton reloadWaveform];
}

#pragma mark - UIScrollView Touch Events

- (BOOL)touchesShouldBegin:(NSSet *)touches withEvent:(UIEvent *)event inContentView:(UIView *)view {
    return YES;
}


- (BOOL)touchesShouldCancelInContentView:(UIView *)view
{
    BOOL returnVal = YES;
    
    if(view.tag == (_trackID+100) || (view.tag == (300)))
    {
        returnVal = NO;
    }
    
    return returnVal;
}


#pragma mark - UIButton Events

- (void)recordButtonTouchDown:(UIButton*)sender {
    if (!_recordingLock) {
        [[BMAudioController sharedController] startRecordingAtTrack:_trackID];
    }
}

- (void)recordButtonTouchUpInside:(UIButton*)sender {
    [[BMAudioController sharedController] stopRecordingAtTrack:_trackID];
}

- (void)recordButtonTouchUpOutside:(UIButton*)sender {
    [[BMAudioController sharedController] stopRecordingAtTrack:_trackID];
}


- (void)fxButtonTapped {
    if ([self.sampleDelegate respondsToSelector:@selector(effectsButtonTappedAtTrack:)]) {
        [self.sampleDelegate effectsButtonTappedAtTrack:_trackID];
    }
}

- (void)loadSampleButtonTapped {
    if ([self.sampleDelegate respondsToSelector:@selector(loadSampleButtonTappedAtTrack:)]) {
        [self.sampleDelegate loadSampleButtonTappedAtTrack:_trackID];
    }
}



@end
