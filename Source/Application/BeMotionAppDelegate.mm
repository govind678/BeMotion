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
    NSString *samplePath0 = [[NSBundle mainBundle] pathForResource:@"EKit0" ofType:@"wav"];
    NSString *samplePath1 = [[NSBundle mainBundle] pathForResource:@"EKit1" ofType:@"wav"];
    NSString *samplePath2 = [[NSBundle mainBundle] pathForResource:@"EKit2" ofType:@"wav"];
    NSString *samplePath3 = [[NSBundle mainBundle] pathForResource:@"EKit3" ofType:@"wav"];
    NSString *samplePath4 = [[NSBundle mainBundle] pathForResource:@"EKit4" ofType:@"wav"];
    
    NSString *fxPath0 = [[NSBundle mainBundle] pathForResource:@"Percs_Delay" ofType:@"json"];
    
    backendInterface->loadAudioFile(0, samplePath0);
    backendInterface->loadAudioFile(1, samplePath1);
    backendInterface->loadAudioFile(2, samplePath2);
    backendInterface->loadAudioFile(3, samplePath3);
    backendInterface->loadAudioFile(4, samplePath4);
    
    backendInterface->loadFXPreset(0, fxPath0);
    
    
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
    
    for (int i=0; i < NUM_BUTTONS; i++)
    {
        backendInterface->stopRecording(i);
        backendInterface->stopPlayback(i);
    }
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
    
    
    // Delete Media Selected Copies, if any
    for (int i=0; i < 4; i++)
    {
        NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentPath = [searchPaths lastObject];
        NSString *filePath = [NSString stringWithFormat:@"%@/Media%i.wav", documentPath, i];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath])
        {
            [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
        }
    }
    
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
