//
//  MotionControl.h
//  BeMotion
//
//  Created by Govinda Ram Pingali on 6/4/14.
//  Copyright (c) 2014 BeMotionLLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>
#include "BeMotionInterface.h"

#include "Macros.h"

@interface MotionControl : NSObject {
    
    float*                          motion;
    
}

@property (nonatomic, assign) BeMotionInterface*  backendInterface;
@property (strong, nonatomic) CMMotionManager *motionManager;
@property (nonatomic, assign) id  delegate;

- (void)motionDeviceUpdate: (CMDeviceMotion*) deviceMotion;
- (void)processUserAcceleration: (CMAcceleration) userAcceleration;

@end
