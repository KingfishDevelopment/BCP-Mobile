//
//  BCPContentViewGradesCell.m
//  BCP-Mobile
//
//  Created by Bryce Pauken on 10/7/13.
//  Copyright (c) 2013 Kingfish. All rights reserved.
//

#import "BCPContentViewGradesCell.h"

static NSMutableDictionary *views;

@implementation BCPContentViewGradesCell

+ (void)initialize {
    if(views==nil)
        views = [NSMutableDictionary dictionary];
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
}

/*- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    
    NSLog(@"%@",self.backgroundView);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    NSLog(@"%@",self.backgroundView);
}*/

- (void)setTextWithTitle:(NSString *)title grade:(NSString *)grade percent:(NSString *)percent withDivder:(BOOL)divider {
    if(grade==nil)
        grade = @"";
    if(percent==nil)
        percent = @"";
    self.view = [NSString stringWithFormat:@"%@%@%@%i%i%i",title,grade,percent,divider,(int)self.frame.size.width,[BCPCommon TABLEVIEW_CELL_HEIGHT]];
    if([views objectForKey:self.view]==nil) {
        CGRect frame = CGRectMake(0, 0, self.frame.size.width, [BCPCommon TABLEVIEW_CELL_HEIGHT]);
        [views setObject:[[BCPContentViewGradesCellView alloc] initWithFrame:frame withTitle:title withGrade:grade withPercent:percent withDivider:divider selected:NO] forKey:self.view];
        [views setObject:[[BCPContentViewGradesCellView alloc] initWithFrame:frame withTitle:title withGrade:grade withPercent:percent withDivider:divider selected:YES] forKey:[self.view stringByAppendingString:@"selected"]];
    }
    self.backgroundView = [views objectForKey:self.view];
    self.selectedBackgroundView = [views objectForKey:[self.view stringByAppendingString:@"selected"]];
}

@end
