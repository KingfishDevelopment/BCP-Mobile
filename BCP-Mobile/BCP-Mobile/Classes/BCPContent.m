//
//  BCPContent.m
//  BCP-Mobile
//
//  Created by Bryce Pauken on 11/17/13.
//  Copyright (c) 2013 Kingfish. All rights reserved.
//

#import "BCPContent.h"

@implementation BCPContent

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor BCPOffWhite]];
        
        UIView *block = [[UIView alloc] initWithFrame:CGRectMake((self.bounds.size.width-50)/2, (self.bounds.size.height-50)/2, 50, 50)];
        [block setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin];
        [block setBackgroundColor:[UIColor blueColor]];
        [self addSubview:block];
        
        [BCPData sendRequest:@"login" withDetails:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"bryce.pauken14",@"nope",nil] forKeys:[NSArray arrayWithObjects:@"username",@"password",nil]] onCompletion:^(BOOL errorOccured) {
            
        }];
    }
    return self;
}

@end
