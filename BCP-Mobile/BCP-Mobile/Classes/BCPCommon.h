//
//  BCPCommon.h
//  BCP-Mobile
//
//  Created by Bryce Pauken on 11/17/13.
//  Copyright (c) 2013 Kingfish. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "BCPConstants.h"
#import "BCPData.h"
#import "BCPDelegates.h"
#import "FUIAlertView.h"
#import "FUIButton.h"
#import "TSMessage.h"
#import "UIColor+BCPColors.h"

@interface BCPCommon : NSObject

+ (void)alertWithTitle:(NSString *)title withText:(NSString*)text;
+ (BOOL)IS_IOS7;
+ (BOOL)IS_IPAD;
+ (void)setViewControllerDelegate:(NSObject<BCPViewControllerDelegate> *)viewControllerDelegate;
+ (NSObject<BCPViewControllerDelegate> *) viewController;

@end
