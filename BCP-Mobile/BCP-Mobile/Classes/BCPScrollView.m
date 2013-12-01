//
//  BCPScrollView.m
//  BCP-Mobile
//
//  Created by Bryce Pauken on 11/30/13.
//  Copyright (c) 2013 Kingfish. All rights reserved.
//

#import "BCPScrollView.h"

@implementation BCPScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUserInteractionEnabled:YES];
    }
    return self;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    return [super hitTest:point withEvent:event];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    return YES;
}

@end
