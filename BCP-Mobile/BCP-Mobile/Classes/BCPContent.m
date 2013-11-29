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
        [[self layer] setMasksToBounds:NO];
        [[self layer] setShadowOffset:CGSizeMake(0, 2)];
        [[self layer] setShadowOpacity:0.5];
        [[self layer] setShadowRadius:6];
        [self setBackgroundColor:[UIColor BCPOffWhite]];
        
        /*UIView *block = [[UIView alloc] initWithFrame:CGRectMake((self.bounds.size.width-50)/2, (self.bounds.size.height-50)/2, 50, 50)];
        [block setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin];
        [block setBackgroundColor:[UIColor blueColor]];
        [self addSubview:block];
        
        [BCPData sendRequest:@"login" withDetails:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"bryce.pauken14",@"nope",nil] forKeys:[NSArray arrayWithObjects:@"username",@"password",nil]] onCompletion:^(BOOL errorOccured) {
            
        }];*/
        
        self.views = [NSDictionary dictionaryWithObjectsAndKeys:[[BCPContentLogin alloc] initWithFrame:self.bounds],@"Login",nil];
        for(NSString *key in [self.views allKeys]) {
            [[self.views objectForKey:key] setHidden:YES];
            [self addSubview:[self.views objectForKey:key]];
        }
    }
    return self;
}

- (void)showContentView:(NSString *)view {
    for(NSString *key in [self.views allKeys]) {
        [[self.views objectForKey:key] setHidden:![key isEqualToString:view]];
        if([key isEqualToString:view]) {
            //[BCPCommon setKeyboardOwner:[self.views objectForKey:key]];
        }
    }
}

@end
