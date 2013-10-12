//
//  BCPImage.m
//  BCP-Mobile
//
//  Created by Bryce Pauken on 10/3/13.
//  Copyright (c) 2013 Kingfish. All rights reserved.
//

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

#import "BCPImage.h"

static NSMutableArray *views = nil;

@implementation BCPImage

+ (void)initialize {
    views = [NSMutableArray array];
}

+ (UIImage *)adjustImage:(UIImage *)image toHue:(CGFloat)hueAdjust {
    return image;
    CIImage *inputImage = [[CIImage alloc] initWithImage:image];
    CIFilter * controlsFilter = [CIFilter filterWithName:@"CIHueAdjust"];
    [controlsFilter setValue:inputImage forKey:kCIInputImageKey];
    
    [controlsFilter setValue:[NSNumber numberWithFloat:hueAdjust] forKey:@"inputAngle"];
    
    CIImage *displayImage = controlsFilter.outputImage;
    UIImage *finalImage = [UIImage imageWithCIImage:displayImage];
    CIContext *context = [CIContext contextWithOptions:nil];
    if (displayImage == nil || finalImage == nil)
        return  image;
    else {
        CGImageRef cgImage = [context createCGImage:displayImage fromRect:displayImage.extent];
        UIImage *returnImage = [UIImage imageWithCGImage:cgImage];
        CGImageRelease(cgImage);
        return returnImage;
    }
}

+ (void)registerView:(UIView *)view withGetter:(NSString *)getter withSetter:(NSString *)setter withImage:(UIImage *)image {
    bool containsView = false;
    for(NSMutableDictionary *dictionary in views)
        if([[dictionary objectForKey:@"view"] isEqual:view]) {
            containsView = true;
            [dictionary setObject:image forKey:@"image"];
            break;
        }
    if(!containsView)
        [views addObject:[NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:view,getter,setter,(image==nil?[NSNull null]:image),nil] forKeys:[NSArray arrayWithObjects:@"view",@"getter",@"setter",@"image",nil]]];
}

+ (void)updateImages {
    for(NSDictionary *view in views) {
        UIImage *newImage = [self adjustImage:[view objectForKey:@"image"] toHue:[[[BCPCommon data] getSetting:@"hue"] floatValue]];
        [[view objectForKey:@"view"] performSelector:NSSelectorFromString([view objectForKey:@"setter"]) withObject:newImage];
    }
}

@end

#pragma clang diagnostic pop
