//
//  BCPCommon.m
//  BCP-Mobile
//
//  Created by Bryce Pauken on 11/17/13.
//  Copyright (c) 2013 Kingfish. All rights reserved.
//

#import "BCPCommon.h"

static NSObject<BCPViewControllerDelegate> *viewController = nil;

@implementation BCPCommon

+ (void)alertWithTitle:(NSString *)title withText:(NSString*)text {
    FUIAlertView *alertView = [[FUIAlertView alloc] initWithTitle:title message:text delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    alertView.titleLabel.textColor = [UIColor BCPOffWhite];
    alertView.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    alertView.messageLabel.textColor = [UIColor BCPOffWhite];
    alertView.messageLabel.font = [UIFont boldSystemFontOfSize:14];
    alertView.backgroundOverlay.backgroundColor = [[UIColor BCPOffBlack] colorWithAlphaComponent:0.5];
    alertView.alertContainer.backgroundColor = [UIColor BCPBlue];
    alertView.defaultButtonColor = [UIColor BCPOffWhite];
    alertView.defaultButtonShadowColor = [UIColor BCPOffBlack];
    alertView.defaultButtonFont = [UIFont boldSystemFontOfSize:16];
    alertView.defaultButtonTitleColor = [UIColor BCPOffBlack];
    alertView.maxHeight = 380;
    
    [alertView show];
}

+ (BOOL)IS_IOS7 {
    return ([[[UIDevice currentDevice] systemVersion] compare:@"7" options:NSNumericSearch] != NSOrderedAscending);
}

+ (BOOL)IS_IPAD {
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
}

+ (void)setViewControllerDelegate:(NSObject<BCPViewControllerDelegate> *)viewControllerDelegate {
    viewController = viewControllerDelegate;
}

+ (NSObject<BCPViewControllerDelegate> *) viewController {
    return viewController;
}

@end
