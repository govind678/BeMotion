//
//  Metronome.m
//  GestureController
//
//  Created by Govinda Ram Pingali on 4/9/14.
//  Copyright (c) 2014 GTCMT. All rights reserved.
//

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
        bar                 =   0;
        timeInterval_s      =   0.0f;
        
        delegate            =   self;
        
        [self updateTimer];
//        timer = [[NSTimer alloc] init];
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
    
    timer = [NSTimer scheduledTimerWithTimeInterval:timeInterval_s target:self selector:@selector(timerCallback) userInfo:nil repeats:YES];
    
    status  =   YES;
}


- (void) stopClock
{
    [timer invalidate];
    status  =   NO;
}




- (void) setTempo:(float)newTempo
{
    tempo = newTempo;
    [self updateTimer];
}


- (void) setMeter:(int)newMeter
{
    numerator = newMeter;
}


- (void) updateTimer
{
    timeInterval_s = 60.0f / (MAX_QUANTIZATION * tempo);
    if (status)
    {
        [self stopClock];
        [self startClock];
    }
}


- (void) timerCallback
{
    beat = (beat % numerator) + 1;
    [delegate beat: beat];
}


- (void) beat:(int)beatNo
{
    NSLog(@"Bad, Wrong place to Beat");
}


- (void)dealloc
{
//    [timer dealloc];
    
    [super dealloc];
}

@end
