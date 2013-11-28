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
    return self.titles.count*2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    BCPSidebarCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell==nil) {
        cell = [[BCPSidebarCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [cell setDividerHidden:indexPath.row==0];
    [cell setText:[[self.sections objectAtIndex:indexPath.section/2] objectAtIndex:indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //[tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return section%2==0?60:0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section%2==0?0:[[self.sections objectAtIndex:section/2] count];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if(section%2==0) {
        UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SIDEBAR_WIDTH, [self tableView:tableView heightForFooterInSection:section])];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(SIDEBAR_CELL_PADDING, header.frame.size.height-20, SIDEBAR_WIDTH-SIDEBAR_CELL_PADDING*2, 20)];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setFont:[UIFont systemFontOfSize:14]];
        [label setText:[self.titles objectAtIndex:section/2]];
        [label setTextColor:[UIColor whiteColor]];
        [header addSubview:label];
        return header;
    }
    return nil;
}

@end
