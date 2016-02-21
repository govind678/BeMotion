//
//  BMSettings.h
//  BeMotion
//
//  Created by Govinda Pingali on 2/14/16.
//  Copyright © 2016 Plasmatio Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BMSettings : NSObject

@property (nonatomic) BOOL ranOnce;


/** Returns the current user's settings.
 @returns The current user's settings and state information. */
+ (instancetype)userSettings;

- (void)save;

@end
