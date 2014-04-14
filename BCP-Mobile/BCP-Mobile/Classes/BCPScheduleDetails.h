//
//  BCPGradesDetails.h
//  BCP-Mobile
//
//  Created by Bryce Pauken on 4/13/14.
//  Copyright (c) 2014 Kingfish. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BCPScheduleDetails : UIView

@property (nonatomic, retain) NSMutableArray *labels;
@property (nonatomic, retain) UIScrollView *scrollView;

- (void)setTitle:(NSString *)title withDetails:(NSArray *)details;

@end
