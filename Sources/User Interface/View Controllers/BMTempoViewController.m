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


static const float kTempoViewHeight                 = 4.0f;
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
    UISwitch*               _quantizationSwitch;
}
@end


@implementation BMTempoViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // Header
    float yPos = self.margin;
    float xMargin = self.margin;
    
    _headerView = [[BMHeaderView alloc] initWithFrame:CGRectMake(xMargin, yPos, self.view.frame.size.width - 2.0f * xMargin, self.headerHeight)];
    [_headerView setTitle:@"Time"];
    [_headerView addTarget:self action:@selector(backButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_headerView];
    
    // Setup Tempo Bar
    yPos += self.headerHeight + (1.5f * self.yGap);
    _tempoView = [[BMTempoView alloc] initWithFrame:CGRectMake(xMargin, yPos, self.view.frame.size.width - (2.0f * xMargin), kTempoViewHeight)];
    [self.view addSubview:_tempoView];
    
    
    _clockSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
    
    float switchWidth = _clockSwitch.frame.size.width;
    float switchHeight = _clockSwitch.frame.size.height;
    yPos += kTempoViewHeight + self.yGap;
    
    UILabel* clockLabel = [[UILabel alloc] initWithFrame:CGRectMake(xMargin + 5.0f, yPos, 100.0f, switchHeight)];
    [clockLabel setTextColor:[UIColor textWhiteColor]];
    [clockLabel setFont:[UIFont lightDefaultFontOfSize:14.0f]];
    [clockLabel setTextAlignment:NSTextAlignmentLeft];
    [clockLabel setText:@"Clock"];
    [self.view addSubview:clockLabel];
    
    [_clockSwitch setFrame:CGRectMake(self.view.frame.size.width - switchWidth - xMargin, yPos, switchWidth, switchHeight)];
    [_clockSwitch setOnTintColor:[UIColor textWhiteColor]];
    [_clockSwitch setThumbTintColor:[UIColor colorWithWhite:0.4f alpha:1.0f]];
    [_clockSwitch setTintColor:[UIColor colorWithWhite:0.4f alpha:1.0f]];
    [_clockSwitch addTarget:self action:@selector(clockSwitchTapped) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_clockSwitch];
    
    
    yPos += switchHeight + self.yGap;
    UIView* separatorView1 = [[UIView alloc] initWithFrame:CGRectMake(xMargin, yPos, self.view.frame.size.width - (2.0f * xMargin), self.verticalSeparatorHeight)];
    [separatorView1 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:kXSeparatorImage]]];
    [self.view addSubview:separatorView1];
    
    
    yPos += self.verticalSeparatorHeight + self.yGap;
    UILabel* tempoLabel = [[UILabel alloc] initWithFrame:CGRectMake(xMargin + 5.0f, yPos, 100.0f, switchHeight)];
    [tempoLabel setTextColor:[UIColor textWhiteColor]];
    [tempoLabel setFont:[UIFont lightDefaultFontOfSize:14.0f]];
    [tempoLabel setTextAlignment:NSTextAlignmentLeft];
    [tempoLabel setText:@"Tempo"];
    [self.view addSubview:tempoLabel];
    
    yPos += switchHeight;
    _tempoPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(xMargin, yPos, self.view.frame.size.width - (2.0f * xMargin), kTempoPickerHeight)];
    [_tempoPicker setBackgroundColor:[UIColor colorWithWhite:0.0f alpha:0.2f]];
    [_tempoPicker setDataSource:self];
    [_tempoPicker setDelegate:self];
    [self.view addSubview:_tempoPicker];
    
    
    yPos += kTempoPickerHeight + self.yGap;
    UIView* separatorView2 = [[UIView alloc] initWithFrame:CGRectMake(xMargin, yPos, self.view.frame.size.width - (2.0f * xMargin), self.verticalSeparatorHeight)];
    [separatorView2 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:kXSeparatorImage]]];
    [self.view addSubview:separatorView2];
    
    
    yPos += self.verticalSeparatorHeight + (2.0f * self.yGap);
    
    UILabel* meterLabel = [[UILabel alloc] initWithFrame:CGRectMake(xMargin + 5.0f, yPos, 100.0f, switchHeight)];
    [meterLabel setTextColor:[UIColor textWhiteColor]];
    [meterLabel setFont:[UIFont lightDefaultFontOfSize:14.0f]];
    [meterLabel setTextAlignment:NSTextAlignmentLeft];
    [meterLabel setText:@"Meter"];
    [self.view addSubview:meterLabel];
    
    _meterStepper = [[UIStepper alloc] initWithFrame:CGRectZero];
    
    float stepperWidth = _meterStepper.frame.size.width;
    float stepperHeight = _meterStepper.frame.size.height;
    
    [_meterStepper setFrame:CGRectMake(self.view.frame.size.width/2.0f, yPos, stepperWidth, stepperHeight)];
    [_meterStepper setMaximumValue:[[BMSequencer sharedSequencer] maximumMeter]];
    [_meterStepper setMinimumValue:[[BMSequencer sharedSequencer] minimumMeter]];
    [_meterStepper setContentMode:UIViewContentModeCenter];
    [_meterStepper setTintColor:[UIColor elementWhiteColor]];
    [_meterStepper addTarget:self action:@selector(meterStepperChanged) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_meterStepper];
    
    _meterStepperLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width - xMargin - 30.0f, yPos, 30.0f, stepperHeight)];
    [_meterStepperLabel setTextColor:[UIColor textWhiteColor]];
    [_meterStepperLabel setFont:[UIFont lightDefaultFontOfSize:14.0f]];
    [_meterStepperLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:_meterStepperLabel];
    
    
    yPos += stepperHeight + (2.0f * self.yGap);
    UILabel* intervalLabel = [[UILabel alloc] initWithFrame:CGRectMake(xMargin + 5.0f, yPos, 100.0f, switchHeight)];
    [intervalLabel setTextColor:[UIColor textWhiteColor]];
    [intervalLabel setFont:[UIFont lightDefaultFontOfSize:14.0f]];
    [intervalLabel setTextAlignment:NSTextAlignmentLeft];
    [intervalLabel setText:@"Interval"];
    [self.view addSubview:intervalLabel];
    
    NSArray* segments = [NSArray arrayWithObjects:@"1/4", @"1/8", @"1/16", @"1/32", nil];
    NSDictionary* attribute = [NSDictionary dictionaryWithObject:[UIFont lightDefaultFontOfSize:12.0f] forKey:NSFontAttributeName];
    
    _intervalSegment = [[UISegmentedControl alloc] initWithItems:segments];
    [_intervalSegment setFrame:CGRectMake(self.view.frame.size.width/2.0f - 30.0f, yPos, (self.view.frame.size.width / 2.0f) - xMargin + 30.0f, switchHeight)];
    [_intervalSegment setTitleTextAttributes:attribute forState:UIControlStateNormal];
    [_intervalSegment setTintColor:[UIColor elementWhiteColor]];
    [_intervalSegment setSelectedSegmentIndex:0];
    [_intervalSegment addTarget:self action:@selector(intervalSegmentChanged) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_intervalSegment];
    
    
    yPos += switchHeight + (2.0f * self.yGap);
    UILabel* quantizationLabel = [[UILabel alloc] initWithFrame:CGRectMake(xMargin + 5.0f, yPos, 100.0f, switchHeight)];
    [quantizationLabel setTextColor:[UIColor textWhiteColor]];
    [quantizationLabel setFont:[UIFont lightDefaultFontOfSize:14.0f]];
    [quantizationLabel setTextAlignment:NSTextAlignmentLeft];
    [quantizationLabel setText:@"Quantization"];
    [self.view addSubview:quantizationLabel];
    
    _quantizationSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
    [_quantizationSwitch setFrame:CGRectMake(self.view.frame.size.width - switchWidth - xMargin, yPos, switchWidth, switchHeight)];
    [_quantizationSwitch setOnTintColor:[UIColor textWhiteColor]];
    [_quantizationSwitch setThumbTintColor:[UIColor colorWithWhite:0.4f alpha:1.0f]];
    [_quantizationSwitch setTintColor:[UIColor colorWithWhite:0.4f alpha:1.0f]];
    [_quantizationSwitch addTarget:self action:@selector(quantSwitchTapped) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_quantizationSwitch];
    
    
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
    [_tempoView setTimeDuration:[[BMSequencer sharedSequencer] timeInterval_s]];
    [_meterStepper setValue:(int)meter];
    [_meterStepperLabel setText:[NSString stringWithFormat:@"%d", meter]];
    
    int interval = [[BMSequencer sharedSequencer] interval];
    [_intervalSegment setSelectedSegmentIndex:log2f(interval) - 2];
    
    [_quantizationSwitch setOn:[[BMSequencer sharedSequencer] quantization]];
    
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

- (void)quantSwitchTapped {
    [[BMSequencer sharedSequencer] setQuantization:_quantizationSwitch.isOn];
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
        [_tempoView setTimeDuration:[[BMSequencer sharedSequencer] timeInterval_s]];
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
