//
//  ViewController.m
//  BeMotion
//
//  Created by Govinda Pingali on 2/14/16.
//  Copyright © 2016 Plasmatio Tech. All rights reserved.
//

#import "BMViewController.h"

static NSString* const kBackgroundImageName     =   @"Background.png";

static const float kMargin              = 20.0f;
static const float kHeaderHeight        = 40.0f;

@interface BMViewController ()

@end

@implementation BMViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _headerHeight = kHeaderHeight;
    _margin = kMargin;
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:kBackgroundImageName]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
