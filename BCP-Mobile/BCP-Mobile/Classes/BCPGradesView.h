//
//  BCPGradesView.h
//  BCP-Mobile
//
//  Created by Bryce Pauken on 4/8/14.
//  Copyright (c) 2014 Kingfish. All rights reserved.
//

#import "BCPContentView.h"

@interface BCPGradesView : BCPContentView <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) BOOL firstLoadCompleted;
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) NSMutableDictionary *selectedCourse;
@property (nonatomic, retain) NSMutableArray *tableViews;

@end
