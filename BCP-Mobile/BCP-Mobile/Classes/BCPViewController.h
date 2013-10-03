//
//  BCPViewController.h
//  BCP-Mobile
//
//  Created by Bryce Pauken on 10/2/13.
//  Copyright (c) 2013 Kingfish. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BCPInterface.h"

@interface BCPViewController : UIViewController <BCPViewControllerDelegate>

@property (nonatomic, unsafe_unretained) NSObject<BCPKeyboardDelegate> *keyboardDelegate;
@property (nonatomic, retain) BCPInterface *interface;

- (id)initWithFrame:(CGRect)frame;

@end
