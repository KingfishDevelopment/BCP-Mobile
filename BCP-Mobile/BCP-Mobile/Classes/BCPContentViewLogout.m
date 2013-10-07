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
        
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.button addTarget:self action:@selector(logout:) forControlEvents:UIControlEventTouchDown];
        [self.button setBackgroundColor:[BCPCommon BUTTON_COLOR]];
        
        [self.button setTitle:@"Logout" forState:UIControlStateNormal];
        [self.button setTitleColor:[BCPCommon BUTTON_TEXT_COLOR] forState:UIControlStateNormal];
        [self.button setTitleColor:[BCPCommon BUTTON_DOWN_COLOR] forState:UIControlStateHighlighted];
        [self addShadowToView:self.button];
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

    [self.button setFrame:CGRectMake([BCPCommon CONTENT_SIDE_PADDING], frame.size.height/2+[BCPCommon CONTENT_MIDDLE_PADDING], frame.size.width-[BCPCommon CONTENT_SIDE_PADDING]*2, [BCPCommon BUTTON_HEIGHT])];
}

@end
