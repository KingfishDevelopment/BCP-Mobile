//
//  BCPCommon.m
//  BCP-Mobile
//
//  Created by Bryce Pauken on 4/5/14.
//  Copyright (c) 2014 Kingfish. All rights reserved.
//

#import "BCPCommon.h"

@implementation BCPCommon

static BCPViewController *viewController = nil;

+ (BOOL)isIOS7 {
    return ([[[UIDevice currentDevice] systemVersion] compare:@"7" options:NSNumericSearch] != NSOrderedAscending);
}

+ (void)setViewController:(BCPViewController *)newViewController {
    viewController = newViewController;
}

+ (BCPViewController *)viewController {
    return viewController;
}

@end
