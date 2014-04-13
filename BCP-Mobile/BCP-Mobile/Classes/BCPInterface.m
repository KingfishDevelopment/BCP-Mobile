//
//  BCPInterface.m
//  BCP-Mobile
//
//  Created by Bryce Pauken on 4/5/14.
//  Copyright (c) 2014 Kingfish. All rights reserved.
//

#import "BCPInterface.h"

#import "BCPContent.h"
#import "BCPSidebar.h"

@implementation BCPInterface

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        __unsafe_unretained typeof(self) weakSelf = self;
        
        UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Background"]];
        [background setAutoresizingMask:UIViewAutoresizingFlexibleMargins];
        [background setFrame:CGRectMake((self.bounds.size.width-background.image.size.width)/2, (self.bounds.size.height-background.image.size.height)/2, background.image.size.width, background.image.size.height)];
        [self addSubview:background];
        
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, BCP_SIDEBAR_WIDTH, self.bounds.size.height)];
        [self.scrollView setScrollsToTop:NO];
        
        self.sideBar = [[BCPSidebar alloc] initWithFrame:CGRectMake(0, 0, BCP_SIDEBAR_WIDTH, self.bounds.size.height)];
        [self.sideBar setSelectBlock:^(NSString *name) {
            [weakSelf.content showViewWithKey:name];
            [UIView animateWithDuration:BCP_TRANSITION_DURATION animations:^{
                [weakSelf.scrollView setContentOffset:CGPointMake(BCP_SIDEBAR_WIDTH, 0)];
            }];
        }];
        [self addSubview:self.sideBar];
        
        self.content = [[BCPContent alloc] initWithFrame:CGRectMake(BCP_SIDEBAR_WIDTH, 0, self.bounds.size.width, self.bounds.size.height)];
        [self.scrollView addSubview:self.content];
        NSString *lastViewKey = [[BCPData data] objectForKey:@"lastView"];
        if(lastViewKey) {
            [self.content showViewWithKey:lastViewKey];
            BOOL sectionFound = NO;
            for(int i=0;i<[self.sideBar.sections count];i++) {
                for(int j=0;j<[[self.sideBar.sections objectAtIndex:i] count];j++) {
                    if([[[self.sideBar.sections objectAtIndex:i] objectAtIndex:j] isEqualToString:lastViewKey]) {
                        [self.sideBar setSelectedIndexPath:[NSIndexPath indexPathForRow:j inSection:i*2+1]];
                        sectionFound = YES;
                        break;
                    }
                }
                if(sectionFound) {
                    break;
                }
            }
            [self.sideBar reloadData];
        }
        else {
            [self.content showViewWithKey:@"Welcome"];
        }
        
        [self.scrollView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
        [self.scrollView setBounces:NO];
        [self.scrollView setClipsToBounds:NO];
        [self.scrollView setContentOffset:CGPointMake(BCP_SIDEBAR_WIDTH, 0)];
        [self.scrollView setDelegate:self];
        [self.scrollView setPagingEnabled:YES];
        [self.scrollView setShowsHorizontalScrollIndicator:NO];
        [self.scrollView setShowsVerticalScrollIndicator:NO];
        [self addSubview:self.scrollView];
        self.scrollViewTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewTapped:)];
        [self.scrollViewTapRecognizer setCancelsTouchesInView:NO];
        [self.scrollViewTapRecognizer setEnabled:NO];
        [self.scrollView addGestureRecognizer:self.scrollViewTapRecognizer];
    }
    return self;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if(self.scrollView.contentOffset.x==0&&point.x<MIN(self.content.frame.origin.x,self.bounds.size.width-100))
        return self.sideBar;
    if(self.content.userInteractionEnabled&&CGRectContainsPoint(self.content.frame, [self.scrollView convertPoint:point fromView:self])) {
        return [self.content hitTest:[self.content convertPoint:point fromView:self] withEvent:event];
    }
    return self.scrollView;
}

- (void)layoutSubviews {
    [self.scrollView setContentSize:CGSizeMake(BCP_SIDEBAR_WIDTH*2, self.bounds.size.height)];
    [self.sideBar setTransform:CGAffineTransformIdentity];
    [self.sideBar setFrame:CGRectMake(0, 0, BCP_SIDEBAR_WIDTH, self.bounds.size.height)];
    [self.content setTransform:CGAffineTransformIdentity];
    [self.content setFrame:CGRectMake(BCP_SIDEBAR_WIDTH, 0, self.bounds.size.width, self.bounds.size.height)];
    [self scaleContent];
    [self scaleSidebar];
}

- (void)scaleContent {
    CGFloat scale = BCP_CONTENT_MIN_SCALE+(self.scrollView.contentOffset.x/(BCP_SIDEBAR_WIDTH*(1/(1-BCP_CONTENT_MIN_SCALE))));
    [self.content setTransform:CGAffineTransformScale(CGAffineTransformIdentity, scale, scale)];
}

- (void)scaleSidebar {
    CGFloat scale = 1-(self.scrollView.contentOffset.x/(BCP_SIDEBAR_WIDTH*(1/(1-BCP_CONTENT_MIN_SCALE*2))));
    [self.sideBar setAlpha:scale*scale*scale];
    [self.sideBar setTransform:CGAffineTransformScale(CGAffineTransformIdentity, scale, scale)];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self scaleContent];
    [self scaleSidebar];
    if(self.scrollView.contentOffset.x>=BCP_SIDEBAR_WIDTH) {
        [self.sideBar setContentOffset:CGPointZero];
    }
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    [self.content setUserInteractionEnabled:scrollView.contentOffset.x>0];
    [self.scrollViewTapRecognizer setEnabled:scrollView.contentOffset.x==0];
}

- (void)scrollViewTapped:(UIGestureRecognizer *)tap {
    CGPoint touchPoint = [tap locationInView:self.scrollView];
    if(CGRectContainsPoint(self.content.frame, touchPoint)) {
        [UIView animateWithDuration:BCP_TRANSITION_DURATION animations:^{
            [self.scrollView setContentOffset:CGPointMake(BCP_SIDEBAR_WIDTH, 0)];
        }];
    }
}

@end
