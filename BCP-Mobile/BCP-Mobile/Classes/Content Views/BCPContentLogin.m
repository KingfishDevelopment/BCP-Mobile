//
//  BCPContentLogin.m
//  BCP-Mobile
//
//  Created by Bryce Pauken on 11/28/13.
//  Copyright (c) 2013 Kingfish. All rights reserved.
//

#import "BCPContentLogin.h"

@implementation BCPContentLogin

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.navigationBar = [[BCPNavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, NAVIGATION_BAR_HEIGHT)];
        [self.navigationBar setText:@"Login"];
        
        self.icon = [[UIImageView alloc] init];
        [self.icon setImage:[UIImage imageNamed:@"RoundedIcon"]];
        [self addSubview:self.icon];
        
        self.textFieldContainer = [[UIView alloc] init];
        [self.textFieldContainer setBackgroundColor:[UIColor BCPOffWhite]];
        self.textFieldContainer.layer.shadowColor = [UIColor BCPOffBlack].CGColor;
        self.textFieldContainer.layer.shadowOffset = CGSizeMake(0, 4);
        self.textFieldContainer.layer.shadowOpacity = 0.8;
        self.textFieldContainer.layer.shadowRadius = 4;
        self.textFieldContainer.clipsToBounds = NO;
        [self addSubview:self.textFieldContainer];
        
        self.textFieldUsername = [[UITextField alloc] init];
        [self.textFieldUsername setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        [self.textFieldUsername setAutocorrectionType:UITextAutocorrectionTypeNo];
        [self.textFieldUsername setClearButtonMode:UITextFieldViewModeWhileEditing];
        [self.textFieldUsername setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [self.textFieldUsername setDelegate:self];
        [self.textFieldUsername setPlaceholder:@"Username"];
        [self.textFieldUsername setReturnKeyType:UIReturnKeyNext];
        [self.textFieldContainer addSubview:self.textFieldUsername];
        
        self.textFieldPassword = [[UITextField alloc] init];
        [self.textFieldPassword setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        [self.textFieldPassword setAutocorrectionType:UITextAutocorrectionTypeNo];
        [self.textFieldPassword setClearButtonMode:UITextFieldViewModeWhileEditing];
        [self.textFieldPassword setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [self.textFieldPassword setDelegate:self];
        [self.textFieldPassword setPlaceholder:@"Password"];
        [self.textFieldPassword setReturnKeyType:UIReturnKeyGo];
        [self.textFieldPassword setSecureTextEntry:YES];
        [self.textFieldContainer addSubview:self.textFieldPassword];
        
        [self addSubview:self.navigationBar];
    }
    return self;
}

- (void)layoutSubviews {
    [self.icon setFrame:CGRectMake((self.bounds.size.width-LOGIN_ICON_WIDTH)/2, (self.navigationBar.bounds.size.height+self.bounds.size.height)/2-LOGIN_ICON_WIDTH-CONTENT_MIDDLE_PADDING, LOGIN_ICON_WIDTH, LOGIN_ICON_WIDTH)];
    CGFloat textContainerWidth = MIN(320,self.bounds.size.width-(CONTENT_SIDE_PADDING*2));
    [self.textFieldContainer setFrame:CGRectMake((self.bounds.size.width-textContainerWidth)/2, self.bounds.size.height/2+CONTENT_MIDDLE_PADDING, textContainerWidth, TEXTBOX_HEIGHT*2)];
    [self.textFieldPassword setFrame:CGRectMake(TEXTBOX_PADDING, self.textFieldContainer.frame.size.height/2, self.textFieldContainer.frame.size.width-TEXTBOX_PADDING*2, self.textFieldContainer.frame.size.height/2-TEXTBOX_PADDING)];
    [self.textFieldUsername setFrame:CGRectMake(TEXTBOX_PADDING, TEXTBOX_PADDING, self.textFieldContainer.frame.size.width-TEXTBOX_PADDING*2, self.textFieldContainer.frame.size.height/2-TEXTBOX_PADDING)];
}

@end
