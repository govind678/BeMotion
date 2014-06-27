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
//#import "SCUI.h"



@implementation BeMotionAppDelegate

@synthesize sampleSets, fxPacks;

+ (void)initialize
{
//    [SCSoundCloud setClientID:@"YOUR_CLIENT_ID"
//                       secret:@"YOUR_CLIENT_SECRET"
//                  redirectURL:[NSURL URLWithString:@"sampleproject://oauth"]];
    
}



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    
    //--- Enable Push Notifications ---//
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    
    
    //--- Create Instance of Backend ---//
    backendInterface    =   new BeMotionInterface();

    
    
    //--- Generate Sample Sets ---//
    
    NSDictionary* initialSet =  @{
                                  
                   @"Electronic Kit"            : @[@"EKit0", @"EKit1", @"EKit2", @"EKit3", @"EKit4", @"Breakbeat4",
                                                    [NSNumber numberWithInt:120]],
                   
                   @"Dubstep Loops"             : @[@"DubBeat0", @"DubBeat1", @"DubBeat2", @"DubBeat3", @"DubBeat4", @"EKit4",
                                                    [NSNumber numberWithInt:140]],
                   
                   @"Breakbeat Drums"           : @[@"Breakbeat0", @"Breakbeat1", @"Breakbeat2", @"Breakbeat3", @"Breakbeat4", @"EKit4",
                                                    [NSNumber numberWithInt:140]],
                   
                   @"Indian Percussion"         : @[@"Indian_Percussion0", @"Indian_Percussion1", @"Indian_Percussion2",
                                                    @"Indian_Percussion3", @"Indian_Percussion4", @"Electronica4",
                                                    [NSNumber numberWithInt:100]],
                   
                   @"Latin Loops"               : @[@"Latin_Loop0", @"Latin_Loop1", @"Latin_Loop2", @"Latin_Loop3", @"Latin_Loop4",
                                                    @"Latin_Percussion4",
                                                    [NSNumber numberWithInt:126]],
                   
                   @"Latin Percussion"          : @[@"Latin_Percussion0", @"Latin_Percussion1", @"Latin_Percussion2", @"Latin_Percussion3",
                                                    @"Latin_Percussion4", @"Latin_Loop4",
                                                    [NSNumber numberWithInt:126]],
                   
                   @"Electronic Set 1"          : @[@"Electronic0", @"Electronic1", @"Electronic2", @"Electronic3", @"Electronic4",
                                                    @"Electronica4",
                                                    [NSNumber numberWithInt:85]],
                   
                   @"Electronic Set 2"          : @[@"Electronica0", @"Electronica1", @"Electronica2", @"Electronica3", @"Electronica4",
                                                    @"Electronic4",
                                                    [NSNumber numberWithInt:85]],
                   
                   @"Embryo"                    : @[@"Embryo0", @"Embryo1", @"Embryo2", @"Embryo3", @"Embryo4", @"Latin_Percussion4",
                                                    [NSNumber numberWithInt:200]],
                   
                   @"Machine Transformations"   : @[@"MachineTransformations0", @"MachineTransformations1", @"MachineTransformations2",
                                                    @"MachineTransformations3", @"MachineTransformations4", @"Embryo4",
                                                    [NSNumber numberWithInt:120]],
                   
                   @"Skies"                     : @[@"Skies0", @"Skies1", @"Skies2", @"Skies3", @"Skies4", @"Electronic4",
                                                    [NSNumber numberWithInt:180]],
                   };
    
    
    sampleSets = [[NSMutableDictionary alloc] initWithDictionary:initialSet copyItems:YES];
    
    
    
    //--- Generate FX Packs ---//
    NSArray* initialArray = @[@"Wah_Tremolo", @"Percs_Delay", @"DelayWah", @"BeatRepeat", @"Template"];
    fxPacks = [[NSMutableArray alloc] initWithArray:initialArray copyItems:YES];
    
    
    
    //--- Preload Audio Samples and FX Path ---//
    
    NSArray *sectionSamples = [sampleSets objectForKey:@"Dubstep Loops"];
    
    for (int sample = 0; sample < NUM_SAMPLE_SOURCES; sample++) {
        NSString *samplePath = [[NSBundle mainBundle] pathForResource:[sectionSamples objectAtIndex:sample] ofType:@"wav"];
        backendInterface->loadAudioFile(sample, samplePath);
    }
    
    NSString *fxPath = [[NSBundle mainBundle] pathForResource:[fxPacks objectAtIndex:0] ofType:@"json"];
    backendInterface->loadFXPreset(fxPath);
    
    
    
    //--- Initialize Metronome ---//
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
    for (int i=0; i < NUM_BUTTONS; i++)
    {
        NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentPath = [searchPaths lastObject];
        NSString *filePath = [NSString stringWithFormat:@"%@/Media%i.wav", documentPath, i];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath])
        {
            [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
        }
    }
    
    [sampleSets release];
    [fxPacks release];
    [metronome dealloc];
    delete backendInterface;
}


- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
	NSLog(@"My token is: %@", deviceToken);
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
//	NSLog(@"Failed to get token, error: %@", error);
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
