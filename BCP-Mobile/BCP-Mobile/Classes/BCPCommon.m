//
//  BCPCommon.m
//  BCP-Mobile
//
//  Created by Bryce Pauken on 10/2/13.
//  Copyright (c) 2013 Kingfish. All rights reserved.
//

#import "BCPCommon.h"

static NSObject<BCPViewControllerDelegate> *viewControllerDelegate = nil;

@implementation BCPCommon

+ (UIColor *)BLUE {
    return [UIColor colorWithRed:0 green:0.333 blue:0.588 alpha:1];
}

+ (BOOL)IS_IOS7 {
    return ([[[UIDevice currentDevice] systemVersion] compare:@"7" options:NSNumericSearch] != NSOrderedAscending);
}

+ (BOOL)IS_IPAD {
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
}

+ (UIColor *)SIDEBAR_ACCENT_COLOR {
    return [UIColor colorWithWhite:0.3 alpha:1];
}

+ (int)SIDEBAR_CELL_HEIGHT {
    return 50;
}

+ (UIColor *)SIDEBAR_COLOR {
    return [UIColor colorWithWhite:0.2 alpha:1];
}

+ (int)SIDEBAR_CELL_PADDING {
    return 8;
}

+ (UIColor *)SIDEBAR_HEADER_COLOR {
    return [UIColor colorWithWhite:0.3 alpha:1];
}

+ (int)SIDEBAR_HEADER_PADDING {
    return 5;
}

+ (UIColor *)SIDEBAR_SELECTED_COLOR {
    return [UIColor colorWithWhite:0.15 alpha:1];
}

+ (UIColor *)SIDEBAR_TEXT_COLOR {
    return [UIColor colorWithWhite:0.8 alpha:1];
}

+ (int)SHADOW_SIZE {
    return 4;
}

+ (int)SIDEBAR_WIDTH {
    return 240;
}

+ (void)setScrollsToTop:(UIScrollView *)scrollView {
    [viewControllerDelegate setScrollsToTop:scrollView];
}

+ (void)setViewControllerDelegate:(NSObject<BCPViewControllerDelegate> *)newViewControllerDelegate {
    viewControllerDelegate = newViewControllerDelegate;
}

@end
