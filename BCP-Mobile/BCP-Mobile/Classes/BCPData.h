//
//  BCPData.h
//  BCP-Mobile
//
//  Created by Bryce Pauken on 11/23/13.
//  Copyright (c) 2013 Kingfish. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BCPData : NSObject

+ (NSMutableDictionary *)data;
+ (void)sendRequest:(NSString *)requestString onCompletion:(void (^)(BOOL errorOccurred))completionBlock;
+ (void)sendRequest:(NSString *)requestString withDetails:(NSDictionary *)details onCompletion:(void (^)(BOOL errorOccurred))completionBlock;

@end
