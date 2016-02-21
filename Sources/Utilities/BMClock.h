//
//  BMClock.h
//  BeMotion
//
//  Created by Govinda Pingali on 2/18/16.
//  Copyright © 2016 Plasmatio Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BMClock : NSObject

/* Returns shared instance of Metronome */
+ (instancetype)sharedClock;

- (void)start;
- (void)stop;

@property (nonatomic, readonly) BOOL isRunning;
@property (nonatomic, assign) float tempo;
@property (nonatomic, assign) int meter;
@property (nonatomic, assign) int interval;

@end
