//
//  BCPInterface.m
//  BCP-Mobile
//
//  Created by Bryce Pauken on 10/2/13.
//  Copyright (c) 2013 Kingfish. All rights reserved.
//

#import "BCPInterface.h"

@implementation BCPInterface

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.sidebarController = [[BCPSidebarController alloc] init];
        
        self.sidebar = [[UITableView alloc] init];
        [self.sidebar setDataSource:self.sidebarController];
        [self.sidebar setDelegate:self.sidebarController];
        [self.sidebarController setTableView:self.sidebar];
        [self addSubview:self.sidebar];
        
        self.sidebarHeader = [[UIView alloc] init];
        [self.sidebarHeader setBackgroundColor:[BCPCommon SIDEBAR_COLOR]];
        [self.sidebarHeader setHidden:![BCPCommon IS_IOS7]];
        [self addSubview:self.sidebarHeader];
        
        self.scrollView = [[UIScrollView alloc] init];
        [self.scrollView setBounces:NO];
        [self.scrollView setDelegate:self];
        [self.scrollView setPagingEnabled:YES];
        [self.scrollView setShowsHorizontalScrollIndicator:NO];
        [self.scrollView setShowsVerticalScrollIndicator:NO];
        UITapGestureRecognizer *scrollViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewTap:)];
        [scrollViewTap setDelegate:self];
        scrollViewTap.numberOfTapsRequired = 1;
        scrollViewTap.enabled = YES;
        scrollViewTap.cancelsTouchesInView = NO;
        [self.scrollView addGestureRecognizer:scrollViewTap];
        [self addSubview:self.scrollView];
        self.scrollViewShadow = [[UIImageView alloc] init];
        [self.scrollViewShadow setImage:[UIImage imageNamed:@"ShadowRight"]];
        [BCPImage registerView:self.scrollViewShadow withGetter:@"image" withSetter:@"setImage:" withImage:[UIImage imageNamed:@"ShadowRight"]];
        [self addSubview:self.scrollViewShadow];
        
        self.content = [[BCPContent alloc] init];
        [self.scrollView addSubview:self.content];
    }
    return self;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(![BCPCommon IS_IPAD]) {
        [self.sidebar setFrame:CGRectMake(-scrollView.contentOffset.x/5, 0, [BCPCommon SIDEBAR_WIDTH], self.scrollView.frame.size.height)];
        [self.scrollViewShadow setFrame:CGRectMake([BCPCommon SIDEBAR_WIDTH]-scrollView.contentOffset.x-[BCPCommon SHADOW_SIZE], 0, [BCPCommon SHADOW_SIZE], self.scrollView.frame.size.height)];
    }
    if(scrollView.contentOffset.x==0) {
        [self sendSubviewToBack:self.scrollView];
        [BCPCommon setScrollsToTop:self.sidebar];
        [self.content setUserInteractionEnabled:NO];
    }
    else
        [self bringSubviewToFront:self.scrollView];
    if(scrollView.contentOffset.x==[BCPCommon SIDEBAR_WIDTH])
        [self.content setUserInteractionEnabled:YES];
}

- (void)scrollViewTap:(UITapGestureRecognizer *)recognizer {
    if(self.content.userInteractionEnabled==NO&&![BCPCommon IS_IPAD]) {
        [UIView animateWithDuration:0.25 delay:0 options:0 animations:^ {
            [self.scrollView setContentOffset:CGPointMake([BCPCommon SIDEBAR_WIDTH], 0)];
        } completion:NULL];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if(scrollView.contentOffset.x==[BCPCommon SIDEBAR_WIDTH])
        [self.sidebar scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
}

- (void)setFrame:(CGRect)frame {
    if(![BCPCommon IS_IOS7]) {
        frame.origin.y-=40;
        frame.size.height+=40;
    }
    [super setFrame:frame];
    if(![BCPCommon IS_IPAD]) {
        [self.scrollView setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self.scrollView setContentSize:CGSizeMake(frame.size.width+[BCPCommon SIDEBAR_WIDTH], frame.size.height)];
        [self.scrollView setContentOffset:CGPointMake([BCPCommon SIDEBAR_WIDTH], 0)];
        
        [self.sidebar setFrame:CGRectMake(0, 0, [BCPCommon SIDEBAR_WIDTH], self.scrollView.frame.size.height)];
        [self.sidebarHeader setFrame:CGRectMake(0, 0, [BCPCommon SIDEBAR_WIDTH], 20)];
        
        [self.content setFrame:CGRectMake([BCPCommon SIDEBAR_WIDTH], 0, frame.size.width, frame.size.height)];
    }
    else {
        [self.scrollView setFrame:CGRectMake([BCPCommon SIDEBAR_WIDTH], 0, frame.size.width-[BCPCommon SIDEBAR_WIDTH], frame.size.height)];
        [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width, self.scrollView.frame.size.height)];
    
        [self.scrollViewShadow setFrame:CGRectMake([BCPCommon SIDEBAR_WIDTH]-[BCPCommon SHADOW_SIZE], 0, [BCPCommon SHADOW_SIZE], self.scrollView.frame.size.height)];
        
        [self.sidebar setFrame:CGRectMake(0, 0, [BCPCommon SIDEBAR_WIDTH], self.frame.size.height)];
        [self.sidebarHeader setFrame:CGRectMake(0, 0, [BCPCommon SIDEBAR_WIDTH], 20)];
        
        [self.content setFrame:CGRectMake(0, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height)];
    }
}

@end
