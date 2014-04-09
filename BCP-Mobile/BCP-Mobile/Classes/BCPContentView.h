//
//  BCPContentView.h
//  BCP-Mobile
//
//  Created by Bryce Pauken on 4/5/14.
//  Copyright (c) 2014 Kingfish. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BCPContentView : UIView

@property (nonatomic, retain) BCPNavigationController *navigationController;

+ (void)setUpdateNavigationBlock:(void (^)(BCPNavigationController *navigationController))newUpdateNavigationBlock;
- (void)updateNavigation;

@end