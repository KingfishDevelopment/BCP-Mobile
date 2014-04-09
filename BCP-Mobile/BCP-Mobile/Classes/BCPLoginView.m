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
        self.loggedIn = NO;
        self.keyboardHeight = 0;
        
        self.container = [[UIView alloc] init];
        
        self.icon = [[UIImageView alloc] initWithFrame:CGRectMake(BCP_ICON_SIZE, 0, BCP_ICON_SIZE, BCP_ICON_SIZE)];
        [self.icon setImage:[UIImage imageNamed:@"IconLarge"]];
        [self.container addSubview:self.icon];
        
        self.textFieldContainer = [[UIView alloc] initWithFrame:CGRectMake(0, self.icon.frame.size.height+20, BCP_LOGIN_CONTAINER_WIDTH, BCP_TEXTFIELD_HEIGHT*2)];
        [self.textFieldContainer.layer setBorderColor:[UIColor BCPLightGrayColor].CGColor];
        [self.textFieldContainer.layer setBorderWidth:1.0f];
        [self.textFieldContainer.layer setCornerRadius:5.0f];
        [self.textFieldContainer.layer setMasksToBounds:YES];
        [self.container addSubview:self.textFieldContainer];
        
        for(int i=0;i<2;i++) {
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(10, BCP_TEXTFIELD_HEIGHT*i, BCP_LOGIN_CONTAINER_WIDTH-20, BCP_TEXTFIELD_HEIGHT)];
            [textField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
            [textField setAutocorrectionType:UITextAutocorrectionTypeNo];
            [textField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
            [textField setDelegate:self];
            [textField setPlaceholder:i==0?@"Username":@"Password"];
            [textField setSecureTextEntry:i==1];
            [self.textFieldContainer addSubview:textField];
            if(i==0) {
                self.usernameField = textField;
            }
            else {
                self.passwordField = textField;
            }
        }
        
        UIView *textFieldContainerDivider = [[UIView alloc] initWithFrame:CGRectMake(0, BCP_TEXTFIELD_HEIGHT-0.5f, BCP_LOGIN_CONTAINER_WIDTH, 1)];
        [textFieldContainerDivider setBackgroundColor:[UIColor BCPLightGrayColor]];
        [self.textFieldContainer addSubview:textFieldContainerDivider];
        
        self.loginButton = [[UIButton alloc] initWithFrame:CGRectMake(0, self.textFieldContainer.frame.origin.y+self.textFieldContainer.frame.size.height+20, BCP_LOGIN_CONTAINER_WIDTH, BCP_TEXTFIELD_HEIGHT)];
        [self.loginButton addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
        [self.loginButton setTitle:@"Login" forState:UIControlStateNormal];
        [self.loginButton setTitleColor:[UIColor BCPOffBlackColor] forState:UIControlStateNormal];
        [self.loginButton.layer setBorderColor:[UIColor BCPLightGrayColor].CGColor];
        [self.loginButton.layer setBorderWidth:1.0f];
        [self.loginButton.layer setCornerRadius:5.0f];
        [self.loginButton.layer setMasksToBounds:YES];
        [self.container addSubview:self.loginButton];
        
        CGFloat containerHeight = self.icon.frame.size.height+self.textFieldContainer.frame.size.height+self.loginButton.frame.size.height+40;
        [self.container setFrame:CGRectMake((self.frame.size.width-BCP_LOGIN_CONTAINER_WIDTH)/2, (self.frame.size.height-self.keyboardHeight)/2-self.textFieldContainer.frame.origin.y-BCP_TEXTFIELD_HEIGHT-(BCP_NAVIGATION_BAR_HEIGHT+([BCPCommon isIOS7]?20:0))*(self.keyboardHeight>0?0:1)/2, BCP_LOGIN_CONTAINER_WIDTH, containerHeight)];
        [self addSubview:self.container];
        
        [self.navigationController setNavigationBarText:@"Login"];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (void)animateLoginButton {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setDuration:0.08];
    [animation setRepeatCount:4];
    [animation setAutoreverses:YES];
    [animation setFromValue:[NSValue valueWithCGPoint:CGPointMake(self.loginButton.center.x-5, self.loginButton.center.y)]];
    [animation setToValue:[NSValue valueWithCGPoint:CGPointMake(self.loginButton.center.x+5, self.loginButton.center.y)]];
    [self.loginButton.layer addAnimation:animation forKey:@"position"];
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
    if(!self.loggedIn) {
        [self.container setFrame:CGRectMake((self.frame.size.width-BCP_LOGIN_CONTAINER_WIDTH)/2, (self.frame.size.height-self.keyboardHeight)/2-BCP_ICON_SIZE-20-BCP_TEXTFIELD_HEIGHT-(BCP_NAVIGATION_BAR_HEIGHT+([BCPCommon isIOS7]?20:0))*(self.keyboardHeight>0?0:1)/2, BCP_LOGIN_CONTAINER_WIDTH, self.container.frame.size.height)];
    }
    else {
        [self.container setFrame:CGRectMake((self.frame.size.width-BCP_LOGIN_CONTAINER_WIDTH)/2, self.frame.size.height/2-self.icon.frame.size.height/2-self.icon.frame.origin.y, BCP_LOGIN_CONTAINER_WIDTH, self.container.frame.size.height)];
    }
    [self.icon setAlpha:[self convertPoint:self.icon.frame.origin fromView:self.container].y<20?0:1];
}

- (void)login {
    [self.usernameField resignFirstResponder];
    [self.passwordField resignFirstResponder];
    __unsafe_unretained typeof(self) weakSelf = self;
    [BCPData sendRequest:@"login" withDetails:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:self.usernameField.text,self.passwordField.text,nil] forKeys:[NSArray arrayWithObjects:@"username",@"password",nil]] onCompletion:^(NSString *error) {
        if(!error&&[[BCPData data] objectForKey:@"login"]&&[[[BCPData data] objectForKey:@"login"] objectForKey:@"token"]) {
            [[BCPCommon viewController] setLoggedIn:YES];
            self.loggedIn = YES;
            [self.textFieldContainer setUserInteractionEnabled:NO];
            [self.loginButton setUserInteractionEnabled:NO];
            [UIView animateWithDuration:BCP_TRANSITION_DURATION animations:^{
                [self.textFieldContainer setAlpha:0];
                [self.loginButton setAlpha:0];
                [self.container setFrame:CGRectMake((self.frame.size.width-BCP_LOGIN_CONTAINER_WIDTH)/2, self.frame.size.height/2-self.icon.frame.size.height/2-self.icon.frame.origin.y, BCP_LOGIN_CONTAINER_WIDTH, self.container.frame.size.height)];
            }];
        }
        else {
            [TSMessage showNotificationWithTitle:@"Invalid Username or Password" subtitle:@"Please check the credentials you entered and try again." type:TSMessageNotificationTypeError];
            [weakSelf performSelectorOnMainThread:@selector(animateLoginButton) withObject:nil waitUntilDone:NO];
        }
    }];
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
