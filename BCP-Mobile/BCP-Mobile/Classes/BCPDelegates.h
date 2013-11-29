//
//  BCPDelegates.h
//  BCP-Mobile
//
//  Created by Bryce Pauken on 11/17/13.
//  Copyright (c) 2013 Kingfish. All rights reserved.
//

@protocol BCPViewControllerDelegate<NSObject>

- (void)errorWithCode:(int)code;
- (void)errorWithMessage:(NSString *)message;
- (void)registerBlockForAfterRotation:(void (^)())block;
- (void)registerBlockForBeforeAnimationRotation:(void (^)())block;
- (void)registerBlockForBeforeRotation:(void (^)())block;
- (void)setScrollsToTop:(UIScrollView *)scrollView;
- (void)showContentView:(NSString *)view;

@end
