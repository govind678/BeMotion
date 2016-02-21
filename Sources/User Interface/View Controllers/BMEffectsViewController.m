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

static const float kFXButtonSize        = 60.0f;
static const float kFXTitleHeight       = 40.0f;
static const float kParamLabelWidth     = 90.0f;
static const float kSliderHeight        = 30.0f;
static const float kYMargin             = 30.0f;
static const float kVerticalBarWidth    = 5.0f;

static NSString* const kFXButtonNormal          =   @"FXButton-Normal.png";
static NSString* const kFXButtonSelected        =   @"FXButton-Selected.png";
static NSString* const kXSeparatorImage         =   @"HorizontalSeparator.png";
static NSString* const kYSeparatorImage         =   @"VerticalSeparator.png";
static NSString* const kFXTitleImage            =   @"FXTitleBackground.png";

@interface BMEffectsViewController()
{
    BMHeaderView*       _headerView;
    NSArray*            _fxButtons;
    NSArray*            _verticalBars;
    NSArray*            _effectsObject;
    int                 _currentFXSlot;
    UIButton*           _fxTitleButton;
    
    UISwitch*           _fxEnableSwitch;
    NSArray*            _sliders;
    NSArray*            _sliderLabels;
    NSArray*            _parameterLabels;
    UISwitch*           _motionControlSwitch;
}
@end


@implementation BMEffectsViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // Get Effects Fields
    NSString* profileFieldsPath = [[NSBundle mainBundle] pathForResource:@"AudioEffects" ofType:@"plist"];
    _effectsObject = [[NSArray alloc] initWithContentsOfFile:profileFieldsPath];
    
    UIColor* currentTrackColor = (UIColor*)[[UIColor trackColors] objectAtIndex:_trackID];
    
    
    // Header
    _headerView = [[BMHeaderView alloc] initWithFrame:CGRectMake(0.0f, self.margin, self.view.frame.size.width, self.headerHeight)];
    [_headerView setTitle:@"Effects"];
    [_headerView addTarget:self action:@selector(backButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_headerView];
    
    
    
    // FX Buttons
    
    _currentFXSlot = 0;
    
    NSMutableArray* fxButtons = [[NSMutableArray alloc] init];
    NSMutableArray* verticalBars = [[NSMutableArray alloc] init];
    float xSpacing =  (self.view.frame.size.width - (2.0f * self.margin)) / kNumEffectsPerTrack;
    
    for (int i=0; i < kNumEffectsPerTrack; i++) {
        
        float xPos = self.margin + (i * xSpacing) + ((xSpacing - kFXButtonSize) / 2.0f);
        float yPos = _headerView.frame.origin.y + _headerView.frame.size.height + 20.0f;
        
        UIView* verticalBar = [[UIView alloc] initWithFrame:CGRectMake(xPos + ((kFXButtonSize - kVerticalBarWidth) / 2.0f), yPos + kFXButtonSize - 7.0f, kVerticalBarWidth, kYMargin)];
        [verticalBar setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:kYSeparatorImage]]];
        [verticalBar setHidden:YES];
        [verticalBars addObject:verticalBar];
        [self.view addSubview:verticalBar];
        
        UIButton* fxButton = [[UIButton alloc] initWithFrame:CGRectMake(xPos, yPos, kFXButtonSize, kFXButtonSize)];
        [fxButton setBackgroundImage:[UIImage imageNamed:kFXButtonNormal] forState:UIControlStateNormal];
        [fxButton setBackgroundImage:[UIImage imageNamed:kFXButtonSelected] forState:UIControlStateSelected];
        [fxButton setTitle:[NSString stringWithFormat:@"FX %d", i+1] forState:UIControlStateNormal];
        [fxButton.titleLabel setFont:[UIFont boldDefaultFontOfSize:12.0f]];
        [fxButton setTitleColor:currentTrackColor forState:UIControlStateNormal];
        [fxButton setTag:i];
        [fxButton addTarget:self action:@selector(fxButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:fxButton];
        [fxButtons addObject:fxButton];
        
        if (i == _currentFXSlot) {
            [fxButton setSelected:YES];
            [verticalBar setHidden:NO];
        }
    }
    _fxButtons = [[NSArray alloc] initWithArray:fxButtons];
    _verticalBars = [[NSArray alloc] initWithArray:verticalBars];
    
    
    // Separator
    UIButton* fxButton = (UIButton*)[_fxButtons objectAtIndex:0];
    UIView* separatorView = [[UIView alloc] initWithFrame:CGRectMake(self.margin, fxButton.frame.origin.y + fxButton.frame.size.height + 20.0f,self.view.frame.size.width - (2.0f * self.margin), 5.0f)];
    [separatorView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:kXSeparatorImage]]];
    [self.view addSubview:separatorView];
    
    
    // FX Title Button
    
    _fxTitleButton = [[UIButton alloc] initWithFrame:CGRectMake(self.margin, separatorView.frame.origin.y + separatorView.frame.size.height + kYMargin, self.view.frame.size.width - (2.0f * self.margin), kFXTitleHeight)];
    [_fxTitleButton setBackgroundImage:[UIImage imageNamed:kFXTitleImage] forState:UIControlStateNormal];
    [_fxTitleButton.titleLabel setFont:[UIFont lightDefaultFontOfSize:12.0f]];
    [_fxTitleButton setTitleColor:currentTrackColor forState:UIControlStateNormal];
    [_fxTitleButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [_fxTitleButton setContentEdgeInsets:UIEdgeInsetsMake(0.0f, 10.0f, 0.0f, 0.0f)];
    [_fxTitleButton addTarget:self action:@selector(fxTitleButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_fxTitleButton];
    
    _fxEnableSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
    [_fxEnableSwitch setFrame:CGRectMake(kParamLabelWidth + 10.0f, _fxTitleButton.frame.origin.y + _fxTitleButton.frame.size.height + kYMargin, _fxEnableSwitch.frame.size.width, _fxEnableSwitch.frame.size.height)];
    [_fxEnableSwitch setOnTintColor:currentTrackColor];
    [_fxEnableSwitch setThumbTintColor:[UIColor colorWithWhite:0.3f alpha:1.0f]];
    [_fxEnableSwitch setTintColor:[UIColor colorWithWhite:0.3f alpha:1.0f]];
    [_fxEnableSwitch addTarget:self action:@selector(fxEnableSwitchTapped) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_fxEnableSwitch];
    
    UILabel* fxEnableTitle = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, _fxTitleButton.frame.origin.y + _fxTitleButton.frame.size.height + kYMargin, kParamLabelWidth, _fxEnableSwitch.frame.size.height)];
    [fxEnableTitle setTextColor:currentTrackColor];
    [fxEnableTitle setFont:[UIFont lightDefaultFontOfSize:11.0f]];
    [fxEnableTitle setTextAlignment:NSTextAlignmentRight];
    [fxEnableTitle setText:@"Enable"];
    [self.view addSubview:fxEnableTitle];
    
    
    //--- Effect Parameter Sliders and Labels ---//
    
    NSMutableArray* parameterLabels = [[NSMutableArray alloc] init];
    NSMutableArray* parameterSliders = [[NSMutableArray alloc] init];
    NSMutableArray* sliderLabels = [[NSMutableArray alloc] init];
    
    float sliderYOffset = _fxEnableSwitch.frame.origin.y + _fxEnableSwitch.frame.size.height + self.margin;
    
    for (int i=0; i < kNumParametersPerEffect; i++) {
        
        float yPos = sliderYOffset + (i * 50.0f);
        
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, yPos, kParamLabelWidth, kSliderHeight)];
        [label setTextColor:currentTrackColor];
        [label setFont:[UIFont lightDefaultFontOfSize:11.0f]];
        [label setTextAlignment:NSTextAlignmentRight];
        [parameterLabels addObject:label];
        [self.view addSubview:label];
        
        UISlider* slider = [[UISlider alloc] initWithFrame:CGRectMake(kParamLabelWidth + 10.0f, yPos, 155.0f, kSliderHeight)];
        [slider setMinimumValue:0.0f];
        [slider setMaximumValue:1.0f];
        [slider setTintColor:currentTrackColor];
        [slider setThumbTintColor:[UIColor colorWithWhite:0.3f alpha:1.0f]];
        [slider setTag:i];
        [slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        [parameterSliders addObject:slider];
        [self.view addSubview:slider];
        
        UILabel* value = [[UILabel alloc] initWithFrame:CGRectMake(kParamLabelWidth + 170.0f, yPos, 25.0f, kSliderHeight)];
        [value setTextColor:[UIColor lightGrayColor]];
        [value setTextAlignment:NSTextAlignmentRight];
        [value setFont:[UIFont lightDefaultFontOfSize:10.0f]];
        [value setTextAlignment:NSTextAlignmentRight];
        [sliderLabels addObject:value];
        [self.view addSubview:value];
    }
    
    _parameterLabels = [[NSArray alloc] initWithArray:parameterLabels];
    _sliders = [[NSArray alloc] initWithArray:parameterSliders];
    _sliderLabels = [[NSArray alloc] initWithArray:sliderLabels];
    
    
    // Separator 2
    UILabel* paramLabel2 = (UILabel*)[_parameterLabels objectAtIndex:2];
    UIView* separatorView2 = [[UIView alloc] initWithFrame:CGRectMake(self.margin, paramLabel2.frame.origin.y + paramLabel2.frame.size.height + 20.0f,self.view.frame.size.width - (2.0f * self.margin), 5.0f)];
    [separatorView2 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:kXSeparatorImage]]];
    [self.view addSubview:separatorView2];

    _motionControlSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
    [_motionControlSwitch setFrame:CGRectMake((self.view.frame.size.width - _fxEnableSwitch.frame.size.width) / 2.0f, separatorView2.frame.origin.y + separatorView2.frame.size.height + kYMargin, _fxEnableSwitch.frame.size.width, _fxEnableSwitch.frame.size.height)];
    [_motionControlSwitch setOnTintColor:currentTrackColor];
    [_motionControlSwitch setThumbTintColor:[UIColor colorWithWhite:0.3f alpha:1.0f]];
    [_motionControlSwitch setTintColor:[UIColor colorWithWhite:0.3f alpha:1.0f]];
    [_motionControlSwitch addTarget:self action:@selector(motionControlSwitchTapped) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_motionControlSwitch];
    
    UILabel* motionEnableTitle = [[UILabel alloc] initWithFrame:CGRectMake(self.margin, separatorView2.frame.origin.y + separatorView2.frame.size.height + kYMargin, kParamLabelWidth, _fxEnableSwitch.frame.size.height)];
    [motionEnableTitle setTextColor:currentTrackColor];
    [motionEnableTitle setFont:[UIFont lightDefaultFontOfSize:11.0f]];
    [motionEnableTitle setTextAlignment:NSTextAlignmentCenter];
    [motionEnableTitle setText:@"Motion Control"];
    [self.view addSubview:motionEnableTitle];
}

- (void)didReceiveMemoryWarning {
    NSLog(@"Received Memory Warning at BMEffectsViewController");
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self updateCurrentFXTitles];
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
    [vc setEffectsObject:_effectsObject];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)fxButtonTapped:(UIButton*)sender {
    
    for (UIButton* button in _fxButtons) {
        if (button == sender) {
            [button setSelected:YES];
        } else {
            [button setSelected:NO];
        }
    }
    
    _currentFXSlot = (int)sender.tag;
    [self updateCurrentFXTitles];
}

- (void)sliderValueChanged:(UISlider*)slider {
    [[BMAudioController sharedController] setEffectParameterOnTrack:_trackID AtSlot:_currentFXSlot ForParameter:(int)slider.tag withValue:slider.value];
    UILabel* label = (UILabel*)[_sliderLabels objectAtIndex:slider.tag];
    [label setText:[NSString stringWithFormat:@"%.2f", slider.value]];
}

- (void)fxEnableSwitchTapped {
    [[BMAudioController sharedController] setEffectEnableOnTrack:_trackID AtSlot:_currentFXSlot WithValue:_fxEnableSwitch.on];
}

- (void)motionControlSwitchTapped {
    
}

#pragma mark - Private Methods

- (void)updateCurrentFXTitles {
    
    int currentEffectID = [[BMAudioController sharedController] getEffectOnTrack:_trackID AtSlot:_currentFXSlot];
    NSDictionary* effect = (NSDictionary*)[_effectsObject objectAtIndex:currentEffectID];
    NSString* title = [effect objectForKey:@"Title"];
    
    [_fxTitleButton setTitle:title forState:UIControlStateNormal];
    
    for (int i=0; i < _verticalBars.count; i++) {
        UIView* view = [_verticalBars objectAtIndex:i];
        if (_currentFXSlot == i) {
            [view setHidden:NO];
        } else {
            [view setHidden:YES];
        }
    }
    NSArray* parameters = (NSArray*)[effect objectForKey:@"Parameters"];
    for (int i=0; i < parameters.count; i++) {
        UILabel* label = (UILabel*)[_parameterLabels objectAtIndex:i];
        [label setText:(NSString*)[parameters objectAtIndex:i]];
    }
    
    [_fxEnableSwitch setOn:[[BMAudioController sharedController] getEffectEnableOnTrack:_trackID AtSlot:_currentFXSlot] animated:YES];
    
    [self updateFXParameters];
}


- (void)updateFXParameters {
    
    for (int i=0; i < _sliders.count; i++) {
        float value = [[BMAudioController sharedController] getEffectParameterOnTrack:_trackID AtSlot:_currentFXSlot ForParameter:i];
        
        UISlider* slider = (UISlider*)[_sliders objectAtIndex:i];
        [slider setValue:value animated:YES];
        
        UILabel* label = (UILabel*)[_sliderLabels objectAtIndex:i];
        [label setText:[NSString stringWithFormat:@"%.2f", value]];
    }
}

@end
