//
//  BMLoadFileViewController.m
//  BeMotion
//
//  Created by Govinda Pingali on 2/17/16.
//  Copyright © 2016 Plasmatio Tech. All rights reserved.
//

#import "BMLoadFileViewController.h"
#import "BMAudioController.h"
#import "BMConstants.h"
#import "BMLoadFileView.h"

static NSString* const kLoopNormalImage             = @"Options-Loop-Normal.png";
static NSString* const kLoopSelectedImage           = @"Options-Loop-Selected.png";
static NSString* const kOneShotNormalImage          = @"Options-OneShot-Normal.png";
static NSString* const kOneShotSelectedImage        = @"Options-OneShot-Selected.png";
static NSString* const kBeatRepeatNormalImage       = @"Options-BeatRepeat-Normal.png";
static NSString* const kMBeatRepeatSelectedImage    = @"Options-BeatRepeat-Selected.png";

static NSString* const kHorizontalSeparatorImage    =   @"HorizontalSeparator.png";


@interface BMLoadFileViewController() <BMLoadFileViewDelegate>
{
    BMHeaderView*           _headerView;
    
    UIButton*               _loopButton;
    UIButton*               _oneShotButton;
    UIButton*               _beatRepeatButton;
    BMPlaybackMode          _currentPlaybackMode;
    
    BMLoadFileView*         _loadFileView;
}
@end


@implementation BMLoadFileViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    CGFloat xMargin = self.margin;
    CGFloat yPos = self.margin;
    
    // Header
    _headerView = [[BMHeaderView alloc] initWithFrame:CGRectMake(xMargin, yPos, self.view.frame.size.width - (2.0f * xMargin), self.headerHeight)];
    [_headerView setTitle:@"Load Audio File"];
    [_headerView addTarget:self action:@selector(backButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_headerView];
    
    
    
    // Playback Option Select
    
    yPos += self.headerHeight + self.yGap;
    
    CGFloat xOptionMargin = xMargin * 2.0f;
    CGFloat xOptionWidth = self.view.frame.size.width - (2.0f * xOptionMargin);
    CGFloat xOptionGap = (xOptionWidth - (3.0f * self.optionButtonSize)) / 2.0f;
    
//    float optionSelectButtonGap = (self.view.frame.size.width - (2.0f * xMargin) - (4.0f * kOptionButtonSize)) / 3.0f;
//    float xOffset = (self.view.frame.size.width - (kOptionButtonSize * 3.0f) + (optionSelectButtonGap * 2.0f)) / 2.0f;
    
    _loopButton = [[UIButton alloc] initWithFrame:CGRectMake(xOptionMargin, yPos, self.optionButtonSize, self.optionButtonSize)];
    [_loopButton setImage:[UIImage imageNamed:kLoopNormalImage] forState:UIControlStateNormal];
    [_loopButton setImage:[UIImage imageNamed:kLoopSelectedImage] forState:UIControlStateSelected];
    [_loopButton setTag:BMPlaybackMode_Loop];
    [_loopButton addTarget:self action:@selector(playbackOptionTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loopButton];
    
    _oneShotButton = [[UIButton alloc] initWithFrame:CGRectMake(xOptionMargin + self.optionButtonSize + xOptionGap, yPos, self.optionButtonSize, self.optionButtonSize)];
    [_oneShotButton setImage:[UIImage imageNamed:kOneShotNormalImage] forState:UIControlStateNormal];
    [_oneShotButton setImage:[UIImage imageNamed:kOneShotSelectedImage] forState:UIControlStateSelected];
    [_oneShotButton setTag:BMPlaybackMode_OneShot];
    [_oneShotButton addTarget:self action:@selector(playbackOptionTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_oneShotButton];

    _beatRepeatButton = [[UIButton alloc] initWithFrame:CGRectMake(xOptionMargin + (2.0f * (self.optionButtonSize + xOptionGap)), yPos, self.optionButtonSize, self.optionButtonSize)];
    [_beatRepeatButton setImage:[UIImage imageNamed:kBeatRepeatNormalImage] forState:UIControlStateNormal];
    [_beatRepeatButton setImage:[UIImage imageNamed:kMBeatRepeatSelectedImage] forState:UIControlStateSelected];
    [_beatRepeatButton setTag:BMPlaybackMode_BeatRepeat];
    [_beatRepeatButton setUserInteractionEnabled:NO];
    [_beatRepeatButton setEnabled:NO];
    [_beatRepeatButton setAlpha:0.3f];
//    [_beatRepeatButton addTarget:self action:@selector(playbackOptionTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_beatRepeatButton];
    
    
    
    // Separator
    yPos += self.optionButtonSize + self.yGap;
    UIView* separatorView1 = [[UIView alloc] initWithFrame:CGRectMake(self.margin, yPos, self.view.frame.size.width - (2.0f * self.margin), self.verticalSeparatorHeight)];
    [separatorView1 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:kHorizontalSeparatorImage]]];
    [self.view addSubview:separatorView1];
    
    
    // Load File View
    yPos += self.verticalSeparatorHeight + self.yGap;
    _loadFileView = [[BMLoadFileView alloc] initWithFrame:CGRectMake(self.margin, yPos, self.view.frame.size.width - (2.0f * xMargin), self.view.frame.size.height - yPos)];
    [_loadFileView setTrackID:_trackID];
    [_loadFileView setDelegate:self];
    [self.view addSubview:_loadFileView];
    
    _currentPlaybackMode = BMPlaybackMode_Loop;
}


- (void)didReceiveMemoryWarning {
    NSLog(@"Did Receive Memory Warning at BMLoadFileViewController");
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [_loadFileView viewWillAppear];
    
    _currentPlaybackMode = (BMPlaybackMode)[[BMAudioController sharedController] getPlaybackModeOnTrack:_trackID];
    [self updatePlaybackModeOptionsUI];
}

#pragma mark - Public Methods

- (void)setTrackID:(int)trackID {
    _trackID = trackID;
    [_loadFileView setTrackID:_trackID];
}


#pragma mark - UI Action Methods

- (void)backButtonTapped {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)playbackOptionTapped:(UIButton*)sender {
    _currentPlaybackMode = (BMPlaybackMode)sender.tag;
    [[BMAudioController sharedController] setPlaybackModeOnTrack:_trackID withMode:_currentPlaybackMode];
    [self updatePlaybackModeOptionsUI];
}

#pragma mark - Private Methods

- (void)updatePlaybackModeOptionsUI {
    
    switch (_currentPlaybackMode) {
            
        case BMPlaybackMode_Loop:
            [_loopButton setSelected:YES];
            [_oneShotButton setSelected:NO];
            [_beatRepeatButton setSelected:NO];
            break;
            
        case BMPlaybackMode_OneShot:
            [_loopButton setSelected:NO];
            [_oneShotButton setSelected:YES];
            [_beatRepeatButton setSelected:NO];
            break;
            
        case BMPlaybackMode_BeatRepeat:
            [_loopButton setSelected:NO];
            [_oneShotButton setSelected:NO];
            [_beatRepeatButton setSelected:YES];
            break;
            
        default:
            break;
    }
}


#pragma mark - BMLoadFileViewDelegate

- (void)launchAlertViewController:(UIViewController *)controller {
    [self presentViewController:controller animated:YES completion:nil];
}

@end
