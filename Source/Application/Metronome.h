//==============================================================================
//
//  Metronome.h
//  BeMotion
//
//  Created by Govinda Ram Pingali on 4/9/14.
//  Copyright (c) 2014 BeMotionLLC. All rights reserved.
//
//==============================================================================


#import <Foundation/Foundation.h>
#include "BeMotionInterface.h"

@interface Metronome : NSObject
{
    float   tempo;
    int     numerator;
    BOOL    status;
    
    int         beat;
    int         guiBeat;
    int         bar;
    double      timeInterval_s;
    
    NSTimer*    timer;
    
    id          delegate;
    
    BeMotionInterface*              backendInterface;
    
}


- (void) startClock;
- (void) stopClock;


- (void) setTempo           :   (float) newTempo;
- (float)getTempo;
- (void) setMeter           :   (int)   newMeter;

- (void) updateTimer;

- (void) timerCallback;

- (void) setDelegate        :   (id) newDelegate;
- (void) beat               :   (int) beatNo;
- (void) guiBeat            :   (int) beatNo;

- (BOOL) isRunning;

- (void)setBackendReference :   (BeMotionInterface*)interface;



@end
