//
//  BCPCommon.m
//  BCP-Mobile
//
//  Created by Bryce Pauken on 4/5/14.
//  Copyright (c) 2014 Kingfish. All rights reserved.
//

#import "BCPCommon.h"

@implementation BCPCommon

static NSObject<BCPViewControllerDelegate> *viewController = nil;

+ (BOOL)isIOS7 {
    return ([[[UIDevice currentDevice] systemVersion] compare:@"7" options:NSNumericSearch] != NSOrderedAscending);
}

+ (BOOL)isIPad {
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
}

+ (void)setViewController:(NSObject<BCPViewControllerDelegate> *)newViewController {
    viewController = newViewController;
}

+ (CGSize)sizeOfText:(NSString *)text withFont:(UIFont *)font {
    return [BCPCommon sizeOfText:text withFont:font constrainedToWidth:MAXFLOAT];
}

+ (CGSize)sizeOfText:(NSString *)text withFont:(UIFont *)font constrainedToWidth:(CGFloat)width {
    if([BCPCommon isIOS7]) {
        CGRect labelRect = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
        labelRect.size.width = ceil(labelRect.size.width);
        labelRect.size.height = ceil(labelRect.size.height);
        return labelRect.size;
    }
    else {
        return [text sizeWithFont:font constrainedToSize:CGSizeMake(width, MAXFLOAT)];
    }
}

+ (NSObject<BCPViewControllerDelegate> *)viewController {
    return viewController;
}

@end
