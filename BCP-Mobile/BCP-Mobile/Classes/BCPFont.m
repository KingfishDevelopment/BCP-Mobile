//
//  BCPFont.m
//  BCP-Mobile
//
//  Created by Bryce Pauken on 10/3/13.
//  Copyright (c) 2013 Kingfish. All rights reserved.
//

#import "BCPFont.h"

@implementation BCPFont

+ (UIFont *)boldSystemFontOfSize:(CGFloat)fontSize {
    if([[BCPCommon data] unlockableValueForName:@"Announcement Enthusiast"]>0)
        return [UIFont fontWithName:@"ComicSansMS-Bold" size:fontSize];
    return [UIFont boldSystemFontOfSize:fontSize];
}

+ (UIFont *)fontWithName:(NSString *)fontName size:(CGFloat)fontSize {
    if([[BCPCommon data] unlockableValueForName:@"Announcement Enthusiast"]>0)
        return [UIFont fontWithName:([[fontName lowercaseString] rangeOfString:@"bold"].location==NSNotFound?@"ComicSansMS":@"ComicSansMS-Bold") size:fontSize];
    return [UIFont boldSystemFontOfSize:fontSize];
}

+ (UIFont *)systemFontOfSize:(CGFloat)fontSize {
    if([[BCPCommon data] unlockableValueForName:@"Announcement Enthusiast"]>0)
        return [UIFont fontWithName:@"ComicSansMS" size:fontSize];
    return [UIFont systemFontOfSize:fontSize];
}

@end
