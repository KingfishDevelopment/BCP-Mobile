//
//  BCPViewController.m
//  BCP-Mobile
//
//  Created by Bryce Pauken on 4/5/14.
//  Copyright (c) 2014 Kingfish. All rights reserved.
//

#import "BCPViewController.h"

#import "BCPContent.h"
#import "BCPGradesView.h"
#import "BCPInterface.h"
#import "BCPNavigationBar.h"
#import "BCPSidebar.h"
#import "TSMessageView.h"

@interface BCPViewController ()

@end

@implementation BCPViewController

- (id)init {
    self = [super init];
    if (self) {
        [BCPCommon setViewController:self];
        [BCPData initialize];
        [self.view setClipsToBounds:YES];
        
        self.interface = [[BCPInterface alloc] initWithFrame:self.view.bounds];
        [self.interface setAutoresizingMask:UIViewAutoresizingFlexibleSize];
        [self.view addSubview:self.interface];
        
        UITextField *field = [UITextField new];
        [[[[UIApplication sharedApplication] windows] lastObject] addSubview:field];
        [field becomeFirstResponder];
        [field resignFirstResponder];
        [field removeFromSuperview];
        
        [TSMessage setDefaultViewController:self];
    }
    return self;
}

- (UIView *)currentNotification {
    for(UIView *view in [self.interface.content subviews]) {
        if([view isKindOfClass:[TSMessageView class]]) {
            return view;
        }
    }
    return nil;
}

- (void)insertSubviewBelowNavigationBar:(UIView *)view {
    if(!self.interface.content.navigationBar.hidden) {
        [self.interface.content insertSubview:view belowSubview:self.interface.content.navigationBar];
    }
    else {
        [self.interface.content addSubview:view];
    }
}

- (BOOL)loggedIn {
    return [[BCPData data] objectForKey:@"login"]&&[[[BCPData data] objectForKey:@"login"] objectForKey:@"token"];
}

- (int)navigationBarHeight {
    UIView *navigationBar = self.interface.content.navigationBar;
    if(!navigationBar.hidden) {
        return navigationBar.frame.size.height;
    }
    return 0;
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)setLoggedIn:(BOOL)loggedIn {
    [self.interface.sideBar setSelectedIndexPath:nil];
    [self.interface.sideBar performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    if(loggedIn) {
        [TSMessage showNotificationWithTitle:@"Logged In" subtitle:@"You may now access new sections from the sidebar." type:TSMessageNotificationTypeSuccess];
    
        [[self.interface.content.views objectForKey:@"Grades"] setFirstLoadCompleted:NO];
        for(UITableView *tableView in [[self.interface.content.views objectForKey:@"Grades"] tableViews]) {
            [tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
        }
        
        [[self.interface.content.views objectForKey:@"Schedule"] setFirstLoadCompleted:NO];
        for(UITableView *tableView in [[self.interface.content.views objectForKey:@"Schedule"] tableViews]) {
            [tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
        }
    }
    else {
        [TSMessage showNotificationWithTitle:@"Logged Out" subtitle:@"You must login again to access the 'My BCP' sections." type:TSMessageNotificationTypeMessage];
    }
}

- (void)setScrollsToTop:(UIScrollView *)scrollView {
    if(self.currentScrollView) {
        [self.currentScrollView setScrollsToTop:NO];
    }
    self.currentScrollView = scrollView;
    if(self.currentScrollView) {
        [self.currentScrollView setScrollsToTop:YES];
    }
}

- (void)showSideBar {
    [UIView animateWithDuration:BCP_TRANSITION_DURATION animations:^{
        [self.interface.scrollView setContentOffset:CGPointZero];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if([BCPCommon isIOS7]) {
        [self setNeedsStatusBarAppearanceUpdate];
    }
}

@end
