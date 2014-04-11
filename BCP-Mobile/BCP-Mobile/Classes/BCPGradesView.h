//
//  BCPGradesView.h
//  BCP-Mobile
//
//  Created by Bryce Pauken on 4/8/14.
//  Copyright (c) 2014 Kingfish. All rights reserved.
//

#import "BCPContentView.h"

@class BCPGradesDetails;

@interface BCPGradesView : BCPContentView <UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) BCPGradesDetails *details;
@property (nonatomic, retain) NSMutableArray *dividers;
@property (nonatomic) BOOL firstLoadCompleted;
@property (nonatomic, retain) NSMutableArray *scrollViews;
@property (nonatomic, retain) NSMutableDictionary *selectedCourse;
@property (nonatomic) BOOL selectedDetail;
@property (nonatomic, retain) NSMutableArray *tableViews;

@end
