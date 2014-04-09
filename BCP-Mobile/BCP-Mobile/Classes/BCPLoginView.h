//
//  BCPLoginView.h
//  BCP-Mobile
//
//  Created by Bryce Pauken on 4/6/14.
//  Copyright (c) 2014 Kingfish. All rights reserved.
//

#import "BCPContentView.h"

@interface BCPLoginView : BCPContentView <UITextFieldDelegate>

@property (nonatomic, retain) UIView *container;
@property (nonatomic) CGFloat keyboardHeight;
@property (nonatomic) BOOL loggedIn;
@property (nonatomic, retain) UIButton *loginButton;
@property (nonatomic, retain) UIImageView *icon;
@property (nonatomic, retain) UITextField *passwordField;
@property (nonatomic, retain) UIView *textFieldContainer;
@property (nonatomic, retain) UITextField *usernameField;

@end
