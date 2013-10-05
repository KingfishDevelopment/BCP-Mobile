//
//  BCPImage.h
//  BCP-Mobile
//
//  Created by Bryce Pauken on 10/3/13.
//  Copyright (c) 2013 Kingfish. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BCPImage : NSObject

@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain) NSString *name;

+ (void)registerView:(UIView *)view withGetter:(NSString *)getter withSetter:(NSString *)setter withImage:(UIImage *)image;
+ (void)updateImages;

@end
