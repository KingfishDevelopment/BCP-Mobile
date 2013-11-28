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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

-(BOOL)shouldAutorotate {
    [self willRotateToInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
    return YES;
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
