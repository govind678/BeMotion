//
//  BMSettings.h
//  BeMotion
//
//  Created by Govinda Pingali on 2/14/16.
//  Copyright © 2016 Plasmatio Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BMSettings : NSObject

@property (nonatomic, readwrite, getter = didRunOnce) BOOL ranOnce;
@property (nonatomic, readonly) NSString* projectName;

/** Returns the current user's settings.
 @returns The current user's settings and state information. */
+ (instancetype)sharedInstance;

- (void)saveToUserDefaults;

/* Project Settings */
- (BOOL)saveProjectWithName:(NSString*)projectName;
- (BOOL)loadProjectAtIndex:(NSInteger)index;
- (void)deleteProjectAtIndex:(NSInteger)index;
- (void)renameProjectAtIndex:(NSInteger)index with:(NSString*)newTitle;
- (NSArray*)getListOfSavedProjects;
@property (nonatomic, readonly) NSString* projectsDirectory;

/* App Settings */
@property (nonatomic, readwrite) BOOL shouldDrawWaveform;

@end
