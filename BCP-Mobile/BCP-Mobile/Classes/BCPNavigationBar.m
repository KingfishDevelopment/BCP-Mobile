//
//  BCPNavigationBar.m
//  BCP-Mobile
//
//  Created by Bryce Pauken on 10/7/13.
//  Copyright (c) 2013 Kingfish. All rights reserved.
//

#import "BCPNavigationBar.h"

@implementation BCPNavigationBar

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[BCPCommon DARK_BLUE]];
        [self setClipsToBounds:NO];
        
        self.label = [[UILabel alloc] init];
        [self.label setTextAlignment:NSTextAlignmentCenter];
        [self.label setBackgroundColor:[UIColor clearColor]];
        [self.label setFont:[BCPFont boldSystemFontOfSize:20]];
        [self.label setTextColor:[BCPCommon INTRO_TEXT_COLOR]];
        [self.label setShadowColor:[BCPCommon INTRO_SHADOW_COLOR]];
        [self.label setShadowOffset:CGSizeMake(0,2)];
        [self addSubview:self.label];
        
        self.shadow = [[UIImageView alloc] init];
        [self.shadow setImage:[UIImage imageNamed:@"ShadowBelow"]];
        [BCPImage registerView:self.shadow withGetter:@"image" withSetter:@"setImage:" withImage:[UIImage imageNamed:@"ShadowRight"]];
        [self addSubview:self.shadow];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    [self.label setFrame:CGRectMake(0, 20, frame.size.width, frame.size.height-20)];
    [self.shadow setFrame:CGRectMake(0, frame.size.height, frame.size.width, 2)];
}

- (void)setText:(NSString *)text {
    [self.label setText:text];
}

@end
