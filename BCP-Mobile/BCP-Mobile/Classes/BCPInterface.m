//
//  BCPInterface.m
//  BCP-Mobile
//
//  Created by Bryce Pauken on 11/17/13.
//  Copyright (c) 2013 Kingfish. All rights reserved.
//

#import "BCPInterface.h"

@implementation BCPInterface

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor BCPOffWhite]];
        
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SIDEBAR_WIDTH, self.bounds.size.height)];
        [self.scrollView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
        [self.scrollView setBounces:NO];
        [self.scrollView setClipsToBounds:NO];
        [[BCPCommon viewController] registerViewForRotation:self.scrollView withBlock:^(void) {
            [self.scrollView setContentSize:CGSizeMake(SIDEBAR_WIDTH*2, self.bounds.size.height)];
            self.i++;
        }];
        [self.scrollView setPagingEnabled:YES];
        [self.scrollView setShowsHorizontalScrollIndicator:NO];
        [self addSubview:self.scrollView];
        
        UIView *block = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SIDEBAR_WIDTH, self.bounds.size.height)];
        [block setBackgroundColor:[UIColor redColor]];
        [self.scrollView addSubview:block];
        
        self.content = [[BCPContent alloc] initWithFrame:CGRectMake(SIDEBAR_WIDTH, 0, self.bounds.size.width, self.bounds.size.height)];
        [self.scrollView addSubview:self.content];
    }
    return self;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if([self pointInside:point withEvent:event])
        return self.scrollView;
    return nil;
}

- (void)layoutSubviews {
    [self.content setFrame:CGRectMake(SIDEBAR_WIDTH, 0, self.bounds.size.width, self.bounds.size.height)];
}

@end
