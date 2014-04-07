//
//  BCPNavigationBar.m
//  BCP-Mobile
//
//  Created by Bryce Pauken on 4/5/14.
//  Copyright (c) 2014 Kingfish. All rights reserved.
//

#import "BCPNavigationBar.h"

@implementation BCPNavigationBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor BCPBlueColor]];
        
        NSInteger offset = [BCPCommon isIOS7]?20:0;
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(10, offset, self.bounds.size.width-20, self.bounds.size.height-offset)];
        [self.label setAutoresizingMask:UIViewAutoresizingFlexibleSize];
        [self.label setBackgroundColor:[UIColor clearColor]];
        [self.label setFont:[UIFont boldSystemFontOfSize:20]];
        [self.label setShadowColor:[UIColor BCPOffBlackColor]];
        [self.label setShadowOffset:CGSizeMake(0,2)];
        [self.label setTextAlignment:NSTextAlignmentCenter];
        [self.label setTextColor:[UIColor whiteColor]];
        [self addSubview:self.label];
        
        CGFloat buttonPadding = (self.bounds.size.height-offset-BCP_NAVIGATION_BUTTON_SIZE)/2;
        for(int i=0;i<2;i++) {
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(i==0?buttonPadding:self.bounds.size.width-buttonPadding-BCP_NAVIGATION_BUTTON_SIZE, offset+buttonPadding, BCP_NAVIGATION_BUTTON_SIZE, BCP_NAVIGATION_BUTTON_SIZE)];
            [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
            [button setAutoresizingMask:i==0?UIViewAutoresizingFlexibleRightMargin:UIViewAutoresizingFlexibleLeftMargin];
            [button setHidden:YES];
            [self addSubview:button];
            if(i==0) {
                self.leftButton = button;
            }
            else {
                self.rightButton = button;
            }
        }
    }
    return self;
}

- (void)buttonTapped:(UIButton *)sender {
    if(sender==self.leftButton&&self.leftButtonTapped) {
        self.leftButtonTapped();
    }
    else if(sender==self.rightButton&&self.rightButtonTapped) {
        self.rightButtonTapped();
    }
}

@end
