//
//  BCPAnnouncementsDetails.m
//  BCP-Mobile
//
//  Created by Bryce Pauken on 4/12/14.
//  Copyright (c) 2014 Kingfish. All rights reserved.
//

#import "BCPAnnouncementsDetails.h"

@implementation BCPAnnouncementsDetails

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor BCPOffWhiteColor]];
        
        self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        [self.scrollView setAutoresizingMask:UIViewAutoresizingFlexibleSize];
        [self addSubview:self.scrollView];
        
        for(int i=0;i<3;i++) {
            UILabel *label = [[UILabel alloc] init];
            [label setBackgroundColor:[UIColor BCPOffWhiteColor]];
            [label setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:i==0?24:18]];
            [label setNumberOfLines:0];
            [label setTextColor:i<2?[UIColor BCPOffBlackColor]:[UIColor BCPBlueColor]];
            if(i==0) {
                [self.scrollView addSubview:label];
                self.titleLabel = label;
            }
            else if(i==1) {
                [self.scrollView addSubview:label];
                self.descriptionLabel = label;
            }
            else {
                self.linkButton = [[UIButton alloc] init];
                [self.linkButton addTarget:self action:@selector(linkDown) forControlEvents:UIControlEventTouchDown|UIControlEventTouchDragEnter];
                [self.linkButton addTarget:self action:@selector(linkTapped) forControlEvents:UIControlEventTouchUpInside];
                [self.linkButton addTarget:self action:@selector(linkUp) forControlEvents:UIControlEventTouchCancel|UIControlEventTouchDragExit];
                [self.linkButton addSubview:label];
                [self.scrollView addSubview:self.linkButton];
                self.linkLabel = label;
            }
        }
    }
    return self;
}

- (void)layoutSubviews {
    CGRect lastLabelFrame = CGRectZero;
    
    CGSize titleSize = [BCPCommon sizeOfText:self.titleLabel.text withFont:self.titleLabel.font constrainedToWidth:self.bounds.size.width-20];
    [self.titleLabel setFrame:CGRectMake(10, lastLabelFrame.origin.y+lastLabelFrame.size.height+20, titleSize.width, titleSize.height)];
    lastLabelFrame = self.titleLabel.frame;
    
    if([self.descriptionLabel.text length]>0) {
        CGSize descriptionSize = [BCPCommon sizeOfText:self.descriptionLabel.text withFont:self.descriptionLabel.font constrainedToWidth:self.bounds.size.width-20];
        [self.descriptionLabel setFrame:CGRectMake(10, lastLabelFrame.origin.y+lastLabelFrame.size.height+20, descriptionSize.width, descriptionSize.height)];
        lastLabelFrame = self.descriptionLabel.frame;
    }
    
    if([self.linkLabel.text length]>0) {
        CGSize linkSize = [BCPCommon sizeOfText:self.linkLabel.text withFont:self.linkLabel.font constrainedToWidth:self.bounds.size.width-20];
        [self.linkButton setFrame:CGRectMake(10, lastLabelFrame.origin.y+lastLabelFrame.size.height+20, linkSize.width, linkSize.height)];
        lastLabelFrame = self.linkButton.frame;
        [self.linkLabel setFrame:self.linkButton.bounds];
    }
    
    [self.scrollView setContentSize:CGSizeMake(self.bounds.size.width, lastLabelFrame.origin.y+lastLabelFrame.size.height+20)];
}

- (void)linkDown {
    [self.linkLabel setBackgroundColor:[UIColor BCPMoreOffWhiteColor]];
}

- (void)linkTapped {
    [self linkUp];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.linkLabel.text]];
}

- (void)linkUp {
    [self.linkLabel setBackgroundColor:[UIColor BCPOffWhiteColor]];
}

- (void)setTitle:(NSString *)title withDescription:(NSString *)description withURL:(NSString *)url {
    [self.titleLabel setText:title];
    [self.descriptionLabel setText:description?description:@""];
    [self.linkLabel setText:url?url:@""];
    
    [self layoutSubviews];
}

@end
