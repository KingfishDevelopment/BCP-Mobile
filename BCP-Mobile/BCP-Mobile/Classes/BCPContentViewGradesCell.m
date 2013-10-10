//
//  BCPContentViewGradesCell.m
//  BCP-Mobile
//
//  Created by Bryce Pauken on 10/7/13.
//  Copyright (c) 2013 Kingfish. All rights reserved.
//

#import "BCPContentViewGradesCell.h"

@implementation BCPContentViewGradesCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBackgroundColor:[BCPCommon TABLEVIEW_COLOR]];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        self.divider = [[UIView alloc] init];
        [self.divider setBackgroundColor:[BCPCommon TABLEVIEW_ACCENT_COLOR]];
        [self addSubview:self.divider];
        
        self.labelClass = [[UILabel alloc] init];
        [self formatLabel:self.labelClass];
        self.labelGrade = [[UILabel alloc] init];
        [self formatLabel:self.labelGrade];
        self.labelHyphen = [[UILabel alloc] init];
        [self.labelHyphen setText:@"–"];
        [self formatLabel:self.labelHyphen];
        self.labelPercent = [[UILabel alloc] init];
        [self formatLabel:self.labelPercent];
        
        [self setFrame:self.frame];
    }
    return self;
}

- (void)formatLabel:(UILabel *)label {
    [label setFont:[BCPFont boldSystemFontOfSize:18]];
    [label setBackgroundColor:[BCPCommon TABLEVIEW_COLOR]];
    [label setOpaque:YES];
    [label setTextColor:[BCPCommon TABLEVIEW_TEXT_COLOR]];
    [self addSubview:label];
}

- (void)setDividerHidden:(BOOL)hidden {
    if(self.divider.hidden!=hidden)
        [self.divider setHidden:hidden];
}

- (void)setFrame:(CGRect)frame {
    if(!CGRectEqualToRect(frame,self.frame)) {
        [super setFrame:frame];
        
        [self.divider setFrame:CGRectMake(0, 0, frame.size.width, 1)];
        
        CGSize labelGradeSize = [@"___" sizeWithFont:self.labelGrade.font];
        [self.labelGrade setFrame:CGRectMake(frame.size.width-[BCPCommon TABLEVIEW_CELL_PADDING]-labelGradeSize.width, [BCPCommon TABLEVIEW_CELL_PADDING], labelGradeSize.width, frame.size.height-([BCPCommon TABLEVIEW_CELL_PADDING]*2))];
        
        CGSize labelHyphenSize = [self.labelHyphen.text sizeWithFont:self.labelHyphen.font];
        [self.labelHyphen setFrame:CGRectMake(frame.size.width-[BCPCommon TABLEVIEW_CELL_PADDING]*2-labelGradeSize.width-labelHyphenSize.width, [BCPCommon TABLEVIEW_CELL_PADDING], labelHyphenSize.width, frame.size.height-([BCPCommon TABLEVIEW_CELL_PADDING]*2))];
        
        CGSize labelPercentSize = [self.labelPercent.text sizeWithFont:self.labelPercent.font];
        [self.labelPercent setFrame:CGRectMake(frame.size.width-[BCPCommon TABLEVIEW_CELL_PADDING]*3-labelGradeSize.width-labelHyphenSize.width-labelPercentSize.width, [BCPCommon TABLEVIEW_CELL_PADDING], labelPercentSize.width, frame.size.height-([BCPCommon TABLEVIEW_CELL_PADDING]*2))];
        
        [self.labelClass setFrame:CGRectMake([BCPCommon TABLEVIEW_CELL_PADDING], [BCPCommon TABLEVIEW_CELL_PADDING], frame.size.width-[BCPCommon TABLEVIEW_CELL_PADDING]*6-labelGradeSize.width-labelHyphenSize.width-labelPercentSize.width, frame.size.height-([BCPCommon TABLEVIEW_CELL_PADDING]*2))];
    }
}

- (void)setClassLabelText:(NSString *)text {
    [self.labelClass setText:text];
}

- (void)setGradeLabelText:(NSString *)text {
    [self.labelGrade setText:text];
}

- (void)setPercentLabelText:(NSString *)text {
    [self.labelPercent setText:text];
}

@end
