//
//  BCPViewController.m
//  BCP-Mobile
//
//  Created by Bryce Pauken on 4/5/14.
//  Copyright (c) 2014 Kingfish. All rights reserved.
//

#import "BCPViewController.h"

#import "BCPInterface.h"

@interface BCPViewController ()

@end

@implementation BCPViewController

- (id)init {
    self = [super init];
    if (self) {
        [BCPCommon setViewController:self];
        [self.view setClipsToBounds:YES];
        
        self.interface = [[BCPInterface alloc] initWithFrame:self.view.bounds];
        [self.interface setAutoresizingMask:UIViewAutoresizingFlexibleSize];
        [self.view addSubview:self.interface];
        
        UITextField *field = [UITextField new];
        [[[[UIApplication sharedApplication] windows] lastObject] addSubview:field];
        [field becomeFirstResponder];
        [field resignFirstResponder];
        [field removeFromSuperview];
    }
    return self;
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
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
