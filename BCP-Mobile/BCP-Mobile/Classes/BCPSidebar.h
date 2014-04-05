//
//  BCPSidebar.h
//  BCP-Mobile
//
//  Created by Bryce Pauken on 4/5/14.
//  Copyright (c) 2014 Kingfish. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BCPSidebarCell.h"

@interface BCPSidebar : UITableView <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *sections;
@property (nonatomic, copy) void (^selectBlock)(NSString *name);
@property (nonatomic, strong) NSArray *titles;

@end
