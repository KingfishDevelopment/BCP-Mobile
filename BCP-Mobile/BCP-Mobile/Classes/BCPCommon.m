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

+ (int)tableViewPadding {
    return [BCPCommon isIPad]?20:10;
}

+ (void)setViewController:(NSObject<BCPViewControllerDelegate> *)newViewController {
    viewController = newViewController;
}

+ (CGSize)sizeOfText:(NSString *)text withFont:(UIFont *)font {
    return [BCPCommon sizeOfText:text withFont:font constrainedToWidth:MAXFLOAT singleLine:NO];
}

+ (CGSize)sizeOfText:(NSString *)text withFont:(UIFont *)font constrainedToWidth:(CGFloat)width {
    return [BCPCommon sizeOfText:text withFont:font constrainedToWidth:width singleLine:NO];
}

+ (CGSize)sizeOfText:(NSString *)text withFont:(UIFont *)font constrainedToWidth:(CGFloat)width singleLine:(BOOL)singleLine {
    if([BCPCommon isIOS7]) {
        CGRect labelRect;
        if(singleLine) {
            labelRect = [text boundingRectWithSize:CGSizeMake(width, 1) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName:font} context:nil];
        }
        else {
            labelRect = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
        }
        labelRect.size.width = ceil(labelRect.size.width);
        labelRect.size.height = ceil(labelRect.size.height);
        return labelRect.size;
    }
    else {
        if(singleLine) {
            return [text sizeWithFont:font forWidth:width lineBreakMode:NSLineBreakByWordWrapping];
        }
        else {
            return [text sizeWithFont:font constrainedToSize:CGSizeMake(width, MAXFLOAT)];
        }
    }
}

+ (CGSize)sizeOfText:(NSString *)text withFont:(UIFont *)font singleLine:(BOOL)singleLine {
    return [BCPCommon sizeOfText:text withFont:font constrainedToWidth:MAXFLOAT singleLine:singleLine];
}

+ (NSObject<BCPViewControllerDelegate> *)viewController {
    return viewController;
}

@end
