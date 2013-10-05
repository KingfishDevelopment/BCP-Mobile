//
//  BCPColor.m
//  BCP-Mobile
//
//  Created by Bryce Pauken on 10/3/13.
//  Copyright (c) 2013 Kingfish. All rights reserved.
//

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

#import "BCPColor.h"

static NSMutableArray *views = nil;

@implementation BCPColor

+ (void)initialize {
    views = [NSMutableArray array];
}

+ (UIColor *)colorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha {
    UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
    return [self shiftColor:color toHue:[[[BCPCommon data] getSetting:@"hue"] floatValue]];
}

+ (UIColor *)colorWithWhite:(CGFloat)white alpha:(CGFloat)alpha {
    UIColor *color = [UIColor colorWithWhite:white alpha:alpha];
    return [self shiftColor:color toHue:[[[BCPCommon data] getSetting:@"hue"] floatValue]];
}

+ (UIColor *)getRGBAsFromImage:(UIImage*)image atX:(int)xx andY:(int)yy count:(int)count {
    CGImageRef imageRef = [image CGImage];
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char *rawData = (unsigned char*) calloc(height * width * 4, sizeof(unsigned char));
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData, width, height,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(context);
    
    unsigned long byteIndex = (bytesPerRow * yy) + xx * bytesPerPixel;
    for (int ii = 0 ; ii < count ; ++ii)
    {
        CGFloat red   = (rawData[byteIndex]     * 1.0) / 255.0;
        CGFloat green = (rawData[byteIndex + 1] * 1.0) / 255.0;
        CGFloat blue  = (rawData[byteIndex + 2] * 1.0) / 255.0;
        CGFloat alpha = (rawData[byteIndex + 3] * 1.0) / 255.0;
        byteIndex += 4;
        
        UIColor *acolor = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
        free(rawData);
        return acolor;
    }
    return nil;
}

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIColor *)shiftColor:(UIColor *)color toHue:(CGFloat)hueAdjust {
    UIImage *pixel = [self imageWithColor:color];
    CIImage *inputImage = [[CIImage alloc] initWithImage:pixel];
    CIFilter * controlsFilter = [CIFilter filterWithName:@"CIHueAdjust"];
    [controlsFilter setValue:inputImage forKey:kCIInputImageKey];
    
    [controlsFilter setValue:[NSNumber numberWithFloat:hueAdjust] forKey:@"inputAngle"];
    
    CIImage *displayImage = controlsFilter.outputImage;
    UIImage *finalImage = [UIImage imageWithCIImage:displayImage];
    
    CIContext *context = [CIContext contextWithOptions:nil];
    UIImage *image;
    if (displayImage == nil || finalImage == nil)
        image = pixel;
    else
        image = [UIImage imageWithCGImage:[context createCGImage:displayImage fromRect:displayImage.extent]];
    
    return [self getRGBAsFromImage:image atX:0 andY:0 count:1];
}

+ (void)registerView:(UIView *)view withGetter:(NSString *)getter withSetter:(NSString *)setter {
    UIColor *currentColor = [view performSelector:NSSelectorFromString(getter)];
    [views addObject:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:view,getter,setter,currentColor,nil] forKeys:[NSArray arrayWithObjects:@"view",@"getter",@"setter",@"color",nil]]];
}

+ (void)updateColors {
    for(NSDictionary *view in views) {
        UIColor *newColor = [self shiftColor:[view objectForKey:@"color"] toHue:[[[BCPCommon data] getSetting:@"hue"] floatValue]];
        [[view objectForKey:@"view"] performSelector:NSSelectorFromString([view objectForKey:@"setter"]) withObject:newColor];
    }
}

@end

#pragma clang diagnostic pop
