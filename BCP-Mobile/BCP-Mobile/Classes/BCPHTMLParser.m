//
//  BCPHTMLParser.m
//  BCP-Mobile
//
//  Created by Bryce Pauken on 4/10/14.
//  Copyright (c) 2014 Kingfish. All rights reserved.
//

#import "BCPHTMLParser.h"

@implementation BCPHTMLParser

+ (id)parser {
    return [[BCPHTMLParser alloc] init];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)s {
    [self.resultString appendString:s];
}

- (NSString *)parseString:(NSString *)string {
    self.resultString = [[NSMutableString alloc] init];
    if(string == nil) {
        return string;
    }
    NSString* xmlStr = [NSString stringWithFormat:@"<d>%@</d>",[string stringByReplacingOccurrencesOfString:@"& " withString:@"&amp; "]];
    NSData *data = [xmlStr dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSXMLParser* xmlParse = [[NSXMLParser alloc] initWithData:data];
    [xmlParse setDelegate:self];
    [xmlParse parse];
    return [NSString stringWithFormat:@"%@",self.resultString];
}

@end
