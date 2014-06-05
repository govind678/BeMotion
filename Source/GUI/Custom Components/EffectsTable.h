//
//  EffectsTable.h
//  BeMotion
//
//  Created by Govinda Ram Pingali on 6/4/14.
//  Copyright (c) 2014 BeMotionLLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "Macros.h"

@interface EffectsTable : UITableView <UITableViewDataSource, UITableViewDelegate>
{
    
}

@property (nonatomic, strong) NSArray *effectsArray;

@end
