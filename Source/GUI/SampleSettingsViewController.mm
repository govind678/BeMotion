//
//  SampleSettingsViewController.m
//  GestureController
//
//  Created by Govinda Ram Pingali on 4/28/14.
//  Copyright (c) 2014 GTCMT. All rights reserved.
//

#import "SampleSettingsViewController.h"

@interface SampleSettingsViewController ()

@end

@implementation SampleSettingsViewController

@synthesize m_iSampleID;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (m_iSampleID == 0)
    {
        [[self view] setBackgroundColor:[UIColor colorWithRed:0.4f green:0.0f blue:0.0f alpha:1.0f]];
    }
    
    else if (m_iSampleID == 1)
    {
        [[self view] setBackgroundColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.4f alpha:1.0f]];
    }
    
    else if (m_iSampleID == 2)
    {
        [[self view] setBackgroundColor:[UIColor colorWithRed:0.0f green:0.4f blue:0.0f alpha:1.0f]];
    }
    
    else if (m_iSampleID == 3)
    {
        [[self view] setBackgroundColor:[UIColor colorWithRed:0.4f green:0.4f blue:0.0f alpha:1.0f]];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
