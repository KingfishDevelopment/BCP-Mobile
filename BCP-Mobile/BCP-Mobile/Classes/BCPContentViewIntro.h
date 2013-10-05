//
//  BCPContentViewIntro.h
//  BCP-Mobile
//
//  Created by Bryce Pauken on 10/4/13.
//  Copyright (c) 2013 Kingfish. All rights reserved.
//

#import "BCPContentView.h"

@interface BCPContentViewIntro : BCPContentView <UIScrollViewDelegate>

@property (nonatomic, retain) UIImageView *codingIcon;
@property (nonatomic, retain) UILabel *codingLabel;
@property (nonatomic, retain) UIScrollView *descriptionScrollView;
@property (nonatomic, retain) UIView *descriptionScrollViewContainer;
@property (nonatomic, retain) UILabel *descriptionLabel;
@property (nonatomic, retain) UIImageView *finalIcon;
@property (nonatomic, retain) UILabel *finalIconLabel;
@property (nonatomic, retain) UIImageView *icon;
@property (nonatomic, retain) UILabel *iconLabel;
@property (nonatomic, retain) UIScrollView *scrollView;

@end
