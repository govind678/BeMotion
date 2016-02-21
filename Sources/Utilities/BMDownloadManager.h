//
//  BMDownloadManager.h
//  BeMotion
//
//  Created by Govinda Pingali on 2/15/16.
//  Copyright © 2016 Plasmatio Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BMDownloadManagerDelegate <NSObject>

@optional

/** Callback from download manager after calling 'getRemoteSampleSets' */
- (void)availableSampleSets:(NSArray*)sets;

@end



@interface BMDownloadManager : NSObject

/** Returns the single instance of the download manager. */
+ (instancetype)manager;

/** Set Download Manager Delegate */
@property (nonatomic, weak) id <BMDownloadManagerDelegate> delegate;

/** Request to retrieve list of audio sample sets from remote server */
- (void)getRemoteSampleSets;

@end
