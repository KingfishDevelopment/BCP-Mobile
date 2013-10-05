//
//  BCPData.h
//  BCP-Mobile
//
//  Created by Bryce Pauken on 10/3/13.
//  Copyright (c) 2013 Kingfish. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BCPData : NSObject

@property (nonatomic, retain) NSMutableDictionary *data;
@property (nonatomic, retain) NSString *path;

- (void)changeSetting:(NSString *)setting toValue:(id)value;
- (id)getSetting:(NSString *)setting;
- (void)setUnlockableValue:(double)value forName:(NSString *)name;
- (float)unlockableValueForName:(NSString *)name;

@end
