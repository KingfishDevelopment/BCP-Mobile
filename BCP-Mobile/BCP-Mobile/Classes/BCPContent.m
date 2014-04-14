//
//  BCPContent.m
//  BCP-Mobile
//
//  Created by Bryce Pauken on 4/5/14.
//  Copyright (c) 2014 Kingfish. All rights reserved.
//

#import "BCPContent.h"

#import "BCPAnnouncementsView.h"
#import "BCPGradesView.h"
#import "BCPLoginView.h"
#import "BCPLogoutView.h"
#import "BCPNavigationBar.h"
#import "BCPNewsView.h"
#import "BCPWelcomeView.h"

@implementation BCPContent

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor BCPOffWhiteColor]];
        [self setClipsToBounds:YES];
        __unsafe_unretained typeof(self) weakSelf = self;
        
        CGFloat navigationBarHeight = BCP_NAVIGATION_BAR_HEIGHT+([BCPCommon isIOS7]?20:0);
        self.container = [[UIView alloc] initWithFrame:CGRectMake(0, navigationBarHeight, self.bounds.size.width, self.bounds.size.height-navigationBarHeight)];
        [self addSubview:self.container];
        
        self.navigationBar = [[BCPNavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, navigationBarHeight)];
        [self.navigationBar setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [self addSubview:self.navigationBar];
        [BCPContentView setUpdateNavigationBlock:^(BCPNavigationController *navigationController) {
            [weakSelf updateNavigationBarWithController:navigationController];
        }];
        
        self.views = [[NSMutableDictionary alloc] init];
        
        BCPAnnouncementsView *announcementsView = [[BCPAnnouncementsView alloc] initWithFrame:self.container.bounds];
        [self.container addSubview:announcementsView];
        [self.views setObject:announcementsView forKey:@"Announcements"];
        
        BCPGradesView *gradesView = [[BCPGradesView alloc] initWithFrame:self.container.bounds];
        [self.container addSubview:gradesView];
        [self.views setObject:gradesView forKey:@"Grades"];
        
        BCPLoginView *loginView = [[BCPLoginView alloc] initWithFrame:self.container.bounds];
        [self.container addSubview:loginView];
        [self.views setObject:loginView forKey:@"Login"];
        
        BCPLogoutView *logoutView = [[BCPLogoutView alloc] initWithFrame:self.container.bounds];
        [self.container addSubview:logoutView];
        [self.views setObject:logoutView forKey:@"Logout"];
        
        BCPNewsView *newsView = [[BCPNewsView alloc] initWithFrame:self.container.bounds];
        [self.container addSubview:newsView];
        [self.views setObject:newsView forKey:@"News"];
        
        BCPWelcomeView *welcomeView = [[BCPWelcomeView alloc] initWithFrame:self.container.bounds];
        [self.container addSubview:welcomeView];
        [self.views setObject:welcomeView forKey:@"Welcome"];
    }
    return self;
}

- (void)layoutSubviews {
    CGFloat navigationBarHeight = BCP_NAVIGATION_BAR_HEIGHT+([BCPCommon isIOS7]?20:0);
    [self.container setFrame:CGRectMake(0, navigationBarHeight, self.bounds.size.width, self.bounds.size.height-navigationBarHeight)];
}

- (void)showViewWithKey:(NSString *)showKey {
    if([showKey isEqualToString:@"Login"]&&[[BCPCommon viewController] loggedIn]) {
        showKey = @"Logout";
    }
    else if([showKey isEqualToString:@"Logout"]&&![[BCPCommon viewController] loggedIn]) {
        showKey = @"Login";
    }
    if([showKey isEqualToString:@"Login"]) {
        BCPLoginView *loginView = [[BCPLoginView alloc] initWithFrame:self.container.bounds];
        [self.container addSubview:loginView];
        [self.views setObject:loginView forKey:@"Login"];
    }
    else if([showKey isEqualToString:@"Logout"]) {
        BCPLogoutView *logoutView = [[BCPLogoutView alloc] initWithFrame:self.container.bounds];
        [self.container addSubview:logoutView];
        [self.views setObject:logoutView forKey:@"Logout"];
    }
    __block BOOL viewFound = NO;
    [self.views enumerateKeysAndObjectsUsingBlock:^(NSString *key, UIView *view, BOOL *stop) {
        [view setHidden:![key isEqualToString:showKey]];
        if([key isEqualToString:showKey]) {
            viewFound = YES;
        }
    }];
    if(!viewFound) {
        [self updateNavigationBarWithController:[[BCPNavigationController alloc] init]];
    }
    if(![showKey isEqual:[[BCPData data] objectForKey:@"lastView"]]) {
        [TSMessage removeCurrentNotification];
        [[BCPData data] setObject:showKey forKey:@"lastView"];
        [BCPData saveDictionary];
    }
}

- (void)updateNavigationBarWithController:(BCPNavigationController *)navigationController {
    [self.navigationBar.label setText:navigationController.navigationBarText];
    if(navigationController.leftButtonImageName&&navigationController.leftButtonTapped) {
        [self.navigationBar.leftButton setHidden:NO];
        [self.navigationBar.leftButton setImage:[UIImage imageNamed:navigationController.leftButtonImageName] forState:UIControlStateNormal];
        [self.navigationBar setLeftButtonTapped:navigationController.leftButtonTapped];
    }
    else {
        [self.navigationBar.leftButton setHidden:YES];
    }
    if(navigationController.rightButtonImageName&&navigationController.rightButtonTapped) {
        [self.navigationBar.rightButton setHidden:NO];
        [self.navigationBar.rightButton setImage:[UIImage imageNamed:navigationController.rightButtonImageName] forState:UIControlStateNormal];
        [self.navigationBar setRightButtonTapped:navigationController.rightButtonTapped];
    }
    else {
        [self.navigationBar.rightButton setHidden:YES];
    }
}

@end
