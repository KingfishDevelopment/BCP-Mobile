//
//  BCPNavigationBarButtonController.m
//  BCP-Mobile
//
//  Created by Bryce Pauken on 4/6/14.
//  Copyright (c) 2014 Kingfish. All rights reserved.
//

#import "BCPNavigationController.h"

@implementation BCPNavigationController

- (id)init {
    self = [super init];
    if(self) {
        self.navigationBarText = @"BCP Mobile";
        self.leftButtonImageName = @"Sidebar";
        self.leftButtonTapped = ^{
            [[BCPCommon viewController] showSideBar];
        };
        self.rightButtonImageName = nil;
        self.rightButtonTapped = nil;
    }
    return self;
}

@end
