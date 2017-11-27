//
//  AppDelegate.m
//  BeMotion
//
//  Created by Govinda Pingali on 2/14/16.
//  Copyright © 2016 Plasmatio Tech. All rights reserved.
//

#import "AppDelegate.h"

#import "BMAudioController.h"
#import "BMSequencer.h"
#import "BMSettings.h"
#import "BMHomeViewController.h"

#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

@interface AppDelegate ()
{
    UINavigationController*             _navController;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    CGRect screenFrame = [[UIScreen mainScreen] bounds];
    self.window = [[UIWindow alloc] initWithFrame:screenFrame];
    [self.window setBackgroundColor:[UIColor whiteColor]];
    [self.window makeKeyAndVisible];
    [self.window setRootViewController:[[UIViewController alloc] init]];
    
    // Initialize Audio Controller
    [BMAudioController sharedController];
    
    // Load Default Settings
    [BMSettings sharedInstance];
    
    // Initialize Home View Controller
    UIViewController *viewController = [[BMHomeViewController alloc] init];
    
    // Setup Navigation Controller and Appearance
    _navController = [[UINavigationController alloc] initWithRootViewController:viewController];
    
    // Initialize Root View Controller
    UIViewController* rootController = [[UIViewController alloc] init];
    [rootController addChildViewController:_navController];
    [rootController.view addSubview:_navController.view];
    [self.window setRootViewController:rootController];
    
    // Launch Fabric
    [Fabric with:@[[Crashlytics class]]];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[BMAudioController sharedController] stop];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [[BMAudioController sharedController] restart];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[BMSettings sharedInstance] saveToUserDefaults];
    [[BMAudioController sharedController] close];
}

@end
