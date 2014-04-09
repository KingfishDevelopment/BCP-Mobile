//
//  BCPData.m
//  BCP-Mobile
//
//  Created by Bryce Pauken on 4/7/14.
//  Copyright (c) 2014 Kingfish. All rights reserved.
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
    
    if([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        @try {
            data = [NSKeyedUnarchiver unarchiveObjectWithData:[NSData dataWithContentsOfFile:path]];
        }
        @catch (NSException *exception) {
            data = [NSMutableDictionary dictionary];
        }
    }
    else {
        data = [NSMutableDictionary dictionary];
    }
    connectionResponses = [[NSMutableDictionary alloc] init];
}

+ (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    if([challenge previousFailureCount]==0) {
        id credentials = [[connectionResponses objectForKey:[NSValue valueWithNonretainedObject:connection]] objectForKey:@"credentials"];
        if(credentials == (id)[NSNull null])
            if([data objectForKey:@"login"]) {
                [[connectionResponses objectForKey:[NSValue valueWithNonretainedObject:connection]] setObject:@"INVALID_LOGIN" forKey:@"credentials"];
                [[challenge sender] useCredential:[NSURLCredential credentialWithUser:[[data objectForKey:@"login"] objectForKey:@"username"] password:[[data objectForKey:@"login"] objectForKey:@"encryptedPassword"] persistence:NSURLCredentialPersistenceNone] forAuthenticationChallenge:challenge];
            }
            else {
                [[challenge sender] cancelAuthenticationChallenge:challenge];
            }
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
    void (^completionBlock)(NSString *error) = [connectionResponses objectForKey:[NSValue valueWithNonretainedObject:connection]];
    if([[[connectionResponses objectForKey:[NSValue valueWithNonretainedObject:connection]] objectForKey:@"credentials"] isEqual:@"INVALID_LOGIN"]) {
        completionBlock(@"Unauthorized");
    }
    else {
        completionBlock(@"Fatal");
    }
    
    [connectionResponses removeObjectForKey:[NSValue valueWithNonretainedObject:connection]];
}

+ (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [self parseResponse:[[connectionResponses objectForKey:[NSValue valueWithNonretainedObject:connection]] objectForKey:@"data"] withCompletionBlock:[[connectionResponses objectForKey:[NSValue valueWithNonretainedObject:connection]] objectForKey:@"completionBlock"] withRequest:[[connectionResponses objectForKey:[NSValue valueWithNonretainedObject:connection]] objectForKey:@"request"]];
    [connectionResponses removeObjectForKey:[NSValue valueWithNonretainedObject:connection]];
}

+ (NSMutableDictionary *)data {
    return data;
}

+ (void)deleteData {
    NSString *lastView = [data objectForKey:@"lastView"];
    data = [NSMutableDictionary dictionary];
    if(lastView) {
        [data setObject:lastView forKey:@"lastView"];
    }
    [self saveDictionary];
}

+ (void)parseResponse:(NSData *)responseString withCompletionBlock:(void (^)(NSString *error))completionBlock withRequest:(NSString *)request {
    NSError *e = nil;
    id response = [NSJSONSerialization JSONObjectWithData:responseString options:NSJSONReadingMutableContainers error:&e];
    if(response==nil) {
        completionBlock(@"Fatal");
    }
    else if([response respondsToSelector:@selector(objectForKey:)]&&[response objectForKey:@"error"]) {
        completionBlock([response objectForKey:@"error"]);
    }
    else {
        [data setObject:response forKey:request];
        [self saveDictionary];
        completionBlock(nil);
    }
}

+ (void)saveDictionary {
    NSData *writeData = [NSKeyedArchiver archivedDataWithRootObject:data];
    [writeData writeToFile:path atomically:YES];
}

+ (void)sendRequest:(NSString *)requestString onCompletion:(void (^)(NSString *error))completionBlock {
    [self sendRequest:requestString withDetails:nil onCompletion:completionBlock];
}

+ (void)sendRequest:(NSString *)requestString withDetails:(NSDictionary *)details onCompletion:(void (^)(NSString *error))completionBlock {
    NSString *requestURL = @"https://";
    NSDictionary *credentials;
    if(details&&[details objectForKey:@"username"]&&[details objectForKey:@"password"]) {
        NSString *username = [details objectForKey:@"username"];
        NSString *password = [details objectForKey:@"password"];
        credentials = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:username,password,nil] forKeys:[NSArray arrayWithObjects:@"username",@"password",nil]];
    }
    requestURL = [requestURL stringByAppendingString:[@"kingfi.sh/api/bellarmine/v2/" stringByAppendingString:[requestString stringByAppendingString:@"#"]]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestURL]];
    if(!credentials&&details&&[details count]>0) {
        [request setHTTPMethod:@"POST"];
        NSMutableString *postFields = [NSMutableString string];
        BOOL firstKey = YES;
        for(NSString *key in [details allKeys]) {
            [postFields appendFormat:@"%@%@=%@",firstKey?@"":@"&",[key stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"],[[details objectForKey:key] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
            firstKey = NO;
        }
        [request setHTTPBody:[postFields dataUsingEncoding:NSUTF8StringEncoding]];
    }
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    void (^completionBlockCopy)(NSString *error) = [completionBlock copy];
    NSMutableDictionary *newConnection = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSMutableData data],@"data",completionBlockCopy,@"completionBlock",(credentials?credentials:[NSNull null]),@"credentials",requestString,@"request",nil];
    [connectionResponses setObject:newConnection forKey:[NSValue valueWithNonretainedObject:connection]];
    [connection start];
}


@end
