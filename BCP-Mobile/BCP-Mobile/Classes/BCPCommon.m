//
//  BCPCommon.m
//  BCP-Mobile
//
//  Created by Bryce Pauken on 10/2/13.
//  Copyright (c) 2013 Kingfish. All rights reserved.
//

#import "BCPCommon.h"

static BCPData *data = nil;
static NSObject<BCPViewControllerDelegate> *viewControllerDelegate = nil;

@implementation BCPCommon

+ (void)initialize {
    data = [[BCPData alloc] init];
}

+ (UIColor *)BLUE {
    return [BCPColor colorWithRed:0 green:0.333 blue:0.588 alpha:1];
}
+ (BOOL)IS_IOS7 {
    return ([[[UIDevice currentDevice] systemVersion] compare:@"7" options:NSNumericSearch] != NSOrderedAscending);
}
+ (BOOL)IS_IPAD {
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
}
+ (int)SHADOW_SIZE {
    return 4;
}
+ (UIColor *)SIDEBAR_ACCENT_COLOR {
    return [BCPColor colorWithWhite:0.3 alpha:1];
}
+ (int)SIDEBAR_CELL_HEIGHT {
    return 50;
}
+ (UIColor *)SIDEBAR_COLOR {
    return [BCPColor colorWithWhite:0.2 alpha:1];
}
+ (float)SIDEBAR_DISABLED_ALPHA {
    return 0.6;
}
+ (UIColor *)SIDEBAR_DISABLED_COLOR {
    return [BCPColor colorWithWhite:0.25 alpha:1];
}
+ (int)SIDEBAR_CELL_PADDING {
    return 8;
}
+ (UIColor *)SIDEBAR_HEADER_COLOR {
    return [BCPColor colorWithWhite:0.3 alpha:1];
}
+ (int)SIDEBAR_HEADER_PADDING {
    return 5;
}
+ (UIColor *)SIDEBAR_SELECTED_COLOR {
    return [BCPColor colorWithWhite:0.15 alpha:1];
}
+ (UIColor *)SIDEBAR_TEXT_COLOR {
    return [BCPColor colorWithWhite:0.8 alpha:1];
}
+ (int)SIDEBAR_WIDTH {
    return 240;
}

+ (BCPData *)data {
    return data;
}

+ (void)setScrollsToTop:(UIScrollView *)scrollView {
    [viewControllerDelegate setScrollsToTop:scrollView];
}

+ (void)setViewControllerDelegate:(NSObject<BCPViewControllerDelegate> *)newViewControllerDelegate {
    viewControllerDelegate = newViewControllerDelegate;
}

+ (void)showContentView:(NSString *)view {
    [viewControllerDelegate showContentView:view];
}

@end
