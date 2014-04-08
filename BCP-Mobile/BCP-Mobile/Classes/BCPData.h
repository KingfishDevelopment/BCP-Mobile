//
//  BCPData.h
//  BCP-Mobile
//
//  Created by Bryce Pauken on 4/7/14.
//  Copyright (c) 2014 Kingfish. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BCPData : NSObject

+ (NSMutableDictionary *)data;
+ (void)sendRequest:(NSString *)requestString onCompletion:(void (^)(NSString *error))completionBlock;
+ (void)sendRequest:(NSString *)requestString withDetails:(NSDictionary *)details onCompletion:(void (^)(NSString *error))completionBlock;

@end
