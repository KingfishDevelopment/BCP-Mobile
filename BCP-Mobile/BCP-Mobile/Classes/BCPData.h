//
//  BCPData.h
//  BCP-Mobile
//
//  Created by Bryce Pauken on 10/3/13.
//  Copyright (c) 2013 Kingfish. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BCPDelegates.h"
#import "SBJson.h"

@interface BCPData : NSObject

@property (nonatomic, retain) NSMutableDictionary *connectionResponses;
@property (nonatomic, retain) NSMutableDictionary *data;
@property (nonatomic, retain) SBJsonParser *parser;
@property (nonatomic, retain) NSString *path;

- (NSArray *)allKeys;
- (void)changeSetting:(NSString *)setting toValue:(id)value;
- (id)getSetting:(NSString *)setting;
- (NSData *)loadCellWithKey:(NSString *)key;
- (id)objectForKey:(id)aKey;
- (void)removeObjectForKey:(id)aKey;
- (void)saveCell:(NSData *)cell withKey:(NSString *)key saveDictionary:(BOOL)save;
- (void)sendRequest:(NSString *)requestString withDelegate:(NSObject<BCPDataDelegate> *)delegate;
- (void)sendRequest:(NSString *)requestString withDetails:(NSDictionary *)details withDelegate:(NSObject<BCPDataDelegate> *)delegate;
- (void)setObject:(id)anObject forKey:(id < NSCopying >)aKey;
- (void)setUnlockableValue:(double)value forName:(NSString *)name;
- (float)unlockableValueForName:(NSString *)name;

@end
