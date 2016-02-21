//
//  BMLoadEffectsViewController.h
//  BeMotion
//
//  Created by Govinda Pingali on 2/15/16.
//  Copyright © 2016 Plasmatio Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMViewController.h"

@interface BMLoadEffectsViewController : BMViewController

@property (nonatomic, assign) int trackID;
@property (nonatomic, assign) int effectSlot;
@property (nonatomic, retain) NSIndexPath* selectedIndexPath;
@property (nonatomic, assign) NSArray*  effectsObject;

@end
