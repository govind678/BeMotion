//
//  MotionControl.h
//  BeatMotion
//
//  Created by Govinda Ram Pingali on 6/4/14.
//  Copyright (c) 2014 PlasmatioTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>
#include "BeatMotionInterface.h"

#include "Macros.h"

@interface MotionControl : NSObject {
    
    float*                          motion;
    
    float                           amplitude;
    float                           lowpass;
    float                           kLowpass;
    
    bool                            decayToggle;
    int                             decayCounter;
    
}

@property (nonatomic, assign) BeatMotionInterface*  backendInterface;
@property (strong, nonatomic) CMMotionManager *motionManager;
@property (nonatomic, assign) id  delegate;

- (void)motionDeviceUpdate: (CMDeviceMotion*) deviceMotion;
- (void)processUserAcceleration: (CMAcceleration) userAcceleration;

@end
