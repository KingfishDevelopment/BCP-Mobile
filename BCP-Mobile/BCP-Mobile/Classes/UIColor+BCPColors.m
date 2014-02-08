//
//  UIColor+BCPColors.m
//  BCP-Mobile
//
//  Created by Bryce Pauken on 11/17/13.
//  Copyright (c) 2013 Kingfish. All rights reserved.
//

#import "UIColor+BCPColors.h"

@implementation UIColor (BCPColors)

+ (UIColor *)BCPBackgroundColor {
    static UIColor *color = nil;
    if (!color)
        color = [UIColor colorWithRed:(9/255.0) green:(92/255.0) blue:(154/255.0) alpha:1];
    return color;
}

+ (UIColor *)BCPBlue {
    static UIColor *color = nil;
    if (!color)
        color = [UIColor colorWithRed:(0/255.0) green:(85/255.0) blue:(150/255.0) alpha:1];
    color = [UIColor greenColor];
    return color;
}

+ (UIColor *)BCPDarkBlue {
    static UIColor *color = nil;
    if (!color)
        color = [UIColor colorWithRed:(15/255.0) green:(54/255.0) blue:(83/255.0) alpha:1];
        color = [UIColor redColor];
    return color;
}

+ (UIColor *)BCPGray {
    static UIColor *color = nil;
    if (!color)
        color = [UIColor colorWithRed:(150/255.0) green:(150/255.0) blue:(150/255.0) alpha:1];
    color = [UIColor yellowColor];
    return color;
}

+ (UIColor *)BCPLightBlue {
    static UIColor *color = nil;
    if (!color)
        color = [UIColor colorWithRed:(108/255.0) green:(174/255.0) blue:(223/255.0) alpha:1];
    return color;
}

+ (UIColor *)BCPNavigationBarColor {
    static UIColor *color = nil;
    if (!color)
        color = [UIColor colorWithRed:(67/255.0) green:(114/255.0) blue:(170/255.0) alpha:1];
    return color;
}

+ (UIColor *)BCPOffBlack {
    static UIColor *color = nil;
    if (!color)
        color = [UIColor colorWithWhite:0.1 alpha:1];
    return color;
}

+ (UIColor *)BCPOffWhite {
    static UIColor *color = nil;
    if (!color)
        color = [UIColor colorWithWhite:0.9 alpha:1];
    return color;
}

+ (UIColor *)BCPSidebarAccentColor {
    static UIColor *color = nil;
    if (!color)
        color = [UIColor colorWithRed:(150/255.0) green:(150/255.0) blue:(150/255.0) alpha:1];
    return color;
}

+ (UIColor *)BCPSidebarColor {
    static UIColor *color = nil;
    if (!color)
        color = [UIColor colorWithRed:(243/255.0) green:(247/255.0) blue:(250/255.0) alpha:1];
    return color;
}

+ (UIColor *)BCPSidebarSelectedColor {
    static UIColor *color = nil;
    if (!color)
        color = [UIColor colorWithRed:(150/255.0) green:(150/255.0) blue:(150/255.0) alpha:1];
    return color;
}

@end
