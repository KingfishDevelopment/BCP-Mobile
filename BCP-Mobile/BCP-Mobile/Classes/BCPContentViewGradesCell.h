//
//  BCPContentViewGradesCell.h
//  BCP-Mobile
//
//  Created by Bryce Pauken on 10/7/13.
//  Copyright (c) 2013 Kingfish. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BCPContentViewGradesCellView.h"

@interface BCPContentViewGradesCell : UITableViewCell

@property (nonatomic, retain) NSString *view;

- (void)setTextWithTitle:(NSString *)title grade:(NSString *)grade percent:(NSString *)percent withDivder:(BOOL)divider;

@end
