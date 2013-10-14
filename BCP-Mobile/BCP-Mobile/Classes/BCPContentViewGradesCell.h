//
//  BCPContentViewGradesCell.h
//  BCP-Mobile
//
//  Created by Bryce Pauken on 10/7/13.
//  Copyright (c) 2013 Kingfish. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BCPContentViewGradesCell : UITableViewCell

@property (nonatomic) BOOL divider;
@property (nonatomic, retain) NSString *grade;
@property (nonatomic, retain) NSString *percent;
@property (nonatomic, retain) UIActivityIndicatorView *spinner;
@property (nonatomic, retain) UIView *spinnerContainer;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *view;

+ (NSData *)drawCellWithFrame:(CGRect)frame withScale:(int)scale withTitle:(NSString *)title withGrade:(NSString *)grade withPercent:(NSString *)percent withDivider:(BOOL)divider selected:(BOOL)selected;
- (void)hideSpinner;
- (void)setTextWithTitle:(NSString *)title grade:(NSString *)grade percent:(NSString *)percent withDivder:(BOOL)divider;
- (void)showSpinner;

@end
