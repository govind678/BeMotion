//
//  BMAppDelegate.m
//  BeatMotion
//
//  Created by Govinda Ram Pingali on 7/20/14.
//  Copyright (c) 2014 BeatMotion. All rights reserved.
//

#import "BMAppDelegate.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import <TwitterKit/TwitterKit.h>



@implementation BMAppDelegate

@synthesize sampleSets, fxPacks, fxTypes;

static NSString * const kDefaultSampleSet = @"DubBeat";

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Fabric with:@[CrashlyticsKit, TwitterKit]];


//    //--- Enable Push Notifications ---//
//    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
//     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    //--- Create Instance of Backend ---//
    backendInterface    =   new BeatMotionInterface();
    
    
    
    //--- Generate Sample Sets ---//
    NSString* sampleSetsPath = [[NSBundle mainBundle] pathForResource:@"SamplePacks" ofType:@"plist"];
    sampleSets = [[NSMutableDictionary alloc] initWithContentsOfFile:sampleSetsPath];
    
    
    //--- Generate FX Packs ---//
    NSString* fxPacksPath = [[NSBundle mainBundle] pathForResource:@"FXPacks" ofType:@"plist"];
    fxPacks = [[NSMutableArray alloc] initWithContentsOfFile:fxPacksPath];
    
    
    //--- Generate FX Types ---//
    NSString* fxTypesPath = [[NSBundle mainBundle] pathForResource:@"FXTypes" ofType:@"plist"];
    fxTypes = [[NSMutableArray alloc] initWithContentsOfFile:fxTypesPath];
    
    
    //--- Preload Audio Samples and FX Path ---//
    
    NSArray *sectionSamples = [sampleSets objectForKey:kDefaultSampleSet];
    
    backendInterface->setCurrentSampleBankIndex(4);
    
    for (int sample = 0; sample < NUM_SAMPLE_SOURCES; sample++) {
        NSString *samplePath = [[NSBundle mainBundle] pathForResource:[sectionSamples objectAtIndex:sample] ofType:@"wav"];
        backendInterface->loadAudioFile(sample, samplePath);
    }
    
    NSString *fxPath = [[NSBundle mainBundle] pathForResource:[fxPacks objectAtIndex:0] ofType:@"json"];
    backendInterface->loadFXPreset(fxPath);
    backendInterface->setTempo([[sectionSamples objectAtIndex:6] floatValue]);
    backendInterface->setCurrentFXPackIndex(0);
    
    
    
    //--- Initialize Metronome ---//
    metronome   =   [[Metronome alloc] init];
    [metronome setBackendReference:backendInterface];
    [metronome setTempo:[[sectionSamples objectAtIndex:6] floatValue]];
    
    
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



//- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
//{
//	NSLog(@"My token is: %@", deviceToken);
//    
//    
//    NSString *receipt1 = @"username";
//    
//    NSString *post =[NSString stringWithFormat:@"receipt=%@",receipt1];
//    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
//    
//    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
//    
//    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
//    [request setURL:[NSURL URLWithString:@"http://www.govindarampingali.com/projects/bemotion.php"]];
//    [request setHTTPMethod:@"POST"];
//    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
//    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
//    [request setHTTPBody:postData];
//    
//    
//    NSHTTPURLResponse* urlResponse = nil;
//    NSError *error = [[NSError alloc] init];
//    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
//    NSString *result = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
//    NSLog(@"Response Code: %ld", (long)[urlResponse statusCode]);
//    
//    if ([urlResponse statusCode] >= 200 && [urlResponse statusCode] < 300)
//    {
//        NSLog(@"Response: %@", result);
//    }
//}
//
//- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
//{
//	NSLog(@"Failed to get token, error: %@", error);
//}


- (BeatMotionInterface*)getBackendReference
{
    return backendInterface;
}

- (Metronome*)getMetronomeReference
{
    return metronome;
}

@end
