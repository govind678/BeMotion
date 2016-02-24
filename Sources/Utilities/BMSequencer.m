//
//  BMSequencer.m
//  BeMotion
//
//  Created by Govinda Pingali on 2/18/16.
//  Copyright © 2016 Plasmatio Tech. All rights reserved.
//

#import "BMSequencer.h"
#import <mach/mach.h>
#import <mach/mach_time.h>

static const float kMinTempo                = 60.0f;
static const float kMaxTempo                = 240.0f;
static const float kDefaultTempo            = 140.0f;

static const int kMinInterval               = 4;
static const int kMaxInterval               = 16;
static const int kDefaultInterval           = 4;

static const int kMinMeter                  = 2;
static const int kMaxMeter                  = 16;
static const int kDefaultMeter              = 8;

static const NSUInteger kDefaultQuantization = 1; // 1 Bar


@interface BMSequencer()
{
    NSUInteger      _currentTick;
}
@end


@implementation BMSequencer

- (id)init {
    
    if (self = [super init]) {
        _tempo = kDefaultTempo;
        _meter = kDefaultMeter;
        _interval = kDefaultInterval;
        _quantization = kDefaultQuantization;
        _timeInterval = 4.0f * (60.0f / _tempo) / _interval;
    }
    
    return self;
}


#pragma mark - Singleton

+ (instancetype)sharedSequencer {
    static BMSequencer* sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[BMSequencer alloc] init];
    });
    
    return sharedInstance;
}

#pragma mark - Public Methods

- (void)startClock {
    if (!_isClockRunning) {
        _isClockRunning = YES;
        _currentTick = 0;
        [NSThread detachNewThreadSelector:@selector(runClock) toTarget:self withObject:nil];
    }
}

- (void)stopClock {
    _isClockRunning = NO;
    [_delegate tick:-1];
}

- (void)setMeter:(int)meter {
    if (meter < kMinMeter) {
        _meter = kMinMeter;
    } else if (meter > kMaxMeter) {
        _meter = kMaxMeter;
    } else {
        _meter = meter;
    }
}

- (void)setInterval:(int)interval {
    if (interval < kMinInterval) {
        _interval = kMinInterval;
    } else if (interval > kMaxInterval) {
        _interval = kMaxInterval;
    } else {
        _interval = interval;
    }
    
    _timeInterval = 4.0f * (60.0f / _tempo) / _interval;
}

- (void)setTempo:(float)tempo {
    if (tempo < kMinTempo) {
        _tempo = kMinTempo;
    } else if (tempo > kMaxTempo) {
        _tempo = kMaxTempo;
    } else {
        _tempo = tempo;
    }
    
    _timeInterval = 4.0f * (60.0f / _tempo) / _interval;
}

- (int)minimumInterval { return kMinInterval; }
- (int)maximumInterval { return kMaxInterval; }
- (int)minimumMeter { return kMinMeter; }
- (int)maximumMeter { return kMaxMeter; }
- (int)minimumTempo { return kMinTempo; }
- (int)maximumTempo { return kMaxTempo; }


- (NSUInteger)nextTriggerCount {
    if (_quantization == 1) { // 1 bar
        return 0;
    } else if (_quantization == 2) {
        
        return ((int)((_meter - _currentTick) / (_meter / 2.0f)) * (_meter / 2.0f));
        
    } else if (_quantization == 3) {
        
        return ((int)((_meter - _currentTick) / (_meter / 4.0f)) * (_meter / 4.0f));
        
    } else {
        return -1;
    }
}


#pragma mark - Private Methods

- (uint64_t) computeTimeInterval {
    // The default interval we're working with is 1 second (1 billion nanoseconds)
    uint64_t interval = 1000 * 1000 * 1000;
    
    // We find what fraction of a second the tempo really is. For example, a tempo of 60
    // would be 60/60 == 1 second, a tempo of 61 would be 60/61 == 0.984, etc.
    double intervalFraction = 60.0f / _tempo;
    
    // Turn this back into nanoseconds
    interval = (uint64_t)(interval * intervalFraction);
    
    return interval;
}


- (void)runClock {
    
    uint64_t interval = [self computeTimeInterval];
    
    mach_timebase_info_data_t info;
    mach_timebase_info(&info);
    
    uint64_t currentTime = mach_absolute_time();
    currentTime *= info.numer;
    currentTime /= info.denom;
    
    uint64_t nextTime = currentTime;
    
    
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    
    while (_isClockRunning) {
        
        if (currentTime >= nextTime) {
            
            NSUInteger tick = _currentTick;
            
            dispatch_async(mainQueue, ^{
                [_delegate tick:tick];
            });
            
            _currentTick = (_currentTick + 1) % _meter;
            interval = [self computeTimeInterval];
            nextTime += interval / (_interval / 4);
        }
        
        currentTime = mach_absolute_time();
        currentTime *= info.numer;
        currentTime /= info.denom;
    }
}


@end
