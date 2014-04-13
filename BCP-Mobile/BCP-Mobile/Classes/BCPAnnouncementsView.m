//
//  BCPAnnouncementsView.m
//  BCP-Mobile
//
//  Created by Bryce Pauken on 4/12/14.
//  Copyright (c) 2014 Kingfish. All rights reserved.
//

#import "BCPAnnouncementsView.h"

#import "BCPAnnouncementsCell.h"

@implementation BCPAnnouncementsView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.firstLoadCompleted = NO;
        
        self.tableView = [[UITableView alloc] initWithFrame:self.bounds];
        [self.tableView setAutoresizingMask:UIViewAutoresizingFlexibleSize];
        [self.tableView setBackgroundColor:[UIColor BCPOffWhiteColor]];
        [self.tableView setDataSource:self];
        [self.tableView setDelegate:self];
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        if([BCPCommon isIOS7]) {
            [self.tableView registerClass:[BCPAnnouncementsCell class] forCellReuseIdentifier:@"AnnouncementsCell"];
        }
        [self addSubview:self.tableView];
        
        UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 0)];
        [header setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        UIView *divider = [[UIView alloc] initWithFrame:CGRectMake(0, -1, self.tableView.bounds.size.width, 1)];
        [divider setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [divider setBackgroundColor:[UIColor BCPLightGrayColor]];
        [header addSubview:divider];
        [self.tableView setTableHeaderView:header];
        
        __unsafe_unretained typeof(self) weakSelf = self;
        [self.tableView addPullToRefreshWithActionHandler:^{
                [weakSelf loadAnnouncements];
        }];
        
        [self.navigationController setNavigationBarText:@"Announcements"];
    }
    return self;
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

- (void)setHidden:(BOOL)hidden {
    [super setHidden:hidden];
    if(!hidden&&!self.firstLoadCompleted) {
        [self.tableView triggerPullToRefresh];
        [self loadAnnouncements];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BCPAnnouncementsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AnnouncementsCell"];
    if (cell == nil) {
        cell = [[BCPAnnouncementsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AnnouncementsCell"];
    }
    [cell setText:[[[[[[BCPData data] objectForKey:@"announcements"] objectAtIndex:indexPath.section] objectForKey:@"announcements"] objectAtIndex:indexPath.row] objectForKey:@"announcement"]];
    return cell;
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
