//
//  BCPContentView.h
//  BCP-Mobile
//
//  Created by Bryce Pauken on 10/4/13.
//  Copyright (c) 2013 Kingfish. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BCPContentView : UIView <BCPKeyboardDelegate>

- (void)addShadowToView:(UIView *)view;
- (void)formatLabel:(UILabel *)label;

@end
