//
//  BCPContent.h
//  BCP-Mobile
//
//  Created by Bryce Pauken on 10/2/13.
//  Copyright (c) 2013 Kingfish. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BCPContentViewIntro.h"

@interface BCPContent : UIView

@property (nonatomic, retain) NSDictionary *views;

- (void)showContentView:(NSString *)view;

@end
