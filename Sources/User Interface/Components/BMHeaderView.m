//
//  BMHeaderView.m
//  BeMotion
//
//  Created by Govinda Pingali on 2/15/16.
//  Copyright © 2016 Plasmatio Tech. All rights reserved.
//

#import "BMHeaderView.h"
#import "UIFont+Additions.h"

static const float kBackButtonWidth             = 40.0f;

static NSString* const kBackButtonImageName     =   @"BackButton.png";

@interface BMHeaderView()
{
    UIButton*       _backButton;
    UILabel*        _titleLabel;
}
@end


@implementation BMHeaderView

- (id)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        // Title Label
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, frame.size.width, frame.size.height)];
        [_titleLabel setFont:[UIFont boldDefaultFontOfSize:15.0f]];
        [_titleLabel setTextColor:[UIColor lightGrayColor]];
        [_titleLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:_titleLabel];
        
        // Back Button
        _backButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, kBackButtonWidth, frame.size.height)];
        [_backButton setImage:[UIImage imageNamed:kBackButtonImageName] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(backButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_backButton];
    }
    
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark - Public Methods

- (void)setTitle:(NSString *)title {
    _title = title;
    [_titleLabel setText:title];
}

- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
    [_titleLabel setTextColor:titleColor];
}


#pragma mark - UIControl Methods

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    
//    if (CGRectContainsPoint(_backButton.bounds, [touch locationInView:self])) {
//        return YES;
//    }
    return NO;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    
//    if (CGRectContainsPoint(_backButton.bounds, [touch locationInView:self])) {
//        return YES;
//    }
    
    return NO;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
//    [self sendActionsForControlEvents:UIControlEventTouchUpInside];
}


#pragma mark - Private Methods

- (void)backButtonTapped {
    [self sendActionsForControlEvents:UIControlEventTouchUpInside];
}

@end
