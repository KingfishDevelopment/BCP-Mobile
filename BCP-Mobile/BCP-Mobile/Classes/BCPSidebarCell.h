//
//  BCPSidebarCell.h
//  BCP-Mobile
//
//  Created by Bryce Pauken on 11/23/13.
//  Copyright (c) 2013 Kingfish. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BCPSidebarCell : UITableViewCell

@property (nonatomic, retain) UIView *divider;
@property (nonatomic, retain) UIView *highlight;
@property (nonatomic, retain) UIImageView *icon;
@property (nonatomic, retain) UILabel *label;

- (void)setDividerHidden:(BOOL)hidden;
- (void)setText:(NSString *)text;

@end
