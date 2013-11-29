//
//  BCPContent.h
//  BCP-Mobile
//
//  Created by Bryce Pauken on 11/17/13.
//  Copyright (c) 2013 Kingfish. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BCPContentLogin.h"

@interface BCPContent : UIView

@property (nonatomic, retain) NSDictionary *views;

- (void)showContentView:(NSString *)view;

@end
