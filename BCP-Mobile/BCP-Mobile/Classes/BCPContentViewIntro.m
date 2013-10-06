//
//  BCPContentViewIntro.m
//  BCP-Mobile
//
//  Created by Bryce Pauken on 10/4/13.
//  Copyright (c) 2013 Kingfish. All rights reserved.
//

#import "QuartzCore/CALayer.h"
#import "BCPContentViewIntro.h"

@implementation BCPContentViewIntro

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.scrollView = [[UIScrollView alloc] init];
        [self.scrollView setBounces:NO];
        [self.scrollView setDelegate:self];
        [self.scrollView setPagingEnabled:YES];
        [self.scrollView setShowsVerticalScrollIndicator:NO];
        [self addSubview:self.scrollView];
        
        self.icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"RoundedIcon"]];
        [BCPImage registerView:self.icon withGetter:@"image" withSetter:@"setImage:" withImage:[UIImage imageNamed:@"RoundedIcon"]];
        [self addShadowToView:self.icon];
        [self addSubview:self.icon];
        
        self.iconLabel = [[UILabel alloc] init];
        [self.iconLabel setText:@"Welcome to BCP Mobile!\r\n\r\nSwipe Left to Continue."];
        [self formatLabel:self.iconLabel];
        [self.scrollView addSubview:self.iconLabel];
        
        self.descriptionScrollViewContainer = [[UIView alloc] init];
        [self.descriptionScrollViewContainer setAlpha:0];
        [self addShadowToView:self.descriptionScrollViewContainer];
        [self addSubview:self.descriptionScrollViewContainer];
        
        self.descriptionScrollView = [[UIScrollView alloc] init];
        [self.descriptionScrollView setBackgroundColor:[BCPCommon SIDEBAR_COLOR]];
        [self.descriptionScrollView setShowsVerticalScrollIndicator:NO];
        [self.descriptionScrollView setScrollEnabled:NO];
        NSArray *descriptionIcons = [NSArray arrayWithObjects:@"Grades",@"Email",@"Schedule",@"Planner",@"CSP Hours",@"Announcements",@"News",@"Calendar",@"Sports Results",nil];
        [self.descriptionScrollView setContentSize:CGSizeMake([descriptionIcons count]*2*([BCPCommon INTRO_DESCRIPTION_ICON_SIZE]+10), [BCPCommon INTRO_DESCRIPTION_ICON_SIZE])];
        for(int i=0;i<[descriptionIcons count]*2;i++) {
            int iconIndex=i%[descriptionIcons count];
            UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(([BCPCommon INTRO_DESCRIPTION_ICON_SIZE]+10)*i, 0, [BCPCommon INTRO_DESCRIPTION_ICON_SIZE], [BCPCommon INTRO_DESCRIPTION_ICON_SIZE])];
            UIImage *iconImage = [UIImage imageNamed:[@"Tab" stringByAppendingString:[[descriptionIcons objectAtIndex:iconIndex] stringByReplacingOccurrencesOfString:@" " withString:@""]]];
            [iconView setImage:iconImage];
            [BCPImage registerView:iconView withGetter:@"image" withSetter:@"setImage:" withImage:iconImage];
            [self.descriptionScrollView addSubview:iconView];
        }
        [self.descriptionScrollViewContainer addSubview:self.descriptionScrollView];
        [self scrollDescriptionScrollView];
        
        self.descriptionLabel = [[UILabel alloc] init];
        [self.descriptionLabel setText:@"BCP Mobile lets you check your school grades, announcements, news, and more."];
        [self formatLabel:self.descriptionLabel];
        [self.scrollView addSubview:self.descriptionLabel];
        
        self.codingIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CodingIcon"]];
        [BCPImage registerView:self.codingIcon withGetter:@"image" withSetter:@"setImage:" withImage:[UIImage imageNamed:@"CodingIcon"]];
        [self addShadowToView:self.codingIcon];
        [self addSubview:self.codingIcon];
        
        self.codingLabel = [[UILabel alloc] init];
        [self.codingIcon setAlpha:0];
        [self.codingLabel setText:@"BCP Mobile is made by Bellarmine students. It's completely open source, so if you want to help out, you can get started right now!\r\n\r\n(This also means questions should be sent to the developers, not Bellarmine!)"];
        [self formatLabel:self.codingLabel];
        [self.scrollView addSubview:self.codingLabel];
        
        self.finalIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"RoundedIcon"]];
        [BCPImage registerView:self.finalIcon withGetter:@"image" withSetter:@"setImage:" withImage:[UIImage imageNamed:@"RoundedIcon"]];
        [self addShadowToView:self.finalIcon];
        [self addSubview:self.finalIcon];
        
        self.finalIconLabel = [[UILabel alloc] init];
        [self.finalIconLabel setText:[([BCPCommon IS_IPAD]?@"Look to the Left":@"Swipe Right") stringByAppendingString:@" to Get Started!" ]];
        [self formatLabel:self.finalIconLabel];
        [self.scrollView addSubview:self.finalIconLabel];
        
        if(![BCPCommon IS_IPAD])
            [BCPCommon setInterfaceScrollViewEnabled:NO];
    }
    return self;
}

- (void)scrollDescriptionScrollView {
    [self.descriptionScrollView setContentOffset:CGPointMake(0, 0)];
    [UIView animateWithDuration:[self.descriptionScrollView tag]*(self.descriptionScrollView.contentSize.width/([BCPCommon INTRO_DESCRIPTION_ICON_SIZE]+10)) delay:0 options:UIViewAnimationOptionCurveLinear animations:^ {
        [self.descriptionScrollView setContentOffset:CGPointMake(self.descriptionScrollView.contentSize.width/2, 0)];
    } completion:^(BOOL finished) {
        [self.descriptionScrollView setTag:1];
        [self scrollDescriptionScrollView];
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if([scrollView isEqual:self.scrollView]) {
        [self.icon setAlpha:ABS(ABS((MAX(scrollView.frame.size.width*0,MIN(scrollView.frame.size.width*1,scrollView.contentOffset.x))/scrollView.frame.size.width)-0)-1)];
        [self.descriptionScrollViewContainer setAlpha:ABS(ABS((MAX(scrollView.frame.size.width*0,MIN(scrollView.frame.size.width*2,scrollView.contentOffset.x))/scrollView.frame.size.width)-1)-1)];
        [self.codingIcon setAlpha:ABS(ABS((MAX(scrollView.frame.size.width*1,MIN(scrollView.frame.size.width*3,scrollView.contentOffset.x))/scrollView.frame.size.width)-2)-1)];
        [self.finalIcon setAlpha:ABS(ABS((MAX(scrollView.frame.size.width*2,MIN(scrollView.frame.size.width*4,scrollView.contentOffset.x))/scrollView.frame.size.width)-3)-1)];
        if(scrollView.contentOffset.x>=scrollView.frame.size.width*3&&![BCPCommon IS_IPAD]) {
            [scrollView setScrollEnabled:NO];
            [BCPCommon setInterfaceScrollViewEnabled:YES];
        }
    }
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    [self.scrollView setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [self.scrollView setContentSize:CGSizeMake(self.frame.size.width*4, self.frame.size.height)];
    
    [self.icon setFrame:CGRectMake((frame.size.width-[BCPCommon INTRO_ICON_SIZE])/2, frame.size.height/2-[BCPCommon INTRO_ICON_SIZE]-[BCPCommon CONTENT_MIDDLE_PADDING], [BCPCommon INTRO_ICON_SIZE], [BCPCommon INTRO_ICON_SIZE])];
    CGSize iconLabelSize = [self.iconLabel.text sizeWithFont:[self.iconLabel font] constrainedToSize:CGSizeMake(frame.size.width-[BCPCommon CONTENT_SIDE_PADDING]*2, 10000) lineBreakMode:self.iconLabel.lineBreakMode];
    [self.iconLabel setFrame:CGRectMake([BCPCommon CONTENT_SIDE_PADDING], frame.size.height/2+[BCPCommon CONTENT_MIDDLE_PADDING], frame.size.width-[BCPCommon CONTENT_SIDE_PADDING]*2, iconLabelSize.height)];
    
    [self.descriptionScrollViewContainer setFrame:CGRectMake([BCPCommon CONTENT_SIDE_PADDING], frame.size.height/2-[BCPCommon INTRO_DESCRIPTION_ICON_SIZE]-[BCPCommon CONTENT_MIDDLE_PADDING], frame.size.width-[BCPCommon CONTENT_SIDE_PADDING]*2, [BCPCommon INTRO_DESCRIPTION_ICON_SIZE])];
    [self.descriptionScrollView setFrame:CGRectMake(0, 0, frame.size.width-[BCPCommon CONTENT_SIDE_PADDING]*2, [BCPCommon INTRO_DESCRIPTION_ICON_SIZE])];
    CGSize descriptionLabelSize = [self.descriptionLabel.text sizeWithFont:[self.descriptionLabel font] constrainedToSize:CGSizeMake(frame.size.width-[BCPCommon CONTENT_SIDE_PADDING]*2, 10000) lineBreakMode:self.descriptionLabel.lineBreakMode];
    [self.descriptionLabel setFrame:CGRectMake(frame.size.width+[BCPCommon CONTENT_SIDE_PADDING], frame.size.height/2+[BCPCommon CONTENT_MIDDLE_PADDING], frame.size.width-[BCPCommon CONTENT_SIDE_PADDING]*2, descriptionLabelSize.height)];

    [self.codingIcon setFrame:CGRectMake((frame.size.width-[BCPCommon INTRO_ICON_SIZE])/2, frame.size.height/2-[BCPCommon INTRO_ICON_SIZE]-[BCPCommon CONTENT_MIDDLE_PADDING], [BCPCommon INTRO_ICON_SIZE], [BCPCommon INTRO_ICON_SIZE])];
    CGSize codingLabelSize = [self.codingLabel.text sizeWithFont:[self.codingLabel font] constrainedToSize:CGSizeMake(frame.size.width-[BCPCommon CONTENT_SIDE_PADDING]*2, 10000) lineBreakMode:self.codingLabel.lineBreakMode];
    [self.codingLabel setFrame:CGRectMake(frame.size.width*2+[BCPCommon CONTENT_SIDE_PADDING], frame.size.height/2+[BCPCommon CONTENT_MIDDLE_PADDING], frame.size.width-[BCPCommon CONTENT_SIDE_PADDING]*2, codingLabelSize.height)];

    [self.finalIcon setFrame:CGRectMake((frame.size.width-[BCPCommon INTRO_ICON_SIZE])/2, frame.size.height/2-[BCPCommon INTRO_ICON_SIZE]-[BCPCommon CONTENT_MIDDLE_PADDING], [BCPCommon INTRO_ICON_SIZE], [BCPCommon INTRO_ICON_SIZE])];
    CGSize finalIconLabelSize = [self.finalIconLabel.text sizeWithFont:[self.finalIconLabel font] constrainedToSize:CGSizeMake(frame.size.width-[BCPCommon CONTENT_SIDE_PADDING]*2, 10000) lineBreakMode:self.finalIconLabel.lineBreakMode];
    [self.finalIconLabel setFrame:CGRectMake(frame.size.width*3+[BCPCommon CONTENT_SIDE_PADDING], frame.size.height/2+[BCPCommon CONTENT_MIDDLE_PADDING], frame.size.width-[BCPCommon CONTENT_SIDE_PADDING]*2, finalIconLabelSize.height)];
}

@end
