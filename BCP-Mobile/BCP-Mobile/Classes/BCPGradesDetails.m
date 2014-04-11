//
//  BCPGradesDetails.m
//  BCP-Mobile
//
//  Created by Bryce Pauken on 4/10/14.
//  Copyright (c) 2014 Kingfish. All rights reserved.
//

#import "BCPGradesDetails.h"

@implementation BCPGradesDetails

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor BCPOffWhiteColor]];
    }
    return self;
}

- (void)layoutSubviews {
    CGRect lastLabelFrame = CGRectMake(0, 20, 0, 0);
    for(UILabel *label in self.labels) {
        CGSize labelSize = [BCPCommon sizeOfText:label.text withFont:label.font constrainedToWidth:self.bounds.size.width-20];
        [label setFrame:CGRectMake(10, lastLabelFrame.origin.y+lastLabelFrame.size.height+10, labelSize.width, labelSize.height)];
        lastLabelFrame = [label frame];
    }
}

- (void)setTitle:(NSString *)title withDetails:(NSArray *)details {
    for(UILabel *label in self.labels) {
        [label removeFromSuperview];
    }
    self.labels = [NSMutableArray array];
    for(int i=0;i<[details count]/2+2;i++) {
        UILabel *label = [[UILabel alloc] init];
        [label setBackgroundColor:[UIColor BCPOffWhiteColor]];
        [label setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:i==0?24:18]];
        [label setNumberOfLines:0];
        [label setTextColor:[UIColor BCPOffBlackColor]];
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        [style setHeadIndent:50];
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:i==0?title:(i==1||[[details objectAtIndex:(i-2)*2] length]==0||[[details objectAtIndex:(i-2)*2+1] length]==0?@" ":[NSString stringWithFormat:@"%@: %@",[details objectAtIndex:(i-2)*2+1],[details objectAtIndex:(i-2)*2]])];
        [text addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0,[text length])];
        [label setAttributedText:text];
        [self addSubview:label];
        [self.labels addObject:label];
    }
    [self layoutSubviews];
}

@end
