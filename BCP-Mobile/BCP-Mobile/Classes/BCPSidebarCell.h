//
//  BCPSidebarCell.h
//  BCP-Mobile
//
//  Created by Bryce Pauken on 10/2/13.
//  Copyright (c) 2013 Kingfish. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BCPSidebarCell : UITableViewCell

@property (nonatomic, retain) UIView *disabledOverlay;
@property (nonatomic, retain) UIView *divider;
@property (nonatomic) BOOL enabled;
@property (nonatomic, retain) UIImageView *icon;
@property (nonatomic, retain) UILabel *label;

- (void)setDividerHidden:(BOOL)hidden;
- (void)setLabelText:(NSString *)text;

@end
