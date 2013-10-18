//
//  BCPContentViewAnnouncementsViewController.m
//  BCP-Mobile
//
//  Created by Bryce Pauken on 10/17/13.
//  Copyright (c) 2013 Kingfish. All rights reserved.
//

#import "BCPContentViewAnnouncementsViewController.h"

@interface BCPContentViewAnnouncementsViewController ()

@end

@implementation BCPContentViewAnnouncementsViewController

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if([[BCPCommon data] objectForKey:@"announcements"]) {
        return [[[BCPCommon data] objectForKey:@"announcements"] count];
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[[[BCPCommon data] objectForKey:@"announcements"] objectAtIndex:section] objectForKey:@"announcements"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BCPContentViewAnnouncementsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AnnouncementsCell2"];
    if(cell==nil) {
        cell = [[BCPContentViewAnnouncementsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AnnouncementsCell3"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    }
    
    NSDictionary *announcement = [[[[[BCPCommon data] objectForKey:@"announcements"] objectAtIndex:indexPath.section] objectForKey:@"announcements"] objectAtIndex:indexPath.row];
    [cell setTextWithAnnouncement:[announcement objectForKey:@"announcement"] withDivder:indexPath.row>0];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSDictionary *announcement = [[[[[BCPCommon data] objectForKey:@"announcements"] objectAtIndex:indexPath.section] objectForKey:@"announcements"] objectAtIndex:indexPath.row];
    [BCPCommon alertWithTitle:[announcement objectForKey:@"announcement"] withText:([announcement objectForKey:@"details"]&&![[announcement objectForKey:@"details"] isEqualToString:@""]?[announcement objectForKey:@"details"]:@"No details were provided for this announcement.")];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [BCPCommon TABLEVIEW_HEADER_HEIGHT];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [BCPCommon TABLEVIEW_CELL_HEIGHT];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if([self numberOfSectionsInTableView:tableView]>1) {
        UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, [BCPCommon TABLEVIEW_HEADER_HEIGHT])];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake([BCPCommon TABLEVIEW_HEADER_PADDING], 0, header.frame.size.width-[BCPCommon TABLEVIEW_HEADER_PADDING]*2, header.frame.size.height)];
        [label setBackgroundColor:[BCPCommon BLUE]];
        [label setFont:[BCPFont boldSystemFontOfSize:16]];
        [label setText:[[[[BCPCommon data] objectForKey:@"announcements"] objectAtIndex:section] objectForKey:@"title"]];
        [label setTextColor:[BCPColor colorWithWhite:1 alpha:1]];
        [header addSubview:label];
        [header setBackgroundColor:[BCPCommon BLUE]];
        return header;
    }
    else {
        UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 0)];
        return header;
    }
}

@end
