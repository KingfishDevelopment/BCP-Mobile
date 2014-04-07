//
//  BCPLoginView.m
//  BCP-Mobile
//
//  Created by Bryce Pauken on 4/6/14.
//  Copyright (c) 2014 Kingfish. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "BCPLoginView.h"

@implementation BCPLoginView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *container = [[UIView alloc] init];
        [container setAutoresizingMask:UIViewAutoresizingFlexibleMargins];
        
        UIView *textFieldContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BCP_LOGIN_CONTAINER_WIDTH, BCP_TEXTFIELD_HEIGHT*2)];
        [textFieldContainer.layer setBorderColor:[UIColor blackColor].CGColor];
        [textFieldContainer.layer setBorderWidth:1.0f];
        [textFieldContainer.layer setCornerRadius:5.0f];
        [textFieldContainer.layer setMasksToBounds:YES];
        [container addSubview:textFieldContainer];
        
        for(int i=0;i<2;i++) {
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, BCP_TEXTFIELD_HEIGHT*i, BCP_LOGIN_CONTAINER_WIDTH, BCP_TEXTFIELD_HEIGHT)];
            [textField setPlaceholder:i==0?@"Username":@"Password"];
            [textField setSecureTextEntry:i==1];
            [textFieldContainer addSubview:textField];
            if(i==0) {
                self.usernameField = textField;
            }
            else {
                self.passwordField = textField;
            }
        }
        
        self.loginButton = [[UIButton alloc] initWithFrame:CGRectMake(0, textFieldContainer.frame.size.height+20, BCP_LOGIN_CONTAINER_WIDTH, BCP_TEXTFIELD_HEIGHT)];
        [self.loginButton setBackgroundColor:[UIColor blueColor]];
        [container addSubview:self.loginButton];
        
        CGFloat containerHeight = textFieldContainer.frame.size.height+self.loginButton.frame.size.height+20;
        [container setFrame:CGRectMake((self.frame.size.width-BCP_LOGIN_CONTAINER_WIDTH)/2, (self.frame.size.height-containerHeight)/2, BCP_LOGIN_CONTAINER_WIDTH, containerHeight)];
        [self addSubview:container];
        
        [self.navigationController setNavigationBarText:@"Login"];
    }
    return self;
}

@end
