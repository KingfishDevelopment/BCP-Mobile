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
    CGFloat largestFieldWidth = 0;
    for(int i=1;i<[self.labels count];i+=2) {
        CGSize labelSize = [BCPCommon sizeOfText:[[self.labels objectAtIndex:i] text] withFont:[[self.labels objectAtIndex:i] font]];
        if(labelSize.width>largestFieldWidth) {
            largestFieldWidth = labelSize.width;
        }
    }
    CGRect lastLabelFrame = CGRectMake(0, 30, 0, 0);
    for(int i=0;i<[self.labels count];i++) {
        CGSize labelSize = [BCPCommon sizeOfText:[[self.labels objectAtIndex:i] text] withFont:[[self.labels objectAtIndex:i] font] constrainedToWidth:self.bounds.size.width-20];
        [[self.labels objectAtIndex:i] setFrame:CGRectMake(10+(i==0||i%2==1?0:largestFieldWidth+20), lastLabelFrame.origin.y+lastLabelFrame.size.height+10, labelSize.width, labelSize.height)];
        if(i==0||i%2==0) {
            lastLabelFrame = [[self.labels objectAtIndex:i] frame];
        }
    }
}

- (void)setTitle:(NSString *)title withDetails:(NSArray *)details {
    for(UILabel *label in self.labels) {
        [label removeFromSuperview];
    }
    self.labels = [NSMutableArray array];
    for(int i=0;i<[details count]+3;i++) {
        UILabel *label = [[UILabel alloc] init];
        [label setBackgroundColor:[UIColor BCPOffWhiteColor]];
        [label setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:i==0?24:18]];
        [label setNumberOfLines:0];
        [label setTextColor:[UIColor BCPOffBlackColor]];
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        [style setHeadIndent:50];
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:i==0?title:(i==1||i==2||[[details objectAtIndex:i-3] length]==0||[[details objectAtIndex:i-3+(i%2==0?-1:1)] length]==0?@" ":(i%2==1?[[details objectAtIndex:i-2] stringByAppendingString:@":"]:[details objectAtIndex:i-4]))];
        [text addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0,[text length])];
        [label setAttributedText:text];
        [self addSubview:label];
        [self.labels addObject:label];
    }
    [self layoutSubviews];
}

@end
