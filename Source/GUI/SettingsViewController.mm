//
//  SettingsViewController.m
//  TransducerMusic
//
//  Created by Govinda Ram Pingali on 11/13/13.
//  Copyright (c) 2013 GTCMT. All rights reserved.
//

#import "SettingsViewController.h"
#define IPHONE 0

@interface SettingsViewController ()

@end

@implementation SettingsViewController

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
    
    // iPod     : 6786
    // iPhone   : 6788
    
    osc =[[OSCCom alloc] init];
#if IPHONE
    [osc initialize: @"10.0.0.9" : 6788];
#else
    [osc initialize: @"10.0.0.9" : 6786];
#endif
    
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)masterGain:(UISlider *)sender {
    double gain[] = {sender.value};
    [osc sendFloat:@"/masterGain" : gain : 1];
}


- (IBAction)audioToggle:(UISwitch *)sender {
    if (sender.on) {
        [osc sendToggle:@"/master" :true];
    } else {
        [osc sendToggle:@"/master" :false];
    }
}






@end
