//
//  BCPInterface.h
//  BCP-Mobile
//
//  Created by Bryce Pauken on 11/17/13.
//  Copyright (c) 2013 Kingfish. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BCPContent.h"

@interface BCPInterface : UIView

@property (nonatomic, retain) BCPContent *content;
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) UIView *sideBar;

@end
