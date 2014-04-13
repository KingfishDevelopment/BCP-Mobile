//
//  BCPAnnouncementsView.h
//  BCP-Mobile
//
//  Created by Bryce Pauken on 4/12/14.
//  Copyright (c) 2014 Kingfish. All rights reserved.
//

#import "BCPContentView.h"

@class BCPAnnouncementsDetails;

@interface BCPAnnouncementsView : BCPContentView <UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) BCPAnnouncementsDetails *detailsView;
@property (nonatomic) BOOL firstLoadCompleted;
@property (nonatomic) BOOL scrollingBack;
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) UITableView *tableView;

@end
