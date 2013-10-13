//
//  BCPContentViewGradesCellView.m
//  BCP-Mobile
//
//  Created by Bryce Pauken on 10/12/13.
//  Copyright (c) 2013 Kingfish. All rights reserved.
//

#import "BCPContentViewGradesCellView.h"

@implementation BCPContentViewGradesCellView

- (id)initWithFrame:(CGRect)frame withTitle:(NSString *)title withGrade:(NSString *)grade withPercent:(NSString *)percent withDivider:(BOOL)divider selected:(BOOL)selected {
    self = [super initWithFrame:frame];
    if(self) {
        self.title = title;
        self.grade = grade;
        self.percent = percent;
        self.divider = divider;
        self.selected = selected;
        [self setOpaque:YES];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context,(self.selected?[BCPCommon TABLEVIEW_SELECTED_COLOR]:[BCPCommon TABLEVIEW_COLOR]).CGColor);
    CGContextFillRect(context, self.bounds);
    
    if(self.divider) {
        CGContextSetStrokeColorWithColor(context, [BCPCommon TABLEVIEW_ACCENT_COLOR].CGColor);
        CGContextMoveToPoint(context, 0,0);
        CGContextAddLineToPoint(context, self.frame.size.width, 0);
        CGContextStrokePath(context);
    }
    
    NSMutableParagraphStyle* style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [style setLineBreakMode:NSLineBreakByTruncatingTail];
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[BCPCommon TABLEVIEW_TEXT_COLOR],NSForegroundColorAttributeName,[BCPFont boldSystemFontOfSize:18],NSFontAttributeName,style,NSParagraphStyleAttributeName,nil];
    
    CGSize labelGradeSize = [@"___" sizeWithFont:[BCPFont boldSystemFontOfSize:18]];
    [self.grade drawInRect:CGRectMake(self.frame.size.width-[BCPCommon TABLEVIEW_CELL_PADDING]-labelGradeSize.width, (self.frame.size.height-labelGradeSize.height)/2, labelGradeSize.width, labelGradeSize.height) withAttributes:attributes];
    
    NSString *hypen = ([self.grade isEqualToString:@""]||[self.percent isEqualToString:@""]?@"     (None)":@"");
    CGSize labelHyphenSize = [hypen sizeWithFont:[BCPFont boldSystemFontOfSize:18]];
    [hypen drawInRect:CGRectMake(self.frame.size.width-[BCPCommon TABLEVIEW_CELL_PADDING]*2-labelGradeSize.width-labelHyphenSize.width, (self.frame.size.height-labelHyphenSize.height)/2, labelHyphenSize.width, labelHyphenSize.height) withAttributes:attributes];
    
    CGSize labelPercentSize = [self.percent sizeWithFont:[BCPFont boldSystemFontOfSize:18]];
    [self.percent drawInRect:CGRectMake(self.frame.size.width-[BCPCommon TABLEVIEW_CELL_PADDING]*3-labelGradeSize.width-labelHyphenSize.width-labelPercentSize.width, (self.frame.size.height-labelPercentSize.height)/2, labelPercentSize.width, labelPercentSize.height) withAttributes:attributes];
    
    CGSize labelClassSize = [self.title sizeWithFont:[BCPFont boldSystemFontOfSize:18]];
    [self.title drawInRect:CGRectMake([BCPCommon TABLEVIEW_CELL_PADDING], (self.frame.size.height-labelClassSize.height)/2, self.frame.size.width-[BCPCommon TABLEVIEW_CELL_PADDING]*6.5-labelGradeSize.width-labelHyphenSize.width-labelPercentSize.width, labelClassSize.height) withAttributes:attributes];
    
    //if(self.labelClass.bounds.size.width<labelClassSize.width)
    //    [self fadeLabel:self.labelClass withWidth:labelClassSize.width highlighted:self.highlighted];
}

@end
