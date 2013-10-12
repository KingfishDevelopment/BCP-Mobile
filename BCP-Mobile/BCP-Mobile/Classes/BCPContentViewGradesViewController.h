//
//  BCPContentViewGradesViewController.h
//  BCP-Mobile
//
//  Created by Bryce Pauken on 10/7/13.
//  Copyright (c) 2013 Kingfish. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BCPContentViewGradesCell.h"

@interface BCPContentViewGradesViewController : UITableViewController

@property (nonatomic, retain) NSArray *classes;
@property (nonatomic, retain) NSObject<BCPTableViewDelegate> *delegate;

- (id)initWithDelegate:(NSObject<BCPTableViewDelegate> *)delegate;;

@end
