//==============================================================================
//
//  Metronome.h
//  BeMotion
//
//  Created by Govinda Ram Pingali on 4/9/14.
//  Copyright (c) 2014 BeMotionLLC. All rights reserved.
//
//==============================================================================


#import "Metronome.h"
#import "Macros.h"


@implementation Metronome


- (id) init
{
    if (self = [super init])
    {
        tempo               =   DEFAULT_TEMPO;
        numerator           =   DEFAULT_NUMERATOR;
        status              =   NO;
        
        beat                =   0;
        guiBeat             =   0;
        bar                 =   0;
        timeInterval_s      =   0.0f;
        
        delegate            =   self;
        
        [self updateTimer];
    }
    
    return self;
}


- (void) setDelegate:(id)newDelegate
{
    delegate = newDelegate;
}


- (void) startClock
{
    beat    = 0;
    bar     = 0;
    guiBeat = 0;
    
    timer = [NSTimer scheduledTimerWithTimeInterval:timeInterval_s target:self selector:@selector(timerCallback) userInfo:nil repeats:YES];
    
    status  =   YES;
    
    [self timerCallback];
}


- (void) stopClock
{
    [timer invalidate];
    status  =   NO;
}




- (void) setTempo:(float)newTempo
{
    tempo = newTempo;
    [delegate setTempo: tempo];
    [self updateTimer];
}

- (float) getTempo
{
    return tempo;
}

- (void) setMeter:(int)newMeter
{
    numerator = newMeter;
}


- (void) updateTimer
{
    timeInterval_s = 60.0f / (powf(2, MAX_QUANTIZATION) * tempo);
    if (status)
    {
        [self stopClock];
        [self startClock];
    }
}


- (void) timerCallback
{
    beat = (beat % numerator) + 1;
//    [delegate beat: beat];
    
    backendInterface->beat(beat);
    
    if (((beat - 1) % GUI_METRO_COUNT) == 0)
    {
        guiBeat = (guiBeat % GUI_METRO_COUNT) + 1;
        [delegate guiBeat: guiBeat];
    }
}


- (void) beat:(int)beatNo
{
    NSLog(@"Bad, Wrong place to Beat");
}

- (void)guiBeat:(int)beatNo
{
    NSLog(@"Bad, Wrong place to Beat");
}

- (BOOL)isRunning
{
    return status;
}

- (void)dealloc
{
//    [timer dealloc];
    
    [super dealloc];
}


- (void)setBackendReference:(BeMotionInterface*)interface
{
    backendInterface = interface;
}

@end
