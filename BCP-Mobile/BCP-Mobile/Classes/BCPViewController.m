//
//  BCPViewController.m
//  BCP-Mobile
//
//  Created by Bryce Pauken on 4/5/14.
//  Copyright (c) 2014 sobryapps. All rights reserved.
//

#import "BCPViewController.h"

@interface BCPViewController ()

@end

@implementation BCPViewController

- (id)init {
    self = [super init];
    if (self) {
        self.interface = [[BCPInterface alloc] init];
        [self.interface setAutoresizingMask:UIViewAutoresizingFlexibleSize];
        [self.interface setFrame:self.view.bounds];
        [self.view addSubview:self.interface];
    }
    return self;
}

@end
