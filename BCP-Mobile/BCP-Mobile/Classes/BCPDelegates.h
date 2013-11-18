//
//  BCPDelegates.h
//  BCP-Mobile
//
//  Created by Bryce Pauken on 11/17/13.
//  Copyright (c) 2013 Kingfish. All rights reserved.
//

@protocol BCPViewControllerDelegate<NSObject>

- (void)registerViewForAfterRotation:(UIView *)view withBlock:(void (^)())block;
- (void)registerViewForBeforeAnimationRotation:(UIView *)view withBlock:(void (^)())block;
- (void)registerViewForBeforeRotation:(UIView *)view withBlock:(void (^)())block;

@end
