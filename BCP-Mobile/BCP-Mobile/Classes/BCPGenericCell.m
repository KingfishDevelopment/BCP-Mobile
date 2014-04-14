//
//  BCPAnnouncementsCell.m
//  BCP-Mobile
//
//  Created by Bryce Pauken on 4/12/14.
//  Copyright (c) 2014 Kingfish. All rights reserved.
//

#import "BCPGenericCell.h"

@implementation BCPGenericCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBackgroundColor:[UIColor BCPOffWhiteColor]];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        self.divider = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-1, self.bounds.size.width, 1)];
        [self.divider setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth];
        [self.divider setBackgroundColor:[UIColor BCPLightGrayColor]];
        [self addSubview:self.divider];
        
        self.label = [[UILabel alloc] init];
        [self.label setBackgroundColor:[UIColor BCPOffWhiteColor]];
        [self.label setNumberOfLines:0];
        [self.label setFont:[BCPGenericCell font]];
        [self.label setTextColor:[UIColor BCPOffBlackColor]];
        [self addSubview:self.label];
    }
    return self;
}

+ (UIFont *)font {
    return [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
}

- (void)layoutSubviews {
    [self.label setFrame:CGRectMake([BCPCommon tableViewPadding], 4, self.bounds.size.width-[BCPCommon tableViewPadding]*2, self.bounds.size.height-8)];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    UIColor *cellColor = highlighted?[UIColor BCPLightGrayColor]:[UIColor BCPOffWhiteColor];
    [self setBackgroundColor:cellColor];
    [self.label setBackgroundColor:cellColor];
}

- (void)setText:(NSString *)text {
    [self.label setText:text];
    [self setNeedsLayout];
}

@end
