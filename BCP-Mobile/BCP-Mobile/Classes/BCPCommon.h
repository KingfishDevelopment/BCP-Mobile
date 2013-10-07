//
//  BCPCommon.h
//  BCP-Mobile
//
//  Created by Bryce Pauken on 10/2/13.
//  Copyright (c) 2013 Kingfish. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BCPColor.h"
#import "BCPData.h"
#import "BCPDelegates.h"
#import "BCPFont.h"
#import "BCPImage.h"

@interface BCPCommon : NSObject

+ (UIColor *)BLUE;
+ (UIColor *)BUTTON_COLOR;
+ (UIColor *)BUTTON_DOWN_COLOR;
+ (int)BUTTON_HEIGHT;
+ (UIColor *)BUTTON_TEXT_COLOR;
+ (int)CONTENT_MIDDLE_PADDING;
+ (int)CONTENT_SIDE_PADDING;
+ (int)LOGIN_ICON_SIZE;
+ (int)INTRO_DESCRIPTION_ICON_SIZE;
+ (int)INTRO_ICON_SIZE;
+ (UIColor *)INTRO_SHADOW_COLOR;
+ (UIColor *)INTRO_TEXT_COLOR;
+ (BOOL)IS_IOS7;
+ (BOOL)IS_IPAD;
+ (int)SHADOW_SIZE;
+ (UIColor *)SIDEBAR_ACCENT_COLOR;
+ (int)SIDEBAR_CELL_HEIGHT;
+ (UIColor *)SIDEBAR_COLOR;
+ (float)SIDEBAR_DISABLED_ALPHA;
+ (UIColor *)SIDEBAR_DISABLED_COLOR;
+ (int)SIDEBAR_CELL_PADDING;
+ (UIColor *)SIDEBAR_HEADER_COLOR;
+ (int)SIDEBAR_HEADER_PADDING;
+ (UIColor *)SIDEBAR_SELECTED_COLOR;
+ (UIColor *)SIDEBAR_TEXT_COLOR;
+ (int)SIDEBAR_WIDTH;
+ (UIColor *)TEXTFIELD_COLOR;
+ (int)TEXTBOX_HEIGHT;
+ (int)TEXTBOX_PADDING;

+ (BCPData *)data;
+ (void)dismissKeyboard;
+ (void)error:(NSString *)error;
+ (void)logout;
+ (void)reloadSidebar;
+ (void)setKeyboardOwner:(NSObject<BCPKeyboardDelegate> *)keyboardDelegate;
+ (void)setInterfaceScrollViewEnabled:(BOOL)enabled;
+ (void)setScrollsToTop:(UIScrollView *)scrollView;
+ (void)setViewControllerDelegate:(NSObject<BCPViewControllerDelegate> *)viewControllerDelegate;
+ (void)showContentView:(NSString *)view;

@end