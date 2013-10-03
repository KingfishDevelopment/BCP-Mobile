//
//  BCPSidebarController.m
//  BCP-Mobile
//
//  Created by Bryce Pauken on 10/2/13.
//  Copyright (c) 2013 Kingfish. All rights reserved.
//

#import "BCPSidebarController.h"

@interface BCPSidebarController ()

@end

@implementation BCPSidebarController

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        self.sections = [NSArray arrayWithObjects:[NSArray arrayWithObjects:@"Grades",@"Email",@"Schedule",@"Planner",@"CSP Hours",@"Login",nil],[NSArray arrayWithObjects:@"Announcements",@"News",@"Calendar",@"Sports Results",nil],[NSArray arrayWithObjects:@"Settings",@"About",@"Rate This App",nil],nil];
        self.titles = [NSArray arrayWithObjects:@"My BCP",@"General",@"More",nil];
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.sections count];
}

- (void)setTableView:(UITableView *)tableView {
    [super setTableView:tableView];
    [tableView setBackgroundColor:[BCPCommon SIDEBAR_COLOR]];
    if([BCPCommon IS_IOS7])
        [tableView setContentInset:UIEdgeInsetsMake(20, 0, 0, 0)];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    UIView *divider = [[UIView alloc] init];
    [divider setBackgroundColor:[BCPCommon SIDEBAR_ACCENT_COLOR]];
    [divider setFrame:CGRectMake(0, 0, tableView.frame.size.width, 1)];
    [tableView setTableFooterView:divider];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BCPSidebarCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SidebarCell"];
    if(cell==nil) {
        cell = [[BCPSidebarCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SidebarCell"];
    }
    [cell setDividerHidden:(indexPath.row==0)];
    [cell setLabelText:[[self.sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [BCPCommon SIDEBAR_CELL_HEIGHT];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.sections objectAtIndex:section] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.titles objectAtIndex:section];
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 20)];
    [headerView setBackgroundColor:[BCPCommon SIDEBAR_HEADER_COLOR]];
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake([BCPCommon SIDEBAR_HEADER_PADDING], [BCPCommon SIDEBAR_HEADER_PADDING]/2, tableView.frame.size.width-([BCPCommon SIDEBAR_HEADER_PADDING]*2), 20)];
    [headerLabel setBackgroundColor:[UIColor clearColor]];
    [headerLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [headerLabel setText:[self tableView:tableView titleForHeaderInSection:section]];
    [headerLabel setTextColor:[BCPCommon SIDEBAR_TEXT_COLOR]];
    [headerView addSubview:headerLabel];
    
    return headerView;
}

@end
