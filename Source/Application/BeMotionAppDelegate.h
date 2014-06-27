//==============================================================================
//
//  BeMotionAppDelegate.h
//  BeMotion
//
//  Created by Govinda Ram Pingali on 3/8/14.
//  Copyright (c) 2014 BeMotionLLC. All rights reserved.
//
//==============================================================================


#import <UIKit/UIKit.h>
#include "BeMotionInterface.h"
#import "Metronome.h"

@interface BeMotionAppDelegate : UIResponder <UIApplicationDelegate>
{
    BeMotionInterface*              backendInterface;
    Metronome*                      metronome;
    
    NSMutableDictionary*            sampleSets;
    NSMutableArray*                 fxPacks;
}

@property (strong, nonatomic) UIWindow *window;

@property(strong, nonatomic) NSMutableDictionary* sampleSets;
@property(strong, nonatomic) NSMutableArray* fxPacks;

- (BeMotionInterface*)getBackendReference;
- (Metronome*)getMetronomeReference;

@end
