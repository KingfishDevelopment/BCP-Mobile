//
//  BCPCalendarView.m
//  BCP-Mobile
//
//  Created by Bryce Pauken on 4/14/14.
//  Copyright (c) 2014 Kingfish. All rights reserved.
//

#import "BCPCalendarView.h"

#import "BCPGenericCell.h"

@implementation BCPCalendarView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.firstLoadCompleted = NO;
        self.firstTableViewPosition = 0;
        self.scrollingBack = NO;
        self.startDate = [NSDate date];
        
        self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        [self.scrollView setAutoresizingMask:UIViewAutoresizingFlexibleSize];
        [self.scrollView setBackgroundColor:[UIColor greenColor]];
        [self.scrollView setBounces:NO];
        [self.scrollView setDelegate:self];
        [self.scrollView setScrollsToTop:NO];
        [self.scrollView setShowsHorizontalScrollIndicator:NO];
        [self.scrollView setShowsVerticalScrollIndicator:NO];
        [self.scrollView setTag:0];
        [self addSubview:self.scrollView];
        
        __unsafe_unretained typeof(self) weakSelf = self;
        self.tableViews = [[NSMutableArray alloc] init];
        for(int i=0;i<3;i++) {
            UITableView *tableView = [[UITableView alloc] init];
            [tableView setBackgroundColor:[UIColor BCPOffWhiteColor]];
            [tableView setBackgroundColor:i==0?[UIColor redColor]:(i==1?[UIColor orangeColor]:[UIColor yellowColor])];
            [tableView setDataSource:self];
            [tableView setDelegate:self];
            [tableView setScrollsToTop:NO];
            [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
            [tableView setTag:i];
            if([BCPCommon isIOS7]) {
                [tableView registerClass:[BCPGenericCell class] forCellReuseIdentifier:@"CalendarCell"];
            }
            [self.scrollView addSubview:tableView];
            [self.tableViews addObject:tableView];
            
            UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 0)];
            [header setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
            UIView *divider = [[UIView alloc] initWithFrame:CGRectMake(0, -1, tableView.bounds.size.width, 1)];
            [divider setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
            [divider setBackgroundColor:[UIColor BCPLightGrayColor]];
            [header addSubview:divider];
            [tableView setTableHeaderView:header];
            
            [tableView addPullToRefreshWithActionHandler:^{
                [weakSelf loadCalendar];
            }];
        }
        
        [self setNeedsLayout];
        [self.navigationController setNavigationBarText:@"Calendar"];
    }
    return self;
}

- (int)convertedTag {
    int positiveTag = (int)self.scrollView.tag;
    if(positiveTag<0) {
        positiveTag = -positiveTag;
        if(positiveTag%3==1) {
            positiveTag = 2;
        }
        else if(positiveTag%3==2) {
            positiveTag = 1;
        }
    }
    return positiveTag;
}

- (NSArray *)dateWithOffset:(int)offset {
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setDay:offset];
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self.startDate options:0];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear fromDate:newDate];
    return [NSArray arrayWithObjects:[NSString stringWithFormat:@"%i",(int)[components month]],[NSString stringWithFormat:@"%i",(int)[components day]],[NSString stringWithFormat:@"%i",(int)[components year]],nil];
}

- (void)layoutSubviews {
    [self.scrollView setContentSize:CGSizeMake(self.bounds.size.width*5+4,self.bounds.size.height)];
    [self positionTableViews];
    [self.scrollView setContentOffset:CGPointMake((self.bounds.size.width+1)*2, 0)];
}

- (void)loadCalendar {
    [BCPData sendRequest:@"calendar" withDetails:nil onCompletion:^(NSString *error) {
        for(UITableView *tableView in self.tableViews) {
            [[tableView pullToRefreshView] stopAnimating];
        }
        if(!error&&[[BCPData data] objectForKey:@"news"]) {
            for(UITableView *tableView in self.tableViews) {
                [tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
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

- (void)positionTableViews {
    for(int i=0;i<3;i++) {
        [[self.tableViews objectAtIndex:([self convertedTag]+i)%3] setFrame:CGRectMake((self.scrollView.bounds.size.width+1)*(i+1), 0, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height)];
    }
    [self updateCurrentScrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if([scrollView isKindOfClass:[UITableView class]]||self.scrollingBack) {
        self.scrollingBack = NO;
        return;
    }
    int nearestIndex = (scrollView.contentOffset.x / (scrollView.bounds.size.width+1) + 0.5f);
    nearestIndex = (int)MIN(MAX(nearestIndex,1),3);
    dispatch_async(dispatch_get_main_queue(), ^{
        [scrollView setContentOffset:CGPointMake((scrollView.bounds.size.width+1)*nearestIndex, 0) animated:YES];
    });
    [self updateCurrentScrollView];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if([scrollView isKindOfClass:[UITableView class]]||velocity.x==0) {
        return;
    }
    self.scrollingBack = YES;
    int nearestIndex = (targetContentOffset->x / (scrollView.bounds.size.width+1) + 0.5f);
    nearestIndex = (int)MIN(MAX(nearestIndex,1),3);
    *targetContentOffset = CGPointMake((scrollView.bounds.size.width+1)*nearestIndex, targetContentOffset->y);
    dispatch_async(dispatch_get_main_queue(), ^{
        [scrollView setContentOffset:CGPointMake((scrollView.bounds.size.width+1)*nearestIndex, targetContentOffset->y) animated:YES];
    });
    [self updateCurrentScrollView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    BOOL changeTag = NO;
    if(scrollView.contentOffset.x<=(self.bounds.size.width+1)) {
        [scrollView setTag:scrollView.tag-1];
        changeTag = YES;
    }
    else if(scrollView.contentOffset.x>=(self.bounds.size.width+1)*3) {
        [scrollView setTag:scrollView.tag+1];
        changeTag = YES;
    }
    if(changeTag) {
        [scrollView setContentOffset:CGPointMake((self.bounds.size.width+1)*2, 0)];
        [self positionTableViews];
    }
}

- (void)setHidden:(BOOL)hidden {
    [super setHidden:hidden];
    if(!hidden&&!self.firstLoadCompleted) {
        self.firstLoadCompleted = YES;
        for(UITableView *tableView in self.tableViews) {
            [tableView triggerPullToRefresh];
        }
        [self loadCalendar];
    }
    [self updateCurrentScrollView];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (void)updateCurrentScrollView {
    if(!self.hidden) {
        [[BCPCommon viewController] setScrollsToTop:[self.tableViews objectAtIndex:([self convertedTag]+1)%3]];
    }
}

@end
