//
//  UIFont+Additions.h
//  BeMotion
//
//  Created by Govinda Pingali on 2/15/16.
//  Copyright © 2016 Plasmatio Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (Additions)

/** Returns default light font with a given size.
 @param fontSize The size of the font. */
+ (UIFont *)lightDefaultFontOfSize:(CGFloat)fontSize;

/**  Returns default font with a given size.
 @param fontSize The size of the font. */
+ (UIFont *)regularFontOfSize:(CGFloat)fontSize;

/** Returns default medium font with a given size.
 @param fontSize The size of the font. */
+ (UIFont *)semiboldDefaultFontOfSize:(CGFloat)fontSize;

/** Returns default bold font with a given size.
 @param fontSize The size of the font. */
+ (UIFont *)boldDefaultFontOfSize:(CGFloat)fontSize;

@end
