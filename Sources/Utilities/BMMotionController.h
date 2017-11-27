//
//  BMMotionController.h
//  BeMotion
//
//  Created by Govinda Ram Pingali on 10/4/17.
//  Copyright © 2017 Plasmatio Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BMMotionControllerDelegate <NSObject>
//- (void)attitudeUpdate:(float)pitch :(float)roll :(float)yaw;
- (void)attitudeUpdate:(float*)attitude;
- (void)xDirectionTrigger:(int)direction;
@end


@interface BMMotionController : NSObject

/* Returns shared instance of Motion Controller */
+ (instancetype)sharedController;

/* Motion Controller Delegate */
@property (nonatomic, weak) id <BMMotionControllerDelegate> motionDelegate;

/* Properties */
@property (nonatomic, readonly) BOOL isMotionControlRunning;
@property (nonatomic, assign) float xTriggerThreshold;

- (void)start;
- (void)stop;

@end
