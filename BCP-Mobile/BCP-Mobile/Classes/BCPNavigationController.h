//
//  BCPNavigationBarButtonController.h
//  BCP-Mobile
//
//  Created by Bryce Pauken on 4/6/14.
//  Copyright (c) 2014 Kingfish. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BCPNavigationController : NSObject

@property (nonatomic, retain) NSString *navigationBarText;
@property (nonatomic, retain) NSString *leftButtonImageName;
@property (nonatomic, copy) void (^leftButtonTapped)();
@property (nonatomic, retain) NSString *rightButtonImageName;
@property (nonatomic, copy) void (^rightButtonTapped)();

@end
