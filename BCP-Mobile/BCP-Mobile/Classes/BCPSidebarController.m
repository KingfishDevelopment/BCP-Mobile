//
//  BCPSidebarController.m
//  BCP-Mobile
//
//  Created by Bryce Pauken on 11/17/13.
//  Copyright (c) 2013 Kingfish. All rights reserved.
//

#import "BCPSidebarController.h"

@interface BCPSidebarController ()

@end

@implementation BCPSidebarController

- (id)init {
    self = [super init];
    if(self) {
        self.sections = [NSArray arrayWithObjects:[NSArray arrayWithObjects:@"Grades",@"Email",@"Schedule",@"Planner",@"CSP Hours",@"Login",nil],[NSArray arrayWithObjects:@"Announcements",@"News",@"Calendar",@"Sports Results",nil],[NSArray arrayWithObjects:@"Settings",@"About",@"Rate This App",nil],nil];
        self.titles = [NSArray arrayWithObjects:@"My BCP",@"General",@"More",nil];
    }
    [BCPData initialize];
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    BCPSidebarCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell==nil) {
        cell = [[BCPSidebarCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [cell setDividerHidden:indexPath.row==0];
    [cell setText:[[self.sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.sections objectAtIndex:section] count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SIDEBAR_WIDTH, [self tableView:tableView heightForHeaderInSection:section])];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(SIDEBAR_CELL_PADDING, header.frame.size.height-20, SIDEBAR_WIDTH-SIDEBAR_CELL_PADDING*2, 20)];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setFont:[UIFont systemFontOfSize:14]];
    [label setText:[self.titles objectAtIndex:section]];
    [label setTextColor:[UIColor whiteColor]];
    [header addSubview:label];
    return header;
}

@end
