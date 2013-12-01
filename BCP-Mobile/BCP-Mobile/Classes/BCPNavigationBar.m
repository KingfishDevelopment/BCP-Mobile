//
//  BCPNavigationBar.m
//  BCP-Mobile
//
//  Created by Bryce Pauken on 11/28/13.
//  Copyright (c) 2013 Kingfish. All rights reserved.
//

#import "BCPNavigationBar.h"

@implementation BCPNavigationBar

- (id)initWithFrame:(CGRect)frame
{
    if([BCPCommon IS_IOS7])
        frame.size.height+=20;
    self = [super initWithFrame:frame];
    if (self) {
        [self setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [self setClipsToBounds:NO];
        
        self.background = [[UIImageView alloc] initWithFrame:self.bounds];
        [self.background setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
        [self.background setImage:[UIImage imageNamed:@"NavigationBar"]];
        [self addSubview:self.background];
        
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, frame.size.width-20, frame.size.height-([BCPCommon IS_IOS7]?0:20))];
        [self.label setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
        [self.label setBackgroundColor:[UIColor clearColor]];
        [self.label setFont:[UIFont boldSystemFontOfSize:20]];
        [self.label setShadowColor:[UIColor colorWithWhite:0.2 alpha:0.8]];
        [self.label setShadowOffset:CGSizeMake(0,2)];
        [self.label setTextAlignment:NSTextAlignmentCenter];
        [self.label setTextColor:[UIColor whiteColor]];
        [self addSubview:self.label];
        
        self.shadow = [[UIImageView alloc] initWithFrame:CGRectMake(0, frame.size.height, frame.size.width, 2)];
        [self.shadow setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [self.shadow setImage:[UIImage imageNamed:@"ShadowBelow"]];
        [self addSubview:self.shadow];
    }
    return self;
}

- (void)setText:(NSString *)text {
    [self.label setText:text];
}

@end
