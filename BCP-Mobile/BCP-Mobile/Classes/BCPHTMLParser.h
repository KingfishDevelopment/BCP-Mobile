//
//  BCPHTMLParser.h
//  BCP-Mobile
//
//  Created by Bryce Pauken on 4/10/14.
//  Copyright (c) 2014 Kingfish. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BCPHTMLParser : NSObject <NSXMLParserDelegate>

@property (nonatomic, retain) NSMutableString *resultString;

+ (id)parser;
- (NSString *)parseString:(NSString *)string;

@end
