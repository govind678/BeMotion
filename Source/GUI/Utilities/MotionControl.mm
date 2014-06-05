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


- (id)init {
    
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
        
        motion  =   new float [NUM_MOTION_PARAMS];
        
    }
    
    return self;
}



//--- Motion Processing Methods ---//

- (void) motionDeviceUpdate: (CMDeviceMotion*) deviceMotion
{
    motion[ATTITUDE_PITCH]  = (((deviceMotion.attitude.pitch + M_PI) / (2 * M_PI)) - 0.25f) * 2.0f;
    motion[ATTITUDE_ROLL]   = (deviceMotion.attitude.roll + M_PI) / (2 * M_PI);
    motion[ATTITUDE_YAW]    = (deviceMotion.attitude.yaw + M_PI) / (2 * M_PI);
    motion[ACCEL_X]         = deviceMotion.userAcceleration.x;
    motion[ACCEL_Y]         = deviceMotion.userAcceleration.y;
    motion[ACCEL_Z]         = deviceMotion.userAcceleration.z;
    
    [self processUserAcceleration:deviceMotion.userAcceleration];
    
    _backendInterface->motionUpdate(motion);
}




- (void)processUserAcceleration: (CMAcceleration) userAcceleration
{
    double amplitude = pow( (pow(userAcceleration.x, 2) + pow(userAcceleration.y, 2) + pow(userAcceleration.z, 2)), 0.5);
    
    if (amplitude > LIN_ACC_THRESHOLD || amplitude < -(LIN_ACC_THRESHOLD))
    {
        _backendInterface->startPlayback(4);
    }
}




- (void)dealloc {
    
    
    
    [super dealloc];
}

@end
