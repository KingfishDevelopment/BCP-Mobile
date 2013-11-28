//
//  BCPSidebarController.h
//  BCP-Mobile
//
//  Created by Bryce Pauken on 11/17/13.
//  Copyright (c) 2013 Kingfish. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BCPSidebarCell.h"

@interface BCPSidebarController : UITableViewController

@property (nonatomic, retain) NSArray *sections;
@property (nonatomic, retain) NSArray *titles;

@end
