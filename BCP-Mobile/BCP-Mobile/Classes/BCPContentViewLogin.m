//
//  BCPContentViewLogin.m
//  BCP-Mobile
//
//  Created by Bryce Pauken on 10/5/13.
//  Copyright (c) 2013 Kingfish. All rights reserved.
//

#import "BCPContentViewLogin.h"

@implementation BCPContentViewLogin

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.textFieldContainer = [[UIView alloc] init];
        [self.textFieldContainer setBackgroundColor:[BCPCommon TEXTFIELD_COLOR]];
        [self addShadowToView:self.textFieldContainer];
        [self addSubview:self.textFieldContainer];
        
        self.loggedInLabel = [[UILabel alloc] init];
        [self.loggedInLabel setAlpha:0];
        [self.loggedInLabel setText:@"You have been successfully logged in!\r\n\r\nYou may now access personal information like grades, email, and more."];
        [self formatLabel:self.loggedInLabel];
        [self addSubview:self.loggedInLabel];
        
        self.icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"RoundedIcon"]];
        [BCPImage registerView:self.icon withGetter:@"image" withSetter:@"setImage:" withImage:[UIImage imageNamed:@"RoundedIcon"]];
        [self addShadowToView:self.icon];
        [self addSubview:self.icon];
        
        self.textFieldUsername = [[UITextField alloc] init];
        [self.textFieldUsername setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        [self.textFieldUsername setAutocorrectionType:UITextAutocorrectionTypeNo];
        [self.textFieldUsername setClearButtonMode:UITextFieldViewModeWhileEditing];
        [self.textFieldUsername setDelegate:self];
        [self.textFieldUsername setPlaceholder:@"Username"];
        [self.textFieldUsername setReturnKeyType:UIReturnKeyNext];
        [self.textFieldContainer addSubview:self.textFieldUsername];
        
        self.textFieldPassword = [[UITextField alloc] init];
        [self.textFieldPassword setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        [self.textFieldPassword setAutocorrectionType:UITextAutocorrectionTypeNo];
        [self.textFieldPassword setClearButtonMode:UITextFieldViewModeWhileEditing];
        [self.textFieldPassword setDelegate:self];
        [self.textFieldPassword setPlaceholder:@"Password"];
        [self.textFieldPassword setReturnKeyType:UIReturnKeyGo];
        [self.textFieldPassword setSecureTextEntry:YES];
        [self.textFieldContainer addSubview:self.textFieldPassword];
        
        if([[BCPCommon data] objectForKey:@"login"]) {
            [self.loggedInLabel setAlpha:1];
            [self.icon setAlpha:0];
            [self.textFieldContainer setAlpha:0];
        }
    }
    return self;
}

- (void)keyboardHidden:(NSNotification*)notification {
    self.keyboardVisible = false;
    [UIView animateWithDuration:0.25 delay:0 options:0 animations:^ {
        [self setFrame:self.frame];
    } completion:NULL];
}

- (void)keyboardShown:(NSNotification*)notification {
    self.keyboardVisible = true;
    NSDictionary* info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    self.keyboardHeight = MIN(kbSize.height, kbSize.width);
    [UIView animateWithDuration:0.25 delay:0 options:0 animations:^ {
        [self setFrame:self.frame];
    } completion:NULL];
}

- (void)responseReturnedError:(BOOL)error {
    if(!error) {
        [BCPCommon reloadSidebar];
        [UIView animateWithDuration:0.25 delay:0 options:0 animations:^ {
            [self.loggedInLabel setAlpha:1];
            [self.icon setAlpha:0];
            [self.textFieldContainer setAlpha:0];
        } completion:NULL];
    }
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    if(self.keyboardVisible)
        frame.size.height-=self.keyboardHeight;
    
    CGSize loggedInLabelSize = [self.loggedInLabel.text sizeWithFont:[self.loggedInLabel font] constrainedToSize:CGSizeMake(frame.size.width-[BCPCommon CONTENT_SIDE_PADDING]*2, 10000) lineBreakMode:self.loggedInLabel.lineBreakMode];
    [self.loggedInLabel setFrame:CGRectMake([BCPCommon CONTENT_SIDE_PADDING], frame.size.height/2-loggedInLabelSize.height, frame.size.width-[BCPCommon CONTENT_SIDE_PADDING]*2, loggedInLabelSize.height)];
    
    [self.icon setFrame:CGRectMake((frame.size.width-[BCPCommon LOGIN_ICON_SIZE])/2, frame.size.height/2-[BCPCommon LOGIN_ICON_SIZE]-[BCPCommon CONTENT_MIDDLE_PADDING], [BCPCommon LOGIN_ICON_SIZE], [BCPCommon LOGIN_ICON_SIZE])];
    
    [self.textFieldContainer setFrame:CGRectMake([BCPCommon CONTENT_SIDE_PADDING], frame.size.height/2+[BCPCommon CONTENT_MIDDLE_PADDING], frame.size.width-([BCPCommon CONTENT_SIDE_PADDING]*2), [BCPCommon TEXTBOX_HEIGHT]*2)];

    [self.textFieldUsername setFrame:CGRectMake([BCPCommon TEXTBOX_PADDING], [BCPCommon TEXTBOX_PADDING], self.textFieldContainer.frame.size.width-[BCPCommon TEXTBOX_PADDING]*2, self.textFieldContainer.frame.size.height/2-[BCPCommon TEXTBOX_PADDING])];
    [self.textFieldPassword setFrame:CGRectMake([BCPCommon TEXTBOX_PADDING], self.textFieldContainer.frame.size.height/2, self.textFieldContainer.frame.size.width-[BCPCommon TEXTBOX_PADDING]*2, self.textFieldContainer.frame.size.height/2-[BCPCommon TEXTBOX_PADDING])];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if([textField isEqual:self.textFieldUsername])
        [self.textFieldPassword becomeFirstResponder];
    else if([textField isEqual:self.textFieldPassword]&&[[self.textFieldUsername text] length]>0&&[[self.textFieldPassword text] length]>0) {
        [self.textFieldPassword resignFirstResponder];
        [self keyboardHidden:nil];
        [[BCPCommon data] sendRequest:@"login" withDetails:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[self.textFieldUsername text],[self.textFieldPassword text],nil] forKeys:[NSArray arrayWithObjects:@"username",@"password",nil]] withDelegate:self];
    }
    return YES;
}

@end
