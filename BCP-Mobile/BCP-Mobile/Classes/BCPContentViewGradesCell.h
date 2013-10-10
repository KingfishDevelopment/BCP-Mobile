//
//  BCPContentViewGradesCell.h
//  BCP-Mobile
//
//  Created by Bryce Pauken on 10/7/13.
//  Copyright (c) 2013 Kingfish. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BCPContentViewGradesCell : UITableViewCell

@property (nonatomic, retain) UIView *divider;
@property (nonatomic, retain) UILabel *labelClass;
@property (nonatomic, retain) UILabel *labelGrade;
@property (nonatomic, retain) UILabel *labelHyphen;
@property (nonatomic, retain) UILabel *labelPercent;

- (void)setDividerHidden:(BOOL)hidden;
- (void)setClassLabelText:(NSString *)text;
- (void)setGradeLabelText:(NSString *)text;
- (void)setPercentLabelText:(NSString *)text;

@end
