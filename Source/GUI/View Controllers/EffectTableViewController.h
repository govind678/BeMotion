//
//  EffectTableViewController.h
//  BeMotion
//
//  Created by Govinda Ram Pingali on 7/16/14.
//  Copyright (c) 2014 BeMotionLLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "BeMotionInterface.h"

@interface EffectTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    NSArray* fxTypes;
    UIColor* currentColor;
}

@property (retain, nonatomic) IBOutlet UITableView *effectTable;
@property (nonatomic, assign) NSIndexPath* checkedPath;
@property (nonatomic, assign) BeMotionInterface*  backendInterface;
@property (nonatomic, assign) int sampleID;
@property (nonatomic, assign) int effectPosition;
@property (retain, nonatomic) IBOutlet UILabel *headerLabel;

@end
