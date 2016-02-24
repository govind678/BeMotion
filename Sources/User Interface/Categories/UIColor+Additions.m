//
//  UIColor+Additions.m
//  BeMotion
//
//  Created by Govinda Pingali on 2/15/16.
//  Copyright © 2016 Plasmatio Tech. All rights reserved.
//

#import "UIColor+Additions.h"

@implementation UIColor (Additions)

+ (UIColor *)colorWithRGBHex:(UInt32)hex {
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    return [UIColor colorWithRed:r / 255.0f
                           green:g / 255.0f
                            blue:b / 255.0f
                           alpha:1.0f];
}

+ (UIColor *)colorWithHexString:(NSString *)color {
    NSScanner *scanner = [NSScanner scannerWithString:color];
    unsigned hexNum = 0x0;
    if (![scanner scanHexInt:&hexNum]) return nil;
    return [self colorWithRGBHex:hexNum];
}

+ (UIColor*)colorFromUIColor:(UIColor *)color withBrightnessOffset:(CGFloat)offset {
    CGFloat hue, saturation, brightness, alpha;
    [color getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
    brightness += offset;
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:alpha];
}

+ (UIColor*)desaturate:(UIColor *)color {
    CGFloat hue, saturation, brightness, alpha;
    [color getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
    return [UIColor colorWithHue:hue saturation:0.0f brightness:brightness alpha:alpha];
}


#pragma mark - Custom Colors

+ (UIColor*)appRedColor {
    return [UIColor colorWithRed:0.98f green:0.34f blue:0.14f alpha:1.0f];
}

+ (UIColor*)appBlueColor {
    return [UIColor colorWithRed:0.17 green:0.47f blue:0.98f alpha:1.0f];
}

+ (UIColor*)appGreenColor {
    return [UIColor colorWithRed:0.0f green:0.74f blue:0.42f alpha:1.0f];
}

+ (UIColor*)appYellowColor {
    return [UIColor colorWithRed:0.96f green:0.93f blue:0.17f alpha:1.0f];
}

+ (UIColor*)textWhiteColor {
    return [UIColor colorWithWhite:0.8f alpha:1.0f];
}

+ (UIColor*)elementWhiteColor {
    return [UIColor colorWithWhite:0.6f alpha:1.0f];
}

+ (NSArray*)trackColors {
    return [NSArray arrayWithObjects:[UIColor appRedColor], [UIColor appBlueColor], [UIColor appGreenColor], [UIColor appYellowColor], nil];
}


@end
