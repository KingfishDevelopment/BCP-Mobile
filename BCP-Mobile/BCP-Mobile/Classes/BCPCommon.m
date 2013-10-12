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
+ (UIColor *)BUTTON_COLOR {
    return [BCPColor colorWithWhite:0.9 alpha:1];
}
+ (UIColor *)BUTTON_DOWN_COLOR {
    return [BCPColor colorWithWhite:0.5 alpha:1];
}
+ (int)BUTTON_HEIGHT {
    return 50;
}
+ (UIColor *)BUTTON_TEXT_COLOR {
    return [BCPColor colorWithWhite:0.1 alpha:1];
}
+ (int)CONTENT_MIDDLE_PADDING {
    return 10;
}
+ (int)CONTENT_SIDE_PADDING {
    return 20;
}
+ (UIColor *)DARK_BLUE {
    return [BCPColor colorWithRed:0 green:0.294 blue:0.490 alpha:1];
}
+ (int)LOGIN_ICON_SIZE {
    return 96;
}
+ (int)INTRO_DESCRIPTION_ICON_SIZE {
    return 64;
}
+ (int)INTRO_ICON_SIZE {
    return 128;
}
+ (UIColor *)INTRO_SHADOW_COLOR {
    return [BCPColor colorWithWhite:0.1 alpha:1];
}
+ (UIColor *)INTRO_TEXT_COLOR {
    return [BCPColor colorWithWhite:0.9 alpha:1];
}
+ (BOOL)IS_IOS7 {
    return ([[[UIDevice currentDevice] systemVersion] compare:@"7" options:NSNumericSearch] != NSOrderedAscending);
}
+ (BOOL)IS_IPAD {
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
}
+ (int)NAVIGATION_BAR_HEIGHT {
    return 65;
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
+ (UIColor *)TABLEVIEW_ACCENT_COLOR {
    return [BCPColor colorWithWhite:0.8 alpha:1];
}
+ (int)TABLEVIEW_CELL_HEIGHT {
    return 50;
}
+ (int)TABLEVIEW_CELL_PADDING {
    return 8;
}
+ (UIColor *)TABLEVIEW_COLOR {
    return [BCPColor colorWithWhite:0.9 alpha:1];
}
+ (int)TABLEVIEW_HEADER_HEIGHT {
    return 24;
}
+ (int)TABLEVIEW_HEADER_PADDING {
    return 4;
}
+ (UIColor *)TABLEVIEW_TEXT_COLOR {
    return [BCPColor colorWithWhite:0.1 alpha:1];
}
+ (UIColor *)TEXTFIELD_COLOR {
    return [BCPColor colorWithWhite:0.9 alpha:1];
}
+ (int)TEXTBOX_HEIGHT {
    return 50;
}
+ (int)TEXTBOX_PADDING {
    return 10;
}

+ (BCPData *)data {
    return data;
}

+ (void)dismissKeyboard {
    [viewControllerDelegate dismissKeyboard];
}

+ (void)error:(NSString *)error {
    [viewControllerDelegate error:error];
}

+ (BOOL)loggedIn {
    return [data objectForKey:@"login"]!=nil;
}

+ (void)logout {
    NSArray *allKeys = [self.data allKeys];
    for(NSString *key in allKeys)
        if(![key isEqualToString:@"lastView"])
            [self.data removeObjectForKey:key];
    [viewControllerDelegate reloadLoginViews];
    [self reloadSidebar];
    [viewControllerDelegate selectLogin];
    [self showContentView:@"login"];
}

+ (void)reloadSidebar {
    [viewControllerDelegate reloadSidebar];
}

+ (void)setKeyboardOwner:(NSObject<BCPKeyboardDelegate> *)keyboardDelegate {
    [viewControllerDelegate setKeyboardOwner:keyboardDelegate];
}

+ (void)setInterfaceScrollViewEnabled:(BOOL)enabled {
    [viewControllerDelegate setInterfaceScrollViewEnabled:enabled];
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

+ (BOOL)viewIsVisable:(NSString *)view {
    return [viewControllerDelegate viewIsVisable:view];
}

@end
