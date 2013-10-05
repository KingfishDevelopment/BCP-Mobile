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
#import "BCPFont.h"
#import "BCPImage.h"

@protocol BCPKeyboardDelegate<NSObject>
- (void)keyboardHidden:(NSNotification*)notification;
- (void)keyboardShown:(NSNotification*)notification;
@end

@protocol BCPViewControllerDelegate<NSObject>
- (void)setScrollsToTop:(UIScrollView *)scrollView;
- (void)showContentView:(NSString *)view;
@end

@interface BCPCommon : NSObject

+ (UIColor *)BLUE;
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

+ (BCPData *)data;
+ (void)setScrollsToTop:(UIScrollView *)scrollView;
+ (void)setViewControllerDelegate:(NSObject<BCPViewControllerDelegate> *)viewControllerDelegate;
+ (void)showContentView:(NSString *)view;

@end