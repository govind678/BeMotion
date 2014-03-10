//
//  TransducerMusicViewController.m
//  TransducerMusic
//
//  Created by Govinda Ram Pingali on 11/10/13.
//  Copyright (c) 2013 GTCMT. All rights reserved.
//

#import "TransducerMusicViewController.h"

#define SAMPLING_RATE 0.1
#define IPHONE  0

@interface TransducerMusicViewController ()

@end

@implementation TransducerMusicViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	
    
    // iPod     : 6787, 6786
    // iPhone   : 6789, 6788
    
    osc =[[OSCCom alloc] init];
    
#if IPHONE
    [osc initialize: @"10.0.0.9" : 6789];
#else
    [osc initialize: @"10.0.0.9" : 6787];
#endif
    
    
    self.motionManager = [[CMMotionManager alloc] init];
    self.motionManager.deviceMotionUpdateInterval = SAMPLING_RATE;
    
    
    [self.motionManager startDeviceMotionUpdatesToQueue: [NSOperationQueue currentQueue]
                                            withHandler:^ (CMDeviceMotion *deviceMotion, NSError *error) {
                                                [self motionDeviceUpdate:deviceMotion];
                                                if(error){
                                                    NSLog(@"%@", error);
                                                }
                                            }];
    
    
    blackColour = [self colorFromHexString:@"#000000"];
    redColour = [self colorFromHexString:@"#420000"];
    greenColour = [self colorFromHexString:@"#004200"];
    blueColour = [self colorFromHexString:@"#000042"];
    yellowColour = [self colorFromHexString:@"#424200"];
}



//--- Motion Processing Methods ---//

- (void) motionDeviceUpdate: (CMDeviceMotion*) deviceMotion
{

    double attitude[3];
    
    attitude[0] = deviceMotion.attitude.roll;
    attitude[1] = deviceMotion.attitude.pitch;
    attitude[2] = deviceMotion.attitude.yaw;
    [osc sendFloat:@"/attitude" : attitude : 3];
    
    
    double acceleration[3];
    
    acceleration[0] = deviceMotion.userAcceleration.x;
    acceleration[1] = deviceMotion.userAcceleration.y;
    acceleration[2] = deviceMotion.userAcceleration.z;
    [self processUserAcceleration:deviceMotion.userAcceleration];
    [osc sendFloat:@"/acceleration" : acceleration : 3];
    
    
    double quaternion[4];
    
    quaternion[0] = deviceMotion.attitude.quaternion.w;
    quaternion[1] = deviceMotion.attitude.quaternion.x;
    quaternion[2] = deviceMotion.attitude.quaternion.y;
    quaternion[3] = deviceMotion.attitude.quaternion.z;
    [osc sendFloat:@"/quaternion" : quaternion : 4];
    
    
    double rotationRate[3];
    rotationRate[0] = deviceMotion.rotationRate.x;
    rotationRate[1] = deviceMotion.rotationRate.y;
    rotationRate[2] = deviceMotion.rotationRate.z;
    [osc sendFloat:@"/rotationRate" : rotationRate : 3];
    
    
    double gravity[3];
    gravity[0] = deviceMotion.gravity.x;
    gravity[1] = deviceMotion.gravity.y;
    gravity[2] = deviceMotion.gravity.z;
    [osc sendFloat:@"/gravity" : gravity : 3];

}


- (void)processUserAcceleration: (CMAcceleration) userAcceleration
{
    // iPhone   : 10
    // iPod     : 9
    double threshold;
    
#if IPHONE
    threshold = 10;
#else
    threshold = 10;
#endif
    
    
    double amplitude = pow( (pow(userAcceleration.x, 2) + pow(userAcceleration.y, 2) + pow(userAcceleration.z, 2)), 0.5);
    
    if (amplitude > threshold || amplitude < -threshold) {
        [osc sendBang:@"/trigger"];
    }
}





//--- UI Action Methods ---//

- (UIColor*)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
    
}


- (IBAction)redButtonDown:(UIButton *)sender {
    self.view.backgroundColor = redColour;
    [osc sendToggle:@"/red" : true];
}


- (IBAction)redButtonUp:(UIButton *)sender {
    self.view.backgroundColor = blackColour;
    [osc sendToggle:@"/red" : false];
}


- (IBAction)greenButtonDown:(UIButton *)sender {
    self.view.backgroundColor = greenColour;
    [osc sendToggle:@"/green" : true];
}


- (IBAction)greenButtonUp:(UIButton *)sender {
    self.view.backgroundColor = blackColour;
    [osc sendToggle:@"/green" : false];
}


- (IBAction)blueButtonDown:(id)sender {
    self.view.backgroundColor = blueColour;
    [osc sendToggle:@"/blue" : true];
}


- (IBAction)blueButtonUp:(UIButton *)sender {
    self.view.backgroundColor = blackColour;
    [osc sendToggle:@"/blue" : false];
}


- (IBAction)yellowButtonDown:(UIButton *)sender {
    self.view.backgroundColor = yellowColour;
    [osc sendToggle:@"/yellow" : true];
}


- (IBAction)yellowButtonUp:(UIButton *)sender {
    self.view.backgroundColor = blackColour;
    [osc sendToggle:@"/yellow" : false];
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



@end
