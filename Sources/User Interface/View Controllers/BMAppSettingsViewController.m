//
//  BMAppSettingsViewController.m
//  BeMotion
//
//  Created by Govinda Ram Pingali on 11/14/17.
//  Copyright © 2017 Plasmatio Tech. All rights reserved.
//

#import "BMAppSettingsViewController.h"
#import "BMSettings.h"
#import "BMConstants.h"

@interface BMAppSettingsViewController ()
{
    BMHeaderView*           _headerView;
    UISwitch*               _drawWaveformSwitch;
}

@end

@implementation BMAppSettingsViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    float xMargin = self.margin;
    float yPos = self.margin;
    
    // Header
    _headerView = [[BMHeaderView alloc] initWithFrame:CGRectMake(xMargin, yPos, self.view.frame.size.width - (2.0f * xMargin), self.headerHeight)];
    [_headerView setTitle:@"App Settings"];
    [_headerView addTarget:self action:@selector(backButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_headerView];
    
    
    // Waveform View Switch
    _drawWaveformSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
    
    float switchWidth = _drawWaveformSwitch.frame.size.width;
    float switchHeight = _drawWaveformSwitch.frame.size.height;
    yPos += self.headerHeight + (2.0f * self.yGap);
    
    UILabel* waveformLabel = [[UILabel alloc] initWithFrame:CGRectMake(xMargin + 5.0f, yPos, 180.0f, switchHeight)];
    [waveformLabel setTextColor:[UIColor textWhiteColor]];
    [waveformLabel setFont:[UIFont lightDefaultFontOfSize:14.0f]];
    [waveformLabel setTextAlignment:NSTextAlignmentLeft];
    [waveformLabel setText:@"Draw Waveforms"];
    [self.view addSubview:waveformLabel];
    
    [_drawWaveformSwitch setFrame:CGRectMake(self.view.frame.size.width - switchWidth - xMargin, yPos, switchWidth, switchHeight)];
    [_drawWaveformSwitch setOnTintColor:[UIColor textWhiteColor]];
    [_drawWaveformSwitch setThumbTintColor:[UIColor colorWithWhite:0.4f alpha:1.0f]];
    [_drawWaveformSwitch setTintColor:[UIColor colorWithWhite:0.4f alpha:1.0f]];
    [_drawWaveformSwitch addTarget:self action:@selector(drawWaveformSwitchTapped) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_drawWaveformSwitch];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_drawWaveformSwitch setOn:[[BMSettings sharedInstance] shouldDrawWaveform]];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UIActions

- (void)backButtonTapped {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)drawWaveformSwitchTapped {
    [[BMSettings sharedInstance] setShouldDrawWaveform:_drawWaveformSwitch.isOn];
}

@end
