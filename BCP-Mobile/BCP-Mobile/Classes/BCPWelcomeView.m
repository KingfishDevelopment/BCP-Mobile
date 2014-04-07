//
//  BCPWelcomeView.m
//  BCP-Mobile
//
//  Created by Bryce Pauken on 4/6/14.
//  Copyright (c) 2014 Kingfish. All rights reserved.
//

#import "BCPWelcomeView.h"

@implementation BCPWelcomeView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *container = [[UIView alloc] init];
        [container setAutoresizingMask:UIViewAutoresizingFlexibleMargins];
        
        UILabel *topLabel = [[UILabel alloc] init];
        [topLabel setFont:[UIFont systemFontOfSize:24]];
        [topLabel setNumberOfLines:0];
        [topLabel setText:@"Welcome to\nBCP Mobile!"];
        [topLabel setTextAlignment:NSTextAlignmentCenter];
        CGSize topLabelSize = [BCPCommon sizeOfText:topLabel.text withFont:topLabel.font constrainedToWidth:BCP_WELCOME_CONTAINER_WIDTH];
        [topLabel setFrame:CGRectMake((BCP_WELCOME_CONTAINER_WIDTH-topLabelSize.width)/2, 0, topLabelSize.width, topLabelSize.height)];
        [container addSubview:topLabel];
        
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(BCP_WELCOME_CONTAINER_WIDTH/3, topLabel.frame.size.height+10, BCP_WELCOME_CONTAINER_WIDTH/3, BCP_WELCOME_CONTAINER_WIDTH/3)];
        [icon setImage:[UIImage imageNamed:@"IconLarge"]];
        [container addSubview:icon];
        
        UILabel *bottomLabel = [[UILabel alloc] init];
        [bottomLabel setFont:[UIFont systemFontOfSize:18]];
        [bottomLabel setNumberOfLines:0];
        [bottomLabel setText:@"Swipe to the right\n(or tap the button at the top)\nto get started."];
        [bottomLabel setTextAlignment:NSTextAlignmentCenter];
        CGSize bottomLabelSize = [BCPCommon sizeOfText:bottomLabel.text withFont:bottomLabel.font constrainedToWidth:BCP_WELCOME_CONTAINER_WIDTH];
        [bottomLabel setFrame:CGRectMake((BCP_WELCOME_CONTAINER_WIDTH-bottomLabelSize.width)/2, icon.frame.origin.y+icon.frame.size.height+10, bottomLabelSize.width, bottomLabelSize.height)];
        [container addSubview:bottomLabel];
        
        CGFloat containerHeight = topLabel.frame.size.height+icon.frame.size.height+bottomLabel.frame.size.height+20;
        [container setFrame:CGRectMake((self.frame.size.width-BCP_WELCOME_CONTAINER_WIDTH)/2, (self.frame.size.height-containerHeight)/2, BCP_WELCOME_CONTAINER_WIDTH, containerHeight)];
        [self addSubview:container];
        
        [self.navigationController setNavigationBarText:@"Welcome"];
    }
    return self;
}

@end
