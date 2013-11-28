//
//  BCPInterface.h
//  BCP-Mobile
//
//  Created by Bryce Pauken on 11/17/13.
//  Copyright (c) 2013 Kingfish. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BCPContent.h"
#import "BCPSidebarController.h"

@interface BCPInterface : UIView <UIScrollViewDelegate>

@property (nonatomic, retain) UIImageView *background;
@property (nonatomic, retain) BCPContent *content;
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) UITableView *sidebar;
@property (nonatomic, retain) UITableViewController *sidebarController;

@end
