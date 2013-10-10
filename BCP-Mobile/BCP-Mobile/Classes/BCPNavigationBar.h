//
//  BCPNavigationBar.h
//  BCP-Mobile
//
//  Created by Bryce Pauken on 10/7/13.
//  Copyright (c) 2013 Kingfish. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BCPNavigationBar : UIView

@property (nonatomic, retain) UILabel *label;
@property (nonatomic, retain) UIImageView *shadow;

- (void)setText:(NSString *)text;

@end
