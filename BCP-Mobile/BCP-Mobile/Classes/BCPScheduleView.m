//
//  BCPGradesView.m
//  BCP-Mobile
//
//  Created by Bryce Pauken on 4/13/14.
//  Copyright (c) 2014 Kingfish. All rights reserved.
//

#import "BCPScheduleView.h"

#import "BCPGenericCell.h"
#import "BCPScheduleDetails.h"

@implementation BCPScheduleView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.firstLoadCompleted = NO;
        self.scrollingBack = NO;
        __unsafe_unretained typeof(self) weakSelf = self;
        
        self.scrollViews = [[NSMutableArray alloc] init];
        for(int i=0;i<3;i++) {
            UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:i<2?self.bounds:CGRectMake(0, self.bounds.size.height, self.bounds.size.width, self.bounds.size.height)];
            if(i>0) {
                [scrollView setDecelerationRate:UIScrollViewDecelerationRateFast];
                [scrollView setDelegate:self];
            }
            [scrollView setBounces:NO];
            [scrollView setPagingEnabled:i==0];
            [scrollView setScrollEnabled:NO];
            [scrollView setScrollsToTop:NO];
            [scrollView setShowsHorizontalScrollIndicator:NO];
            [scrollView setShowsVerticalScrollIndicator:NO];
            [scrollView setTag:i==0?[self currentSemester]*2:0];
            [self.scrollViews addObject:scrollView];
            if(i==0) {
                [self addSubview:scrollView];
            }
            else {
                [[self.scrollViews objectAtIndex:0] addSubview:scrollView];
            }
        }
        
        self.tableViews = [[NSMutableArray alloc] init];
        for(int i=0;i<2;i++) {
            UITableView *tableView = [[UITableView alloc] init];
            [tableView setBackgroundColor:[UIColor BCPOffWhiteColor]];
            [tableView setDataSource:self];
            [tableView setDelegate:self];
            [tableView setScrollsToTop:NO];
            [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
            [tableView setTag:i];
            if([BCPCommon isIOS7]) {
                [tableView registerClass:[BCPGenericCell class] forCellReuseIdentifier:@"ScheduleCell"];
            }
            [[self.scrollViews objectAtIndex:i+1] addSubview:tableView];
            [self.tableViews addObject:tableView];
            
            UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 0)];
            [header setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
            UIView *divider = [[UIView alloc] initWithFrame:CGRectMake(0, -1, tableView.bounds.size.width, 1)];
            [divider setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
            [divider setBackgroundColor:[UIColor BCPLightGrayColor]];
            [header addSubview:divider];
            [tableView setTableHeaderView:header];
            
            [tableView addPullToRefreshWithActionHandler:^{
                [weakSelf loadSchedule];
            }];
        }
        
        self.dividers = [[NSMutableArray alloc] init];
        for(int i=0;i<3;i++) {
            UIView *divider = [[UIView alloc] init];
            [divider setBackgroundColor:[UIColor BCPLightGrayColor]];
            [[self.scrollViews objectAtIndex:i] addSubview:divider];
            [self.dividers addObject:divider];
        }
        
        [self setNeedsLayout];
        
        [self.navigationController setNavigationBarText:[NSString stringWithFormat:@"Schedule (Semester %i)",[self currentSemester]+1]];
        self.navigationController.rightButtonImageName = [self currentSemester]==0?@"ArrowDown":@"ArrowUp";
        self.navigationController.rightButtonTapped = ^{
            [weakSelf changeSemester];
        };
        [self updateCurrentScrollView];
    }
    return self;
}

- (void)changeSemester {
    int newSemester = [self currentSemester]==0?1:0;
    [[BCPData data] setObject:[NSNumber numberWithInt:newSemester] forKey:@"lastScheduleSemester"];
    [BCPData saveDictionary];
    [self.navigationController setNavigationBarText:[NSString stringWithFormat:@"Schedule (Semester %i)",newSemester+1]];
    self.navigationController.rightButtonImageName = newSemester==0?@"ArrowDown":@"ArrowUp";
    [self updateNavigation];
    [[self.scrollViews objectAtIndex:0] setTag:newSemester*2];
    [UIView animateWithDuration:BCP_TRANSITION_DURATION animations:^{
        [self layoutSubviews];
    }];
    [self updateCurrentScrollView];
}

- (int)currentSemester {
    if(![[BCPData data] objectForKey:@"lastScheduleSemester"]) {
        NSDate *date = [NSDate date];
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *components = [calendar components:NSMonthCalendarUnit fromDate:date];
        [[BCPData data] setObject:[NSNumber numberWithInt:[components month]>=7?0:1] forKey:@"lastScheduleSemester"];
        [BCPData saveDictionary];
    }
    return [[[BCPData data] objectForKey:@"lastScheduleSemester"] intValue];
}

- (void)layoutSubviews {
    for(int i=0;i<3;i++) {
        [[self.scrollViews objectAtIndex:i] setFrame:i<2?self.bounds:CGRectMake(0, self.bounds.size.height, self.bounds.size.width, self.bounds.size.height)];
        if(i==0) {
            [[self.scrollViews objectAtIndex:i] setContentSize:CGSizeMake(self.bounds.size.width, self.bounds.size.height*2+1)];
        }
        else {
            [[self.scrollViews objectAtIndex:i] setContentSize:CGSizeMake(self.bounds.size.width*2+1, self.bounds.size.height)];
        }
    }
    for(int i=0;i<[self.tableViews count];i++) {
        [[self.tableViews objectAtIndex:i] setFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    }
    for(int i=0;i<[self.dividers count];i++) {
        [[self.dividers objectAtIndex:i] setFrame:CGRectMake(i==0?0:self.bounds.size.width, i==0?self.bounds.size.height:0, i==0?self.bounds.size.width*2+1:1, i==0?1:self.bounds.size.height)];
    }
    [self.details setFrame:CGRectMake(self.bounds.size.width+1, 0, self.bounds.size.width, self.bounds.size.height)];
    for(UIScrollView *scrollView in self.scrollViews) {
        [scrollView setContentOffset:CGPointMake((scrollView.bounds.size.width+1)*(scrollView.tag%2), (scrollView.bounds.size.height+1)*(scrollView.tag/2))];
    }
}

- (void)loadSchedule {
    [BCPData sendRequest:@"schedule" withDetails:[NSDictionary dictionaryWithObjectsAndKeys:[[[BCPData data] objectForKey:@"login"] objectForKey:@"token"],@"token",nil] onCompletion:^(NSString *error) {
        for(int i=0;i<[self.tableViews count];i++) {
            [[[self.tableViews objectAtIndex:i] pullToRefreshView] stopAnimating];
        }
        if(!error&&[[BCPData data] objectForKey:@"schedule"]) {
            for(int i=0;i<[self.tableViews count];i++) {
                [[self.tableViews objectAtIndex:i] performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
            }
        }
        else {
            [TSMessage showNotificationWithTitle:@"An Error has Occurred" subtitle:@"Please seek help if the problem persists." type:TSMessageNotificationTypeError];
        }
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if([scrollView isKindOfClass:[UITableView class]]||self.scrollingBack) {
        self.scrollingBack = NO;
        return;
    }
    int nearestIndex = (scrollView.contentOffset.x / (scrollView.bounds.size.width+1) + 0.5f);
    if(nearestIndex < scrollView.tag-1) {
        nearestIndex = (int)scrollView.tag-1;
    }
    [scrollView setTag:nearestIndex];
    dispatch_async(dispatch_get_main_queue(), ^{
        [scrollView setContentOffset:CGPointMake((scrollView.bounds.size.width+1)*nearestIndex, 0) animated:YES];
    });
    [self updateCurrentScrollView];
    if(nearestIndex==0) {
        __unsafe_unretained typeof(self) weakSelf = self;
        [self.navigationController setNavigationBarText:[NSString stringWithFormat:@"Grades (Semester %i)",[weakSelf currentSemester]+1]];
        self.navigationController.leftButtonImageName = @"Sidebar";
        self.navigationController.leftButtonTapped = ^{
            [[BCPCommon viewController] showSideBar];
        };
        self.navigationController.rightButtonImageName = [self currentSemester]==0?@"ArrowDown":@"ArrowUp";
        self.navigationController.rightButtonTapped = ^{
            [weakSelf changeSemester];
        };
        [self updateNavigation];
        [[self.scrollViews objectAtIndex:[self currentSemester]+1] setScrollEnabled:NO];
        [[self.scrollViews objectAtIndex:[self currentSemester]+1] setTag:0];
        [UIView animateWithDuration:BCP_TRANSITION_DURATION animations:^{
            [self layoutSubviews];
        }];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if([scrollView isKindOfClass:[UITableView class]]||velocity.x==0) {
        return;
    }
    self.scrollingBack = YES;
    int nearestIndex = (targetContentOffset->x / (scrollView.bounds.size.width+1) + 0.25f);
    if(nearestIndex < scrollView.tag-1) {
        nearestIndex = (int)scrollView.tag-1;
    }
    [scrollView setTag:nearestIndex];
    *targetContentOffset = CGPointMake((scrollView.bounds.size.width+1)*nearestIndex, targetContentOffset->y);
    dispatch_async(dispatch_get_main_queue(), ^{
        [scrollView setContentOffset:CGPointMake((scrollView.bounds.size.width+1)*nearestIndex, targetContentOffset->y) animated:YES];
    });
    [self updateCurrentScrollView];
    if(nearestIndex==0) {
        __unsafe_unretained typeof(self) weakSelf = self;
        [self.navigationController setNavigationBarText:[NSString stringWithFormat:@"Schedule (Semester %i)",[weakSelf currentSemester]+1]];
        self.navigationController.leftButtonImageName = @"Sidebar";
        self.navigationController.leftButtonTapped = ^{
            [[BCPCommon viewController] showSideBar];
        };
        self.navigationController.rightButtonImageName = [self currentSemester]==0?@"ArrowDown":@"ArrowUp";
        self.navigationController.rightButtonTapped = ^{
            [weakSelf changeSemester];
        };
        [self updateNavigation];
        [[self.scrollViews objectAtIndex:[self currentSemester]+1] setScrollEnabled:NO];
        [[self.scrollViews objectAtIndex:[self currentSemester]+1] setTag:0];
        [UIView animateWithDuration:BCP_TRANSITION_DURATION animations:^{
            [self layoutSubviews];
        }];
    }
}

- (void)setHidden:(BOOL)hidden {
    [super setHidden:hidden];
    if(!hidden&&!self.firstLoadCompleted) {
        self.firstLoadCompleted = YES;
        for(int i=0;i<[self.tableViews count];i++) {
            [[self.tableViews objectAtIndex:i] triggerPullToRefresh];
        }
        [self loadSchedule];
    }
    [self updateCurrentScrollView];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BCPGenericCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ScheduleCell"];
    if (cell == nil) {
        cell = [[BCPGenericCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ScheduleCell"];
    }
    [cell setText:[[[[[BCPData data] objectForKey:@"schedule"] objectForKey:[NSString stringWithFormat:@"semester%i",(int)(tableView.tag+1)]] objectAtIndex:indexPath.row] objectForKey:@"name"]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if(self.details&&[self.details superview]) {
        [self.details removeFromSuperview];
    }
    self.details = [[BCPScheduleDetails alloc] initWithFrame:CGRectMake(self.bounds.size.width*2+2, 0, self.bounds.size.width, self.bounds.size.height)];
    NSMutableDictionary *course = [[[[BCPData data] objectForKey:@"schedule"] objectForKey:[NSString stringWithFormat:@"semester%i",(int)(tableView.tag+1)]] objectAtIndex:indexPath.row];
    [self.details setTitle:[course objectForKey:@"name"] withDetails:[NSArray arrayWithObjects:[course objectForKey:@"teacher"],@"Teacher",[course objectForKey:@"period"],@"Period",[course objectForKey:@"room"],@"Room",@"",@"",[course objectForKey:@"course-section"],@"Course-Section:",nil]];
    [[self.scrollViews objectAtIndex:tableView.tag+1] addSubview:self.details];
    
    __unsafe_unretained typeof(self) weakSelf = self;
    [self.navigationController setNavigationBarText:[course objectForKey:@"name"]];
    [self.navigationController setLeftButtonImageName:@"ArrowLeft"];
    [self.navigationController setLeftButtonTapped:^{
        int newTag = (int)[[weakSelf.scrollViews objectAtIndex:[weakSelf currentSemester]+1] tag]-1;
        if(newTag==0) {
            [weakSelf.navigationController setNavigationBarText:[NSString stringWithFormat:@"Schedule (Semester %i)",[weakSelf currentSemester]+1]];
            weakSelf.navigationController.leftButtonImageName = @"Sidebar";
            weakSelf.navigationController.leftButtonTapped = ^{
                [[BCPCommon viewController] showSideBar];
            };
            weakSelf.navigationController.rightButtonImageName = [weakSelf currentSemester]==0?@"ArrowDown":@"ArrowUp";
            weakSelf.navigationController.rightButtonTapped = ^{
                [weakSelf changeSemester];
            };
            [weakSelf updateNavigation];
            [[weakSelf.scrollViews objectAtIndex:[weakSelf currentSemester]+1] setScrollEnabled:NO];
        }
        [[weakSelf.scrollViews objectAtIndex:[weakSelf currentSemester]+1] setTag:newTag];
        [UIView animateWithDuration:BCP_TRANSITION_DURATION animations:^{
            [weakSelf layoutSubviews];
        }];
        [weakSelf updateCurrentScrollView];
    }];
    [self.navigationController setRightButtonImageName:nil];
    [self.navigationController setRightButtonTapped:nil];
    [self updateNavigation];
    
    [[self.scrollViews objectAtIndex:tableView.tag+1] setScrollEnabled:YES];
    [[self.scrollViews objectAtIndex:tableView.tag+1] setTag:1];
    [UIView animateWithDuration:BCP_TRANSITION_DURATION animations:^{
        [self layoutSubviews];
    }];
    [self updateCurrentScrollView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return BCP_TABLEVIEW_CELL_HEIGHT;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if([[BCPData data] objectForKey:@"schedule"]) {
        return [[[[BCPData data] objectForKey:@"schedule"] objectForKey:[NSString stringWithFormat:@"semester%i",(int)(tableView.tag+1)]] count];
    }
    return 0;
}

- (void)updateCurrentScrollView {
    if(!self.hidden) {
        int currentSemester = [self currentSemester];
        int currentPage = (int)[[self.scrollViews objectAtIndex:currentSemester+1] tag];
        [[BCPCommon viewController] setScrollsToTop:currentPage==0?[self.tableViews objectAtIndex:currentSemester]:self.details.scrollView];
    }
}

@end
