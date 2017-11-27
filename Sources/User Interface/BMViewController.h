//
//  BMViewController.h
//  BeMotion
//
//  Created by Govinda Pingali on 2/14/16.
//  Copyright © 2016 Plasmatio Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BMHeaderView.h"
#import "UIColor+Additions.h"
#import "UIFont+Additions.h"

@interface BMViewController : UIViewController

@property (nonatomic, readonly) float margin;
@property (nonatomic, readonly) float headerHeight;
@property (nonatomic, readonly) float buttonHeight;
@property (nonatomic, readonly) float optionButtonSize;
@property (nonatomic, readonly) float yGap;
@property (nonatomic, readonly) float verticalSeparatorHeight;
@property (nonatomic, readonly) float sliderHeight;

@end

