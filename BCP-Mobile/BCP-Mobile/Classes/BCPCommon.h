//
//  BCPCommon.h
//  BCP-Mobile
//
//  Created by Bryce Pauken on 11/17/13.
//  Copyright (c) 2013 Kingfish. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BCPConstants.h"
#import "BCPData.h"
#import "BCPDelegates.h"
#import "UIColor+BCPColors.h"

@interface BCPCommon : NSObject

+ (void)setViewControllerDelegate:(NSObject<BCPViewControllerDelegate> *)viewControllerDelegate;
+ (NSObject<BCPViewControllerDelegate> *) viewController;

@end
