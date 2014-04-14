//
//  BCPCalendarView.h
//  BCP-Mobile
//
//  Created by Bryce Pauken on 4/14/14.
//  Copyright (c) 2014 Kingfish. All rights reserved.
//

#import "BCPContentView.h"

@interface BCPCalendarView : BCPContentView <UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) BOOL firstLoadCompleted;
@property (nonatomic) int firstTableViewPosition;
@property (nonatomic) BOOL scrollingBack;
@property (nonatomic, retain) NSDate *startDate;
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) NSMutableArray *tableViews;

@end
