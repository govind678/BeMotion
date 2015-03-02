//
//  BMAppDelegate.h
//  BeatMotion
//
//  Created by Govinda Ram Pingali on 7/20/14.
//  Copyright (c) 2014 BeatMotion. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "BeatMotionInterface.h"
#import "Metronome.h"

@interface BMAppDelegate : UIResponder <UIApplicationDelegate>
{
    BeatMotionInterface*              backendInterface;
    Metronome*                      metronome;
    
    NSMutableDictionary*            sampleSets;
    NSMutableArray*                 fxPacks;
    NSMutableArray*                 fxTypes;
}

@property (strong, nonatomic) UIWindow *window;

@property(strong, nonatomic) NSMutableDictionary* sampleSets;
@property(strong, nonatomic) NSMutableArray* fxPacks;
@property(strong, nonatomic) NSMutableArray* fxTypes;

- (BeatMotionInterface*)getBackendReference;
- (Metronome*)getMetronomeReference;

@end
