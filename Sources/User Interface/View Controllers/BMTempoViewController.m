//
//  BMTempoViewController.m
//  BeMotion
//
//  Created by Govinda Pingali on 2/22/16.
//  Copyright © 2016 Plasmatio Tech. All rights reserved.
//

#import "BMTempoViewController.h"
#import "BMSequencer.h"
#import "BMTempoView.h"
#import "UIFont+Additions.h"
#import "UIColor+Additions.h"


static const float kTempoViewHeight                 = 5.0f;
static const float kTempoPickerHeight               = 100.0f;

static NSString* const kXSeparatorImage             = @"HorizontalSeparator.png";


@interface BMTempoViewController() <BMSequencerDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
{
    BMHeaderView*           _headerView;
    BMTempoView*            _tempoView;
    
    UISwitch*               _clockSwitch;
    UIPickerView*           _tempoPicker;
    UIStepper*              _meterStepper;
    UILabel*                _meterStepperLabel;
    UISegmentedControl*     _intervalSegment;
    UISegmentedControl*     _quantizationSegment;
}
@end


@implementation BMTempoViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // Header
    _headerView = [[BMHeaderView alloc] initWithFrame:CGRectMake(0.0f, self.margin, self.view.frame.size.width, self.headerHeight)];
    [_headerView setTitle:@"Time"];
    [_headerView addTarget:self action:@selector(backButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_headerView];
    
    // Setup Tempo Bar
    _tempoView = [[BMTempoView alloc] initWithFrame:CGRectMake(self.margin, (self.margin * 2.0f) + self.headerHeight, self.view.frame.size.width - (2.0f * self.margin), kTempoViewHeight)];
    [self.view addSubview:_tempoView];
    
    _clockSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
    
    float switchWidth = _clockSwitch.frame.size.width;
    float switchHeight = _clockSwitch.frame.size.height;
    float clockYPos = _tempoView.frame.origin.y + _tempoView.frame.size.height + self.margin;
    
    UILabel* clockLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.margin + 5.0f, clockYPos, 100.0f, switchHeight)];
    [clockLabel setTextColor:[UIColor textWhiteColor]];
    [clockLabel setFont:[UIFont lightDefaultFontOfSize:14.0f]];
    [clockLabel setTextAlignment:NSTextAlignmentLeft];
    [clockLabel setText:@"Clock"];
    [self.view addSubview:clockLabel];
    
    [_clockSwitch setFrame:CGRectMake(self.view.frame.size.width - switchWidth - self.margin, clockYPos, switchWidth, switchHeight)];
    [_clockSwitch setOnTintColor:[UIColor textWhiteColor]];
    [_clockSwitch setThumbTintColor:[UIColor colorWithWhite:0.4f alpha:1.0f]];
    [_clockSwitch setTintColor:[UIColor colorWithWhite:0.4f alpha:1.0f]];
    [_clockSwitch addTarget:self action:@selector(clockSwitchTapped) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_clockSwitch];
    
    
    UIView* separatorView1 = [[UIView alloc] initWithFrame:CGRectMake(self.margin, _clockSwitch.frame.origin.y + _clockSwitch.frame.size.height + self.margin, self.view.frame.size.width - (2.0f * self.margin), kTempoViewHeight)];
    [separatorView1 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:kXSeparatorImage]]];
    [self.view addSubview:separatorView1];
    
    
    UILabel* tempoLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.margin + 5.0f, separatorView1.frame.origin.y + kTempoViewHeight + self.margin - 10.0f, 100.0f, switchHeight)];
    [tempoLabel setTextColor:[UIColor textWhiteColor]];
    [tempoLabel setFont:[UIFont lightDefaultFontOfSize:14.0f]];
    [tempoLabel setTextAlignment:NSTextAlignmentLeft];
    [tempoLabel setText:@"Tempo"];
    [self.view addSubview:tempoLabel];
    
    _tempoPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(self.margin, tempoLabel.frame.origin.y + tempoLabel.frame.size.height, self.view.frame.size.width - (2.0f * self.margin), kTempoPickerHeight)];
    [_tempoPicker setBackgroundColor:[UIColor colorWithWhite:0.0f alpha:0.2f]];
    [_tempoPicker setDataSource:self];
    [_tempoPicker setDelegate:self];
    [self.view addSubview:_tempoPicker];
    
    
    UIView* separatorView2 = [[UIView alloc] initWithFrame:CGRectMake(self.margin, _tempoPicker.frame.origin.y + _tempoPicker.frame.size.height + self.margin, self.view.frame.size.width - (2.0f * self.margin), kTempoViewHeight)];
    [separatorView2 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:kXSeparatorImage]]];
    [self.view addSubview:separatorView2];
    
    
    
    float meterYPos = separatorView2.frame.origin.y + kTempoViewHeight + self.margin;
    
    UILabel* meterLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.margin + 5.0f, meterYPos, 100.0f, switchHeight)];
    [meterLabel setTextColor:[UIColor textWhiteColor]];
    [meterLabel setFont:[UIFont lightDefaultFontOfSize:14.0f]];
    [meterLabel setTextAlignment:NSTextAlignmentLeft];
    [meterLabel setText:@"Meter"];
    [self.view addSubview:meterLabel];
    
    _meterStepper = [[UIStepper alloc] initWithFrame:CGRectZero];
    
    float stepperWidth = _meterStepper.frame.size.width;
    float stepperHeight = _meterStepper.frame.size.height;
    
    [_meterStepper setFrame:CGRectMake(self.view.frame.size.width/2.0f, meterYPos, stepperWidth, stepperHeight)];
    [_meterStepper setMaximumValue:[[BMSequencer sharedSequencer] maximumMeter]];
    [_meterStepper setMinimumValue:[[BMSequencer sharedSequencer] minimumMeter]];
    [_meterStepper setContentMode:UIViewContentModeCenter];
    [_meterStepper setTintColor:[UIColor elementWhiteColor]];
    [_meterStepper addTarget:self action:@selector(meterStepperChanged) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_meterStepper];
    
    _meterStepperLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width - self.margin - 30.0f, meterYPos, 30.0f, stepperHeight)];
    [_meterStepperLabel setTextColor:[UIColor textWhiteColor]];
    [_meterStepperLabel setFont:[UIFont lightDefaultFontOfSize:14.0f]];
    [_meterStepperLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:_meterStepperLabel];
    
    
    
    float intervalYPos = meterLabel.frame.origin.y + meterLabel.frame.size.height + self.margin;
    
    UILabel* intervalLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.margin + 5.0f, intervalYPos, 100.0f, switchHeight)];
    [intervalLabel setTextColor:[UIColor textWhiteColor]];
    [intervalLabel setFont:[UIFont lightDefaultFontOfSize:14.0f]];
    [intervalLabel setTextAlignment:NSTextAlignmentLeft];
    [intervalLabel setText:@"Interval"];
    [self.view addSubview:intervalLabel];
    
    NSArray* segments = [NSArray arrayWithObjects:@"1/4", @"1/8", @"1/16", nil];
    NSDictionary* attribute = [NSDictionary dictionaryWithObject:[UIFont lightDefaultFontOfSize:12.0f] forKey:NSFontAttributeName];
    
    _intervalSegment = [[UISegmentedControl alloc] initWithItems:segments];
    [_intervalSegment setFrame:CGRectMake(self.view.frame.size.width/2.0f, intervalYPos, (self.view.frame.size.width / 2.0f) - self.margin, switchHeight)];
    [_intervalSegment setTitleTextAttributes:attribute forState:UIControlStateNormal];
    [_intervalSegment setTintColor:[UIColor elementWhiteColor]];
    [_intervalSegment setSelectedSegmentIndex:0];
    [_intervalSegment addTarget:self action:@selector(intervalSegmentChanged) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_intervalSegment];
    
    
    float quantizationYPos = _intervalSegment.frame.origin.y + _intervalSegment.frame.size.height + self.margin;
    
    UILabel* quantizationLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.margin + 5.0f, quantizationYPos, 100.0f, switchHeight)];
    [quantizationLabel setTextColor:[UIColor textWhiteColor]];
    [quantizationLabel setFont:[UIFont lightDefaultFontOfSize:14.0f]];
    [quantizationLabel setTextAlignment:NSTextAlignmentLeft];
    [quantizationLabel setText:@"Quantization"];
    [self.view addSubview:quantizationLabel];
    
    NSArray* quantSegments = [NSArray arrayWithObjects:@"Off", @"1", @"1/2", @"1/4", nil];
    _quantizationSegment = [[UISegmentedControl alloc] initWithItems:quantSegments];
    [_quantizationSegment setFrame:CGRectMake(self.view.frame.size.width/2.0f, quantizationYPos, (self.view.frame.size.width / 2.0f) - self.margin, switchHeight)];
    [_quantizationSegment setTitleTextAttributes:attribute forState:UIControlStateNormal];
    [_quantizationSegment setTintColor:[UIColor elementWhiteColor]];
    [_quantizationSegment setSelectedSegmentIndex:0];
    [_quantizationSegment addTarget:self action:@selector(quantSegmentChanged) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_quantizationSegment];
    
    
    
    [[BMSequencer sharedSequencer] setDelegate:self];
}

- (void)didReceiveMemoryWarning {
    NSLog(@"Did Receive Memory Warning at BMTempoViewController");
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [_clockSwitch setOn:[[BMSequencer sharedSequencer] isClockRunning] animated:animated];
    
    [self updatePickerWithTempo:[[BMSequencer sharedSequencer] tempo]];
    
    int meter = [[BMSequencer sharedSequencer] meter];
    [_tempoView setMeter:meter];
    [_meterStepper setValue:(int)meter];
    [_meterStepperLabel setText:[NSString stringWithFormat:@"%d", meter]];
    
    int interval = [[BMSequencer sharedSequencer] interval];
    [_intervalSegment setSelectedSegmentIndex:log2f(interval) - 2];
    
    NSUInteger quantization = [[BMSequencer sharedSequencer] quantization];
    [_quantizationSegment setSelectedSegmentIndex:quantization];
    
    if (![[BMSequencer sharedSequencer] isClockRunning]) {
        [_tempoView tick:-1];
    }
}


#pragma mark - UIActions

- (void)backButtonTapped {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clockSwitchTapped {
    if ([_clockSwitch isOn]) {
        [[BMSequencer sharedSequencer] startClock];
    } else {
        [[BMSequencer sharedSequencer] stopClock];
    }
}

- (void)meterStepperChanged {
    int meter = (int)_meterStepper.value;
    [[BMSequencer sharedSequencer] setMeter:meter];
    [_meterStepperLabel setText:[NSString stringWithFormat:@"%d", meter]];
    [_tempoView setMeter:meter];
}

- (void)intervalSegmentChanged {
    int interval = powf(2.0f, _intervalSegment.selectedSegmentIndex + 2);
    [[BMSequencer sharedSequencer] setInterval:interval];
}

- (void)quantSegmentChanged {
    [[BMSequencer sharedSequencer] setQuantization:_quantizationSegment.selectedSegmentIndex];
}


#pragma mark - BMSequencerDelegate

- (void)tick:(NSUInteger)count {
    [_tempoView tick:(int)count];
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if (pickerView == _tempoPicker) {
        return 3;
    }
    return 0;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    if (pickerView == _tempoPicker) {
        if (component == 0) {
            return 3;
        } else {
            return 10;
        }
    }
    return 0;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    if (pickerView == _tempoPicker) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, pickerView.frame.size.width / 3.0f, 44.0f)];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setTextColor:[UIColor textWhiteColor]];
        [label setFont:[UIFont lightDefaultFontOfSize:14.0f]];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setText:[NSString stringWithFormat:@"%d", (int)row]];
        return label;
    }
    return nil;
}

#pragma mark - UIPickerViewDelegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if (pickerView == _tempoPicker) {
        
        int hundreds = (int)[pickerView selectedRowInComponent:0];
        int tens = (int)[pickerView selectedRowInComponent:1];
        int units = (int)[pickerView selectedRowInComponent:2];
        
        int tempo = (100 * hundreds) + (10 * tens) + units;
        
        [[BMSequencer sharedSequencer] setTempo:tempo];
        
        [self updatePickerWithTempo:[[BMSequencer sharedSequencer] tempo]];
    }
    
}

- (void)updatePickerWithTempo:(int)tempo {
    
    int hundreds = tempo / 100;
    int tens = (tempo -  (hundreds * 100)) / 10;
    int units = tempo - (hundreds * 100) - (tens * 10);
    
    [_tempoPicker selectRow:hundreds inComponent:0 animated:YES];
    [_tempoPicker selectRow:tens inComponent:1 animated:YES];
    [_tempoPicker selectRow:units inComponent:2 animated:YES];
}


@end
