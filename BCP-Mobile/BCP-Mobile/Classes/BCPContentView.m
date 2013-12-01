//
//  BCPContentView.m
//  BCP-Mobile
//
//  Created by Bryce Pauken on 11/28/13.
//  Copyright (c) 2013 Kingfish. All rights reserved.
//

#import "BCPContentView.h"

@implementation BCPContentView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
        [self setBackgroundColor:[UIColor BCPBlue]];
        [self setUserInteractionEnabled:YES];
        
        self.background = [[UIImageView alloc] initWithFrame:self.bounds];
        [self.background setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
        [self.background setImage:[UIImage imageNamed:@"PlainBackground"]];
        [self addSubview:self.background];
    }
    return self;
}

- (void)shown {
    
}

@end
