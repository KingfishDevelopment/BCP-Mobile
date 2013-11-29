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
        [self setBackgroundColor:[UIColor colorWithWhite:0.8 alpha:0.2]];
        [self setClipsToBounds:NO];
        
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, frame.size.width-40, frame.size.height-20)];
        [self.label setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
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
