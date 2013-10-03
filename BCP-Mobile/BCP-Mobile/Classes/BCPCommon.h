//
//  BCPCommon.h
//  BCP-Mobile
//
//  Created by Bryce Pauken on 10/2/13.
//  Copyright (c) 2013 Kingfish. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol BCPKeyboardDelegate<NSObject>
- (void)keyboardHidden:(NSNotification*)notification;
- (void)keyboardShown:(NSNotification*)notification;
@end

@protocol BCPViewControllerDelegate<NSObject>
- (void)setScrollsToTop:(UIScrollView *)scrollView;
@end

@interface BCPCommon : NSObject

+ (UIColor *)BLUE;
+ (BOOL)IS_IOS7;
+ (BOOL)IS_IPAD;
+ (UIColor *)SIDEBAR_ACCENT_COLOR;
+ (int)SIDEBAR_CELL_HEIGHT;
+ (UIColor *)SIDEBAR_COLOR;
+ (int)SIDEBAR_CELL_PADDING;
+ (UIColor *)SIDEBAR_HEADER_COLOR;
+ (int)SIDEBAR_HEADER_PADDING;
+ (UIColor *)SIDEBAR_SELECTED_COLOR;
+ (UIColor *)SIDEBAR_TEXT_COLOR;
+ (int)SHADOW_SIZE;
+ (int)SIDEBAR_WIDTH;

+ (void)setScrollsToTop:(UIScrollView *)scrollView;
+ (void)setViewControllerDelegate:(NSObject<BCPViewControllerDelegate> *)viewControllerDelegate;

@end