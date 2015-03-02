//
//  BMLoginViewController.m
//  BeMotion
//
//  Created by Govinda Pingali on 2/27/15.
//  Copyright (c) 2015 BeatMotion. All rights reserved.
//

#import "BMLoginViewController.h"
#import <TwitterKit/TwitterKit.h>
#import "UIFont+Additions.h"

@interface BMLoginViewController ()
{
    UIButton*   backButton;
}

@end

@implementation BMLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    DGTAuthenticateButton *authenticateButton = [DGTAuthenticateButton buttonWithAuthenticationCompletion:^(DGTSession *session, NSError *error) {
        // play with Digits session
    }];
    authenticateButton.center = self.view.center;
    [self.view addSubview:authenticateButton];
    
    backButton = [[UIButton alloc] initWithFrame:CGRectMake(10.0f, 10.0f, 30.0f, 30.0f)];
    [backButton setTitle:@"Back" forState:UIControlStateNormal];
    [backButton.titleLabel setFont:[UIFont lightDefaultFontOfSize:12.0f]];
    [backButton addTarget:self action:@selector(backButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) backButtonTapped {
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
