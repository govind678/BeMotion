//==============================================================================
//
//  Metronome.h
//  BeatMotion
//
//  Created by Govinda Ram Pingali on 4/9/14.
//  Copyright (c) 2014 PlasmatioTech. All rights reserved.
//
//==============================================================================


#import <Foundation/Foundation.h>
#include "BeatMotionInterface.h"

@interface Metronome : NSObject
{
    int     tempo;
    int     numerator;
    BOOL    status;
    
    int         beat;
    int         guiBeat;
    int         bar;
    double      timeInterval_s;
    
    NSTimer*    timer;
    
    id          delegate;
    
    BeatMotionInterface*              backendInterface;
    
}


- (void) startClock;
- (void) stopClock;


- (void) setTempo           :   (int) newTempo;
- (int) getTempo;
- (void) setMeter           :   (int)   newMeter;

- (void) updateTimer;

- (void) timerCallback;

- (void) setDelegate        :   (id) newDelegate;
- (void) beat               :   (int) beatNo;
- (void) guiBeat            :   (int) beatNo;

- (BOOL) isRunning;

- (void)setBackendReference :   (BeatMotionInterface*)interface;



@end
