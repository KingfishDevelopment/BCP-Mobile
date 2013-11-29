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

typedef void (^RotationBlock)(void);

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if([BCPCommon IS_IOS7])
        [self setNeedsStatusBarAppearanceUpdate];
    
    [BCPCommon setViewControllerDelegate:self];
    self.registeredAfterBlocks = [[NSMutableArray alloc] init];
    self.registeredBeforeAnimationBlocks = [[NSMutableArray alloc] init];
    self.registeredBeforeBlocks = [[NSMutableArray alloc] init];
	
    self.interface = [[BCPInterface alloc] initWithFrame:self.view.bounds];
    [self.interface setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
    [self.view addSubview:self.interface];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    for (RotationBlock block in self.registeredAfterBlocks)
        block();
}

- (void)errorWithCode:(int)code {
    
}

- (void)errorWithMessage:(NSString *)message {
    
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
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
    /*
     [UIView animateWithDuration:0.25 animations:^{
     [[self.interface scrollView] setContentOffset:CGPointMake(SIDEBAR_WIDTH, 0)];
     }];
     */
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
