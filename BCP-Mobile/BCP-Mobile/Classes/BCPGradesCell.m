//
//  BCPGradesCell.m
//  BCP-Mobile
//
//  Created by Bryce Pauken on 4/8/14.
//  Copyright (c) 2014 Kingfish. All rights reserved.
//

#import "BCPGradesCell.h"

@implementation BCPGradesCell

static CGFloat elipsisWidth;
static CGFloat gradeWidth;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBackgroundColor:[UIColor BCPOffWhiteColor]];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        self.divider = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-1, self.bounds.size.width, 1)];
        [self.divider setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth];
        [self.divider setBackgroundColor:[UIColor BCPLightGrayColor]];
        [self addSubview:self.divider];
        
        for(int i=0;i<2;i++) {
            UILabel *label = [[UILabel alloc] init];
            [label setBackgroundColor:[UIColor BCPOffWhiteColor]];
            [label setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18]];
            [label setTextColor:[UIColor BCPOffBlackColor]];
            [self addSubview:label];
            if(i==0) {
                self.titleLabel = label;
            }
            else {
                self.gradeLabel = label;
            }
        }
        
        if(!gradeWidth) {
            for(int i=0;i<5;i++) {
                for(int j=0;j<3;j++) {
                    CGSize gradeLabelSize = [BCPCommon sizeOfText:[NSString stringWithFormat:@"%@%@",(i==0?@"A":(i==1?@"B":(i==2?@"C":(i==3?@"D":@"F")))),(j==0?@"+":(j==1?@"":@"-"))] withFont:self.titleLabel.font];
                    if(ceil(gradeLabelSize.width)>gradeWidth) {
                        gradeWidth = ceil(gradeLabelSize.width);
                    }
                }
            }
        }
        if(!elipsisWidth) {
            elipsisWidth = [BCPCommon sizeOfText:@"..." withFont:self.titleLabel.font].width;
        }
    }
    return self;
}

- (void)fadeTitleLabel {
    [CATransaction begin];
    [CATransaction setValue: (id) kCFBooleanTrue forKey: kCATransactionDisableActions];
    [self removeFadeFromTitleLabel];
    
    CAGradientLayer *maskLayer = [CAGradientLayer layer];
    [maskLayer setAnchorPoint:CGPointZero];
    [maskLayer setBounds:self.titleLabel.bounds];
    [maskLayer setEndPoint:CGPointMake(1.0, 0.5)];
    [maskLayer setLocations:[NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0],[NSNumber numberWithFloat:1.0],nil]];
    [maskLayer setStartPoint:CGPointMake(1.0-(elipsisWidth/self.titleLabel.bounds.size.width)*2, 0.5)];
    
    [self.titleLabel.layer addSublayer:maskLayer];
    [CATransaction commit];
    [self updateLabelFadeColor];
}

- (void)layoutSubviews {
    [self.titleLabel setFrame:CGRectMake([BCPCommon tableViewPadding], 4, self.bounds.size.width-gradeWidth-[BCPCommon tableViewPadding]*4, self.bounds.size.height-8)];
    [self.gradeLabel setFrame:CGRectMake(self.bounds.size.width-gradeWidth-[BCPCommon tableViewPadding]+([self.gradeLabel.text isEqualToString:@"X"]?2:([self.gradeLabel.text isEqualToString:@"∅"]?1:0)), 4, gradeWidth, self.bounds.size.height-8)];
    
    CGSize titleLabelSize = [BCPCommon sizeOfText:self.titleLabel.text withFont:self.titleLabel.font constrainedToWidth:self.titleLabel.bounds.size.width singleLine:YES];
    CGSize titleLabelSizeMax = [BCPCommon sizeOfText:self.titleLabel.text withFont:self.titleLabel.font singleLine:YES];
    if(titleLabelSize.width<titleLabelSizeMax.width) {
        [self fadeTitleLabel];
    }
    else {
        [self removeFadeFromTitleLabel];
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    UIColor *cellColor = highlighted?[UIColor BCPLightGrayColor]:[UIColor BCPOffWhiteColor];
    [self setBackgroundColor:cellColor];
    [self.titleLabel setBackgroundColor:cellColor];
    [self.gradeLabel setBackgroundColor:cellColor];
    [self updateLabelFadeColor];
}

- (void)removeFadeFromTitleLabel {
    for(CALayer *layer in [self.titleLabel.layer sublayers]) {
        [layer removeFromSuperlayer];
    }
}

- (void)setTitle:(NSString *)title withGrade:(NSString *)grade {
    [self.titleLabel setText:title];
    if(!grade||[grade length]==0) {
        grade = @"∅";
    }
    if([grade isEqualToString:@"X"]||[grade isEqualToString:@"∅"]) {
        [self.gradeLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:14]];
        [self.gradeLabel setTextColor:[UIColor lightGrayColor]];
    }
    else {
        [self.gradeLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18]];
        [self.gradeLabel setTextColor:[UIColor BCPOffBlackColor]];
    }
    [self.gradeLabel setText:grade];
    
    [self setNeedsLayout];
}

- (void)updateLabelFadeColor {
    [CATransaction begin];
    [CATransaction setValue: (id) kCFBooleanTrue forKey: kCATransactionDisableActions];
    CGColorRef innerColor = [self.backgroundColor colorWithAlphaComponent:0].CGColor;
    CGColorRef outerColor = [self.backgroundColor colorWithAlphaComponent:1].CGColor;
    NSArray *colors = [NSArray arrayWithObjects:(__bridge id)innerColor, (__bridge id)outerColor, nil];
    for(CAGradientLayer *layer in [self.titleLabel.layer sublayers]) {
        [layer setColors:colors];
    }
    [CATransaction commit];
}

@end
