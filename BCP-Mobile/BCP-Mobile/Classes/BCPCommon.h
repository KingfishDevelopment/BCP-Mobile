//
//  BCPCommon.h
//  BCP-Mobile
//
//  Created by Bryce Pauken on 4/5/14.
//  Copyright (c) 2014 Kingfish. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BCPConstants.h"

@class BCPViewController;

@interface BCPCommon : NSObject

+ (BOOL)isIOS7;
+ (void)setViewController:(BCPViewController *)newViewController;
+ (BCPViewController *)viewController;

@end
