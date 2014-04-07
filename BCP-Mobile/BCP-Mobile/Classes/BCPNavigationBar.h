//
//  BCPNavigationBar.h
//  BCP-Mobile
//
//  Created by Bryce Pauken on 4/5/14.
//  Copyright (c) 2014 Kingfish. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BCPNavigationBar : UIView

@property (nonatomic, retain) UILabel *label;
@property (nonatomic, retain) UIButton *leftButton;
@property (nonatomic, copy) void (^leftButtonTapped)();
@property (nonatomic, retain) UIButton *rightButton;
@property (nonatomic, copy) void (^rightButtonTapped)();

@end
