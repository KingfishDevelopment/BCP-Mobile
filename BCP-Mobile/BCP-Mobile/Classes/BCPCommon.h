//
//  BCPCommon.h
//  BCP-Mobile
//
//  Created by Bryce Pauken on 4/5/14.
//  Copyright (c) 2014 Kingfish. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BCPColors.h"
#import "BCPConstants.h"
#import "BCPData.h"
#import "BCPNavigationController.h"
#import "SVPullToRefresh.h"
#import "TSMessage.h"

@protocol BCPViewControllerDelegate<NSObject>
- (UIView *)currentNotification;
- (void)insertSubviewBelowNavigationBar:(UIView *)view;
- (BOOL)loggedIn;
- (int)navigationBarHeight;
- (void)setLoggedIn:(BOOL)loggedIn;
- (void)showSideBar;
@end

@interface BCPCommon : NSObject

+ (BOOL)isIOS7;
+ (BOOL)isIPad;
+ (void)setViewController:(NSObject<BCPViewControllerDelegate> *)newViewController;
+ (CGSize)sizeOfText:(NSString *)text withFont:(UIFont *)font;
+ (CGSize)sizeOfText:(NSString *)text withFont:(UIFont *)font constrainedToWidth:(CGFloat)width;
+ (CGSize)sizeOfText:(NSString *)text withFont:(UIFont *)font constrainedToWidth:(CGFloat)width singleLine:(BOOL)singleLine;
+ (CGSize)sizeOfText:(NSString *)text withFont:(UIFont *)font singleLine:(BOOL)singleLine;
+ (NSObject<BCPViewControllerDelegate> *)viewController;

@end
