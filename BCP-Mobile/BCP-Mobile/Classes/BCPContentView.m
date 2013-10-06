//
//  BCPContentView.m
//  BCP-Mobile
//
//  Created by Bryce Pauken on 10/4/13.
//  Copyright (c) 2013 Kingfish. All rights reserved.
//

#import "BCPContentView.h"

@implementation BCPContentView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)addShadowToView:(UIView *)view {
    view.layer.shadowColor = [BCPCommon INTRO_SHADOW_COLOR].CGColor;
    view.layer.shadowOffset = CGSizeMake(0, 4);
    view.layer.shadowOpacity = 0.8;
    view.layer.shadowRadius = 4;
    view.clipsToBounds = NO;
}

- (void)formatLabel:(UILabel *)label {
    [label setLineBreakMode:NSLineBreakByWordWrapping];
    [label setNumberOfLines:0];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setFont:[BCPFont boldSystemFontOfSize:20]];
    [label setTextColor:[BCPCommon INTRO_TEXT_COLOR]];
    [label setShadowColor:[BCPCommon INTRO_SHADOW_COLOR]];
    [label setShadowOffset:CGSizeMake(0,2)];
}

- (void)keyboardHidden:(NSNotification*)notification {
    NSLog(@"hidden");
}

- (void)keyboardShown:(NSNotification*)notification {
    NSLog(@"shown");
}

@end
