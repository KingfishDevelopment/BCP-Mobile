//
//  BCPContentViewGrades.h
//  BCP-Mobile
//
//  Created by Bryce Pauken on 10/6/13.
//  Copyright (c) 2013 Kingfish. All rights reserved.
//

#import "BCPContentView.h"
#import "BCPContentViewGradesViewController.h"
#import "BCPContentViewGradeDetailsViewController.h"

@interface BCPContentViewGrades : BCPContentView <BCPDataDelegate, BCPTableViewDelegate, UIScrollViewDelegate>

@property (nonatomic) BOOL loaded;
@property (nonatomic, retain) BCPNavigationBar *navigationBar;
@property (nonatomic, retain) BCPNavigationBar *navigationBarDetails;
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) UIImageView *scrollViewShadow;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) UITableView *tableViewDetails;
@property (nonatomic, retain) BCPContentViewGradesViewController *tableViewController;
@property (nonatomic, retain) BCPContentViewGradeDetailsViewController *tableViewDetailsController;

@end
