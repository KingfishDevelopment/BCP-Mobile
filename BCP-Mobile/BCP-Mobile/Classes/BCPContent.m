//
//  BCPContent.m
//  BCP-Mobile
//
//  Created by Bryce Pauken on 11/17/13.
//  Copyright (c) 2013 Kingfish. All rights reserved.
//

#import "BCPContent.h"

@implementation BCPContent

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [[self layer] setMasksToBounds:NO];
        [[self layer] setShadowOffset:CGSizeMake(0, 2)];
        [[self layer] setShadowOpacity:0.4];
        [[self layer] setShadowPath:[UIBezierPath bezierPathWithRect:self.bounds].CGPath];
        [[BCPCommon viewController] registerBlockForBeforeAnimationRotation:^(void) {
            [[self layer] setShadowPath:[UIBezierPath bezierPathWithRect:self.bounds].CGPath];
            [[self layer] setShadowOpacity:0];
        }];
        [[BCPCommon viewController] registerBlockForAfterRotation:^(void) {
            [[self layer] setShadowPath:[UIBezierPath bezierPathWithRect:self.bounds].CGPath];
            [[self layer] setShadowOpacity:0.4];
        }];
        [[self layer] setShadowRadius:2];
        [self setBackgroundColor:[UIColor BCPOffWhite]];
        [self setUserInteractionEnabled:YES];
        self.views = [NSDictionary dictionaryWithObjectsAndKeys:[[BCPContentLogin alloc] initWithFrame:self.bounds],@"Login",[[BCPContentLogout alloc] initWithFrame:self.bounds],@"Logout",nil];
        for(NSString *key in [self.views allKeys]) {
            [[self.views objectForKey:key] setHidden:YES];
            [self addSubview:[self.views objectForKey:key]];
        }
    }
    return self;
}

- (UIView *)currentView {
    return [self.views objectForKey:self.currentViewName];
}

- (void)showContentView:(NSString *)view {
    for(NSString *key in [self.views allKeys]) {
        [[self.views objectForKey:key] setHidden:![key isEqualToString:view]];
        if([key isEqualToString:view]) {
            self.currentViewName = key;
            [[self.views objectForKey:key] shown];
        }
    }
}

@end
