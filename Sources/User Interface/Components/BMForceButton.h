//
//  BMForceButton.h
//  BeMotion
//
//  Created by Govinda Ram Pingali on 11/11/17.
//  Copyright © 2017 Plasmatio Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BMForceButtonDelegate <NSObject>
- (void)forceButtonTouchUpInside:(id)sender;
- (void)forceButtonForcePressDown:(id)sender;
@end

@interface BMForceButton : UIView

@property (nonatomic, assign, getter=isSelected) BOOL selected;
@property (nonatomic, weak) id <BMForceButtonDelegate> delegate;

- (void)setButtonUpImage:(UIImage*)image;
- (void)setButtonDownImage:(UIImage*)image;

@end
