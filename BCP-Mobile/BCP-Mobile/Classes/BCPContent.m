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
        
        self.views = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[[BCPContentViewIntro alloc] init],[[BCPContentViewLogin alloc] init],[[BCPContentViewLogout alloc] init],nil] forKeys:[NSArray arrayWithObjects:@"intro",@"login",@"logout",nil]];
        for(NSString *key in [self.views allKeys]) {
            [[self.views objectForKey:key] setHidden:YES];
            [self addSubview:[self.views objectForKey:key]];
        }
        if([[BCPCommon data] objectForKey:@"lastView"]) {
            [BCPCommon showContentView:[[BCPCommon data] objectForKey:@"lastView"]];
        }
        else {
            if(![BCPCommon IS_IPAD])
                [BCPCommon setInterfaceScrollViewEnabled:NO];
            [self showContentView:@"intro"];
        }
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    CGRect viewFrame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    for(NSString *key in [self.views allKeys])
        [[self.views objectForKey:key] setFrame:viewFrame];
}

- (void)showContentView:(NSString *)view {
    for(NSString *key in [self.views allKeys]) {
        [[self.views objectForKey:key] setHidden:![key isEqualToString:view]];
        if([key isEqualToString:view])
            [BCPCommon setKeyboardOwner:[self.views objectForKey:key]];
    }
}

@end
