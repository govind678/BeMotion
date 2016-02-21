//
//  UIFont+Additions.m
//  BeMotion
//
//  Created by Govinda Pingali on 2/15/16.
//  Copyright © 2016 Plasmatio Tech. All rights reserved.
//

#import "UIFont+Additions.h"

@implementation UIFont (Additions)

+ (UIFont *)lightDefaultFontOfSize:(CGFloat)fontSize {
    return [UIFont fontWithName:@"OpenSans-Light" size:fontSize];
}

+ (UIFont *)regularFontOfSize:(CGFloat)fontSize {
    return [UIFont fontWithName:@"OpenSans-Regular" size:fontSize];
}

+ (UIFont *)semiboldDefaultFontOfSize:(CGFloat)fontSize {
    return [UIFont fontWithName:@"OpenSans-Semibold" size:fontSize];
}

+ (UIFont *)boldDefaultFontOfSize:(CGFloat)fontSize {
    return [UIFont fontWithName:@"OpenSans-Bold" size:fontSize];
}

@end
