//
//  BCPViewController.h
//  BCP-Mobile
//
//  Created by Bryce Pauken on 11/17/13.
//  Copyright (c) 2013 Kingfish. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BCPInterface.h"

@interface BCPViewController : UIViewController <BCPViewControllerDelegate>

typedef void (^RotationBlock)(void);
typedef void (^KeyboardBlock)(void);

@property (nonatomic, strong) BCPInterface *interface;
@property (nonatomic, copy) KeyboardBlock keyboardShown;
@property (nonatomic, copy) KeyboardBlock keyboardHidden;
@property (nonatomic, strong) NSMutableArray *registeredAfterBlocks;
@property (nonatomic, strong) NSMutableArray *registeredBeforeAnimationBlocks;
@property (nonatomic, strong) NSMutableArray *registeredBeforeBlocks;

@end
