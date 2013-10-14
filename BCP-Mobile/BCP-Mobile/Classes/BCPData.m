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
        
        self.parser = [[SBJsonParser alloc] init];
        self.connectionResponses = [[NSMutableDictionary alloc] init];
        
        if([self.data objectForKey:@"cells"]!=nil)
            [self.data removeObjectForKey:@"cells"];
    }
    return self;
}

- (NSArray *)allKeys {
    return [self.data allKeys];
}

- (void)changeSetting:(NSString *)setting toValue:(id)value {
    if([self.data objectForKey:@"settings"]==nil)
        [self.data setObject:[NSMutableDictionary dictionary] forKey:@"settings"];
    [[self.data objectForKey:@"settings"] setObject:value forKey:setting];
    [self saveDictionary];
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    if ([challenge previousFailureCount]==0) {
        id credentials = [[self.connectionResponses objectForKey:[NSValue valueWithNonretainedObject:connection]] objectForKey:@"credentials"];
        if(credentials == (id)[NSNull null])
            [[challenge sender] cancelAuthenticationChallenge:challenge];
        else {
            [[self.connectionResponses objectForKey:[NSValue valueWithNonretainedObject:connection]] setObject:@"INVALID_LOGIN" forKey:@"credentials"];
            [[challenge sender] useCredential:[NSURLCredential credentialWithUser:[credentials objectForKey:@"username"] password:[credentials objectForKey:@"password"] persistence:NSURLCredentialPersistenceNone] forAuthenticationChallenge:challenge];
        }
    }
    else {
        [[self.connectionResponses objectForKey:[NSValue valueWithNonretainedObject:connection]] setObject:@"INVALID_LOGIN" forKey:@"credentials"];
        [[challenge sender] cancelAuthenticationChallenge:challenge];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [[[self.connectionResponses objectForKey:[NSValue valueWithNonretainedObject:connection]] objectForKey:@"data"] appendData:data];
}

- (void)connection:(NSURLConnection*)connection didFailWithError:(NSError *)error {
    if([[[self.connectionResponses objectForKey:[NSValue valueWithNonretainedObject:connection]] objectForKey:@"credentials"] isEqual:@"INVALID_LOGIN"])
        [BCPCommon error:@"INVALID_LOGIN"];
    else
        [BCPCommon error:nil];
    [self.connectionResponses removeObjectForKey:[NSValue valueWithNonretainedObject:connection]];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [self parseResponse:[[NSString alloc] initWithData:[[self.connectionResponses objectForKey:[NSValue valueWithNonretainedObject:connection]] objectForKey:@"data"] encoding:NSUTF8StringEncoding] withDelegate:[[self.connectionResponses objectForKey:[NSValue valueWithNonretainedObject:connection]] objectForKey:@"delegate"] withRequest:[[self.connectionResponses objectForKey:[NSValue valueWithNonretainedObject:connection]] objectForKey:@"request"]];
    [self.connectionResponses removeObjectForKey:[NSValue valueWithNonretainedObject:connection]];
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

- (NSData *)loadCellWithKey:(NSString *)key {
    if([self.data objectForKey:@"cells"]==nil)
        [self.data setObject:[NSMutableDictionary dictionary] forKey:@"cells"];
    return [[self.data objectForKey:@"cells"] objectForKey:key];
}

- (id)objectForKey:(id)aKey {
    return [self.data objectForKey:aKey];
}

- (void)parseResponse:(NSString *)responseString withDelegate:(NSObject<BCPDataDelegate> *)delegate withRequest:(NSString *)request {
    id response = [self.parser objectWithString:responseString];
    if(response==nil) {
        [BCPCommon error:nil];
        [delegate responseReturnedError:YES];
    }
    else if([response objectForKey:@"error"]) {
        [BCPCommon error:[response objectForKey:@"error"]];
        [delegate responseReturnedError:YES];
    }
    else {
        [self.data setObject:response forKey:request];
        [self saveDictionary];
        [delegate responseReturnedError:NO];
    }
}

- (void)removeObjectForKey:(id)aKey {
    [self.data removeObjectForKey:aKey];
    [self saveDictionary];
}

- (void)saveCell:(NSData *)cell withKey:(NSString *)key {
    if([self.data objectForKey:@"cells"]==nil)
        [self.data setObject:[NSMutableDictionary dictionary] forKey:@"cells"];
    [[self.data objectForKey:@"cells"] setObject:cell forKey:key];
}

- (void)saveDictionary {
    [self.data writeToFile:self.path atomically:YES];
}

- (void)sendRequest:(NSString *)requestString withDelegate:(NSObject<BCPDataDelegate> *)delegate {
    [self sendRequest:requestString withDetails:nil withDelegate:delegate];
}

- (void)sendRequest:(NSString *)requestString withDetails:(NSDictionary *)details withDelegate:(NSObject<BCPDataDelegate> *)delegate {
    NSString *requestURL = @"https://";
    NSDictionary *credentials;
    if([details objectForKey:@"username"]&&[details objectForKey:@"password"]) {
        NSString *username = [details objectForKey:@"username"];
        NSString *password = [details objectForKey:@"password"];
        credentials = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:username,password,nil] forKeys:[NSArray arrayWithObjects:@"username",@"password",nil]];
    }
    else if([self objectForKey:@"login"]) {
        NSString *username = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)[[self objectForKey:@"login"] objectForKey:@"username"], NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8));
        NSString *password = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)[[self objectForKey:@"login"] objectForKey:@"encryptedPassword"], NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8));
        requestURL = [requestURL stringByAppendingString:[NSString stringWithFormat:@"%@:%@@",username,password]];
    }
    requestURL = [requestURL stringByAppendingString:[@"kingfi.sh/api/bcpmobile/v2/" stringByAppendingString:[requestString stringByAppendingString:@"#"]]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:requestURL]];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [self.connectionResponses setObject:[NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[NSMutableData data],delegate,(credentials?credentials:[NSNull null]),requestString,nil] forKeys:[NSArray arrayWithObjects:@"data",@"delegate",@"credentials",@"request",nil]] forKey:[NSValue valueWithNonretainedObject:connection]];
    [connection start];
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
    if([[self.data objectForKey:@"unlockables"] objectForKey:name]==nil) {
        [[self.data objectForKey:@"unlockables"] setObject:[NSNumber numberWithDouble:0] forKey:name];
        [self saveDictionary];
    }
    return [[[self.data objectForKey:@"unlockables"] objectForKey:name] floatValue];
}

@end
