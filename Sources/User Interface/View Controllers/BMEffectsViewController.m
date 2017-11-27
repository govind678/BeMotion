//
//  BMEffectsViewController.m
//  BeMotion
//
//  Created by Govinda Pingali on 2/15/16.
//  Copyright © 2016 Plasmatio Tech. All rights reserved.
//

#import "BMEffectsViewController.h"

#import "BMAudioController.h"
#import "BMLoadEffectsViewController.h"
#import "BMConstants.h"

static const float kfxXMargin                       = 20.0f;
static const float kParamLabelWidth                 = 90.0f;
//static const float kYMargin             = 20.0f;
//static const float kVerticalBarWidth    = 5.0f;

static NSString* const kOptionsBackgroundNormalImage    = @"Options-Background-Normal.png";
static NSString* const kOptionsBackgroundSelectedImage  = @"Options-Background-Selected.png";
static NSString* const kHorizontalSeparatorImage        =   @"HorizontalSeparator.png";
//static NSString* const kYSeparatorImage         =   @"VerticalSeparator.png";
static NSString* const kFXTitleImage            =   @"FXTitleBackground.png";

@interface BMEffectsViewController()
{
    BMHeaderView*       _headerView;
    NSArray*            _effectsData;
    
    NSArray*            _fxSelectButtons;
    
    UIButton*           _fxTitleButton;
    UISwitch*           _fxEnableSwitch;
    
    NSArray*            _paramSelectButtons;
    UILabel*            _paramTitleLabel;
    UISlider*           _paramSlider;
    UILabel*            _paramValueLabel;
    
    UISegmentedControl*  _motionControlSelector;
    UISlider*           _motionHighRangeSlider;
    UILabel*            _motionHighRangeValueLabel;
    UISlider*           _motionLowRangeSlider;
    UILabel*            _motionLowRangeValueLabel;
    
    NSTimer*            _motionUpdateTimer;
    
//    NSArray*            _verticalBars;
    
    
//    NSArray*            _sliders;
//    NSArray*            _sliderLabels;
//    NSArray*            _parameterLabels;
//    UISwitch*           _motionControlSwitch;
    
    int                 _currentFXSlot;
    int                 _currentParamSlot;
}
@end


@implementation BMEffectsViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // Get Effects Fields
    NSString* profileFieldsPath = [[NSBundle mainBundle] pathForResource:@"AudioEffectsList" ofType:@"plist"];
    _effectsData = [[NSArray alloc] initWithContentsOfFile:profileFieldsPath];
    _currentFXSlot = 0;
    _currentParamSlot = 0;
    
    UIColor* currentTrackColor = (UIColor*)[[UIColor trackColors] objectAtIndex:_trackID];
    
    float yPos = self.margin;
    float xMargin = self.margin;
    
    // Header
    _headerView = [[BMHeaderView alloc] initWithFrame:CGRectMake(xMargin, yPos, self.view.frame.size.width - (2.0f * xMargin), self.headerHeight)];
    [_headerView setTitle:@"Effects"];
    [_headerView addTarget:self action:@selector(backButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_headerView];
    
    // FX Buttons
    yPos += self.headerHeight + self.yGap;
    
    NSMutableArray* fxSelectButtons = [[NSMutableArray alloc] init];
//    NSMutableArray* verticalBars = [[NSMutableArray alloc] init];
    
    float fxSelectButtonGap = (self.view.frame.size.width - (2.0f * xMargin) - (4.0f * self.optionButtonSize)) / 3.0f;
    
    for (int i=0; i < kNumEffectsPerTrack; i++) {
        
        float xPos = xMargin + (i * (fxSelectButtonGap + self.optionButtonSize)) ;
        
//        UIView* verticalBar = [[UIView alloc] initWithFrame:CGRectMake(xPos + ((kFXButtonSize - kVerticalBarWidth) / 2.0f), yPos + kFXButtonSize - 5.0f, kVerticalBarWidth, kYMargin + 5.0f)];
//        [verticalBar setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:kYSeparatorImage]]];
//        [verticalBar setHidden:YES];
//        [verticalBars addObject:verticalBar];
//        [self.view addSubview:verticalBar];
        
        UIButton* fxButton = [[UIButton alloc] initWithFrame:CGRectMake(xPos, yPos, self.optionButtonSize, self.optionButtonSize)];
        [fxButton setBackgroundImage:[UIImage imageNamed:kOptionsBackgroundNormalImage] forState:UIControlStateNormal];
        [fxButton setBackgroundImage:[UIImage imageNamed:kOptionsBackgroundSelectedImage] forState:UIControlStateSelected];
        [fxButton setTitle:[NSString stringWithFormat:@"FX %d", i+1] forState:UIControlStateNormal];
        [fxButton.titleLabel setFont:[UIFont boldDefaultFontOfSize:12.0f]];
        [fxButton setTitleColor:currentTrackColor forState:UIControlStateNormal];
        [fxButton setTitleEdgeInsets:UIEdgeInsetsMake(2.0f, 0.0f, 0.0f, 0.0f)];
        [fxButton setTag:i];
        [fxButton addTarget:self action:@selector(fxButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:fxButton];
        [fxSelectButtons addObject:fxButton];
        
        if (i == _currentFXSlot) {
            [fxButton setSelected:YES];
//            [verticalBar setHidden:NO];
        }
    }
    _fxSelectButtons = [[NSArray alloc] initWithArray:fxSelectButtons];
//    _verticalBars = [[NSArray alloc] initWithArray:verticalBars];
    
    // Separator
    yPos += self.optionButtonSize + self.yGap;
    UIView* separatorView1 = [[UIView alloc] initWithFrame:CGRectMake(self.margin, yPos, self.view.frame.size.width - (2.0f * self.margin), self.verticalSeparatorHeight)];
    [separatorView1 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:kHorizontalSeparatorImage]]];
    [self.view addSubview:separatorView1];
    
    // FX Title Button
    yPos += self.verticalSeparatorHeight + self.yGap;
    _fxTitleButton = [[UIButton alloc] initWithFrame:CGRectMake(kfxXMargin, yPos, self.view.frame.size.width - (2.0f * kfxXMargin), self.buttonHeight)];
    [_fxTitleButton setBackgroundImage:[UIImage imageNamed:kFXTitleImage] forState:UIControlStateNormal];
    [_fxTitleButton.titleLabel setFont:[UIFont lightDefaultFontOfSize:12.0f]];
    [_fxTitleButton setTitleColor:currentTrackColor forState:UIControlStateNormal];
    [_fxTitleButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [_fxTitleButton setContentEdgeInsets:UIEdgeInsetsMake(0.0f, 10.0f, 0.0f, 0.0f)];
    [_fxTitleButton addTarget:self action:@selector(fxTitleButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_fxTitleButton];
    
    // FX Enable Switch
    yPos += self.buttonHeight + self.yGap;
    _fxEnableSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
    [_fxEnableSwitch setFrame:CGRectMake((self.view.frame.size.width / 2.0f), yPos, _fxEnableSwitch.frame.size.width, _fxEnableSwitch.frame.size.height)];
    [_fxEnableSwitch setOnTintColor:currentTrackColor];
    [_fxEnableSwitch setThumbTintColor:[UIColor colorWithWhite:0.3f alpha:1.0f]];
    [_fxEnableSwitch setTintColor:[UIColor colorWithWhite:0.3f alpha:1.0f]];
    [_fxEnableSwitch addTarget:self action:@selector(fxEnableSwitchTapped) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_fxEnableSwitch];
    
    CGFloat fxCompHeight = _fxEnableSwitch.frame.size.height;

    UILabel* fxEnableTitle = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width / 2.0f) - kParamLabelWidth - xMargin, yPos, kParamLabelWidth, fxCompHeight)];
    [fxEnableTitle setTextColor:currentTrackColor];
    [fxEnableTitle setFont:[UIFont lightDefaultFontOfSize:11.0f]];
    [fxEnableTitle setTextAlignment:NSTextAlignmentRight];
    [fxEnableTitle setText:@"Enable"];
    [self.view addSubview:fxEnableTitle];
    
    
    // Horizontal Separator
    yPos += fxCompHeight + self.yGap;
    UIView* separatorView2 = [[UIView alloc] initWithFrame:CGRectMake(kfxXMargin, yPos, self.view.frame.size.width - (2.0f * kfxXMargin), self.verticalSeparatorHeight)];
    [separatorView2 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:kHorizontalSeparatorImage]]];
    [self.view addSubview:separatorView2];
    
    
    
    // Effect Parameters
    
    NSMutableArray* paramSelectButtons = [[NSMutableArray alloc] init];
    yPos += self.verticalSeparatorHeight + self.yGap;
    
    CGFloat paramButtonsWidth = (self.optionButtonSize * 3.0) + (2.0f * fxSelectButtonGap);
    CGFloat paramXOffset = (self.view.frame.size.width - paramButtonsWidth) / 2.0f;
    
    for (int i=0; i < kNumParametersPerEffect; i++) {

        float xPos = paramXOffset + (i * (fxSelectButtonGap + self.optionButtonSize));
        
        UIButton* paramButton = [[UIButton alloc] initWithFrame:CGRectMake(xPos, yPos, self.optionButtonSize, self.optionButtonSize)];
        [paramButton setBackgroundImage:[UIImage imageNamed:kOptionsBackgroundNormalImage] forState:UIControlStateNormal];
        [paramButton setBackgroundImage:[UIImage imageNamed:kOptionsBackgroundSelectedImage] forState:UIControlStateSelected];
        [paramButton setTitle:[NSString stringWithFormat:@"%d", i+1] forState:UIControlStateNormal];
        [paramButton.titleLabel setFont:[UIFont boldDefaultFontOfSize:12.0f]];
        [paramButton setTitleColor:currentTrackColor forState:UIControlStateNormal];
        [paramButton setTitleEdgeInsets:UIEdgeInsetsMake(2.0f, 0.0f, 0.0f, 0.0f)];
        [paramButton setTag:i];
        [paramButton addTarget:self action:@selector(paramButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:paramButton];
        [paramSelectButtons addObject:paramButton];
        
        if (i == _currentFXSlot) {
            [paramButton setSelected:YES];
        }
    }
    
    _paramSelectButtons = [[NSArray alloc] initWithArray:paramSelectButtons];
    
    yPos += self.optionButtonSize + self.yGap;
    _paramTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kfxXMargin, yPos, self.view.frame.size.width - (2.0f * kfxXMargin), fxCompHeight)];
    [_paramTitleLabel setFont:[UIFont lightDefaultFontOfSize:12.0f]];
    [_paramTitleLabel setTextColor:currentTrackColor];
    [_paramTitleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:_paramTitleLabel];
    
    yPos += fxCompHeight;
    _paramSlider = [[UISlider alloc] initWithFrame:CGRectMake(kfxXMargin + 10.0f, yPos, 225.0f, self.sliderHeight)];
    [_paramSlider setMinimumValue:0.0f];
    [_paramSlider setMaximumValue:1.0f];
    [_paramSlider setTintColor:currentTrackColor];
    [_paramSlider setThumbTintColor:[UIColor colorWithWhite:0.3f alpha:1.0f]];
    [_paramSlider addTarget:self action:@selector(paramSliderValueChanged) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_paramSlider];

    _paramValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(kfxXMargin + 240.0f, yPos, 25.0f, self.sliderHeight)];
    [_paramValueLabel setTextColor:[UIColor lightGrayColor]];
    [_paramValueLabel setTextAlignment:NSTextAlignmentRight];
    [_paramValueLabel setFont:[UIFont lightDefaultFontOfSize:10.0f]];
    [_paramValueLabel setTextAlignment:NSTextAlignmentRight];
    [self.view addSubview:_paramValueLabel];

    
    
    // Motion Control
    NSArray* segments = [NSArray arrayWithObjects:@"Off", @"Pitch", @"Roll", @"Yaw", nil];
    yPos += self.sliderHeight + self.yGap + self.yGap;
    _motionControlSelector = [[UISegmentedControl alloc] initWithItems:segments];
    [_motionControlSelector setFrame:CGRectMake(kfxXMargin + 10.0f, yPos, self.view.frame.size.width - (2.0f * (kfxXMargin + 10.0f)), 29.0f)];
    NSDictionary* attribute = [NSDictionary dictionaryWithObject:[UIFont lightDefaultFontOfSize:12.0f] forKey:NSFontAttributeName];
    [_motionControlSelector setTitleTextAttributes:attribute forState:UIControlStateNormal];
    [_motionControlSelector setTintColor:[UIColor darkGrayColor]];
    [_motionControlSelector setSelectedSegmentIndex:0];
    [_motionControlSelector setTintColor:currentTrackColor];
    [_motionControlSelector addTarget:self action:@selector(motionControlSelectorChanged) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_motionControlSelector];
    
    yPos += 29.0f + self.yGap;
    _motionLowRangeSlider = [[UISlider alloc] initWithFrame:CGRectMake(kfxXMargin + 10.0f, yPos, 225.0f, self.sliderHeight)];
    [_motionLowRangeSlider setMinimumValue:0.0f];
    [_motionLowRangeSlider setMaximumValue:1.0f];
    [_motionLowRangeSlider setTintColor:currentTrackColor];
    [_motionLowRangeSlider setThumbTintColor:[UIColor colorWithWhite:0.3f alpha:1.0f]];
    [_motionLowRangeSlider addTarget:self action:@selector(motionLowSliderValueChanged) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_motionLowRangeSlider];
    
    _motionLowRangeValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(kfxXMargin + 240.0f, yPos, 25.0f, self.sliderHeight)];
    [_motionLowRangeValueLabel setTextColor:[UIColor lightGrayColor]];
    [_motionLowRangeValueLabel setTextAlignment:NSTextAlignmentRight];
    [_motionLowRangeValueLabel setFont:[UIFont lightDefaultFontOfSize:10.0f]];
    [_motionLowRangeValueLabel setTextAlignment:NSTextAlignmentRight];
    [self.view addSubview:_motionLowRangeValueLabel];
    
    yPos += 29.0f + self.yGap;
    _motionHighRangeSlider = [[UISlider alloc] initWithFrame:CGRectMake(kfxXMargin + 10.0f, yPos, 225.0f, self.sliderHeight)];
    [_motionHighRangeSlider setMinimumValue:0.0f];
    [_motionHighRangeSlider setMaximumValue:1.0f];
    [_motionHighRangeSlider setTintColor:currentTrackColor];
    [_motionHighRangeSlider setThumbTintColor:[UIColor colorWithWhite:0.3f alpha:1.0f]];
    [_motionHighRangeSlider addTarget:self action:@selector(motionHighSliderValueChanged) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_motionHighRangeSlider];
    
    _motionHighRangeValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(kfxXMargin + 240.0f, yPos, 25.0f, self.sliderHeight)];
    [_motionHighRangeValueLabel setTextColor:[UIColor lightGrayColor]];
    [_motionHighRangeValueLabel setTextAlignment:NSTextAlignmentRight];
    [_motionHighRangeValueLabel setFont:[UIFont lightDefaultFontOfSize:10.0f]];
    [_motionHighRangeValueLabel setTextAlignment:NSTextAlignmentRight];
    [self.view addSubview:_motionHighRangeValueLabel];
    
    
    [self enableMotionRangeSlider:NO];
}

- (void)didReceiveMemoryWarning {
    NSLog(@"Received Memory Warning at BMEffectsViewController");
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    _currentParamSlot = 0;
    
    [self updateCurrentFXTitle];
    
    if (_motionControlSelector.selectedSegmentIndex > 0) {
        [self enableMotionRangeSlider:YES];
    } else {
        [self enableMotionRangeSlider:NO];
    }
}

#pragma mark - Public Methods

/* Warning: This is actually called before viewDidLoad */
- (void)setTrackID:(int)trackID {
    _trackID = trackID;
}

#pragma mark - UI Actions

- (void)backButtonTapped {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)fxTitleButtonTapped {
    BMLoadEffectsViewController* vc = [[BMLoadEffectsViewController alloc] init];
    [vc setTrackID:_trackID];
    [vc setEffectSlot:_currentFXSlot];
    [vc setEffectsData:_effectsData];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)fxButtonTapped:(UIButton*)sender {
    for (UIButton* button in _fxSelectButtons) {
        [button setSelected:(button == sender)];
    }
    _currentFXSlot = (int)sender.tag;
    _currentParamSlot = 0;
    [self updateCurrentFXTitle];
}

- (void)paramButtonTapped:(UIButton*)sender {
    _currentParamSlot = (int)sender.tag;
    [self updateCurrentFXParamTitleAndValue];
}

- (void)paramSliderValueChanged {
    float value = _paramSlider.value;
    [[BMAudioController sharedController] setEffectParameterOnTrack:_trackID AtSlot:_currentFXSlot ForParameter:_currentParamSlot withValue:value];
    [_paramValueLabel setText:[NSString stringWithFormat:@"%.2f", value]];
}

- (void)motionHighSliderValueChanged {
    float value = _motionHighRangeSlider.value;
    [_motionHighRangeValueLabel setText:[NSString stringWithFormat:@"%.2f", value]];
    [[BMAudioController sharedController] setMotionMaxOnTrack:_trackID AtEffectSlot:_currentFXSlot ForParameter:_currentParamSlot withValue:value];
}

- (void)motionLowSliderValueChanged {
    float value = _motionLowRangeSlider.value;
    [_motionLowRangeValueLabel setText:[NSString stringWithFormat:@"%.2f", value]];
    [[BMAudioController sharedController] setMotionMinOnTrack:_trackID AtEffectSlot:_currentFXSlot ForParameter:_currentParamSlot withValue:value];
}


- (void)fxEnableSwitchTapped {
    [[BMAudioController sharedController] setEffectEnableOnTrack:_trackID AtSlot:_currentFXSlot WithValue:_fxEnableSwitch.on];
}

- (void)motionControlSelectorChanged {
    if (_motionControlSelector.selectedSegmentIndex > 0) {
        [self enableMotionRangeSlider:YES];
    } else {
        [self enableMotionRangeSlider:NO];
    }
    [[BMAudioController sharedController] setMotionMapOnTrack:_trackID AtEffectSlot:_currentFXSlot ForParameter:_currentParamSlot withMap:(int)_motionControlSelector.selectedSegmentIndex];
}


#pragma mark - Private Methods

- (void)updateCurrentFXTitle {
    
    int currentEffectID = [[BMAudioController sharedController] getEffectOnTrack:_trackID AtSlot:_currentFXSlot];
    NSDictionary* effect = (NSDictionary*)[_effectsData objectAtIndex:currentEffectID];
    NSString* title = [effect objectForKey:@"Title"];
    
    [_fxTitleButton setTitle:title forState:UIControlStateNormal];
    [_fxEnableSwitch setOn:[[BMAudioController sharedController] getEffectEnableOnTrack:_trackID AtSlot:_currentFXSlot] animated:YES];
    
    [self updateCurrentFXParamTitleAndValue];
}

- (void)updateCurrentFXParamTitleAndValue {
    
    int currentEffectID = [[BMAudioController sharedController] getEffectOnTrack:_trackID AtSlot:_currentFXSlot];
    NSDictionary* effect = (NSDictionary*)[_effectsData objectAtIndex:currentEffectID];
    
    [self updateCurrentParamButton];
    
    NSArray* parameters = (NSArray*)[effect objectForKey:@"Parameters"];
    [_paramTitleLabel setText:(NSString*)[parameters objectAtIndex:_currentParamSlot]];
    
    [self updateParamValueSliderAndText];
    
    int motionControlMap = [[BMAudioController sharedController] getMotionMapOnTrack:_trackID AtEffectSlot:_currentFXSlot ForParameter:_currentParamSlot];
     [_motionControlSelector setSelectedSegmentIndex:motionControlMap];
    if (motionControlMap > 0) {
        [self enableMotionRangeSlider:YES];
    } else {
        [self enableMotionRangeSlider:NO];
    }
    
    [self updateMotionRangeSliderAndText];
}

- (void)updateCurrentParamButton {
    for (UIButton* button in _paramSelectButtons) {
        [button setSelected:NO];
    }
    [_paramSelectButtons[_currentParamSlot] setSelected:YES];
}

- (void)enableMotionRangeSlider:(BOOL)enable {
    [_motionHighRangeSlider setEnabled:enable];
    [_motionHighRangeSlider setThumbTintColor:[UIColor colorWithWhite:0.3f alpha:(enable ? 1.0f : 0.0f)]];
    [_motionHighRangeValueLabel setAlpha:enable ? 1.0f : 0.0f];
    
    [_motionLowRangeSlider setEnabled:enable];
    [_motionLowRangeSlider setThumbTintColor:[UIColor colorWithWhite:0.3f alpha:(enable ? 1.0f : 0.0f)]];
    [_motionLowRangeValueLabel setAlpha:enable ? 1.0f : 0.0f];
    
    [_paramSlider setEnabled:!enable];
    [_paramSlider setThumbTintColor:[UIColor colorWithWhite:0.3f alpha:(enable ? 0.0f : 1.0f)]];
    
    if (enable) {
        _motionUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:0.1f repeats:YES block:^(NSTimer * _Nonnull timer) {
            [self updateParamValueSliderAndText];
        }];
    } else {
        [_motionUpdateTimer invalidate];
    }
}

- (void)updateParamValueSliderAndText {
    float value = [[BMAudioController sharedController] getEffectParameterOnTrack:_trackID AtSlot:_currentFXSlot ForParameter:_currentParamSlot];
    [_paramSlider setValue:value animated:YES];
    [_paramValueLabel setText:[NSString stringWithFormat:@"%.2f", value]];
}

- (void)updateMotionRangeSliderAndText {
    
    float motionHighRange = [[BMAudioController sharedController] getMotionMaxOnTrack:_trackID AtEffectSlot:_currentFXSlot ForParameter:_currentParamSlot];
    float motionLowRange = [[BMAudioController sharedController] getMotionMinOnTrack:_trackID AtEffectSlot:_currentFXSlot ForParameter:_currentParamSlot];
    
    [_motionHighRangeSlider setValue:motionHighRange animated:YES];
    [_motionHighRangeValueLabel setText:[NSString stringWithFormat:@"%.2f", motionHighRange]];
    
    [_motionLowRangeSlider setValue:motionLowRange animated:YES];
    [_motionLowRangeValueLabel setText:[NSString stringWithFormat:@"%.2f", motionLowRange]];
}

@end
