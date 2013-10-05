//
//  BCPViewController.m
//  BCP-Mobile
//
//  Created by Bryce Pauken on 10/2/13.
//  Copyright (c) 2013 Kingfish. All rights reserved.
//

#import "BCPViewController.h"

@interface BCPViewController ()

@end

@implementation BCPViewController

- (id)initWithFrame:(CGRect)frame {
    self = [super init];
    if(self) {
        [BCPCommon setViewControllerDelegate:self];
        
        [self.view setFrame:frame];
        [self.view setBackgroundColor:[UIColor blackColor]];
        
        SEL keyboardShown = sel_registerName("keyboardShown:");
        SEL keyboardHidden = sel_registerName("keyboardHidden:");
        [[NSNotificationCenter defaultCenter] addObserver:self selector:keyboardShown name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self.keyboardDelegate selector:keyboardHidden name:UIKeyboardWillHideNotification object:nil];
        
        self.interface = [[BCPInterface alloc] init];
        [self.view addSubview:self.interface];
        
        [self shouldAutorotate];
    }
    return self;
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)setScrollsToTop:(UIScrollView *)scrollView {
    [self setScrollsToTop:scrollView fromView:self.view];
}

- (void)setScrollsToTop:(UIScrollView *)scrollView fromView:(UIView *)view {
    if([view isKindOfClass:[UIScrollView class]]) {
        [(UIScrollView*)view setScrollsToTop:[view isEqual:scrollView]];
    }
    for (UIView *subview in [view subviews]) {
        [self setScrollsToTop:scrollView fromView:subview];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

-(BOOL)shouldAutorotate {
    [self willRotateToInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
    return YES;
}

- (void)showContentView:(NSString *)view {
    [self.interface.content showContentView:view];
    if(![BCPCommon IS_IPAD]) {
        [UIView animateWithDuration:0.25 delay:0 options:0 animations:^ {
            [self.interface.scrollView setContentOffset:CGPointMake([BCPCommon SIDEBAR_WIDTH], 0)];
        } completion:NULL];
    }
}

- (void)viewDidLoad {
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)])
        [self setNeedsStatusBarAppearanceUpdate];
}

- (BOOL)willRotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    CGRect frame;
    if(interfaceOrientation==UIInterfaceOrientationPortrait||interfaceOrientation==UIInterfaceOrientationPortraitUpsideDown)
        frame = self.view.frame;
    else
        frame = CGRectMake(0, 0, self.view.frame.size.height, self.view.frame.size.width);
    if(![BCPCommon IS_IOS7])
        frame.origin.y-=20;
    [self.interface setFrame:frame];
    return YES;
}

@end
