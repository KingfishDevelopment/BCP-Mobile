//
//  BCPGradesDetails.h
//  BCP-Mobile
//
//  Created by Bryce Pauken on 4/10/14.
//  Copyright (c) 2014 Kingfish. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BCPGradesDetails : UIView

@property (nonatomic, retain) NSMutableArray *labels;

- (void)setTitle:(NSString *)title withDetails:(NSArray *)details;

@end
