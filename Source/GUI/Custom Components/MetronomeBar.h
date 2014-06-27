//
//  MetronomeBar.h
//  BeMotion
//
//  Created by Govinda Ram Pingali on 6/26/14.
//  Copyright (c) 2014 BeMotionLLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "Macros.h"

@interface MetronomeBar : UIView
{
    
}

@property (nonatomic, strong) NSMutableArray*  metroBars;

- (void) beat : (int)count;
- (void) turnOff;

@end
