//
//  BMRecordButton.h
//  BeMotion
//
//  Created by Govinda Pingali on 2/24/16.
//  Copyright © 2016 Plasmatio Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BMRecordButton : UIView

@property (nonatomic) int trackID;

- (void)tick:(int)count;

@end
