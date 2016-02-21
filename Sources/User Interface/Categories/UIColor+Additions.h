//
//  UIColor+Additions.h
//  BeMotion
//
//  Created by Govinda Pingali on 2/15/16.
//  Copyright © 2016 Plasmatio Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

/** UIColor additions. */
@interface UIColor (Additions)


/** Creates and returns a color object using the specified hexadecimal value.
 @param hex hexadecimal int value.
 @return the UIColor object. */
+ (UIColor *)colorWithRGBHex:(UInt32)hex;

/** Creates and returns a color object using the specified hexadecimal value.
 @param color hexadecimal value as a string.
 @return the UIColor object. */
+ (UIColor *)colorWithHexString:(NSString *)color;

/** Returns a UIColor that is darker or lighter than the specified UIColor.
 @param Brightness offset (positive values will be lighter, negative will be darker).
 @return UIColor. */
+ (UIColor *)colorFromUIColor:(UIColor*)color withBrightnessOffset:(CGFloat)offset;

/** Returns a desaturated UIColor, ie. same hue and brightness but zero saturation.
 @return UIColor */
+ (UIColor *)desaturate:(UIColor*)color;

+ (UIColor*) appRedColor;
+ (UIColor*) appBlueColor;
+ (UIColor*) appGreenColor;
+ (UIColor*) appYellowColor;

+ (NSArray*) trackColors;


@end
