//
//  EffectTableViewController.h
//  BeatMotion
//
//  Created by Govinda Ram Pingali on 7/16/14.
//  Copyright (c) 2014 PlasmatioTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "BeatMotionInterface.h"

@interface EffectTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    NSArray* fxNames;
    UIColor* currentColor;
}

@property (retain, nonatomic) IBOutlet UITableView *effectTable;

@property (nonatomic, assign) NSIndexPath* checkedPath;
@property (nonatomic, assign) BeatMotionInterface*  backendInterface;
@property (nonatomic, assign) int sampleID;
@property (nonatomic, assign) int effectPosition;

@property (retain, nonatomic) IBOutlet UILabel *headerLabel;

@property (nonatomic, retain) NSArray* fxNames;

@end
