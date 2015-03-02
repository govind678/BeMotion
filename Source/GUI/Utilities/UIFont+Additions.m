//
//  UIFont+Additions.m
//  SoundFocus
//
//  Created by Alexandru Gologan on 05/12/13.
//  Copyright (c) 2013 Symphonic Audio Technologies. All rights reserved.
//

#import "UIFont+Additions.h"

@implementation UIFont (Additions)

+ (UIFont *)lightDefaultFontOfSize:(CGFloat)fontSize {
    return [UIFont fontWithName:@"OpenSans-Light" size:fontSize];
}

+ (UIFont *)defaultFontOfSize:(CGFloat)fontSize {
    return [UIFont fontWithName:@"OpenSans" size:fontSize];
}

+ (UIFont *)semiboldDefaultFontOfSize:(CGFloat)fontSize {
    return [UIFont fontWithName:@"OpenSans-Semibold" size:fontSize];
}

+ (UIFont *)boldDefaultFontOfSize:(CGFloat)fontSize {
    return [UIFont fontWithName:@"OpenSans-Bold" size:fontSize];
}

@end
