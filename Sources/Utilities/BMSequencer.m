//
//  BMSequencer.m
//  BeMotion
//
//  Created by Govinda Pingali on 2/18/16.
//  Copyright © 2016 Plasmatio Tech. All rights reserved.
//

#import "BMSequencer.h"
#import "BMAudioController.h"
#import <mach/mach.h>
#import <mach/mach_time.h>

static const float kMinTempo                = 30.0f;
static const float kMaxTempo                = 480.0f;
static const float kDefaultTempo            = 140.0f;

static const int kMinInterval               = 4;
static const int kMaxInterval               = 32;
static const int kDefaultInterval           = 4;

static const int kMinMeter                  = 2;
static const int kMaxMeter                  = 16;
static const int kDefaultMeter              = 8;

static const BOOL kDefaultQuantization      = YES;


@interface BMSequencer()
{
    NSUInteger                  _currentTick;
    NSMutableArray*             _eventsArray;
    
    uint64_t                    _timeInterval_nanos;
}
@end


@implementation BMSequencer

- (id)init {
    
    if (self = [super init]) {
        _tempo = kDefaultTempo;
        _meter = kDefaultMeter;
        _interval = kDefaultInterval;
        _quantization = kDefaultQuantization;
        [self computeTimeIntervals];
        
        _eventsArray = [[NSMutableArray alloc] init];
//        _queue = dispatch_queue_create("Sequencer Queue", dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_CONCURRENT, QOS_CLASS_USER_INITIATED, 0));
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
    
    [self computeTimeIntervals];
}

- (void)setTempo:(float)tempo {
    if (tempo < kMinTempo) {
        _tempo = kMinTempo;
    } else if (tempo > kMaxTempo) {
        _tempo = kMaxTempo;
    } else {
        _tempo = tempo;
    }
    [[BMAudioController sharedController] setTempo:_tempo];
    
    [self computeTimeIntervals];
}

- (int)minimumInterval { return kMinInterval; }
- (int)maximumInterval { return kMaxInterval; }
- (int)minimumMeter { return kMinMeter; }
- (int)maximumMeter { return kMaxMeter; }
- (int)minimumTempo { return kMinTempo; }
- (int)maximumTempo { return kMaxTempo; }


- (void)sequenceEvent:(BMSequencerBlock)block withCompletion:(BMSequencerBlock)completionBlock {
    if (_isClockRunning && _quantization) {
        [_eventsArray addObject:block];
        [_eventsArray addObject:completionBlock];
    } else {
        block();
        completionBlock();
    }
}


#pragma mark - Private Methods

- (void)computeTimeIntervals {
    @synchronized(self) {
        // The default interval we're working with is 1 second (1 billion nanoseconds)
        _timeInterval_nanos = 1000 * 1000 * 1000;
        
        // We find what fraction of a second the tempo really is. For example, a tempo of 60
        // would be 60/60 == 1 second, a tempo of 61 would be 60/61 == 0.984, etc.
        // scale by the interval / denominator
        _timeInterval_s = (60.0f / _tempo) * (4.0f / _interval);
        
        // Turn this back into nanoseconds
        _timeInterval_nanos = (uint64_t)(_timeInterval_nanos * _timeInterval_s);
    }
}


- (void)runClock {
    
    [self computeTimeIntervals];
    
    mach_timebase_info_data_t   _timebaseInfo;
    mach_timebase_info(&_timebaseInfo);
    
    uint64_t currentTimestamp = mach_absolute_time();
    currentTimestamp *= _timebaseInfo.numer;
    currentTimestamp /= _timebaseInfo.denom;
    
    uint64_t nextTimestamp = currentTimestamp;
    
    
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    
    while (_isClockRunning) {
        
        if (currentTimestamp >= nextTimestamp) {
            
            NSUInteger tick = _currentTick;
            
            dispatch_async(mainQueue, ^{
                if (tick == 0) {
                    for (BMSequencerBlock block in _eventsArray) {
                        block();
                    }
                    [_eventsArray removeAllObjects];
                }
                [_delegate tick:tick];
            });
            
            _currentTick = (_currentTick + 1) % _meter;
            nextTimestamp += _timeInterval_nanos;
        }
        
        currentTimestamp = mach_absolute_time();
        currentTimestamp *= _timebaseInfo.numer;
        currentTimestamp /= _timebaseInfo.denom;
    }
}


@end
