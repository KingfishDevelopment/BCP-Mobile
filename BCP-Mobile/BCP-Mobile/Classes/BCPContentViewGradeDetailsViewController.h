//
//  BCPContentViewGradeDetailsViewController.h
//  BCP-Mobile
//
//  Created by Bryce Pauken on 10/10/13.
//  Copyright (c) 2013 Kingfish. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BCPContentViewGradesCell.h"

@interface BCPContentViewGradeDetailsViewController : UITableViewController

@property (nonatomic, retain) NSDictionary *currentClass;

- (id)initWithClass:(NSDictionary *)class;
- (void)reloadTable;

@end
