//
//  GlobalSettingsViewController.m
//  GestureController
//
//  Created by Govinda Ram Pingali on 4/10/14.
//  Copyright (c) 2014 GTCMT. All rights reserved.
//

#import "GlobalSettingsViewController.h"

@interface GlobalSettingsViewController ()

@end

@implementation GlobalSettingsViewController

@synthesize tempoLabel, tempoSlider;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    m_iTempo    = [_metronome getTempo];
    
    [tempoLabel setText:[@(m_iTempo) stringValue]];
    [tempoSlider setValue:m_iTempo];
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

- (void)dealloc
{
    [tempoSlider release];
    [tempoLabel release];
    
    [super dealloc];
}


- (IBAction)tempoSliderChanged:(UISlider *)sender
{
    m_iTempo = sender.value;
    
    [_metronome setTempo:m_iTempo];
    [tempoLabel setText:[@(m_iTempo) stringValue]];
}


@end
