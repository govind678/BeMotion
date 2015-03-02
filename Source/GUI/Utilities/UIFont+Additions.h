//
//  UIFont+Additions.h
//  SoundFocus
//
//  Created by Alexandru Gologan on 05/12/13.
//  Copyright (c) 2013 Symphonic Audio Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>


/** UIFont additions. */
@interface UIFont (Additions)

/** Returns default light font with a given size.
 @param fontSize The size of the font. */
+ (UIFont *)lightDefaultFontOfSize:(CGFloat)fontSize;

/**  Returns default font with a given size.
 @param fontSize The size of the font. */
+ (UIFont *)defaultFontOfSize:(CGFloat)fontSize;

/** Returns default medium font with a given size.
 @param fontSize The size of the font. */
+ (UIFont *)semiboldDefaultFontOfSize:(CGFloat)fontSize;

/** Returns default bold font with a given size.
 @param fontSize The size of the font. */
+ (UIFont *)boldDefaultFontOfSize:(CGFloat)fontSize;

@end
