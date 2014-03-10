//
//  SettingsViewController.m
//  GestureController
//
//  Created by Govinda Ram Pingali on 11/13/13.
//  Copyright (c) 2013 GTCMT. All rights reserved.
//

#import "SettingsViewController.h"

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
    
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)masterGain:(UISlider *)sender
{
    double gain[] = {sender.value};
//    [osc sendFloat:@"/masterGain" : gain : 1];
}


- (IBAction)audioToggle:(UISwitch *)sender
{
    if (sender.on)
    {
//        [osc sendToggle:@"/master" :true];
    } else
    {
//        [osc sendToggle:@"/master" :false];
    }
}




- (void)dealloc
{
    
    //    [_toggleAudioButton release];
    
    //    delete backEndInterface;
    
    
    //    [_removeEffectButton release];
    
    [super dealloc];
    
}



@end
