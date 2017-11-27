//
//  BMLoadFileView.h
//  BeMotion
//
//  Created by Govinda Ram Pingali on 11/17/17.
//  Copyright © 2017 Plasmatio Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BMLoadFileViewDelegate <NSObject>
- (void)launchAlertViewController:(UIViewController*)controller;
@end

@interface BMLoadFileView : UIView
- (void)viewWillAppear;
@property (nonatomic, assign) int trackID;
@property (nonatomic, weak) id <BMLoadFileViewDelegate> delegate;
@end
