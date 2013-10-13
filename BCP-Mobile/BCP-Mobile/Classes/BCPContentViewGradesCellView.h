//
//  BCPContentViewGradesCellView.h
//  BCP-Mobile
//
//  Created by Bryce Pauken on 10/12/13.
//  Copyright (c) 2013 Kingfish. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BCPContentViewGradesCellView : UIView

@property (nonatomic) BOOL divider;
@property (nonatomic, retain) NSString *grade;
@property (nonatomic, retain) NSString *percent;
@property (nonatomic) BOOL selected;
@property (nonatomic, retain) NSString *title;

- (id)initWithFrame:(CGRect)frame withTitle:(NSString *)title withGrade:(NSString *)grade withPercent:(NSString *)percent withDivider:(BOOL)divider selected:(BOOL)selected;

@end
