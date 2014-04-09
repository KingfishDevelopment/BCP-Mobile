//
//  BCPLogoutView.m
//  BCP-Mobile
//
//  Created by Bryce Pauken on 4/8/14.
//  Copyright (c) 2014 Kingfish. All rights reserved.
//

#import "BCPLogoutView.h"

@implementation BCPLogoutView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *container = [[UIView alloc] init];
        [container setAutoresizingMask:UIViewAutoresizingFlexibleMargins];
        
        self.label = [[UILabel alloc] init];
        [self.label setBackgroundColor:[UIColor BCPOffWhiteColor]];
        [self.label setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:24]];
        [self.label setNumberOfLines:0];
        [self.label setText:@"Would you like to log out?"];
        [self.label setTextAlignment:NSTextAlignmentCenter];
        [self.label setTextColor:[UIColor BCPOffBlackColor]];
        CGSize labelSize = [BCPCommon sizeOfText:self.label.text withFont:self.label.font constrainedToWidth:BCP_LOGIN_CONTAINER_WIDTH];
        [self.label setFrame:CGRectMake((BCP_LOGIN_CONTAINER_WIDTH-labelSize.width)/2, 0, labelSize.width, labelSize.height)];
        [container addSubview:self.label];
        
        self.button = [[UIButton alloc] initWithFrame:CGRectMake(0, self.label.frame.size.height+20, BCP_LOGIN_CONTAINER_WIDTH, BCP_TEXTFIELD_HEIGHT)];
        [self.button addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
        [self.button setTag:1];
        [self.button setTitle:@"Logout" forState:UIControlStateNormal];
        [self.button setTitleColor:[UIColor BCPOffBlackColor] forState:UIControlStateNormal];
        [self.button.layer setBorderColor:[UIColor BCPLightGrayColor].CGColor];
        [self.button.layer setBorderWidth:1.0f];
        [self.button.layer setCornerRadius:5.0f];
        [self.button.layer setMasksToBounds:YES];
        [container addSubview:self.button];
        
        CGFloat containerHeight = self.label.frame.size.height+self.button.frame.size.height+20;
        [container setFrame:CGRectMake((self.frame.size.width-BCP_LOGIN_CONTAINER_WIDTH)/2, (self.frame.size.height-containerHeight)/2, BCP_LOGIN_CONTAINER_WIDTH, containerHeight)];
        [self addSubview:container];
        
        [self.navigationController setNavigationBarText:@"Logout"];
    }
    return self;
}

- (void)logout {
    [BCPData deleteData];
    [[BCPCommon viewController] setLoggedIn:NO];
    [self.label setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:20]];
    [self.label setText:@"You have been logged out."];
    [self.button setUserInteractionEnabled:NO];
    [UIView animateWithDuration:BCP_TRANSITION_DURATION animations:^{
        [self.button setAlpha:0];
    }];
}

@end
