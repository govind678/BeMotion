//
//  BMHomeViewController.m
//  BeMotion
//
//  Created by Govinda Pingali on 2/14/16.
//  Copyright © 2016 Plasmatio Tech. All rights reserved.
//

#import "BMHomeViewController.h"

#import "BMAudioController.h"
#import "BMConstants.h"

#import "BMEffectsViewController.h"
#import "BMLoadFileViewController.h"

#import "BMSampleView.h"
#import "BMHorizontalSlider.h"
#import "BMPanSlider.h"


static float const kTrackButtonHeight               = 100.0f;
static float const kButtonYGap                      = 15.0f;
static const float kOptionButtonSize                = 60.0f;

static float const kPlaybackProgressInterval        = 0.01f;

static NSString* const kMasterRecordNormalImage     = @"Recording-Normal.png";
static NSString* const kMasterRecordSelectedImage   = @"Recording-Selected.png";
static NSString* const kMixerNormalImage            = @"Mixer-Normal.png";
static NSString* const kMixerSelectedImage          = @"Mixer-Selected.png";

@interface BMHomeViewController() <BMSampleViewDelegate>
{
    NSArray*        _sampleViews;
    NSTimer*        _progressTimer;
    
    NSArray*        _gainSliders;
    NSArray*        _panSliders;
    
    UIButton*       _masterRecordButton;
    UIButton*       _mixerButton;
}
@end


@implementation BMHomeViewController


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // Get Color Array
    NSArray* trackColors = [UIColor trackColors];
    
    
    // Setup Sample Tracks, Gain and Pan Sliders
    
    NSMutableArray* sampleViews = [[NSMutableArray alloc] init];
    NSMutableArray* gainSliders = [[NSMutableArray alloc] init];
    NSMutableArray* panSliders = [[NSMutableArray alloc] init];
    
    for (int i=0; i < kNumTracks; i++) {
        
        float yPos = self.margin + (i * (kTrackButtonHeight + kButtonYGap));
        
        BMSampleView* sampleView = [[BMSampleView alloc] initWithFrame:CGRectMake(0.0f, yPos, self.view.frame.size.width, kTrackButtonHeight)];
        [sampleView setTrackID:i];
        [sampleView setSampleDelegate:self];
        [sampleViews addObject:sampleView];
        [self.view addSubview:sampleView];
        
        BMHorizontalSlider* gainSlider = [[BMHorizontalSlider alloc] initWithFrame:CGRectMake(self.margin, yPos, sampleView.frame.size.width - (2.0f * self.margin), (kTrackButtonHeight / 2.0f) - 5.0f)];
        [gainSlider setTag:i];
        [gainSlider setOnTrackColor:(UIColor*)[trackColors objectAtIndex:i]];
        [gainSlider addTarget:self action:@selector(gainSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        [gainSlider setAlpha:0.0f];
        [gainSlider setCenterText:@"Level"];
        [gainSliders addObject:gainSlider];
        [self.view addSubview:gainSlider];
        
        BMPanSlider* panSlider = [[BMPanSlider alloc] initWithFrame:CGRectMake(self.margin, yPos + (kTrackButtonHeight / 2.0f) + 5.0f, sampleView.frame.size.width - (2.0f * self.margin), (kTrackButtonHeight / 2.0f) - 5.0f)];
        [panSlider setTag:i];
        [panSlider setOnTrackColor:(UIColor*)[trackColors objectAtIndex:i]];
        [panSlider addTarget:self action:@selector(panSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        [panSlider setAlpha:0.0f];
        [panSliders addObject:panSlider];
        [self.view addSubview:panSlider];
    }
    
    _sampleViews = [[NSArray alloc] initWithArray:sampleViews];
    
    _gainSliders = [[NSArray alloc] initWithArray:gainSliders];
    _panSliders = [[NSArray alloc] initWithArray:panSliders];
    
    
    // Start Track Playback Progress Timer
    
    _progressTimer = [NSTimer scheduledTimerWithTimeInterval:kPlaybackProgressInterval target:self selector:@selector(playbackProgressTimerCallback) userInfo:nil repeats:YES];
    
    
    
    // Setup Option Buttons
    
    _masterRecordButton = [[UIButton alloc] initWithFrame:CGRectMake(self.margin, self.view.frame.size.height - kOptionButtonSize - self.margin, kOptionButtonSize, kOptionButtonSize)];
    [_masterRecordButton setImage:[UIImage imageNamed:kMasterRecordNormalImage] forState:UIControlStateNormal];
    [_masterRecordButton setImage:[UIImage imageNamed:kMasterRecordSelectedImage] forState:UIControlStateSelected];
    [_masterRecordButton addTarget:self action:@selector(masterRecordButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_masterRecordButton];
    
    _mixerButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - self.margin - kOptionButtonSize, self.view.frame.size.height - kOptionButtonSize - self.margin, kOptionButtonSize, kOptionButtonSize)];
    [_mixerButton setImage:[UIImage imageNamed:kMixerNormalImage] forState:UIControlStateNormal];
    [_mixerButton setImage:[UIImage imageNamed:kMixerSelectedImage] forState:UIControlStateSelected];
    [_mixerButton addTarget:self action:@selector(mixerButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_mixerButton];
    
}

- (void)didReceiveMemoryWarning {
    NSLog(@"Received Memory Warning at BMHomeViewController");
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    for (int i=0; i < kNumTracks; i++) {
        
        BMSampleView* sampleView = (BMSampleView*)[_sampleViews objectAtIndex:i];
        [sampleView setContentOffset:CGPointZero animated:animated];
        [sampleView reloadWaveform];
        
        BMHorizontalSlider* gainSlider = (BMHorizontalSlider*)[_gainSliders objectAtIndex:i];
        [gainSlider setValue:[[BMAudioController sharedController] getGainOnTrack:i]];
        
        BMPanSlider* panSlider = (BMPanSlider*)[_panSliders objectAtIndex:i];
        [panSlider setValue:[[BMAudioController sharedController] getPanOnTrack:i]];
    }
}

#pragma mark - BMSampleViewDelegate

- (void)effectsButtonTappedAtTrack:(int)trackID {
    BMEffectsViewController* vc = [[BMEffectsViewController alloc] init];
    [vc setTrackID:trackID];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)loadSampleButtonTappedAtTrack:(int)trackID {
    BMLoadFileViewController* vc = [[BMLoadFileViewController alloc] init];
    [vc setTrackID:trackID];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UI Actions

- (void)masterRecordButtonTapped {
    if ([_masterRecordButton isSelected]) {
        [[BMAudioController sharedController] stopRecordingMaster];
        [_masterRecordButton setSelected:NO];
        [self launchSaveRecordingDialog];
    } else {
        [[BMAudioController sharedController] startRecordingMaster];
        [_masterRecordButton setSelected:YES];
    }
    
}

- (void)mixerButtonTapped {
    if ([_mixerButton isSelected]) {
        [self displayMixerSliders:NO];
        [_mixerButton setSelected:NO];
    } else {
        [self displayMixerSliders:YES];
        [_mixerButton setSelected:YES];
    }
}

- (void)gainSliderValueChanged:(BMHorizontalSlider*)sender {
    [[BMAudioController sharedController] setGainOnTrack:(int)sender.tag withGain:sender.value];
}

- (void)panSliderValueChanged:(BMHorizontalSlider*)sender {
    [[BMAudioController sharedController] setPanOnTrack:(int)sender.tag withPan:sender.value];
}

#pragma mark - Private Methods

- (void)playbackProgressTimerCallback {
    for (BMSampleView* sampleView in _sampleViews) {
        [sampleView updatePlaybackProgress];
    }
}

- (void)launchSaveRecordingDialog {
    
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documents = [[NSString alloc] initWithString:(NSString*)[paths objectAtIndex:0]];
    NSString* filepath = [documents stringByAppendingString:@"/master-recording-test.wav"];
    NSLog(@"%@",filepath);
    if ([[BMAudioController sharedController] saveMasterRecordingAtFilepath:filepath]) {
//        [[BMAudioController sharedController] loadAudioFileIntoTrack:3 withPath:filepath];
    }
}


- (void)displayMixerSliders:(BOOL)display {
    
    float targetAlpha = display ? 1.0f : 0.0f;
    
    for (int i=0; i < kNumTracks; i++) {
        
        BMSampleView* sampleView = [_sampleViews objectAtIndex:i];
        BMHorizontalSlider* gainSlider = [_gainSliders objectAtIndex:i];
        BMPanSlider* panSlider = [_panSliders objectAtIndex:i];
        
        [UIView animateWithDuration:0.1f animations:^{
            [sampleView setAlpha:1.0f - targetAlpha];
            [gainSlider setAlpha:targetAlpha];
            [panSlider setAlpha:targetAlpha];
        }];
    }
}


@end
