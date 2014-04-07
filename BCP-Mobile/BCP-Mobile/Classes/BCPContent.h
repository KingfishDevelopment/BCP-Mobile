//
//  BCPContent.h
//  BCP-Mobile
//
//  Created by Bryce Pauken on 4/5/14.
//  Copyright (c) 2014 Kingfish. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BCPNavigationBar;
@interface BCPContent : UIView

@property (nonatomic, retain) UIView *container;
@property (nonatomic, retain) BCPNavigationBar *navigationBar;
@property (nonatomic, retain) NSMutableDictionary *views;

- (void)showViewWithKey:(NSString *)showKey;

@end
