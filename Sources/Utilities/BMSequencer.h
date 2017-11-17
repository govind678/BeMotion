//
//  BMSequencer.h
//  BeMotion
//
//  Created by Govinda Pingali on 2/18/16.
//  Copyright © 2016 Plasmatio Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^BMSequencerBlock)(void);

@protocol BMSequencerDelegate <NSObject>

- (void)tick:(NSUInteger)count;

@end


@interface BMSequencer : NSObject

/* Returns shared instance of Metronome */
+ (instancetype)sharedSequencer;

- (void)startClock;
- (void)stopClock;

- (int)minimumInterval;
- (int)maximumInterval;
- (int)minimumMeter;
- (int)maximumMeter;
- (int)minimumTempo;
- (int)maximumTempo;

- (void)sequenceEvent:(BMSequencerBlock)block withCompletion:(BMSequencerBlock)completionBlock;

@property (nonatomic, readonly) BOOL isClockRunning;
@property (nonatomic, assign) float tempo;
@property (nonatomic, assign) int meter;
@property (nonatomic, assign) int interval;
@property (nonatomic, assign) BOOL quantization;
@property (nonatomic, readonly) float timeInterval_s;

@property (nonatomic, weak) id <BMSequencerDelegate> delegate;

@end
