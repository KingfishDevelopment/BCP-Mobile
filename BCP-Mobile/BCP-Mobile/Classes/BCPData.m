//
//  BCPData.m
//  BCP-Mobile
//
//  Created by Bryce Pauken on 10/3/13.
//  Copyright (c) 2013 Kingfish. All rights reserved.
//

#import "BCPData.h"

@implementation BCPData

- (id)init {
    self = [super init];
    if(self) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        self.path = [documentsDirectory stringByAppendingPathComponent:@"data"];
        
        if([[NSFileManager defaultManager] fileExistsAtPath:self.path])
            self.data = [NSMutableDictionary dictionaryWithContentsOfFile:self.path];
        else
            self.data = [NSMutableDictionary dictionary];
        [self setUnlockableValue:1 forName:@"Just Getting Started"];
        [self changeSetting:@"hue" toValue:[NSNumber numberWithFloat:0]];
    }
    return self;
}

- (void)changeSetting:(NSString *)setting toValue:(id)value {
    if([self.data objectForKey:@"settings"]==nil)
        [self.data setObject:[NSMutableDictionary dictionary] forKey:@"settings"];
    [[self.data objectForKey:@"settings"] setObject:value forKey:setting];
    [self saveDictionary];
}

- (id)getSetting:(NSString *)setting {
    if([self.data objectForKey:@"settings"]==nil)
        [self.data setObject:[NSMutableDictionary dictionary] forKey:@"settings"];
    if([[self.data objectForKey:@"settings"] objectForKey:setting]==nil) {
        if([setting isEqualToString:@"hue"])
            [self changeSetting:setting toValue:[NSNumber numberWithFloat:0]];
    }
    return [[self.data objectForKey:@"settings"] objectForKey:setting];
}

- (id)objectForKey:(id)aKey {
    return [self.data objectForKey:aKey];
}

- (void)removeObjectForKey:(id)aKey {
    [self.data removeObjectForKey:aKey];
    [self saveDictionary];
}

- (void)saveDictionary {
    [self.data writeToFile:self.path atomically:YES];
}

- (void)setObject:(id)anObject forKey:(id < NSCopying >)aKey {
    [self.data setObject:anObject forKeyedSubscript:aKey];
    [self saveDictionary];
}

- (void)setUnlockableValue:(double)value forName:(NSString *)name {
    [self unlockableValueForName:name];
    [[self.data objectForKey:@"unlockables"] setObject:[NSNumber numberWithDouble:value] forKey:name];
    [self saveDictionary];
}

- (float)unlockableValueForName:(NSString *)name {
    if([self.data objectForKey:@"unlockables"]==nil)
        [self.data setObject:[NSMutableDictionary dictionary] forKey:@"unlockables"];
    if([[self.data objectForKey:@"unlockables"] objectForKey:name]==nil)
        [[self.data objectForKey:@"unlockables"] setObject:[NSNumber numberWithDouble:0] forKey:name];
    [self saveDictionary];
    return [[[self.data objectForKey:@"unlockables"] objectForKey:name] floatValue];
}

@end
