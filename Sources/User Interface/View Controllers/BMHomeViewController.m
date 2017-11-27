//
//  BMHomeViewController.m
//  BeMotion
//
//  Created by Govinda Pingali on 2/14/16.
//  Copyright © 2016 Plasmatio Tech. All rights reserved.
//

#import "BMHomeViewController.h"

#import "BMAudioController.h"
#import "BMSequencer.h"
#import "BMConstants.h"
#import "BMSettings.h"
#import "BMMotionController.h"

#import "BMEffectsViewController.h"
#import "BMLoadFileViewController.h"
#import "BMTempoViewController.h"
#import "BMSettingsViewController.h"
#import "BMMotionSettingsViewController.h"

#import "BMSampleButton.h"
#import "BMTempoView.h"
#import "BMForceButton.h"



static float const kTrackButtonHeight               = 94.0;
static float const kButtonYGap                      = 7.0f;
static const float kTempoViewHeight                 = 4.0f;
static const float kTempoAreaHeight                 = 32.0f;

static const float kProgressTimeInterval            = 0.02f;

static NSString* const kMicRecordNormalImage        = @"Options-MicRecord-Normal.png";
static NSString* const kMicRecordSelectedImage      = @"Options-MicRecord-Selected.png";
static NSString* const kEffectsNormalImage          = @"Options-Fx-Normal.png";
static NSString* const kEffectsSelectedImage        = @"Options-Fx-Selected.png";
static NSString* const kMixerNormalImage            = @"Options-Mixer-Normal.png";
static NSString* const kMixerSelectedImage          = @"Options-Mixer-Selected.png";
static NSString* const kImportNormalImage           = @"Options-Import-Normal.png";
static NSString* const kImportSelectedImage         = @"Options-Import-Selected.png";


static NSString* const kSettingsNormalImage         = @"Options-Settings-Normal.png";
static NSString* const kSettingsSelectedImage       = @"Options-Settings-Selected.png";
static NSString* const kMetronomeNormalImage        = @"Options-Metronome-Normal.png";
static NSString* const kMetronomeSelectedImage      = @"Options-Metronome-Selected.png";
static NSString* const kMotionSettingsNormalImage   = @"Options-Motion-Normal.png";
static NSString* const kMotionSettingsSelectedImage = @"Options-Motion-Selected.png";
static NSString* const kMasterRecordNormalImage     = @"Options-MasterRecord-Normal.png";
static NSString* const kMasterRecordSelectedImage   = @"Options-MasterRecord-Selected.png";


@interface BMHomeViewController() <BMSampleButtonDelegate, BMSequencerDelegate, BMForceButtonDelegate, BMAudioControllerDelegate>
{
    NSArray*        _sampleButtons;
    
    UIButton*       _micRecordButton;
    UIButton*       _loadFXButton;
    UIButton*       _loadSampleButton;
    UIButton*       _mixerButton;
    
    BMTempoView*    _tempoView;
    
    BMForceButton*   _metronomeButton;
    BMForceButton*   _motionSettingsButton;
    UIButton*       _masterRecordButton;
    
    NSTimer*        _progressTimer;
    
    UIView*         _micRecordBackgroundView;
    
    UILabel*         _countdownLabel;
    BOOL            _masterAwaitingStart;
    BOOL            _masterAwaitingStop;
}
@end


@implementation BMHomeViewController


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // Get Color Array
//    NSArray* trackColors = [UIColor trackColors];
    
    
    // Mic Recording Background View
    _micRecordBackgroundView = [[UIView alloc] initWithFrame:self.view.frame];
    [_micRecordBackgroundView setBackgroundColor:[UIColor colorWithRed:1.0f green:0.1f blue:0.1f alpha:0.1f]];
    [_micRecordBackgroundView setAlpha:0.0f];
    [_micRecordBackgroundView setUserInteractionEnabled:NO];
    [self.view addSubview:_micRecordBackgroundView];
    
    
    float yPos = self.margin;
    float xMargin = self.margin;
    float optionsButtonGap = (self.view.frame.size.width - (2.0f * xMargin) - (4.0f * self.optionButtonSize)) / 3.0f;
    
    // Setup Sample Track Buttons
    NSMutableArray* sampleButtons = [[NSMutableArray alloc] init];
    for (int i=0; i < kNumButtonTracks; i++) {
        BMSampleButton* sampleButton = [[BMSampleButton alloc] initWithFrame:CGRectMake(xMargin, yPos, self.view.frame.size.width - (2.0f * xMargin), kTrackButtonHeight)];
        [sampleButton setTrackID:i];
        [sampleButton setSampleDelegate:self];
        [sampleButtons addObject:sampleButton];
        [sampleButton updateTitle];
        [self.view addSubview:sampleButton];
        yPos += (kTrackButtonHeight + kButtonYGap);
    }
    _sampleButtons = [[NSArray alloc] initWithArray:sampleButtons];
    
    
    
    // Setup From Bottom
    yPos = self.view.frame.size.height - self.margin - self.optionButtonSize;
    
    // Setup Global Options Buttons
    UIButton* settingsButton = [[UIButton alloc] initWithFrame:CGRectMake(xMargin, yPos, self.optionButtonSize, self.optionButtonSize)];
    [settingsButton setImage:[UIImage imageNamed:kSettingsNormalImage] forState:UIControlStateNormal];
    [settingsButton setImage:[UIImage imageNamed:kSettingsSelectedImage] forState:UIControlStateSelected];
    [settingsButton addTarget:self action:@selector(settingsButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:settingsButton];
    
    _metronomeButton = [[BMForceButton alloc] initWithFrame:CGRectMake(xMargin + self.optionButtonSize + optionsButtonGap, yPos, self.optionButtonSize, self.optionButtonSize)];
    [_metronomeButton setButtonDownImage:[UIImage imageNamed:kMetronomeSelectedImage]];
    [_metronomeButton setButtonUpImage:[UIImage imageNamed:kMetronomeNormalImage]];
    [_metronomeButton setDelegate:self];
    [self.view addSubview:_metronomeButton];
    
    _motionSettingsButton = [[BMForceButton alloc] initWithFrame:CGRectMake(xMargin + 2.0f * (self.optionButtonSize + optionsButtonGap), yPos, self.optionButtonSize, self.optionButtonSize)];
    [_motionSettingsButton setButtonUpImage:[UIImage imageNamed:kMotionSettingsNormalImage]];
    [_motionSettingsButton setButtonDownImage:[UIImage imageNamed:kMotionSettingsSelectedImage]];
    [_motionSettingsButton setDelegate:self];
    [self.view addSubview:_motionSettingsButton];
    
    _masterRecordButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - self.optionButtonSize - xMargin, yPos, self.optionButtonSize, self.optionButtonSize)];
    [_masterRecordButton setImage:[UIImage imageNamed:kMasterRecordNormalImage] forState:UIControlStateNormal];
    [_masterRecordButton setImage:[UIImage imageNamed:kMasterRecordSelectedImage] forState:UIControlStateSelected];
    [_masterRecordButton addTarget:self action:@selector(masterRecordButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_masterRecordButton];
    
    
    
    // Setup Tempo / Meter Indicator Tracks
    yPos -= 0.5 * (kTempoAreaHeight - kTempoViewHeight);
    _tempoView = [[BMTempoView alloc] initWithFrame:CGRectMake(self.margin, yPos, self.view.frame.size.width - (2.0f * self.margin), kTempoViewHeight)];
    [self.view addSubview:_tempoView];
    
    
    
    // Setup Track Options Buttons
    yPos = yPos + (0.5 * kTempoViewHeight) - (0.5 * kTempoAreaHeight) - self.optionButtonSize;
    
    _micRecordButton = [[UIButton alloc] initWithFrame:CGRectMake(xMargin, yPos, self.optionButtonSize, self.optionButtonSize)];
    [_micRecordButton setImage:[UIImage imageNamed:kMicRecordNormalImage] forState:UIControlStateNormal];
    [_micRecordButton setImage:[UIImage imageNamed:kMicRecordSelectedImage] forState:UIControlStateSelected];
    [_micRecordButton setTag:BMSampleMode_Recording];
    [_micRecordButton addTarget:self action:@selector(trackOptionTouchDown:) forControlEvents:UIControlEventTouchDown];
    [_micRecordButton addTarget:self action:@selector(trackOptionTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_micRecordButton];
    
    _loadFXButton = [[UIButton alloc] initWithFrame:CGRectMake(xMargin + self.optionButtonSize + optionsButtonGap, yPos, self.optionButtonSize, self.optionButtonSize)];
    [_loadFXButton setImage:[UIImage imageNamed:kEffectsNormalImage] forState:UIControlStateNormal];
    [_loadFXButton setImage:[UIImage imageNamed:kEffectsSelectedImage] forState:UIControlStateSelected];
    [_loadFXButton setTag:BMSampleMode_LoadFX];
    [_loadFXButton addTarget:self action:@selector(trackOptionTouchDown:) forControlEvents:UIControlEventTouchDown];
    [_loadFXButton addTarget:self action:@selector(trackOptionTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loadFXButton];
    
    _loadSampleButton = [[UIButton alloc] initWithFrame:CGRectMake(xMargin + 2.0f * (self.optionButtonSize + optionsButtonGap), yPos, self.optionButtonSize, self.optionButtonSize)];
    [_loadSampleButton setImage:[UIImage imageNamed:kImportNormalImage] forState:UIControlStateNormal];
    [_loadSampleButton setImage:[UIImage imageNamed:kImportSelectedImage] forState:UIControlStateSelected];
    [_loadSampleButton setTag:BMSampleMode_LoadFile];
    [_loadSampleButton addTarget:self action:@selector(trackOptionTouchDown:) forControlEvents:UIControlEventTouchDown];
    [_loadSampleButton addTarget:self action:@selector(trackOptionTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loadSampleButton];
    
    _mixerButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - self.optionButtonSize - xMargin, yPos, self.optionButtonSize, self.optionButtonSize)];
    [_mixerButton setImage:[UIImage imageNamed:kMixerNormalImage] forState:UIControlStateNormal];
    [_mixerButton setImage:[UIImage imageNamed:kMixerSelectedImage] forState:UIControlStateSelected];
    [_mixerButton setTag:BMSampleMode_Mix];
    [_mixerButton addTarget:self action:@selector(trackOptionTouchDown:) forControlEvents:UIControlEventTouchDown];
    [_mixerButton addTarget:self action:@selector(trackOptionTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_mixerButton];
    
    
    // Master Record Countdown
    CGRect coutdownLabelFrame = _masterRecordButton.frame;
    _countdownLabel = [[UILabel alloc] initWithFrame:coutdownLabelFrame];
    [_countdownLabel setTextColor:[UIColor colorWithWhite:0.0f alpha:1.0f]];
    [_countdownLabel setFont:[UIFont lightDefaultFontOfSize:18.0f]];
    [_countdownLabel setTextAlignment:NSTextAlignmentCenter];
    [_countdownLabel setText:@"0"];
    [_countdownLabel setUserInteractionEnabled:NO];
    [_countdownLabel setAlpha:0.0f];
    [self.view addSubview:_countdownLabel];
    
    _masterAwaitingStart = NO;
    _masterAwaitingStop = NO;
    
    [[BMAudioController sharedController] setDelegate:self];
    
    // Register for App State Notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    
    // Setup Progress Timer
    _progressTimer = [NSTimer timerWithTimeInterval:kProgressTimeInterval target:self selector:@selector(progressTimerCallback) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_progressTimer forMode:NSRunLoopCommonModes];
}

- (void)didReceiveMemoryWarning {
    NSLog(@"Received Memory Warning at BMHomeViewController");
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    for (int i=0; i < kNumButtonTracks; i++) {
        BMSampleButton* sampleButton = (BMSampleButton*)[_sampleButtons objectAtIndex:i];
        [sampleButton viewWillAppear];
        [sampleButton updateWaveform:[[BMSettings sharedInstance] shouldDrawWaveform]];
    }
    
    [_micRecordButton setSelected:NO];
    [_loadFXButton setSelected:NO];
    [_mixerButton setSelected:NO];
    [_loadSampleButton setSelected:NO];
    
    _masterAwaitingStop = NO;
    _masterAwaitingStart = NO;
    
    // Sequencer
    [[BMSequencer sharedSequencer] setDelegate:self];
    [_tempoView setMeter:[[BMSequencer sharedSequencer] meter]];
    [_tempoView setTimeDuration:[[BMSequencer sharedSequencer] timeInterval_s]];
    if (![[BMSequencer sharedSequencer] isClockRunning]) {
        [_tempoView tick:-1];
        [_metronomeButton setSelected:NO];
    } else {
        [_metronomeButton setSelected:YES];
    }
    
    [self displayMicRecordingBackgroundView:NO];
}


- (void)didEnterBackground:(NSNotification*)notification {
    for (BMSampleButton* sampleButton in _sampleButtons) {
        [sampleButton reset];
    }
}

#pragma mark - BMSampleButtonDelegate

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

- (void)trackOptionTouchDown:(UIButton*)sender {
    for (BMSampleButton* sampleButton in _sampleButtons) {
        [sampleButton setCurrentMode:(BMSampleMode)sender.tag];
    }
    
    if (sender.tag == BMSampleMode_Recording) {
        [self displayMicRecordingBackgroundView:YES];
    }
    
    [sender setSelected:YES];
}

- (void)trackOptionTouchUpInside:(UIButton*)sender {
    for (BMSampleButton* sampleButton in _sampleButtons) {
        [sampleButton setCurrentMode:BMSampleMode_Playback];
    }
    
    if (sender.tag == BMSampleMode_Recording) {
        [self displayMicRecordingBackgroundView:NO];
    }
    
    [sender setSelected:NO];
}



- (void)masterRecordButtonTapped {
    
    if ([_masterRecordButton isSelected]) {
        [[BMSequencer sharedSequencer] sequenceEvent:^{
            [[BMAudioController sharedController] stopRecordingMaster];
            [self displayMicRecordingBackgroundView:NO];
        } withCompletion:^{
            _masterAwaitingStop = NO;
            [_masterRecordButton setSelected:NO];
            [self launchSaveMasterRecordingDialog];
        }];
        _masterAwaitingStop = YES;
    }
    
    else {
        [[BMSequencer sharedSequencer] sequenceEvent:^{
            [[BMAudioController sharedController] startRecordingMaster];
            [self displayMicRecordingBackgroundView:YES];
        } withCompletion:^{
            _masterAwaitingStart = NO;
            [_masterRecordButton setSelected:YES];
        }];
        _masterAwaitingStart = YES;
    }
    
}

- (void)settingsButtonTapped {
    BMSettingsViewController* vc = [[BMSettingsViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - BMForceButtonDelegate

- (void)forceButtonTouchUpInside:(id)sender {
    
    if (sender == _metronomeButton) {
        BMTempoViewController* vc = [[BMTempoViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    else if (sender == _motionSettingsButton) {
        BMMotionSettingsViewController* vc = [[BMMotionSettingsViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}


- (void)forceButtonForcePressDown:(id)sender {
    
    if (sender == _metronomeButton) {
        if ([[BMSequencer sharedSequencer] isClockRunning]) {
            [[BMSequencer sharedSequencer] stopClock];
            [_metronomeButton setSelected:NO];
        } else {
            [[BMSequencer sharedSequencer] startClock];
            [_metronomeButton setSelected:YES];
        }
    }
    
    else if (sender == _motionSettingsButton) {
        if ([[BMMotionController sharedController] isMotionControlRunning]) {
            [[BMMotionController sharedController] stop];
        } else {
            [[BMMotionController sharedController] start];
        }
    }
}


#pragma mark - BMSequencerDelegate

- (void)tick:(NSUInteger)count {
    for (BMSampleButton* sampleButton in _sampleButtons) {
        [sampleButton tick:(int)count];
    }
    [_tempoView tick:(int)count];
    
    if (_masterAwaitingStart) {
        [self startMasterPulse:count];
    } else if (_masterAwaitingStop) {
        [self stopMasterPulse:count];
    }
}

#pragma mark - Private Methods

- (void)progressTimerCallback {
    for (BMSampleButton* sampleButton in _sampleButtons) {
        [sampleButton updatePlaybackProgress:kProgressTimeInterval];
    }
}

- (void)displayMicRecordingBackgroundView:(BOOL)display {
    [UIView animateWithDuration:0.1 animations:^{
        [_micRecordBackgroundView setAlpha:(display ? 1.0f : 0.0f)];
    }];
}

- (void)startMasterPulse:(NSUInteger)count {
    [_countdownLabel setText:[NSString stringWithFormat:@"%d", ([[BMSequencer sharedSequencer] meter] - (int)count)]];
    float timeInterval = [[BMSequencer sharedSequencer] timeInterval_s];
    
    [UIView animateWithDuration:(timeInterval / 2.0) animations:^{
        [_countdownLabel setAlpha:1.0f];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:(timeInterval / 4.0f) animations:^{
            [_countdownLabel setAlpha:0.0f];
        }];
    }];
}

- (void)stopMasterPulse:(NSUInteger)count {
    [_countdownLabel setText:[NSString stringWithFormat:@"%d", ([[BMSequencer sharedSequencer] meter] - (int)count)]];
    float timeInterval = [[BMSequencer sharedSequencer] timeInterval_s];
    
    [UIView animateWithDuration:(timeInterval / 4.0) animations:^{
        [_countdownLabel setAlpha:1.0f];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:(timeInterval / 2.0f) animations:^{
            [_countdownLabel setAlpha:0.0f];
        }];
    }];
}


- (void)launchSaveMasterRecordingDialog {
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd MMM HH:mm:ss"];
    NSString* time = [dateFormatter stringFromDate:[NSDate date]];
    NSString* filename = [NSString stringWithFormat:@"%@ - %@", [[BMSettings sharedInstance] projectName], time];
    
    
    UIAlertController* saveDialog = [UIAlertController alertControllerWithTitle:@"Save Recording?"
                                                                        message:nil
                                                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* saveAction = [UIAlertAction actionWithTitle:@"Save"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * _Nonnull action) {
                                                           NSString* filename = saveDialog.textFields.firstObject.text;
                                                           NSString* filepath = [self masterFilepathFromName:filename];
                                                           [[BMAudioController sharedController] saveMasterRecordingAtFilepath:filepath];
                                                       }];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action) {}];
    
    
    [saveDialog addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        [textField setText:filename];
        [textField setClearButtonMode:UITextFieldViewModeAlways];
        [textField selectAll:textField];
    }];
    [saveDialog addAction:saveAction];
    [saveDialog addAction:cancelAction];
    
    [self presentViewController:saveDialog animated:YES completion:nil];
}

- (NSString*)masterFilepathFromName:(NSString*)name {
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documents = [NSString stringWithString:(NSString*)[paths objectAtIndex:0]];
    NSString* recordings = [documents stringByAppendingPathComponent:@"MasterRecordings/"];
    NSString* filepath = [recordings stringByAppendingPathComponent:[name stringByAppendingString:@".wav"]];
    return filepath;
}



#pragma mark - BMAudioControllerDelegate

- (void)didFinishLoadingAudioFileAtTrack:(int)track {
    if (track < kNumButtonTracks) {
        BMSampleButton* button = (BMSampleButton*)_sampleButtons[track];
        [button updateWaveform:[[BMSettings sharedInstance] shouldDrawWaveform]];
        [button updateTitle];
    }
}

- (void)didReachEndOfPlayback:(int)track {
    
}
@end
