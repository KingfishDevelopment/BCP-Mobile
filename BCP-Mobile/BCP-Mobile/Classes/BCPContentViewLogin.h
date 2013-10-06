//
//  BCPContentViewLogin.h
//  BCP-Mobile
//
//  Created by Bryce Pauken on 10/5/13.
//  Copyright (c) 2013 Kingfish. All rights reserved.
//

#import "BCPContentView.h"

@interface BCPContentViewLogin : BCPContentView <BCPDataDelegate, UITextFieldDelegate>

@property (nonatomic) float keyboardHeight;
@property (nonatomic) BOOL keyboardVisible;
@property (nonatomic, retain) UIImageView *icon;
@property (nonatomic, retain) UILabel *loggedInLabel;
@property (nonatomic, retain) UIView *textFieldContainer;
@property (nonatomic, retain) UITextField *textFieldPassword;
@property (nonatomic, retain) UITextField *textFieldUsername;

@end
