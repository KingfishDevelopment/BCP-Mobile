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
        self.background = [[UIImageView alloc] initWithFrame:self.bounds];
        [self.background setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
        [self.background setImage:[UIImage imageNamed:@"Background"]];
        [self addSubview:self.background];
        
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SIDEBAR_WIDTH, self.bounds.size.height)];
        
        self.sidebarController = [[BCPSidebarController alloc] init];
        self.sidebar = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SIDEBAR_WIDTH, self.bounds.size.height)];
        [self.sidebar registerClass:[BCPSidebarCell class] forCellReuseIdentifier:@"SidebarCell"];
        [self.sidebar setBackgroundColor:[UIColor clearColor]];
        [self.sidebar setClipsToBounds:NO];
        [self.sidebar setContentInset:UIEdgeInsetsMake(SIDEBAR_VERTICAL_PADDING, 0, SIDEBAR_VERTICAL_PADDING, 0)];
        [self.sidebar setDataSource:self.sidebarController];
        [self.sidebar setDelegate:self.sidebarController];
        [self.sidebar setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self.sidebar setShowsVerticalScrollIndicator:NO];
        [self addSubview:self.sidebar];
        
        self.content = [[BCPContent alloc] initWithFrame:CGRectMake(SIDEBAR_WIDTH, 0, self.bounds.size.width, self.bounds.size.height)];
        [self.scrollView addSubview:self.content];
        
        [self.scrollView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
        [self.scrollView setBounces:NO];
        [self.scrollView setClipsToBounds:NO];
        [[BCPCommon viewController] registerBlockForAfterRotation:^(void) {
            [self.sidebar setHidden:NO];
        }];
        [[BCPCommon viewController] registerBlockForBeforeAnimationRotation:^(void) {
            if(self.scrollView.contentOffset.x==SIDEBAR_WIDTH)
                [self.sidebar setHidden:YES];
        }];
        [[BCPCommon viewController] registerBlockForBeforeRotation:^(void) {
            [self.scrollView setContentSize:CGSizeMake(SIDEBAR_WIDTH*2, self.bounds.size.height)];
        }];
        [self.scrollView setContentOffset:CGPointMake(SIDEBAR_WIDTH, 0)];
        [self.scrollView setDelegate:self];
        [self.scrollView setPagingEnabled:YES];
        [self.scrollView setShowsHorizontalScrollIndicator:NO];
        [self.scrollView setShowsVerticalScrollIndicator:NO];
        [self addSubview:self.scrollView];
    }
    return self;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if(self.scrollView.contentOffset.x==0&&point.x<SIDEBAR_WIDTH)
        return self.sidebar;
    return self.scrollView;
}

- (void)layoutContent {
    CGFloat scale = CONTENT_MIN_SCALE+(self.scrollView.contentOffset.x/(SIDEBAR_WIDTH*(1/(1-CONTENT_MIN_SCALE))));
    self.content.transform = CGAffineTransformScale(CGAffineTransformIdentity, scale, scale);
    /*CGRect frame = self.content.frame;
    CGFloat offset = -(1-(self.scrollView.contentOffset.x/SIDEBAR_WIDTH))*(CONTENT_MIN_SCALE*self.bounds.size.width/4);
    CGFloat offset = (scale-1)*(frame.size.width/(1/CONTENT_MIN_SCALE));
    frame.origin.x=SIDEBAR_WIDTH+offset;
    self.content.frame = frame;*/
}

- (void)layoutSidebar {
    CGFloat scale = 1-(self.scrollView.contentOffset.x/(SIDEBAR_WIDTH*(1/(1-CONTENT_MIN_SCALE*2))));
    self.sidebar.alpha = scale*scale*scale;
    self.sidebar.transform = CGAffineTransformScale(CGAffineTransformIdentity, scale, scale);
}

- (void)layoutSubviews {
    self.sidebar.transform = CGAffineTransformIdentity;
    [self.sidebar setFrame:CGRectMake(0, 0, SIDEBAR_WIDTH, self.bounds.size.height)];
    self.content.transform = CGAffineTransformIdentity;
    [self.content setFrame:CGRectMake(SIDEBAR_WIDTH, 0, self.bounds.size.width, self.bounds.size.height)];
    [self layoutSidebar];
    [self layoutContent];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self layoutContent];
    [self layoutSidebar];
    if(scrollView.contentOffset.x==0)
        [self.content setUserInteractionEnabled:NO];
    else if(scrollView.contentOffset.x==SIDEBAR_WIDTH)
        [self.content setUserInteractionEnabled:YES];
}

@end
