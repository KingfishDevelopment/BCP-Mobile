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
        
        self.classContainer = [[UIView alloc] init];
        [self.classContainer setBackgroundColor:[BCPCommon TABLEVIEW_COLOR]];
        [self addSubview:self.classContainer];
        
        self.divider = [[UIView alloc] init];
        [self.divider setBackgroundColor:[BCPCommon TABLEVIEW_ACCENT_COLOR]];
        [self addSubview:self.divider];
        
        self.labelClass = [[UILabel alloc] init];
        [self formatLabel:self.labelClass];
        [self.classContainer addSubview:self.labelClass];
        self.labelGrade = [[UILabel alloc] init];
        [self formatLabel:self.labelGrade];
        [self addSubview:self.labelGrade];
        self.labelHyphen = [[UILabel alloc] init];
        [self.labelHyphen setText:@"-"];
        [self formatLabel:self.labelHyphen];
        [self addSubview:self.labelHyphen];
        self.labelPercent = [[UILabel alloc] init];
        [self formatLabel:self.labelPercent];
        [self addSubview:self.labelPercent];
        
        [self setFrame:self.frame];
    }
    return self;
}

- (void)fadeLabel:(UILabel *)label withWidth:(float)width highlighted:(BOOL)highlighted {
    CGSize truncatedSize = [label.text sizeWithFont:label.font constrainedToSize:label.frame.size lineBreakMode:label.lineBreakMode];
    CGSize elipsisSize = [@"..." sizeWithFont:label.font];
    
    UIColor *color = (highlighted?[BCPColor colorWithWhite:0.85 alpha:1]:[BCPCommon TABLEVIEW_COLOR]);
    CGColorRef innerColor = [color colorWithAlphaComponent:0].CGColor;
    CGColorRef outerColor = color.CGColor;
    
    [self.mask removeFromSuperlayer];
    
    self.mask = [CAGradientLayer layer];
    [self.mask setOpacity:1];
    [self.mask setColors:[NSArray arrayWithObjects:(__bridge id)outerColor, (__bridge id)innerColor, (__bridge id)innerColor, (__bridge id)outerColor, nil]];
    [self.mask setLocations:[NSArray arrayWithObjects:[NSNumber numberWithFloat:0],[NSNumber numberWithFloat:0],[NSNumber numberWithFloat:(1-(elipsisSize.width/truncatedSize.width))],[NSNumber numberWithFloat:1],nil]];
    [self.mask setStartPoint:CGPointMake(0, 0)];
    [self.mask setEndPoint:CGPointMake(1.0, 0)];
    [self.mask setBounds:CGRectMake(0, 0, truncatedSize.width, label.frame.size.height)];
    [self.mask setAnchorPoint:CGPointZero];
    
    [self.classContainer.layer addSublayer:self.mask];
}

- (void)formatLabel:(UILabel *)label {
    [label setFont:[BCPFont boldSystemFontOfSize:18]];
    [label setBackgroundColor:[BCPCommon TABLEVIEW_COLOR]];
    [label setOpaque:YES];
    [label setTextColor:[BCPCommon TABLEVIEW_TEXT_COLOR]];
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
        
        [self.classContainer setFrame:CGRectMake([BCPCommon TABLEVIEW_CELL_PADDING], [BCPCommon TABLEVIEW_CELL_PADDING], frame.size.width-[BCPCommon TABLEVIEW_CELL_PADDING]*6.5-labelGradeSize.width-labelHyphenSize.width-labelPercentSize.width, frame.size.height-([BCPCommon TABLEVIEW_CELL_PADDING]*2))];
        [self.labelClass setFrame:CGRectMake(0, 0, self.classContainer.frame.size.width, self.classContainer.frame.size.height)];
        CGSize labelClassSize = [self.labelClass.text sizeWithFont:self.labelClass.font];
        if(self.labelClass.bounds.size.width<labelClassSize.width)
            [self fadeLabel:self.labelClass withWidth:labelClassSize.width highlighted:self.highlighted];
    }
}

- (void)setClassLabelText:(NSString *)text {
    [self.labelClass setText:text];
}

- (void)setGradeLabelText:(NSString *)text {
    if(text==nil||[text isEqualToString:@""]) {
        [self.labelHyphen setText:@"     (None)"];
    }
    else {
        [self.labelGrade setText:text];
        [self.labelHyphen setText:@"-"];
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    
    CGSize labelClassSize = [self.labelClass.text sizeWithFont:self.labelClass.font];
    if(self.labelClass.bounds.size.width<labelClassSize.width)
        [self fadeLabel:self.labelClass withWidth:labelClassSize.width highlighted:self.highlighted||self.selected];
}

- (void)setPercentLabelText:(NSString *)text {
    if(text==nil||[text isEqualToString:@""]) {
        [self.labelHyphen setText:@"     (None)"];
    }
    else {
        [self.labelPercent setText:text];
        [self.labelHyphen setText:@"-"];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    CGSize labelClassSize = [self.labelClass.text sizeWithFont:self.labelClass.font];
    if(self.labelClass.bounds.size.width<labelClassSize.width)
        [self fadeLabel:self.labelClass withWidth:labelClassSize.width highlighted:self.highlighted||self.selected];
}

@end
