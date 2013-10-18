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
    if(self) {
        
    }
    return self;
}

+ (NSData *)drawCellWithFrame:(CGRect)frame withScale:(int)scale withTitle:(NSString *)title withGrade:(NSString *)grade withPercent:(NSString *)percent withDivider:(BOOL)divider selected:(BOOL)selected {
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
    
    CGSize labelGradeSize = [@"___" sizeWithFont:[BCPFont systemFontOfSize:18]];
    [grade drawInRect:CGRectMake(frame.size.width-[BCPCommon TABLEVIEW_CELL_PADDING]-labelGradeSize.width, (frame.size.height-labelGradeSize.height)/2, labelGradeSize.width, labelGradeSize.height) withFont:[BCPFont systemFontOfSize:18] lineBreakMode:NSLineBreakByTruncatingTail];
    
    NSString *hypen = ([grade isEqualToString:@""]||[percent isEqualToString:@""]?@"     (None)":@"");
    CGSize labelHyphenSize = [hypen sizeWithFont:[BCPFont systemFontOfSize:18]];
    [hypen drawInRect:CGRectMake(frame.size.width-[BCPCommon TABLEVIEW_CELL_PADDING]*2-labelGradeSize.width-labelHyphenSize.width, (frame.size.height-labelHyphenSize.height)/2, labelHyphenSize.width, labelHyphenSize.height) withFont:[BCPFont systemFontOfSize:18] lineBreakMode:NSLineBreakByTruncatingTail];
    
    CGSize labelPercentSize = [percent sizeWithFont:[BCPFont systemFontOfSize:18]];
    [percent drawInRect:CGRectMake(frame.size.width-[BCPCommon TABLEVIEW_CELL_PADDING]*3-labelGradeSize.width-labelHyphenSize.width-labelPercentSize.width, (frame.size.height-labelPercentSize.height)/2, labelPercentSize.width, labelPercentSize.height) withFont:[BCPFont systemFontOfSize:18] lineBreakMode:NSLineBreakByTruncatingTail];
    
    CGSize labelClassSize = [title sizeWithFont:[BCPFont systemFontOfSize:18]];
    CGFloat classLabelWidth = frame.size.width-[BCPCommon TABLEVIEW_CELL_PADDING]*6.5-labelGradeSize.width-labelHyphenSize.width-labelPercentSize.width;
    [title drawInRect:CGRectMake([BCPCommon TABLEVIEW_CELL_PADDING], (frame.size.height-labelClassSize.height)/2, classLabelWidth, labelClassSize.height) withFont:[BCPFont systemFontOfSize:18] lineBreakMode:NSLineBreakByTruncatingTail];
    
    CGSize labelClassSizeRestrained = [title sizeWithFont:[BCPFont systemFontOfSize:18] forWidth:classLabelWidth lineBreakMode:NSLineBreakByTruncatingTail];
    if(labelClassSize.width-labelClassSizeRestrained.width>1) {
        CGSize ellipsisSize = [@"..." sizeWithFont:[BCPFont systemFontOfSize:18]];
        
        CGFloat colors[8];
        
        CGColorRef color = (selected?[BCPCommon TABLEVIEW_SELECTED_COLOR]:[BCPCommon TABLEVIEW_COLOR]).CGColor;
        const CGFloat *colorComponents = CGColorGetComponents(color);
        if (CGColorGetNumberOfComponents(color) == 2) {
            for (int i=0; i<7; i++)
                colors[i] = colorComponents[0];
            colors[3] = 0;
            colors[7] = colorComponents[1];
        }
        else {
            for (int i=0; i<8; i++)
                colors[i] = colorComponents[i];
            colors[3] = 0;
        }
        
        CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
        CGGradientRef gradientRef = CGGradientCreateWithColorComponents(rgb, colors, NULL, sizeof(colors) / (sizeof(colors[0]) * 4));
        
        CGPoint start = CGPointMake([BCPCommon TABLEVIEW_CELL_PADDING]+labelClassSizeRestrained.width-ellipsisSize.width, 0);
        CGPoint end = CGPointMake([BCPCommon TABLEVIEW_CELL_PADDING]+labelClassSizeRestrained.width, 0);
        CGContextDrawLinearGradient(context, gradientRef, start, end, 0);
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return UIImagePNGRepresentation(image);
}

- (void)hideSpinner {
    [self.spinnerContainer setHidden:YES];
    [self.spinner setHidden:YES];
    [self.spinner stopAnimating];
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    if(self.title)
        [self setTextWithTitle:self.title grade:self.grade percent:self.percent withDivder:self.divider];
}

- (void)setTextWithTitle:(NSString *)title grade:(NSString *)grade percent:(NSString *)percent withDivder:(BOOL)divider {
    self.title = title;
    self.grade = grade;
    self.percent = percent;
    self.divider = divider;
    if([BCPCommon IS_IPAD]&&self.frame.size.width==320)
        return;
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
        [[BCPCommon data] saveCell:[BCPContentViewGradesCell drawCellWithFrame:frame withScale:scale withTitle:title withGrade:grade withPercent:percent withDivider:divider selected:NO] withKey:self.view];
        [[BCPCommon data] saveCell:[BCPContentViewGradesCell drawCellWithFrame:frame withScale:scale withTitle:title withGrade:grade withPercent:percent withDivider:divider selected:YES] withKey:[self.view stringByAppendingString:@"selected"]];
        [[BCPCommon data] saveDictionary];
    }
    UIImage *backgroundView = [UIImage imageWithData:[[BCPCommon data] loadCellWithKey:self.view]];
    UIImage *selectedBackgroundView = [UIImage imageWithData:[[BCPCommon data] loadCellWithKey:[self.view stringByAppendingString:@"selected"]]];
    self.backgroundView = [[UIImageView alloc] initWithImage:backgroundView];
    self.selectedBackgroundView = [[UIImageView alloc] initWithImage:selectedBackgroundView];
    self.spinnerContainer = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width-self.frame.size.height, 0, self.frame.size.height, self.frame.size.height)];
    [self.spinnerContainer setBackgroundColor:[BCPCommon TABLEVIEW_SELECTED_COLOR]];
    [self.spinnerContainer setHidden:YES];
    [self.selectedBackgroundView addSubview:self.spinnerContainer];
    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.spinner setFrame:CGRectMake((self.spinnerContainer.frame.size.width-self.spinner.frame.size.width)/2, (self.spinnerContainer.frame.size.height-self.spinner.frame.size.height)/2, self.spinner.frame.size.width, self.spinner.frame.size.height)];
    [self.spinner setHidden:YES];
    [self.spinnerContainer addSubview:self.spinner];
}

- (void)showSpinner {
    [self.spinnerContainer setHidden:NO];
    [self.spinnerContainer setBackgroundColor:[BCPCommon TABLEVIEW_SELECTED_COLOR]];
    [self.spinner setHidden:NO];
    [self.spinner startAnimating];
}

@end
