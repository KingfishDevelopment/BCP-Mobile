//
//  BCPSidebarCell.h
//  BCP-Mobile
//
//  Created by Bryce Pauken on 4/5/14.
//  Copyright (c) 2014 Kingfish. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BCPSidebarCell : UITableViewCell

@property (nonatomic, strong) UIView *divider;
@property (nonatomic, strong) UIView *highlight;
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *label;

- (void)setDividerHidden:(BOOL)hidden;
- (void)setText:(NSString *)text;

@end
