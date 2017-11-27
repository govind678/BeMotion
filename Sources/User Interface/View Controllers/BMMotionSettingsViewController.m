//
//  BMMotionSettingsViewController.m
//  BeMotion
//
//  Created by Govinda Ram Pingali on 11/17/17.
//  Copyright © 2017 Plasmatio Tech. All rights reserved.
//

#import "BMMotionSettingsViewController.h"
#import "BMMotionController.h"
#import "BMLoadFileView.h"
#import "BMConstants.h"

static NSString* const kHorizontalSeparatorImage        =   @"HorizontalSeparator.png";
static NSString* const kOptionsBackgroundNormalImage    = @"Options-Background-Normal.png";
static NSString* const kOptionsBackgroundSelectedImage  = @"Options-Background-Selected.png";

@interface BMMotionSettingsViewController () <BMLoadFileViewDelegate>
{
    BMHeaderView*           _headerView;
    
    UISwitch*               _motionControlSwitch;
    
    UIButton*               _leftSelectButton;
    UIButton*               _rightSelectButton;
    UISegmentedControl*     _segmentedControl;
    int                     _currentTrackID;
    
//    UILabel*                _thresholdTitleLabel;
    UISlider*               _thresholdSlider;
//    UILabel*                _thresholdValueLabel;
    
    BMLoadFileView*          _loadFileView;
}

@end

@implementation BMMotionSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _currentTrackID = kNumButtonTracks;    // Motion tracks start at the end of button tracks : '4'
    
    float xMargin = self.margin;
    float yPos = self.margin;
    
    // Header
    _headerView = [[BMHeaderView alloc] initWithFrame:CGRectMake(xMargin, yPos, self.view.frame.size.width - (2.0f * xMargin), self.headerHeight)];
    [_headerView setTitle:@"Motion Settings"];
    [_headerView addTarget:self action:@selector(backButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_headerView];
    
    
    // Motion Control Switch
    _motionControlSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
    
    float switchWidth = _motionControlSwitch.frame.size.width;
    float switchHeight = _motionControlSwitch.frame.size.height;
    yPos += self.headerHeight + self.yGap;
    
    UILabel* motionControlLabel = [[UILabel alloc] initWithFrame:CGRectMake(xMargin + 5.0f, yPos, 100.0f, switchHeight)];
    [motionControlLabel setTextColor:[UIColor textWhiteColor]];
    [motionControlLabel setFont:[UIFont lightDefaultFontOfSize:14.0f]];
    [motionControlLabel setTextAlignment:NSTextAlignmentLeft];
    [motionControlLabel setText:@"Motion Control"];
    [self.view addSubview:motionControlLabel];
    
    [_motionControlSwitch setFrame:CGRectMake(self.view.frame.size.width - switchWidth - xMargin, yPos, switchWidth, switchHeight)];
    [_motionControlSwitch setOnTintColor:[UIColor textWhiteColor]];
    [_motionControlSwitch setThumbTintColor:[UIColor colorWithWhite:0.4f alpha:1.0f]];
    [_motionControlSwitch setTintColor:[UIColor colorWithWhite:0.4f alpha:1.0f]];
    [_motionControlSwitch addTarget:self action:@selector(motionControlSwitchTapped) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_motionControlSwitch];
    
    // Separator 1
    yPos += switchHeight + self.yGap;
    UIView* separatorView1 = [[UIView alloc] initWithFrame:CGRectMake(self.margin, yPos, self.view.frame.size.width - (2.0f * self.margin), self.verticalSeparatorHeight)];
    [separatorView1 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:kHorizontalSeparatorImage]]];
    [self.view addSubview:separatorView1];
    
    
    // Motion Threshold Slider
    yPos += self.verticalSeparatorHeight + self.yGap;
    UILabel* thresholdLabel = [[UILabel alloc] initWithFrame:CGRectMake(xMargin + 5.0f, yPos, 60.0f, switchHeight)];
    [thresholdLabel setTextColor:[UIColor textWhiteColor]];
    [thresholdLabel setFont:[UIFont lightDefaultFontOfSize:12.0f]];
    [thresholdLabel setTextAlignment:NSTextAlignmentLeft];
    [thresholdLabel setText:@"Threshold"];
    [self.view addSubview:thresholdLabel];
    
    _thresholdSlider = [[UISlider alloc] initWithFrame:CGRectMake(90.0f, yPos, self.view.frame.size.width - xMargin - 90.0f, self.sliderHeight)];
    [_thresholdSlider setMinimumValue:1.0f];
    [_thresholdSlider setMaximumValue:4.0f];
    [_thresholdSlider setMinimumTrackTintColor:[UIColor textWhiteColor]];
    [_thresholdSlider setMaximumTrackTintColor:[UIColor colorWithWhite:0.25 alpha:1.0]];
    [_thresholdSlider setThumbTintColor:[UIColor colorWithWhite:0.3f alpha:1.0f]];
    [_thresholdSlider addTarget:self action:@selector(thresholdSliderValueChanged) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_thresholdSlider];
    
    
    // Track Select Segments
    yPos += _thresholdSlider.frame.size.height;
    
    _leftSelectButton = [[UIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width / 2.0f) - (2.0f * self.optionButtonSize), yPos, self.optionButtonSize, self.optionButtonSize)];
    [_leftSelectButton setBackgroundImage:[UIImage imageNamed:kOptionsBackgroundNormalImage] forState:UIControlStateNormal];
    [_leftSelectButton setBackgroundImage:[UIImage imageNamed:kOptionsBackgroundSelectedImage] forState:UIControlStateSelected];
    [_leftSelectButton setTitle:@"Left" forState:UIControlStateNormal];
    [_leftSelectButton.titleLabel setFont:[UIFont boldDefaultFontOfSize:12.0f]];
    [_leftSelectButton setTitleColor:[UIColor textWhiteColor] forState:UIControlStateNormal];
    [_leftSelectButton setTitleEdgeInsets:UIEdgeInsetsMake(2.0f, 0.0f, 0.0f, 0.0f)];
    [_leftSelectButton addTarget:self action:@selector(leftSelectButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_leftSelectButton];
    
    _rightSelectButton = [[UIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width / 2.0f) + self.optionButtonSize, yPos, self.optionButtonSize, self.optionButtonSize)];
    [_rightSelectButton setBackgroundImage:[UIImage imageNamed:kOptionsBackgroundNormalImage] forState:UIControlStateNormal];
    [_rightSelectButton setBackgroundImage:[UIImage imageNamed:kOptionsBackgroundSelectedImage] forState:UIControlStateSelected];
    [_rightSelectButton setTitle:@"Right" forState:UIControlStateNormal];
    [_rightSelectButton.titleLabel setFont:[UIFont boldDefaultFontOfSize:12.0f]];
    [_rightSelectButton setTitleColor:[UIColor textWhiteColor] forState:UIControlStateNormal];
    [_rightSelectButton setTitleEdgeInsets:UIEdgeInsetsMake(2.0f, 0.0f, 0.0f, 0.0f)];
    [_rightSelectButton addTarget:self action:@selector(rightSelectButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_rightSelectButton];
    
    
    
    // Load File View
    yPos += self.optionButtonSize + self.yGap;
    _loadFileView = [[BMLoadFileView alloc] initWithFrame:CGRectMake(xMargin, yPos, self.view.frame.size.width - (2.0f * xMargin), self.view.frame.size.height - yPos)];
    [_loadFileView setDelegate:self];
    [_loadFileView setTrackID:_currentTrackID];
    [self.view addSubview:_loadFileView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_loadFileView viewWillAppear];
    [_motionControlSwitch setOn:[[BMMotionController sharedController] isMotionControlRunning]];
    [_thresholdSlider setValue:[[BMMotionController sharedController] xTriggerThreshold] animated:NO];
    [self updateTrackSelectUI];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (void)backButtonTapped {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)thresholdSliderValueChanged {
    [[BMMotionController sharedController] setXTriggerThreshold:_thresholdSlider.value];
}

- (void)motionControlSwitchTapped {
    if ([_motionControlSwitch isOn]) {
        [[BMMotionController sharedController] start];
    } else {
        [[BMMotionController sharedController] stop];
    }
}

- (void)segmentValueChanged {
    _currentTrackID = (int)_segmentedControl.selectedSegmentIndex + kNumButtonTracks;
    [_loadFileView setTrackID:_currentTrackID];
}

- (void)leftSelectButtonTapped {
    _currentTrackID = kNumButtonTracks;
    [self updateTrackSelectUI];
}

- (void)rightSelectButtonTapped {
    _currentTrackID = kNumButtonTracks + 1;
    [self updateTrackSelectUI];
}


#pragma mark - BMLoadFileViewDelegate

- (void)launchAlertViewController:(UIViewController *)controller {
    [self presentViewController:controller animated:YES completion:nil];
}

#pragma mark - Private

- (void)updateTrackSelectUI {
    if (_currentTrackID == kNumButtonTracks) {
        [_leftSelectButton setSelected:YES];
        [_rightSelectButton setSelected:NO];
    } else if (_currentTrackID == kNumButtonTracks + 1) {
        [_leftSelectButton setSelected:NO];
        [_rightSelectButton setSelected:YES];
    }
    
    [_loadFileView setTrackID:_currentTrackID];
}

@end
