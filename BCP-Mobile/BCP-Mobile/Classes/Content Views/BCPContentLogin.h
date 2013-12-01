//
//  BCPContentLogin.h
//  BCP-Mobile
//
//  Created by Bryce Pauken on 11/28/13.
//  Copyright (c) 2013 Kingfish. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BCPContentView.h"

@interface BCPContentLogin : BCPContentView <UITextFieldDelegate>

@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic) BOOL keyboardVisible;
@property (nonatomic, strong) BCPNavigationBar *navigationBar;
@property (nonatomic, strong) UIView *textFieldContainer;
@property (nonatomic, strong) UITextField *textFieldPassword;
@property (nonatomic, strong) UITextField *textFieldUsername;

@end
