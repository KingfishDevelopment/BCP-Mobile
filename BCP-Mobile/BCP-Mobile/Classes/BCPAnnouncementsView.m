//
//  BCPAnnouncementsView.m
//  BCP-Mobile
//
//  Created by Bryce Pauken on 4/12/14.
//  Copyright (c) 2014 Kingfish. All rights reserved.
//

#import "BCPAnnouncementsView.h"

#import "BCPAnnouncementsCell.h"
#import "BCPAnnouncementsDetails.h"

@implementation BCPAnnouncementsView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.firstLoadCompleted = NO;
        self.scrollingBack = NO;
        
        self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        [self.scrollView setAutoresizingMask:UIViewAutoresizingFlexibleSize];
        [self.scrollView setBounces:NO];
        [self.scrollView setDelegate:self];
        [self.scrollView setScrollEnabled:NO];
        [self.scrollView setShowsHorizontalScrollIndicator:NO];
        [self.scrollView setShowsVerticalScrollIndicator:NO];
        [self.scrollView setTag:0];
        [self addSubview:self.scrollView];
        
        self.tableView = [[UITableView alloc] initWithFrame:self.bounds];
        [self.tableView setBackgroundColor:[UIColor BCPOffWhiteColor]];
        [self.tableView setDataSource:self];
        [self.tableView setDelegate:self];
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        if([BCPCommon isIOS7]) {
            [self.tableView registerClass:[BCPAnnouncementsCell class] forCellReuseIdentifier:@"AnnouncementsCell"];
        }
        [self.scrollView addSubview:self.tableView];
        
        UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 0)];
        [header setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        UIView *divider = [[UIView alloc] initWithFrame:CGRectMake(0, -1, self.tableView.bounds.size.width, 1)];
        [divider setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [divider setBackgroundColor:[UIColor BCPLightGrayColor]];
        [header addSubview:divider];
        [self.tableView setTableHeaderView:header];
        
        self.divider = [[UIView alloc] init];
        [self.divider setBackgroundColor:[UIColor BCPLightGrayColor]];
        [self.scrollView addSubview:self.divider];
        
        self.detailsView = [[BCPAnnouncementsDetails alloc] init];
        [self.scrollView addSubview:self.detailsView];
        
        [self setNeedsLayout];
        
        __unsafe_unretained typeof(self) weakSelf = self;
        [self.tableView addPullToRefreshWithActionHandler:^{
                [weakSelf loadAnnouncements];
        }];
        
        [self.navigationController setNavigationBarText:@"Announcements"];
    }
    return self;
}

- (void)layoutSubviews {
    [self.scrollView setContentSize:CGSizeMake(self.bounds.size.width*2+1, self.bounds.size.height)];
    [self.tableView setFrame:CGRectMake(0, 0, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height)];
    [self.detailsView setFrame:CGRectMake(self.bounds.size.width+1, 0, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height)];
    [self.divider setFrame:CGRectMake(self.bounds.size.width, 0, 1, self.bounds.size.height)];
    [self.scrollView setContentOffset:CGPointMake((self.bounds.size.width+1)*self.scrollView.tag, 0)];
}

- (void)loadAnnouncements {
    [BCPData sendRequest:@"announcements" withDetails:nil onCompletion:^(NSString *error) {
        [[self.tableView pullToRefreshView] stopAnimating];
        if(!error&&[[BCPData data] objectForKey:@"announcements"]) {
            [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
        }
        else {
            [TSMessage showNotificationWithTitle:@"An Error has Occurred" subtitle:@"Please seek help if the problem persists." type:TSMessageNotificationTypeError];
        }
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if([[BCPData data] objectForKey:@"announcements"]) {
        return [[[BCPData data] objectForKey:@"announcements"] count];
    }
    return 0;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if([scrollView isKindOfClass:[UITableView class]]||self.scrollingBack) {
        self.scrollingBack = NO;
        return;
    }
    int nearestIndex = (scrollView.contentOffset.x / (scrollView.bounds.size.width+1) + 0.5f);
    [scrollView setTag:nearestIndex];
    dispatch_async(dispatch_get_main_queue(), ^{
        [scrollView setContentOffset:CGPointMake((scrollView.bounds.size.width+1)*nearestIndex, 0) animated:YES];
    });
    if(nearestIndex==0) {
        self.navigationController.leftButtonImageName = @"Sidebar";
        self.navigationController.leftButtonTapped = ^{
            [[BCPCommon viewController] showSideBar];
        };
        [self updateNavigation];
        [self.scrollView setScrollEnabled:NO];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if([scrollView isKindOfClass:[UITableView class]]||velocity.x==0) {
        return;
    }
    self.scrollingBack = YES;
    int nearestIndex = (targetContentOffset->x / (scrollView.bounds.size.width+1) + 0.25f);
    [scrollView setTag:nearestIndex];
    *targetContentOffset = CGPointMake((scrollView.bounds.size.width+1)*nearestIndex, targetContentOffset->y);
    dispatch_async(dispatch_get_main_queue(), ^{
        [scrollView setContentOffset:CGPointMake((scrollView.bounds.size.width+1)*nearestIndex, targetContentOffset->y) animated:YES];
    });
    if(nearestIndex==0) {
        self.navigationController.leftButtonImageName = @"Sidebar";
        self.navigationController.leftButtonTapped = ^{
            [[BCPCommon viewController] showSideBar];
        };
        [self updateNavigation];
        [self.scrollView setScrollEnabled:NO];
    }
}

- (void)setHidden:(BOOL)hidden {
    [super setHidden:hidden];
    if(!hidden&&!self.firstLoadCompleted) {
        self.firstLoadCompleted = YES;
        [self.tableView triggerPullToRefresh];
        [self loadAnnouncements];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BCPAnnouncementsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AnnouncementsCell"];
    if (cell == nil) {
        cell = [[BCPAnnouncementsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AnnouncementsCell"];
    }
    NSDictionary *announcement = [[[[[BCPData data] objectForKey:@"announcements"] objectAtIndex:indexPath.section] objectForKey:@"announcements"] objectAtIndex:indexPath.row];
    [cell setText:[announcement objectForKey:@"announcement"]];
    [cell setUserInteractionEnabled:([announcement objectForKey:@"more_info"]&&[[announcement objectForKey:@"more_info"] length]>0)||([announcement objectForKey:@"url"]&&[[announcement objectForKey:@"url"] length]>0)];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSDictionary *announcement = [[[[[BCPData data] objectForKey:@"announcements"] objectAtIndex:indexPath.section] objectForKey:@"announcements"] objectAtIndex:indexPath.row];
    [self.detailsView setTitle:[announcement objectForKey:@"announcement"] withDescription:[announcement objectForKey:@"more_info"] withURL:[announcement objectForKey:@"url"]];
    
    __unsafe_unretained typeof(self) weakSelf = self;
    [self.navigationController setLeftButtonImageName:@"ArrowLeft"];
    [self.navigationController setLeftButtonTapped:^{
        weakSelf.navigationController.leftButtonImageName = @"Sidebar";
        weakSelf.navigationController.leftButtonTapped = ^{
            [[BCPCommon viewController] showSideBar];
        };
        [weakSelf updateNavigation];
        [weakSelf.scrollView setScrollEnabled:NO];
        [weakSelf.scrollView setTag:0];
        [UIView animateWithDuration:BCP_TRANSITION_DURATION animations:^{
            [weakSelf.scrollView setContentOffset:CGPointZero];
        }];
    }];
    [self updateNavigation];
    
    [self.scrollView setScrollEnabled:YES];
    [self.scrollView setTag:1];
    [UIView animateWithDuration:BCP_TRANSITION_DURATION animations:^{
        [self layoutSubviews];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return BCP_TABLEVIEW_HEADER_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGSize labelSize = [BCPCommon sizeOfText:[[[[[[BCPData data] objectForKey:@"announcements"] objectAtIndex:indexPath.section] objectForKey:@"announcements"] objectAtIndex:indexPath.row] objectForKey:@"announcement"] withFont:[BCPAnnouncementsCell font] constrainedToWidth:self.tableView.bounds.size.width-[BCPCommon tableViewPadding]*2];
    return MAX(labelSize.height+30,50);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[[[BCPData data] objectForKey:@"announcements"] objectAtIndex:section] objectForKey:@"announcements"] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [[[[BCPData data] objectForKey:@"announcements"] objectAtIndex:section] objectForKey:@"category"];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, [self tableView:tableView heightForHeaderInSection:section])];
    [view setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [view setBackgroundColor:[UIColor BCPMoreOffWhiteColor]];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake([BCPCommon tableViewPadding], 4, view.bounds.size.width-[BCPCommon tableViewPadding]*2, view.bounds.size.height-8)];
    [label setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [label setBackgroundColor:[UIColor BCPMoreOffWhiteColor]];
    [label setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:14]];
    [label setText:[self tableView:tableView titleForHeaderInSection:section]];
    [label setTextColor:[UIColor BCPOffBlackColor]];
    [view addSubview:label];
    
    return view;
}

@end
