//
//  BCPContent.m
//  BCP-Mobile
//
//  Created by Bryce Pauken on 10/2/13.
//  Copyright (c) 2013 Kingfish. All rights reserved.
//

#import "BCPContent.h"

@implementation BCPContent

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[BCPCommon BLUE]];
        [BCPColor registerView:self withGetter:@"backgroundColor" withSetter:@"setBackgroundColor:"];
    }
    return self;
}

- (void)showContentView:(NSString *)view {
    NSLog(@"%@",view);
}

@end
