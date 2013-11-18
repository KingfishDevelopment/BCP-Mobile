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
    
    [BCPCommon setViewControllerDelegate:self];
    self.registeredBlocks = [[NSMutableArray alloc] init];
	
    self.interface = [[BCPInterface alloc] initWithFrame:self.view.bounds];
    [self.interface setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
    [self.view addSubview:self.interface];
}

- (void)registerViewForRotation:(UIView *)view withBlock:(void (^)())block {
    [self.registeredBlocks addObject:block];
    block();
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

-(BOOL)shouldAutorotate {
    [self willRotateToInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
    return YES;
}

typedef void (^RotationBlock)(void);
- (BOOL)willRotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    for (RotationBlock block in self.registeredBlocks) {
        block();
    }
    return YES;
}

@end
