//
//  BCPColor.h
//  BCP-Mobile
//
//  Created by Bryce Pauken on 10/3/13.
//  Copyright (c) 2013 Kingfish. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BCPColor : NSObject

+ (UIColor *)colorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;
+ (UIColor *)colorWithWhite:(CGFloat)white alpha:(CGFloat)alpha;

+ (void)registerView:(UIView *)view withGetter:(NSString *)getter withSetter:(NSString *)setter;
+ (void)updateColors;

@end
