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

- (NSData *)drawCellWithFrame:(CGRect)frame withScale:(int)scale withTitle:(NSString *)title withGrade:(NSString *)grade withPercent:(NSString *)percent withDivider:(BOOL)divider selected:(BOOL)selected {
    UIGraphicsBeginImageContextWithOptions(frame.size, YES, scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context,(selected?[BCPCommon TABLEVIEW_SELECTED_COLOR]:[BCPCommon TABLEVIEW_COLOR]).CGColor);
    CGContextFillRect(context, frame);
    
    if(divider) {
        CGContextSetStrokeColorWithColor(context, [BCPCommon TABLEVIEW_ACCENT_COLOR].CGColor);
        CGContextMoveToPoint(context, 0,0);
        CGContextAddLineToPoint(context, frame.size.width, 0);
        CGContextStrokePath(context);
    }
    
    CGContextSetFillColorWithColor(context, [BCPCommon TABLEVIEW_TEXT_COLOR].CGColor);
    
    CGSize labelGradeSize = [@"___" sizeWithFont:[BCPFont boldSystemFontOfSize:18]];
    [grade drawInRect:CGRectMake(frame.size.width-[BCPCommon TABLEVIEW_CELL_PADDING]-labelGradeSize.width, (frame.size.height-labelGradeSize.height)/2, labelGradeSize.width, labelGradeSize.height) withFont:[BCPFont boldSystemFontOfSize:18] lineBreakMode:NSLineBreakByTruncatingTail];
    
    NSString *hypen = ([grade isEqualToString:@""]||[percent isEqualToString:@""]?@"     (None)":@"");
    CGSize labelHyphenSize = [hypen sizeWithFont:[BCPFont boldSystemFontOfSize:18]];
    [hypen drawInRect:CGRectMake(frame.size.width-[BCPCommon TABLEVIEW_CELL_PADDING]*2-labelGradeSize.width-labelHyphenSize.width, (frame.size.height-labelHyphenSize.height)/2, labelHyphenSize.width, labelHyphenSize.height) withFont:[BCPFont boldSystemFontOfSize:18] lineBreakMode:NSLineBreakByTruncatingTail];
    
    CGSize labelPercentSize = [percent sizeWithFont:[BCPFont boldSystemFontOfSize:18]];
    [percent drawInRect:CGRectMake(frame.size.width-[BCPCommon TABLEVIEW_CELL_PADDING]*3-labelGradeSize.width-labelHyphenSize.width-labelPercentSize.width, (frame.size.height-labelPercentSize.height)/2, labelPercentSize.width, labelPercentSize.height) withFont:[BCPFont boldSystemFontOfSize:18] lineBreakMode:NSLineBreakByTruncatingTail];
    
    CGSize labelClassSize = [title sizeWithFont:[BCPFont boldSystemFontOfSize:18]];
    [title drawInRect:CGRectMake([BCPCommon TABLEVIEW_CELL_PADDING], (frame.size.height-labelClassSize.height)/2, frame.size.width-[BCPCommon TABLEVIEW_CELL_PADDING]*6.5-labelGradeSize.width-labelHyphenSize.width-labelPercentSize.width, labelClassSize.height) withFont:[BCPFont boldSystemFontOfSize:18] lineBreakMode:NSLineBreakByTruncatingTail];
    
    //if(self.labelClass.bounds.size.width<labelClassSize.width)
    //    [self fadeLabel:self.labelClass withWidth:labelClassSize.width highlighted:self.highlighted];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return UIImagePNGRepresentation(image);
}

- (void)setTextWithTitle:(NSString *)title grade:(NSString *)grade percent:(NSString *)percent withDivder:(BOOL)divider {
    int scale = 1;
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] && [[UIScreen mainScreen] scale] == 2.0)
        scale = 2;
    if(grade==nil)
        grade = @"";
    if(percent==nil)
        percent = @"";
    self.view = [NSString stringWithFormat:@"%@%@%@%i%i%i%i",title,grade,percent,divider,(int)self.frame.size.width,[BCPCommon TABLEVIEW_CELL_HEIGHT],scale];
    if([[BCPCommon data] loadCellWithKey:self.view]==nil) {
        CGRect frame = CGRectMake(0, 0, self.frame.size.width, [BCPCommon TABLEVIEW_CELL_HEIGHT]);
        [[BCPCommon data] saveCell:[self drawCellWithFrame:frame withScale:scale withTitle:title withGrade:grade withPercent:percent withDivider:divider selected:NO] withKey:self.view saveDictionary:NO];
        [[BCPCommon data] saveCell:[self drawCellWithFrame:frame withScale:scale withTitle:title withGrade:grade withPercent:percent withDivider:divider selected:YES] withKey:[self.view stringByAppendingString:@"selected"] saveDictionary:YES];
    }
    UIImage *backgroundView = [UIImage imageWithData:[[BCPCommon data] loadCellWithKey:self.view]];
    UIImage *selectedBackgroundView = [UIImage imageWithData:[[BCPCommon data] loadCellWithKey:[self.view stringByAppendingString:@"selected"]]];
    self.backgroundView = [[UIImageView alloc] initWithImage:backgroundView];
    self.selectedBackgroundView = [[UIImageView alloc] initWithImage:selectedBackgroundView];
}

@end
