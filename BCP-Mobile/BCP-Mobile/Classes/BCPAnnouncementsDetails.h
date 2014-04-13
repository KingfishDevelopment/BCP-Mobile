//
//  BCPAnnouncementsDetails.h
//  BCP-Mobile
//
//  Created by Bryce Pauken on 4/12/14.
//  Copyright (c) 2014 Kingfish. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BCPAnnouncementsDetails : UIView

@property (nonatomic, retain) UILabel *descriptionLabel;
@property (nonatomic, retain) UIButton *linkButton;
@property (nonatomic, retain) UILabel *linkLabel;
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) UILabel *titleLabel;

- (void)setTitle:(NSString *)title withDescription:(NSString *)description withURL:(NSString *)url;

@end
