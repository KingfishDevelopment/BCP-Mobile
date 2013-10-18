//
//  BCPContentViewAnnouncements.m
//  BCP-Mobile
//
//  Created by Bryce Pauken on 10/17/13.
//  Copyright (c) 2013 Kingfish. All rights reserved.
//

#import "BCPContentViewAnnouncements.h"

@implementation BCPContentViewAnnouncements

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.tableViewController = [[BCPContentViewAnnouncementsViewController alloc] init];
        
        self.tableView = [[UITableView alloc] init];
        [self.tableView setBackgroundColor:[BCPCommon BLUE]];
        [self.tableView setDataSource:self.tableViewController];
        [self.tableView setDelegate:self.tableViewController];
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self addSubview:self.tableView];
        [self setFrame:self.frame];
        __unsafe_unretained typeof(self) weakSelf = self;
        [self.tableView addPullToRefreshWithActionHandler:^{
            [[BCPCommon data] sendRequest:@"announcements" withDelegate:weakSelf];
        }];
        self.tableView.pullToRefreshView.arrowColor = [BCPCommon TABLEVIEW_COLOR];
        self.tableView.pullToRefreshView.textColor = [BCPCommon TABLEVIEW_COLOR];
        self.tableView.pullToRefreshView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
        
        self.navigationBar = [[BCPNavigationBar alloc] init];
        [self.navigationBar setText:@"Announcements"];
        [self addSubview:self.navigationBar];
    }
    return self;
}

- (void)preloadCells {
    int sections = 0;
    if([[BCPCommon data] objectForKey:@"announcements"])
        sections = [[[BCPCommon data] objectForKey:@"announcements"] count];
    for(int section=0;section<sections;section++) {
        int rows = [[[[[BCPCommon data] objectForKey:@"announcements"] objectAtIndex:section] objectForKey:@"announcements"] count];
        for(int row=0;row<rows;row++) {
            NSDictionary *announcement = [[[[[BCPCommon data] objectForKey:@"announcements"] objectAtIndex:section] objectForKey:@"announcements"] objectAtIndex:row];
            CGRect frame = CGRectMake(0, 0, self.frame.size.width, [BCPCommon TABLEVIEW_CELL_HEIGHT]);
            int scale = 1;
            if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] && [[UIScreen mainScreen] scale] == 2.0)
                scale = 2;
            NSString *key = [NSString stringWithFormat:@"%@%i%i%i%i",[announcement objectForKey:@"announcement"],(row>0),(int)self.frame.size.width,[BCPCommon TABLEVIEW_CELL_HEIGHT],scale];
            if([[BCPCommon data] loadCellWithKey:key]==nil) {
                [[BCPCommon data] saveCell:[BCPContentViewAnnouncementsCell drawCellWithFrame:frame withScale:scale withAnnouncement:[announcement objectForKey:@"announcement"] withDivider:(row>0) selected:NO] withKey:key];
                [[BCPCommon data] saveCell:[BCPContentViewAnnouncementsCell drawCellWithFrame:frame withScale:scale withAnnouncement:[announcement objectForKey:@"announcement"] withDivider:(row>0) selected:YES] withKey:[key stringByAppendingString:@"selected"]];
            }
        }
    }
    [[BCPCommon data] saveDictionary];
    [self.tableView.pullToRefreshView performSelectorOnMainThread:@selector(stopAnimating) withObject:nil waitUntilDone:NO];
    [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
}

- (void)responseReturnedError:(BOOL)error {
    [self performSelectorInBackground:@selector(preloadCells) withObject:nil];
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    [self.navigationBar setFrame:CGRectMake(0, 0, self.frame.size.width, [BCPCommon NAVIGATION_BAR_HEIGHT])];
    [self.tableView setFrame:CGRectMake(0, [BCPCommon NAVIGATION_BAR_HEIGHT], self.frame.size.width, self.frame.size.height-[BCPCommon NAVIGATION_BAR_HEIGHT])];
    [self.tableView reloadData];
}

- (void)setHidden:(BOOL)hidden {
    [super setHidden:hidden];
    
    if(!hidden&!self.loaded) {
        self.loaded = true;
        [[BCPCommon data] sendRequest:@"announcements" withDelegate:self];
        [self.tableView triggerPullToRefresh];
    }
}

@end
