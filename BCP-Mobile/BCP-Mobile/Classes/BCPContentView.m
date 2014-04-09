//
//  BCPContentView.m
//  BCP-Mobile
//
//  Created by Bryce Pauken on 4/5/14.
//  Copyright (c) 2014 Kingfish. All rights reserved.
//

#import "BCPContentView.h"

@implementation BCPContentView

static void (^updateNavigationBlock)(BCPNavigationController *navigationController);

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setAutoresizingMask:UIViewAutoresizingFlexibleSize];
        [self setHidden:YES];
        
        self.navigationController = [[BCPNavigationController alloc] init];
    }
    return self;
}

- (void)setHidden:(BOOL)hidden {
    [super setHidden:hidden];
    if(!hidden&&updateNavigationBlock) {
        [self updateNavigation];
    }
}

+ (void)setUpdateNavigationBlock:(void (^)(BCPNavigationController *navigationController))newUpdateNavigationBlock {
    updateNavigationBlock = newUpdateNavigationBlock;
}

- (void)updateNavigation {
    if(!self.hidden) {
        updateNavigationBlock(self.navigationController);
    }
}

@end
