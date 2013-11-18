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

+ (void)setViewControllerDelegate:(NSObject<BCPViewControllerDelegate> *)viewControllerDelegate {
    viewController = viewControllerDelegate;
}

+ (NSObject<BCPViewControllerDelegate> *) viewController {
    return viewController;
}

@end
