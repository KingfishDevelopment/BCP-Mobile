//
//  BCPGradesView.h
//  BCP-Mobile
//
//  Created by Bryce Pauken on 4/13/14.
//  Copyright (c) 2014 Kingfish. All rights reserved.
//

#import "BCPContentView.h"

@class BCPScheduleDetails;

@interface BCPScheduleView : BCPContentView <UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) BCPScheduleDetails *details;
@property (nonatomic, retain) NSMutableArray *dividers;
@property (nonatomic) BOOL firstLoadCompleted;
@property (nonatomic, retain) NSMutableArray *scrollViews;
@property (nonatomic) BOOL scrollingBack;
@property (nonatomic, retain) NSMutableDictionary *selectedCourse;
@property (nonatomic, retain) NSMutableArray *tableViews;

@end
