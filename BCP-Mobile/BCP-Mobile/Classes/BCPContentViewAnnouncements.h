//
//  BCPContentViewAnnouncements.h
//  BCP-Mobile
//
//  Created by Bryce Pauken on 10/17/13.
//  Copyright (c) 2013 Kingfish. All rights reserved.
//

#import "BCPContentView.h"
#import "BCPContentViewAnnouncementsViewController.h"

@interface BCPContentViewAnnouncements : BCPContentView <BCPDataDelegate>

@property (nonatomic) BOOL loaded;
@property (nonatomic, retain) BCPNavigationBar *navigationBar;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) BCPContentViewAnnouncementsViewController *tableViewController;

@end
