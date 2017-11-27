//
//  BMMotionController.m
//  BeMotion
//
//  Created by Govinda Ram Pingali on 10/4/17.
//  Copyright © 2017 Plasmatio Tech. All rights reserved.
//

#import "BMMotionController.h"
#import <CoreMotion/CoreMotion.h>
#import "BMConstants.h"

static int const kUserAccelerationBlockSize = 20;
static float const kUserAccelerationXThreshold = 1.8f;

@interface BMMotionController()
{
    CMMotionManager*        _motionManager;
    NSOperationQueue*       _workQueue;
    
    float                  _currentAttitude[4];
    
    // User Acceleration Trigger
    int                     _currentState;
    BOOL                    _leftToggle;
    BOOL                    _rightToggle;
    int                     _currentFrameCount;
    CMAcceleration          _prevFrame;
}
@end


@implementation BMMotionController

- (id)init {
    
    if (self = [super init]) {
        
        _motionManager = [[CMMotionManager alloc] init];
        [_motionManager setDeviceMotionUpdateInterval:kDeviceMotionUpdateInterval];
        _workQueue = [[NSOperationQueue alloc] init];
        
        _currentAttitude[BMMotionMode_None] = 0.0f;
        _currentAttitude[BMMotionMode_Pitch] = 0.0f;
        _currentAttitude[BMMotionMode_Roll] = 0.0f;
        _currentAttitude[BMMotionMode_Yaw] = 0.0f;
        
        // User Acceleration Trigger
        _currentState = 0;
        _leftToggle = NO;
        _rightToggle = NO;
        _currentFrameCount = 0;
        _prevFrame.x = 0.0f;
        _prevFrame.y = 0.0f;
        _prevFrame.z = 0.0f;
        
        _isMotionControlRunning = NO;
        
        _xTriggerThreshold = kUserAccelerationXThreshold;
    }
    
    return self;
}


#pragma mark - Singleton

+ (instancetype)sharedController {
    
    static BMMotionController* sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    // CoreMotion must be initialized on the Main Thread
    dispatch_once(&onceToken, ^{
        sharedInstance = [[BMMotionController alloc] init];
    });
    
    return sharedInstance;
}


#pragma mark - Public Methods

- (void)start {
    
    CMAttitudeReferenceFrame referenceFrame = CMAttitudeReferenceFrameXArbitraryZVertical;

    [_motionManager startDeviceMotionUpdatesUsingReferenceFrame:referenceFrame
                                                        toQueue:_workQueue
                                                    withHandler:^(CMDeviceMotion * _Nullable motion, NSError * _Nullable error) {
                                                        [self motionDeviceUpdate:motion withError:error];

    }];
    
    _isMotionControlRunning = YES;
}

- (void)stop {
    [_motionManager stopDeviceMotionUpdates];
    _isMotionControlRunning = NO;
}

#pragma mark - Private Methods

- (void)motionDeviceUpdate:(CMDeviceMotion*)deviceMotion withError:(NSError*)error {
    
    if (error) {
        NSLog(@"Motion Device Update Error: %@", error);
        return;
    }
    
    int result = [self processUserAcceleration:deviceMotion.userAcceleration];
    if (result != 0) {
        if (_motionDelegate && [_motionDelegate respondsToSelector:@selector(xDirectionTrigger:)]) {
            [_motionDelegate xDirectionTrigger:result];
        }
    }
    
    
    _currentAttitude[BMMotionMode_Pitch] = (deviceMotion.attitude.pitch + M_PI_2) / M_PI;
//    _currentAttitude[BMMotionMode_Roll] = (deviceMotion.attitude.roll + (2.0f * M_PI)) / (2.0f * M_PI);
    _currentAttitude[BMMotionMode_Roll] = fabsf(sinf(deviceMotion.attitude.roll));
//    _currentAttitude[BMMotionMode_Yaw] = (deviceMotion.attitude.yaw + M_PI) / (2.0f * M_PI);
    _currentAttitude[BMMotionMode_Yaw] = 1.0f - ((cosf(deviceMotion.attitude.yaw) + 1.0f) / 2.0f);
    
//    if (_motionDelegate && [_motionDelegate respondsToSelector:@selector(attitudeUpdate:::)]) {
//        [_motionDelegate attitudeUpdate:_currentAttitude[BMMotionMode_Pitch] :_currentAttitude[BMMotionMode_Roll] :_currentAttitude[BMMotionMode_Yaw]];
//    }
    
    if (_motionDelegate && [_motionDelegate respondsToSelector:@selector(attitudeUpdate:)]) {
        [_motionDelegate attitudeUpdate:_currentAttitude];
    }
}


- (int)processUserAcceleration:(CMAcceleration)currentFrame {
    
    //    State:
    //      0: No state
    //      1: Enter Positive
    //      2 -> Exit Positive
    //      -1 -> Enter Negative
    //      -2 -> Exit Negative
    
    //    State Transition:
    //      Left:  0 -> 1 -> 2 -> -1 -> -2
    //      Right: 0 -> -1 -> -2 -> 1 -> 2
    
    
    float currentSample = currentFrame.x;
    float prevSample = _prevFrame.x;
    int result = 0;
    
    if ((currentSample < -_xTriggerThreshold) && (prevSample > -_xTriggerThreshold)) {
        _currentState = -1;
        if (_rightToggle == NO) {
            _leftToggle = YES;
            _currentFrameCount = kUserAccelerationBlockSize;
        }
    }
    
    else if ((currentSample > -_xTriggerThreshold) && (prevSample < -_xTriggerThreshold)) {
        _currentState = -2;
    }
    
    else if ((currentSample > _xTriggerThreshold) && (prevSample < _xTriggerThreshold)) {
        _currentState = 1;
        if (_leftToggle == NO) {
            _rightToggle = YES;
            _currentFrameCount = kUserAccelerationBlockSize;
        }
    }
    
    else if ((currentSample < _xTriggerThreshold) && (prevSample > _xTriggerThreshold)) {
        _currentState = 2;
    }
    
    else {
        _currentState = 0;
    }
    
    
    
    if (_leftToggle == YES) {
        if (_currentFrameCount > 0) {
            if (_currentState == 2) {
                _leftToggle = NO;
                _currentFrameCount = 0;
                result = 2;
            }
        } else if (_currentFrameCount == 0) {
            _leftToggle = NO;
        }
        _currentFrameCount--;
    }
    
    else if (_rightToggle == YES) {
        if (_currentFrameCount > 0) {
            if (_currentState == -2) {
                _rightToggle = NO;
                _currentFrameCount = 0;
                result = 1;
            }
        } else if (_currentFrameCount == 0) {
            _rightToggle = NO;
        }
        _currentFrameCount--;
    }
    
    _prevFrame = currentFrame;
    return result;
}

@end
