//
//  BMHorizontalSlider.h
//  BeMotion
//
//  Created by Govinda Pingali on 2/17/16.
//  Copyright © 2016 Plasmatio Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BMHorizontalSlider : UIControl

@property (nonatomic, assign) CGFloat minimumValue;
@property (nonatomic, assign) CGFloat maximumValue;
@property (nonatomic) CGFloat value;
@property (nonatomic, retain) UIColor* onTrackColor;
@property (nonatomic, retain) NSString* centerText;

@end
