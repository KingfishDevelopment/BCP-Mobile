//
//  BCPNavigationBar.h
//  BCP-Mobile
//
//  Created by Bryce Pauken on 11/28/13.
//  Copyright (c) 2013 Kingfish. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BCPNavigationBar : UIView

@property (nonatomic, strong) UIImageView *background;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIImageView *shadow;

- (void)setText:(NSString *)text;

@end
