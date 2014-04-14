//
//  BCPGenericCell.h
//  BCP-Mobile
//
//  Created by Bryce Pauken on 4/12/14.
//  Copyright (c) 2014 Kingfish. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BCPGenericCell : UITableViewCell

@property (nonatomic, retain) UIView *divider;
@property (nonatomic, retain) UILabel *label;

+ (UIFont *)font;
- (void)setText:(NSString *)text;

@end
