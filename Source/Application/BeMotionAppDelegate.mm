//==============================================================================
//
//  BeMotionAppDelegate.mm
//  BeMotion
//
//  Created by Govinda Ram Pingali on 3/8/14.
//  Copyright (c) 2014 BeMotionLLC. All rights reserved.
//
//==============================================================================


#import "BeMotionAppDelegate.h"

@implementation BeMotionAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    backendInterface    =   new BeMotionInterface();
    
    
    
    //--- Preload Audio Samples ---//
    NSString *sample1Path = [[NSBundle mainBundle] pathForResource:@"E_Kit0" ofType:@"wav"];
    NSString *sample2Path = [[NSBundle mainBundle] pathForResource:@"E_Kit1" ofType:@"wav"];
    NSString *sample3Path = [[NSBundle mainBundle] pathForResource:@"E_Kit2" ofType:@"wav"];
    NSString *sample4Path = [[NSBundle mainBundle] pathForResource:@"E_Kit3" ofType:@"wav"];
    NSString *sample5Path = [[NSBundle mainBundle] pathForResource:@"E_Kit4" ofType:@"wav"];
    
    
    backendInterface->loadAudioFile(0, sample1Path);
    backendInterface->loadAudioFile(1, sample2Path);
    backendInterface->loadAudioFile(2, sample3Path);
    backendInterface->loadAudioFile(3, sample4Path);
    backendInterface->loadAudioFile(4, sample5Path);
    
    
    metronome   =   [[Metronome alloc] init];
    [metronome setBackendReference:backendInterface];
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [metronome dealloc];
    delete backendInterface;
}

- (BeMotionInterface*)getBackendReference
{
    return backendInterface;
}

- (Metronome*)getMetronomeReference
{
    return metronome;
}


@end
