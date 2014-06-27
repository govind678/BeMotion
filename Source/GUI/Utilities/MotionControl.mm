//
//  MotionControl.m
//  BeMotion
//
//  Created by Govinda Ram Pingali on 6/4/14.
//  Copyright (c) 2014 BeMotionLLC. All rights reserved.
//

#import "MotionControl.h"
#import "BeMotionAppDelegate.h"


@interface MotionControl ()
{
    BeMotionAppDelegate*   appDelegate;
}
@end




@implementation MotionControl

@synthesize motionManager, delegate;


- (id)init
{
    
    if (self = [super init]) {
        
        
        //--- Get Reference to Backend ---//
        appDelegate = [[UIApplication sharedApplication] delegate];
        _backendInterface   =  [appDelegate getBackendReference];
        
        
        
        //--- Motion Manager ---//
        
        self.motionManager = [[CMMotionManager alloc] init];
        self.motionManager.deviceMotionUpdateInterval = MOTION_UPDATE_RATE;
        
        
        [self.motionManager startDeviceMotionUpdatesToQueue: [NSOperationQueue currentQueue]
                                                withHandler:^ (CMDeviceMotion *deviceMotion, NSError *error) {
                                                    [self motionDeviceUpdate:deviceMotion];
                                                    if(error){
                                                        NSLog(@"%@", error);
                                                    }
                                                }];
        
        motion          =   new float [NUM_MOTION_PARAMS];
        amplitude       =   0.0f;
        lowpass         =   0.0f;
        kLowpass        =   0.1f;
        decayCounter    =   0;
        decayToggle     =   false;
    }
    
    return self;
}



//--- Motion Processing Methods ---//

- (void) motionDeviceUpdate: (CMDeviceMotion*) deviceMotion
{
//    motion[ATTITUDE_PITCH]  = (((deviceMotion.attitude.pitch + M_PI) / (2 * M_PI)) - 0.25f) * 2.0f;
//    motion[ATTITUDE_ROLL]   = (deviceMotion.attitude.roll + M_PI) / (2 * M_PI);
//    motion[ATTITUDE_YAW]    = (deviceMotion.attitude.yaw + M_PI) / (2 * M_PI);
//    motion[ACCEL_X]         = deviceMotion.userAcceleration.x;
//    motion[ACCEL_Y]         = deviceMotion.userAcceleration.y;
//    motion[ACCEL_Z]         = deviceMotion.userAcceleration.z;
    
//    motion[ATTITUDE_PITCH]  = (((deviceMotion.attitude.pitch + M_PI) / (2 * M_PI)) - 0.25f) * 2.0f;
    motion[ATTITUDE_PITCH]  = (deviceMotion.attitude.pitch + 1.0f) * 0.5f;
//    motion[ATTITUDE_ROLL]   = (deviceMotion.attitude.roll + M_PI) / (2 * M_PI);
    
    if (deviceMotion.attitude.roll > M_PI_4) {
        motion[ATTITUDE_ROLL]   = 1.25f - (deviceMotion.attitude.roll * M_1_PI);
    } else if (deviceMotion.attitude.roll < -0.15f) {
        motion[ATTITUDE_ROLL]   = (deviceMotion.attitude.roll * M_1_PI * -1.0f) - 0.25f;
    } else {
        motion[ATTITUDE_ROLL]   = 0.0f;
    }
    
    motion[ATTITUDE_YAW]    = (deviceMotion.attitude.yaw + M_PI) / (2 * M_PI);
    motion[ACCEL_X]         = deviceMotion.userAcceleration.x;
    motion[ACCEL_Y]         = deviceMotion.userAcceleration.y;
    motion[ACCEL_Z]         = deviceMotion.userAcceleration.z;
    
    
    [self processUserAcceleration:deviceMotion.userAcceleration];
    
    _backendInterface->motionUpdate(motion);

}




- (void)processUserAcceleration: (CMAcceleration) userAcceleration
{
//    amplitude = pow( (pow(userAcceleration.x, 2) + pow(userAcceleration.y, 2) + pow(userAcceleration.z, 2)), 0.5);
    amplitude = userAcceleration.x;
//    lowpass  = ((1.0f - kLowpass) * amplitude) + (kLowpass * lowpass);
    
//    NSLog(@"%f \t %f",amplitude, highpass);
//    std::cout << amplitude << std::endl;
    
//    if (amplitude > LIN_ACC_THRESHOLD || amplitude < -(LIN_ACC_THRESHOLD))
//    {
//        _backendInterface->startPlayback(4);
//    }
    
    if (amplitude > LIN_ACC_THRESHOLD) {
        
        if (decayCounter == 0) {
//            std::cout << "Positive" << std::endl;
            _backendInterface->startPlayback(4);
            decayToggle = true;
            decayCounter++;
        }
    }
    
    else if (amplitude < -LIN_ACC_THRESHOLD) {
        
        if (decayCounter == 0) {
//            std::cout << "Negative" << std::endl;
            _backendInterface->startPlayback(5);
            decayToggle = true;
            decayCounter++;
        }
        
    }
    
    
    if (decayToggle) {
        
        if (decayCounter >= (LIN_ACC_DECAY / MOTION_UPDATE_RATE)) {
            decayToggle = false;
            decayCounter = 0;
        }
        
        else {
            decayCounter++;
        }
    }
    
}




- (void)dealloc {
    
    delete [] motion;
    
    [super dealloc];
}

@end
