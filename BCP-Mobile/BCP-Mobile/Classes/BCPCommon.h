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
#import "BCPNavigationController.h"

@protocol BCPViewControllerDelegate<NSObject>
- (void)showSideBar;
@end

@interface BCPCommon : NSObject

+ (BOOL)isIOS7;
+ (void)setViewController:(NSObject<BCPViewControllerDelegate> *)newViewController;
+ (CGSize)sizeOfText:(NSString *)text withFont:(UIFont *)font;
+ (CGSize)sizeOfText:(NSString *)text withFont:(UIFont *)font constrainedToWidth:(CGFloat)width;
+ (NSObject<BCPViewControllerDelegate> *)viewController;

@end
