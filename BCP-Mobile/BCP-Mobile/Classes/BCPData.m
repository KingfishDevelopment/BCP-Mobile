//
//  BCPData.m
//  BCP-Mobile
//
//  Created by Bryce Pauken on 11/23/13.
//  Copyright (c) 2013 Kingfish. All rights reserved.
//

#import "BCPData.h"

@implementation BCPData

static NSMutableDictionary *connectionResponses;
static NSMutableDictionary *data = nil;
static NSString *path = nil;

+ (void)initialize {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    path = [documentsDirectory stringByAppendingPathComponent:@"data"];
    
    if(false&&[[NSFileManager defaultManager] fileExistsAtPath:path]) {
        @try {
            data = [NSKeyedUnarchiver unarchiveObjectWithData:[NSData dataWithContentsOfFile:path]];
        }
        @catch (NSException *exception) {
            data = [NSMutableDictionary dictionary];
        }
    }
    else
        data = [NSMutableDictionary dictionary];
    
    connectionResponses = [[NSMutableDictionary alloc] init];
}

+ (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    if ([challenge previousFailureCount]==0) {
        id credentials = [[connectionResponses objectForKey:[NSValue valueWithNonretainedObject:connection]] objectForKey:@"credentials"];
        if(credentials == (id)[NSNull null])
            if([data objectForKey:@"login"]) {
                [[connectionResponses objectForKey:[NSValue valueWithNonretainedObject:connection]] setObject:@"INVALID_LOGIN" forKey:@"credentials"];
                [[challenge sender] useCredential:[NSURLCredential credentialWithUser:[[data objectForKey:@"login"] objectForKey:@"username"] password:[[data objectForKey:@"login"] objectForKey:@"encryptedPassword"] persistence:NSURLCredentialPersistenceNone] forAuthenticationChallenge:challenge];
            }
            else
                [[challenge sender] cancelAuthenticationChallenge:challenge];
            else {
                [[connectionResponses objectForKey:[NSValue valueWithNonretainedObject:connection]] setObject:@"INVALID_LOGIN" forKey:@"credentials"];
                [[challenge sender] useCredential:[NSURLCredential credentialWithUser:[credentials objectForKey:@"username"] password:[credentials objectForKey:@"password"] persistence:NSURLCredentialPersistenceNone] forAuthenticationChallenge:challenge];
            }
    }
    else {
        [[connectionResponses objectForKey:[NSValue valueWithNonretainedObject:connection]] setObject:@"INVALID_LOGIN" forKey:@"credentials"];
        [[challenge sender] cancelAuthenticationChallenge:challenge];
    }
}

+ (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [[[connectionResponses objectForKey:[NSValue valueWithNonretainedObject:connection]] objectForKey:@"data"] appendData:data];
}

+ (void)connection:(NSURLConnection*)connection didFailWithError:(NSError *)error {
    if([[[connectionResponses objectForKey:[NSValue valueWithNonretainedObject:connection]] objectForKey:@"credentials"] isEqual:@"INVALID_LOGIN"])
        [[BCPCommon viewController] errorWithMessage:@"INVALID_LOGIN"];
    else
        [[BCPCommon viewController] errorWithCode:1454];
    [connectionResponses removeObjectForKey:[NSValue valueWithNonretainedObject:connection]];
}

+ (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [self parseResponse:[[connectionResponses objectForKey:[NSValue valueWithNonretainedObject:connection]] objectForKey:@"data"] withCompletionBlock:[[connectionResponses objectForKey:[NSValue valueWithNonretainedObject:connection]] objectForKey:@"completionBlock"] withRequest:[[connectionResponses objectForKey:[NSValue valueWithNonretainedObject:connection]] objectForKey:@"request"]];
    [connectionResponses removeObjectForKey:[NSValue valueWithNonretainedObject:connection]];
}

+ (NSMutableDictionary *)data {
    return data;
}

+ (void)parseResponse:(NSData *)responseString withCompletionBlock:(void (^)(BOOL errorOccurred))completionBlock withRequest:(NSString *)request {
    NSError *e = nil;
    id response = [NSJSONSerialization JSONObjectWithData:responseString options:NSJSONReadingMutableContainers error:&e];
    if(response==nil) {
        [[BCPCommon viewController] errorWithCode:8179];
        completionBlock(YES);
    }
    else if([response respondsToSelector:@selector(objectForKey:)]&&[response objectForKey:@"error"]) {
        [[BCPCommon viewController] errorWithMessage:[response objectForKey:@"error"]];
        completionBlock(YES);
    }
    else {
        [data setObject:response forKey:request];
        [self saveDictionary];
        completionBlock(NO);
    }
}

+ (void)saveDictionary {
    NSData *writeData = [NSKeyedArchiver archivedDataWithRootObject:data];
    [writeData writeToFile:path atomically:YES];
}

+ (void)sendRequest:(NSString *)requestString onCompletion:(void (^)(BOOL errorOccurred))completionBlock {
    [self sendRequest:requestString withDetails:nil onCompletion:completionBlock];
}

+ (void)sendRequest:(NSString *)requestString withDetails:(NSDictionary *)details onCompletion:(void (^)(BOOL errorOccurred))completionBlock {
    NSString *requestURL = @"https://";
    NSDictionary *credentials;
    if([details objectForKey:@"username"]&&[details objectForKey:@"password"]) {
        NSString *username = [details objectForKey:@"username"];
        NSString *password = [details objectForKey:@"password"];
        credentials = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:username,password,nil] forKeys:[NSArray arrayWithObjects:@"username",@"password",nil]];
    }
    requestURL = [requestURL stringByAppendingString:[@"kingfi.sh/api/bcpmobile/v2/" stringByAppendingString:[requestString stringByAppendingString:@"#"]]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:requestURL]];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connectionResponses setObject:[NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[NSMutableData data],completionBlock,(credentials?credentials:[NSNull null]),requestString,nil] forKeys:[NSArray arrayWithObjects:@"data",@"completionBlock",@"credentials",@"request",nil]] forKey:[NSValue valueWithNonretainedObject:connection]];
    [connection start];
}

@end
