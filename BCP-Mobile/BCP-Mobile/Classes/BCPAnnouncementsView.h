//
//  BCPAnnouncementsView.h
//  BCP-Mobile
//
//  Created by Bryce Pauken on 4/12/14.
//  Copyright (c) 2014 Kingfish. All rights reserved.
//

#import "BCPContentView.h"

@interface BCPAnnouncementsView : BCPContentView <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) BOOL firstLoadCompleted;
@property (nonatomic, retain) UITableView *tableView;

@end
