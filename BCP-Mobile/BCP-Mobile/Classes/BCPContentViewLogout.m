//
//  BCPContentViewLogout.m
//  BCP-Mobile
//
//  Created by Bryce Pauken on 10/6/13.
//  Copyright (c) 2013 Kingfish. All rights reserved.
//

#import "BCPContentViewLogout.h"

@implementation BCPContentViewLogout

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.label = [[UILabel alloc] init];
        [self.label setText:@"Are you sure you want to log out?"];
        [self formatLabel:self.label];
        [self addSubview:self.label];
        
        self.button = [[FUIButton alloc] init];
        self.button.buttonColor = [BCPCommon TEXTFIELD_COLOR];
        self.button.shadowColor = [UIColor blackColor];
        self.button.shadowHeight = 3.0f;
        self.button.cornerRadius = 6.0f;
        self.button.titleLabel.font = [BCPFont systemFontOfSize:18];
        [self.button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.button setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        [self.button setTitle:@"Logout" forState:UIControlStateNormal];
        [self.button addTarget:self action:@selector(logout:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.button];
    }
    return self;
}

-(void)logout:(UIButton *)sender {
    [BCPCommon logout];
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    CGSize labelSize = [self.label.text sizeWithFont:[self.label font] constrainedToSize:CGSizeMake(frame.size.width-[BCPCommon CONTENT_SIDE_PADDING]*2, 10000) lineBreakMode:self.label.lineBreakMode];
    [self.label setFrame:CGRectMake([BCPCommon CONTENT_SIDE_PADDING], frame.size.height/2-labelSize.height-[BCPCommon CONTENT_MIDDLE_PADDING], frame.size.width-[BCPCommon CONTENT_SIDE_PADDING]*2, labelSize.height)];
    
    CGFloat buttonWidth = MIN(350,frame.size.width-[BCPCommon CONTENT_SIDE_PADDING]*2);
    [self.button setFrame:CGRectMake((frame.size.width-buttonWidth)/2, frame.size.height/2+[BCPCommon CONTENT_MIDDLE_PADDING], buttonWidth, [BCPCommon BUTTON_HEIGHT])];
}

@end
