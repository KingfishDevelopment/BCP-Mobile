//
//  BCPSidebar.m
//  BCP-Mobile
//
//  Created by Bryce Pauken on 4/5/14.
//  Copyright (c) 2014 Kingfish. All rights reserved.
//

#import "BCPSidebar.h"

#import "BCPSidebarCell.h"

@implementation BCPSidebar

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        [self setClipsToBounds:NO];
        [self setContentInset:UIEdgeInsetsMake(BCP_SIDEBAR_VERTICAL_PADDING, 0, BCP_SIDEBAR_VERTICAL_PADDING, 0)];
        [self setDataSource:self];
        [self setDelegate:self];
        [self setScrollsToTop:NO];
        [self setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self setShowsHorizontalScrollIndicator:NO];
        [self setShowsVerticalScrollIndicator:NO];
        if([BCPCommon isIOS7]) {
            [self registerClass:[BCPSidebarCell class] forCellReuseIdentifier:@"SidebarCell"];
        }
        
        //self.sections = [NSArray arrayWithObjects:[NSArray arrayWithObjects:@"Grades",@"Email",@"Schedule",@"Planner",@"CSP Hours",@"Login",nil],[NSArray arrayWithObjects:@"Announcements",@"News",@"Calendar",@"Sports Results",nil],[NSArray arrayWithObjects:@"Settings",@"About",@"Rate This App",nil],nil];
        self.sections = [NSArray arrayWithObjects:[NSArray arrayWithObjects:@"Grades",@"Schedule",@"Login",nil],[NSArray arrayWithObjects:@"Announcements",@"News",@"Calendar",nil],[NSArray arrayWithObjects:@"Settings",@"About",@"Rate This App",nil],nil];
        self.titles = [NSArray arrayWithObjects:@"My BCP",@"General",@"More",nil];
    }
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
    NSString *row = [[self.sections objectAtIndex:indexPath.section/2] objectAtIndex:indexPath.row];
    bool disableCell = false;
    if([[BCPCommon viewController] loggedIn]&&[row isEqualToString:@"Login"]) {
        if([row isEqualToString:@"Login"])
            row = @"Logout";
    }
    if(indexPath.section==1) {
        if([row isEqualToString:@"Login"]) {
            if([[BCPCommon viewController] loggedIn])
                row = @"Logout";
        }
        else if(![[BCPCommon viewController] loggedIn])
            disableCell = true;
    }
    [cell setUserInteractionEnabled:!disableCell];
    [cell setText:row];
    if([indexPath isEqual:self.selectedIndexPath]) {
        [cell.highlight setHidden:NO];
    }
    else {
        [cell.highlight setHidden:YES];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if([indexPath isEqual:self.selectedIndexPath]) {
        return;
    }
    if(self.selectedIndexPath) {
        [((BCPSidebarCell *)[self cellForRowAtIndexPath:self.selectedIndexPath]).highlight setHidden:YES];
    }
    self.selectedIndexPath = indexPath;
    [((BCPSidebarCell *)[self cellForRowAtIndexPath:self.selectedIndexPath]).highlight setHidden:NO];
    NSString *row = [[self.sections objectAtIndex:indexPath.section/2] objectAtIndex:indexPath.row];
    if([row isEqualToString:@"Login"]&&[[BCPCommon viewController] loggedIn])
        row = @"Logout";
    if(self.selectBlock) {
        self.selectBlock(row);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return section%2==0?60:0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section%2==0?0:[[self.sections objectAtIndex:section/2] count];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if(section%2==0) {
        UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BCP_SIDEBAR_WIDTH, [self tableView:tableView heightForFooterInSection:section])];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(BCP_SIDEBAR_CELL_PADDING, header.frame.size.height-20, BCP_SIDEBAR_WIDTH-BCP_SIDEBAR_CELL_PADDING*2, 20)];
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
