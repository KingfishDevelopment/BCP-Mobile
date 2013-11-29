//
//  BCPCommon.m
//  BCP-Mobile
//
//  Created by Bryce Pauken on 11/17/13.
//  Copyright (c) 2013 Kingfish. All rights reserved.
//

#import "BCPCommon.h"

static NSObject<BCPViewControllerDelegate> *viewController = nil;

@implementation BCPCommon

+ (BOOL)IS_IOS7 {
    return ([[[UIDevice currentDevice] systemVersion] compare:@"7" options:NSNumericSearch] != NSOrderedAscending);
}

+ (BOOL)IS_IPAD {
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
}

+ (void)setViewControllerDelegate:(NSObject<BCPViewControllerDelegate> *)viewControllerDelegate {
    viewController = viewControllerDelegate;
}

+ (NSObject<BCPViewControllerDelegate> *) viewController {
    return viewController;
}

@end
