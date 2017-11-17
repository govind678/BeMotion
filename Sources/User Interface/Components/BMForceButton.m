//
//  BMForceButton.m
//  BeMotion
//
//  Created by Govinda Ram Pingali on 11/11/17.
//  Copyright © 2017 Plasmatio Tech. All rights reserved.
//

#import "BMForceButton.h"

typedef enum {
    TouchState_Up,
    TouchState_Down
} TouchState;

@interface BMForceButton()
{
    UIImage*            _upImage;
    UIImage*            _downImage;
    
    UIImageView*         _imageView;
    UIImageView*        _highlightView;
    
    TouchState           _touchState;
    BOOL                _ignoreEvents;
}
@end


@implementation BMForceButton

- (id)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        _selected = NO;
        
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [_imageView setUserInteractionEnabled:NO];
        [_imageView setTintColor:[UIColor clearColor]];
        [self addSubview:_imageView];
        
        _highlightView = [[UIImageView alloc] initWithFrame:self.bounds];
        [_highlightView setUserInteractionEnabled:NO];
        [_highlightView setTintColor:[UIColor colorWithWhite:0.2f alpha:0.6f]];
        [_highlightView setHidden:YES];
        [self addSubview:_highlightView];
        
        _touchState = TouchState_Up;
        _ignoreEvents = NO;
        
        [self setBackgroundColor:[UIColor clearColor]];
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

#pragma mark - Public

- (void)setButtonUpImage:(UIImage *)image {
    _upImage = image;
    [self updateImageView];
}

- (void)setButtonDownImage:(UIImage *)image {
    _downImage = image;
    [self updateImageView];
}

- (void)setSelected:(BOOL)selected {
    _selected = selected;
    [self updateImageView];
}


#pragma mark - Touch Events

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_highlightView setHidden:NO];
    _touchState = TouchState_Down;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    if (_ignoreEvents) {
        return;
    }
    
    UITouch* touch = [touches anyObject];
    CGFloat maximumPossibleForce = touch.maximumPossibleForce;
    CGFloat force = touch.force;
    CGFloat normalizedForce = force/maximumPossibleForce;
    
    if (normalizedForce == 1.0f) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(forceButtonForcePressDown:)]) {
            [_delegate forceButtonForcePressDown:self];
        }
        _ignoreEvents = YES;
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_highlightView setHidden:YES];
    if (!_ignoreEvents) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(forceButtonTouchUpInside:)]) {
            [_delegate forceButtonTouchUpInside:self];
        }
    }
    _ignoreEvents = NO;
}

#pragma mark - Private

- (void)updateImageView {
    if (_selected) {
        [_imageView setImage:[_downImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [_highlightView setImage:[_downImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    } else {
        [_imageView setImage:[_upImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [_highlightView setImage:[_upImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    }
}

@end
