//==============================================================================
//
//  GestureControllerAppDelegate.h
//  GestureController
//
//  Created by Govinda Ram Pingali on 3/8/14.
//  Copyright (c) 2014 GTCMT. All rights reserved.
//
//==============================================================================


#import <UIKit/UIKit.h>
#include "GestureControllerInterface.h"
#import "Metronome.h"

@interface GestureControllerAppDelegate : UIResponder <UIApplicationDelegate>
{
    GestureControllerInterface*     backendInterface;
    Metronome*                      metronome;
}

@property (strong, nonatomic) UIWindow *window;

- (GestureControllerInterface*)getBackendReference;
- (Metronome*)getMetronomeReference;

@end
