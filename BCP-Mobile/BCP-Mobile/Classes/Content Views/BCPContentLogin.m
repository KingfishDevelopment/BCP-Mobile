//
//  BCPContentLogin.m
//  BCP-Mobile
//
//  Created by Bryce Pauken on 11/28/13.
//  Copyright (c) 2013 Kingfish. All rights reserved.
//

#import "BCPContentLogin.h"

@implementation BCPContentLogin

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.navigationBar = [[BCPNavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, NAVIGATION_BAR_HEIGHT)];
        [self.navigationBar setText:@"Login"];
        [self addSubview:self.navigationBar];
    }
    return self;
}

@end
