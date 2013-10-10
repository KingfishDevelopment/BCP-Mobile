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
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShown:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHidden:) name:UIKeyboardDidHideNotification object:nil];
        
        self.interface = [[BCPInterface alloc] init];
        if(self.startInterfaceWithDisabledScrollView)
            [self.interface.scrollView setScrollEnabled:NO];
        [self.view addSubview:self.interface];
        
        if(self.firstView)
            [self.interface.sidebarController selectRow:self.firstView];
        
        [self shouldAutorotate];
    }
    return self;
}

- (void)dismissKeyboard {
    [self.view endEditing:YES];
}

- (void)error:(NSString *)error {
    NSString *title = @"Fatal Error";
    if([error isEqualToString:@"INVALID_LOGIN"]) {
        error = @"Your username and password appear to be incorrect.\r\n\r\nPlease try again.";
        title = @"Invalid Login";
    }
    else
        error = @"A serious (and fatal) error has occured.\r\n\r\nPlease try again, and if the problem persists, please report it so we can get it fixed!";
    UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:title message:error delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [errorAlertView performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
}

- (void)keyboardHidden:(NSNotification*)notification {
    [self.keyboardDelegate keyboardHidden:notification];
}

- (void)keyboardShown:(NSNotification*)notification {
    [self.keyboardDelegate keyboardShown:notification];
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)reloadLoginViews {
    [[self.interface.content.views objectForKey:@"login"] removeFromSuperview];
    [[self.interface.content.views objectForKey:@"logout"] removeFromSuperview];
    [self.interface.content.views setObject:[[BCPContentViewLogin alloc] init] forKey:@"login"];
    [self.interface.content.views setObject:[[BCPContentViewLogout alloc] init] forKey:@"logout"];
    [[self.interface.content.views objectForKey:@"login"] setHidden:YES];
    [[self.interface.content.views objectForKey:@"logout"] setHidden:YES];
    [self.interface.content addSubview:[self.interface.content.views objectForKey:@"login"]];
    [self.interface.content addSubview:[self.interface.content.views objectForKey:@"logout"]];
    [self.interface.content setFrame:self.interface.content.frame];
}

- (void)reloadSidebar {
    [self.interface.sidebar reloadData];
}

- (void)selectLogin {
    [self.interface.sidebarController selectLogin];
}

- (void)setInterfaceScrollViewEnabled:(BOOL)enabled {
    if(self.interface==nil)
        self.startInterfaceWithDisabledScrollView = true;
    else
        [self.interface.scrollView setScrollEnabled:enabled];
}

- (void)setKeyboardOwner:(NSObject<BCPKeyboardDelegate> *)keyboardDelegate {
    self.keyboardDelegate = keyboardDelegate;
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
    [[BCPCommon data] setObject:view forKey:@"lastView"];
    [self.interface.content showContentView:view];
    self.firstView = view;
    if(![BCPCommon IS_IPAD]) {
        [UIView animateWithDuration:0.25 delay:0 options:0 animations:^ {
            [self.interface.scrollView setContentOffset:CGPointMake([BCPCommon SIDEBAR_WIDTH], 0)];
        } completion:NULL];
    }
}

- (void)sidebarReselect {
    [self.interface.sidebarController viewDidAppear:YES];
}

- (void)viewDidLoad {
    if([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)])
        [self setNeedsStatusBarAppearanceUpdate];
}

- (BOOL)viewIsVisable:(NSString *)view {
    return ((UIView *)[self.interface.content.views objectForKey:@"login"]).hidden;
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
