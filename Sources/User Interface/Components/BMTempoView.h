//
//  BMTempoView.h
//  BeMotion
//
//  Created by Govinda Pingali on 2/21/16.
//  Copyright © 2016 Plasmatio Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BMTempoView : UIView

@property (nonatomic, assign) int meter;

- (void)tick:(int)count;

@end
