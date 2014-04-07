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
        self.keyboardHeight = 0;
        
        self.container = [[UIView alloc] init];
        
        self.icon = [[UIImageView alloc] initWithFrame:CGRectMake(BCP_ICON_SIZE, 0, BCP_ICON_SIZE, BCP_ICON_SIZE)];
        [self.icon setImage:[UIImage imageNamed:@"IconLarge"]];
        [self.container addSubview:self.icon];
        
        UIView *textFieldContainer = [[UIView alloc] initWithFrame:CGRectMake(0, self.icon.frame.size.height+20, BCP_LOGIN_CONTAINER_WIDTH, BCP_TEXTFIELD_HEIGHT*2)];
        [textFieldContainer.layer setBorderColor:[UIColor BCPLightGrayColor].CGColor];
        [textFieldContainer.layer setBorderWidth:1.0f];
        [textFieldContainer.layer setCornerRadius:5.0f];
        [textFieldContainer.layer setMasksToBounds:YES];
        [self.container addSubview:textFieldContainer];
        
        for(int i=0;i<2;i++) {
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(10, BCP_TEXTFIELD_HEIGHT*i, BCP_LOGIN_CONTAINER_WIDTH-20, BCP_TEXTFIELD_HEIGHT)];
            [textField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
            [textField setAutocorrectionType:UITextAutocorrectionTypeNo];
            [textField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
            [textField setDelegate:self];
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
        
        UIView *textFieldContainerDivider = [[UIView alloc] initWithFrame:CGRectMake(0, BCP_TEXTFIELD_HEIGHT-0.5f, BCP_LOGIN_CONTAINER_WIDTH, 1)];
        [textFieldContainerDivider setBackgroundColor:[UIColor BCPLightGrayColor]];
        [textFieldContainer addSubview:textFieldContainerDivider];
        
        self.loginButton = [[UIButton alloc] initWithFrame:CGRectMake(0, textFieldContainer.frame.origin.y+textFieldContainer.frame.size.height+20, BCP_LOGIN_CONTAINER_WIDTH, BCP_TEXTFIELD_HEIGHT)];
        [self.loginButton addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
        [self.loginButton setTitle:@"Login" forState:UIControlStateNormal];
        [self.loginButton setTitleColor:[UIColor BCPOffBlackColor] forState:UIControlStateNormal];
        [self.loginButton.layer setBorderColor:[UIColor BCPLightGrayColor].CGColor];
        [self.loginButton.layer setBorderWidth:1.0f];
        [self.loginButton.layer setCornerRadius:5.0f];
        [self.loginButton.layer setMasksToBounds:YES];
        [self.container addSubview:self.loginButton];
        
        CGFloat containerHeight = self.icon.frame.size.height+textFieldContainer.frame.size.height+self.loginButton.frame.size.height+40;
        [self.container setFrame:CGRectMake((self.frame.size.width-BCP_LOGIN_CONTAINER_WIDTH)/2, (self.frame.size.height-self.keyboardHeight)/2-textFieldContainer.frame.origin.y-BCP_TEXTFIELD_HEIGHT-(BCP_NAVIGATION_BAR_HEIGHT+([BCPCommon isIOS7]?20:0))*(self.keyboardHeight>0?0:1)/2, BCP_LOGIN_CONTAINER_WIDTH, containerHeight)];
        [self addSubview:self.container];
        
        [self.navigationController setNavigationBarText:@"Login"];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (void)keyboardDidShow:(NSNotification *)notification {
    CGRect keyboardRect;
    [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardRect];
    keyboardRect = [self convertRect:keyboardRect fromView:self.window];
    self.keyboardHeight = keyboardRect.size.height;
    NSTimeInterval duration = 0;
    [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&duration];
    [UIView animateWithDuration:duration animations:^{
        [self layoutSubviews];
    }];
    
}

- (void)keyboardWillHide:(NSNotification *)notification{
    self.keyboardHeight = 0;
    NSTimeInterval duration = 0;
    [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&duration];
    [UIView animateWithDuration:duration animations:^{
        [self layoutSubviews];
    }];
    
}

- (void)layoutSubviews {
    [self.container setFrame:CGRectMake((self.frame.size.width-BCP_LOGIN_CONTAINER_WIDTH)/2, (self.frame.size.height-self.keyboardHeight)/2-BCP_ICON_SIZE-20-BCP_TEXTFIELD_HEIGHT-(BCP_NAVIGATION_BAR_HEIGHT+([BCPCommon isIOS7]?20:0))*(self.keyboardHeight>0?0:1)/2, BCP_LOGIN_CONTAINER_WIDTH, self.container.frame.size.height)];
    [self.icon setAlpha:[self convertPoint:self.icon.frame.origin fromView:self.container].y<20?0:1];
}

- (void)login {
    [self.usernameField resignFirstResponder];
    [self.passwordField resignFirstResponder];
    NSLog(@"login");
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if([textField isEqual:self.usernameField]) {
        [self.passwordField becomeFirstResponder];
    }
    else if([textField isEqual:self.passwordField]) {
        [self.passwordField resignFirstResponder];
        [self login];
    }
    return YES;
}

@end
