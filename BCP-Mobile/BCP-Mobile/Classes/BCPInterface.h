//
//  BCPInterface.h
//  BCP-Mobile
//
//  Created by Bryce Pauken on 4/5/14.
//  Copyright (c) 2014 Kingfish. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BCPContent.h"
#import "BCPSidebar.h"

@interface BCPInterface : UIView <UIScrollViewDelegate>


@property (nonatomic, retain) BCPContent *content;
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) BCPSidebar *sideBar;

@end
