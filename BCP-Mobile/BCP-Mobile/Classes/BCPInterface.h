//
//  BCPInterface.h
//  BCP-Mobile
//
//  Created by Bryce Pauken on 11/17/13.
//  Copyright (c) 2013 Kingfish. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BCPContent.h"
#import "BCPScrollView.h"
#import "BCPSidebarController.h"

@interface BCPInterface : UIView <UIScrollViewDelegate>

@property (nonatomic, strong) UIImageView *background;
@property (nonatomic, strong) BCPContent *content;
@property (nonatomic, strong) BCPScrollView *scrollView;
@property (nonatomic, strong) UITableView *sidebar;
@property (nonatomic, strong) UITableViewController *sidebarController;

@end
