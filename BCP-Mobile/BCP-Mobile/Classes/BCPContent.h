//
//  BCPContent.h
//  BCP-Mobile
//
//  Created by Bryce Pauken on 10/2/13.
//  Copyright (c) 2013 Kingfish. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BCPContentViewAnnouncements.h"
#import "BCPContentViewGrades.h"
#import "BCPContentViewIntro.h"
#import "BCPContentViewLogin.h"
#import "BCPContentViewLogout.h"

@interface BCPContent : UIView

@property (nonatomic, retain) NSMutableDictionary *views;

- (void)showContentView:(NSString *)view;

@end
