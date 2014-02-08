//
//  BCPViewController.m
//  BCP-Mobile
//
//  Created by Bryce Pauken on 11/17/13.
//  Copyright (c) 2013 Kingfish. All rights reserved.
//

#import "BCPViewController.h"

@interface BCPViewController ()

@end

@implementation BCPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if([BCPCommon IS_IOS7])
        [self setNeedsStatusBarAppearanceUpdate];
    
    [BCPCommon setViewControllerDelegate:self];
    self.registeredAfterBlocks = [[NSMutableArray alloc] init];
    self.registeredBeforeAnimationBlocks = [[NSMutableArray alloc] init];
    self.registeredBeforeBlocks = [[NSMutableArray alloc] init];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    self.interface = [[BCPInterface alloc] initWithFrame:self.view.bounds];
    [self.interface setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
    [self.view addSubview:self.interface];
    
    [TSMessage setDefaultViewController:self];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    for (RotationBlock block in self.registeredAfterBlocks)
        block();
}

- (void)errorWithCode:(int)code {
    [self errorWithMessage:[NSString stringWithFormat:@"msg:A fatal error has occurred.\r\n\r\n[Error Code: %i]",code]];
}

- (void)errorWithMessage:(NSString *)message {
    NSString *title = @"Error";
    if([message isEqualToString:@"INVALID_LOGIN"]) {
        title = @"Invalid Login";
        message = @"Your username and password appear to be incorrect.\r\n\r\nPlease try again.";
    }
    else if([message length]<4||![[message substringToIndex:4] isEqualToString:@"msg:"]) {
        title = @"Error";
        message = @"A serious (and fatal) error has occured.\r\n\r\nPlease try again, and if the problem persists, please report it so we can get it fixed!";
    }
    else {
        message = [message substringFromIndex:4];
    }
    [BCPCommon alertWithTitle:title withText:message];
}

- (void)insertSubviewBelowNavigationBar:(UIView *)view {
    if([self.interface.content.currentView respondsToSelector:@selector(navigationBar)])
        [self.interface.content.currentView insertSubview:view belowSubview:[self.interface.content.currentView valueForKey:@"navigationBar"]];
    else
        [self.interface.content.currentView addSubview:view];
}

- (void)keyboardHidden:(NSNotification*)notification {
    self.keyboardHidden();
}

- (void)keyboardShown:(NSNotification*)notification {
    self.keyboardShown();
}

- (void)loggedIn {
    //[TSMessage showNotificationInViewController:self title:@"Logged In!" subtitle:@"You may now access new sections from the sidebar." image:nil type:TSMessageNotificationTypeSuccess duration:5 callback:nil buttonTitle:nil buttonCallback:nil atPosition:TSMessageNotificationPositionBottom canBeDismisedByUser:YES];
    [TSMessage showNotificationWithTitle:@"Logged In!" subtitle:@"You may now access new sections from the sidebar." type:TSMessageNotificationTypeSuccess];
    [UIView animateWithDuration:0.25 animations:^(void) {
        [((BCPContentLogin *)[self.interface.content.views objectForKey:@"Login"]).textFieldContainer setAlpha:0];
    }];
}

- (int)navigationBarHeight {
    if([self.interface.content.currentView respondsToSelector:@selector(navigationBar)])
        return ((BCPNavigationBar *)[self.interface.content.currentView valueForKey:@"navigationBar"]).frame.size.height;
    return 0;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)reloadSidebar {
    [[[self interface] sidebar] performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
}

- (void)registerBlockForAfterRotation:(void (^)())block {
    [self.registeredAfterBlocks addObject:block];
    block();
}

- (void)registerBlockForBeforeAnimationRotation:(void (^)())block {
    [self.registeredBeforeAnimationBlocks addObject:block];
    block();
}

- (void)registerBlockForBeforeRotation:(void (^)())block {
    [self.registeredBeforeBlocks addObject:block];
    block();
}

- (void)registerKeyboardWithShown:(void (^)())shown hidden:(void (^)())hidden {
    self.keyboardHidden = hidden;
    self.keyboardShown = shown;
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

- (BOOL)shouldAutorotate {
    [self willRotateToInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
    return YES;
}

- (void)showContentView:(NSString *)view {
    [[self.interface content] showContentView:view];
    [[self.interface scrollView] setContentOffset:CGPointMake(SIDEBAR_WIDTH, 0) animated:YES];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)orientation duration:(NSTimeInterval)duration {
    for (RotationBlock block in self.registeredBeforeAnimationBlocks)
        block();
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    for (RotationBlock block in self.registeredBeforeBlocks)
        block();
}

@end
