//
//  BCPColors.m
//  BCP-Mobile
//
//  Created by Bryce Pauken on 4/5/14.
//  Copyright (c) 2014 Kingfish. All rights reserved.
//

#import "BCPColors.h"

@implementation UIColor (BCPColors)

+ (UIColor *)BCPBlueColor {
    static UIColor *color = nil;
    if(!color) {
        color = [UIColor colorWithRed:0 green:86/255.0 blue:150/255.0 alpha:1];
    }
    return color;
}

+ (UIColor *)BCPLightGrayColor {
    static UIColor *color = nil;
    if(!color) {
        color = [UIColor colorWithWhite:0.75 alpha:1];
    }
    return color;
}

+ (UIColor *)BCPOffBlackColor {
    static UIColor *color = nil;
    if(!color) {
        color = [UIColor colorWithWhite:0.05 alpha:1];
    }
    return color;
}

+ (UIColor *)BCPOffWhiteColor {
    static UIColor *color = nil;
    if(!color) {
        color = [UIColor colorWithWhite:0.95 alpha:1];
    }
    return color;
}

@end
