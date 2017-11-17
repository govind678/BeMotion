//
//  ViewController.m
//  BeMotion
//
//  Created by Govinda Pingali on 2/14/16.
//  Copyright © 2016 Plasmatio Tech. All rights reserved.
//

#import "BMViewController.h"

static NSString* const kBackgroundImageName     =   @"Background.png";

static const float kMargin              = 13.0f;
static const float kHeaderHeight        = 30.0f;
static const float kButtonHeight        = 44.0f;
static const float kOptionButtonSize    = 53.0f;
static const float kYGap                = 14.0f;
static const float kSeparatorHeight     = 2.0f;

@interface BMViewController ()

@end

@implementation BMViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _headerHeight = kHeaderHeight;
    _margin = kMargin;
    _optionButtonSize = kOptionButtonSize;
    _yGap = kYGap;
    _verticalSeparatorHeight = kSeparatorHeight;
    _buttonHeight = kButtonHeight;
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:kBackgroundImageName]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
