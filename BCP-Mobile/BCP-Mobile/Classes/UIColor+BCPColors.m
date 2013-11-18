//
//  UIColor+BCPColors.m
//  BCP-Mobile
//
//  Created by Bryce Pauken on 11/17/13.
//  Copyright (c) 2013 Kingfish. All rights reserved.
//

#import "UIColor+BCPColors.h"

@implementation UIColor (BCPColors)

+ (UIColor *)BCPBlue {
    static UIColor *color = nil;
    if (!color)
        color = [UIColor colorWithRed:(0/255.0) green:(85/255.0) blue:(150/255.0) alpha:1];
    return color;
}

+ (UIColor *)BCPLightBlue {
    static UIColor *color = nil;
    if (!color)
        color = [UIColor colorWithRed:(108/255.0) green:(174/255.0) blue:(223/255.0) alpha:1];
    return color;
}

+ (UIColor *)BCPOffWhite {
    static UIColor *color = nil;
    if (!color)
        color = [UIColor colorWithRed:(243/255.0) green:(247/255.0) blue:(250/255.0) alpha:1];
    return color;
}

@end
