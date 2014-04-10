//
//  Metronome.h
//  GestureController
//
//  Created by Govinda Ram Pingali on 4/9/14.
//  Copyright (c) 2014 GTCMT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Metronome : NSObject
{
    float   tempo;
    int     numerator;
    BOOL    status;
    
    int         beat;
    int         bar;
    double      timeInterval_s;
    
    NSTimer*    timer;
    
    id          delegate;
}


- (void) startClock;
- (void) stopClock;


- (void) setTempo           :   (float) newTempo;
- (void) setMeter           :   (int)   newMeter;

- (void) updateTimer;

- (void) timerCallback;

- (void) setDelegate        :   (id) newDelegate;
- (void) beat               :   (int) beatNo;


@end
