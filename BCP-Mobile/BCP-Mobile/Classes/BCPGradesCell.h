//
//  BCPGradesCell.h
//  BCP-Mobile
//
//  Created by Bryce Pauken on 4/8/14.
//  Copyright (c) 2014 Kingfish. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BCPGradesCell : UITableViewCell

@property (nonatomic, retain) UIView *divider;
@property (nonatomic, retain) UILabel *gradeLabel;
@property (nonatomic, retain) UILabel *titleLabel;

- (void)setTitle:(NSString *)title withGrade:(NSString *)grade;

@end
