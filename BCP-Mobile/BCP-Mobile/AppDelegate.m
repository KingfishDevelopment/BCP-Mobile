//
//  AppDelegate.m
//  BCP-Mobile
//
//  Created by Bryce Pauken on 10/1/13.
//  Copyright (c) 2013 Kingfish. All rights reserved.
//

#import "AppDelegate.h"
#import "BCPViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    [self.window setRootViewController:[[BCPViewController alloc] initWithFrame:self.window.frame]];
    return YES;
}

@end
