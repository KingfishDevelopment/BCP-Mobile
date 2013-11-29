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

@property (nonatomic, retain) UIImageView *icon;
@property (nonatomic, retain) BCPNavigationBar *navigationBar;
@property (nonatomic, retain) UIView *textFieldContainer;
@property (nonatomic, retain) UITextField *textFieldPassword;
@property (nonatomic, retain) UITextField *textFieldUsername;

@end
