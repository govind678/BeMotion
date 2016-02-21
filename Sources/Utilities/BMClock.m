//
//  BMClock.m
//  BeMotion
//
//  Created by Govinda Pingali on 2/18/16.
//  Copyright © 2016 Plasmatio Tech. All rights reserved.
//

#import "BMClock.h"

static const float kDefaultTempo    = 120.0f;
static const int kDefaultMeter      = 4;
static const int kDefaultInterval   = 4;

@implementation BMClock

- (id)init {
    
    if (self = [super init]) {
        _tempo = kDefaultTempo;
        _meter = kDefaultMeter;
        _interval = kDefaultInterval;
    }
    
    return self;
}


#pragma mark - Singleton

+ (instancetype)sharedClock {
    static BMClock* sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[BMClock alloc] init];
    });
    
    return sharedInstance;
}

#pragma mark - Public Methods

- (void)start {
    _isRunning = YES;
}

- (void)stop {
    _isRunning = NO;
}

@end
