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

@property (nonatomic, retain) BCPInterface *interface;
@property (nonatomic, retain) NSMutableArray *registeredAfterBlocks;
@property (nonatomic, retain) NSMutableArray *registeredBeforeAnimationBlocks;
@property (nonatomic, retain) NSMutableArray *registeredBeforeBlocks;

@end
