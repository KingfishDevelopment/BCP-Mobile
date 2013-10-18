//
//  BCPContentViewAnnouncementsCell.m
//  BCP-Mobile
//
//  Created by Bryce Pauken on 10/17/13.
//  Copyright (c) 2013 Kingfish. All rights reserved.
//

#import "BCPContentViewAnnouncementsCell.h"

@implementation BCPContentViewAnnouncementsCell

+ (NSData *)drawCellWithFrame:(CGRect)frame withScale:(int)scale withAnnouncement:(NSString *)announcement withDivider:(BOOL)divider selected:(BOOL)selected {
    UIGraphicsBeginImageContextWithOptions(frame.size, YES, scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context,(selected?[BCPCommon TABLEVIEW_SELECTED_COLOR]:[BCPCommon TABLEVIEW_COLOR]).CGColor);
    CGContextFillRect(context, frame);
    
    if(divider) {
        CGContextSetStrokeColorWithColor(context, [BCPCommon TABLEVIEW_ACCENT_COLOR].CGColor);
        CGContextMoveToPoint(context, 0,0);
        CGContextAddLineToPoint(context, frame.size.width, 0);
        CGContextStrokePath(context);
    }
    
    CGContextSetFillColorWithColor(context, [BCPCommon TABLEVIEW_TEXT_COLOR].CGColor);
    
    CGSize labelAnnouncementSize = [announcement sizeWithFont:[BCPFont systemFontOfSize:18]];
    CGFloat announcementLabelWidth = frame.size.width-[BCPCommon TABLEVIEW_CELL_PADDING]*2;
    [announcement drawInRect:CGRectMake([BCPCommon TABLEVIEW_CELL_PADDING], (frame.size.height-labelAnnouncementSize.height)/2, announcementLabelWidth, labelAnnouncementSize.height) withFont:[BCPFont systemFontOfSize:18] lineBreakMode:NSLineBreakByTruncatingTail];
    
    CGSize labelAnnouncementSizeRestrained = [announcement sizeWithFont:[BCPFont systemFontOfSize:18] forWidth:announcementLabelWidth lineBreakMode:NSLineBreakByTruncatingTail];
    if(labelAnnouncementSize.width-labelAnnouncementSizeRestrained.width>1) {
        CGSize ellipsisSize = [@"..." sizeWithFont:[BCPFont systemFontOfSize:18]];
        
        CGFloat colors[8];
        
        CGColorRef color = (selected?[BCPCommon TABLEVIEW_SELECTED_COLOR]:[BCPCommon TABLEVIEW_COLOR]).CGColor;
        const CGFloat *colorComponents = CGColorGetComponents(color);
        if (CGColorGetNumberOfComponents(color) == 2) {
            for (int i=0; i<7; i++)
                colors[i] = colorComponents[0];
            colors[3] = 0;
            colors[7] = colorComponents[1];
        }
        else {
            for (int i=0; i<8; i++)
                colors[i] = colorComponents[i];
            colors[3] = 0;
        }
        
        CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
        CGGradientRef gradientRef = CGGradientCreateWithColorComponents(rgb, colors, NULL, sizeof(colors) / (sizeof(colors[0]) * 4));
        
        CGPoint start = CGPointMake([BCPCommon TABLEVIEW_CELL_PADDING]+labelAnnouncementSizeRestrained.width-ellipsisSize.width, 0);
        CGPoint end = CGPointMake([BCPCommon TABLEVIEW_CELL_PADDING]+labelAnnouncementSizeRestrained.width, 0);
        CGContextDrawLinearGradient(context, gradientRef, start, end, 0);
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return UIImagePNGRepresentation(image);
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    if(self.announcement)
        [self setTextWithAnnouncement:self.announcement withDivder:self.divider];
}

- (void)setTextWithAnnouncement:(NSString *)announcement withDivder:(BOOL)divider {
    self.announcement = announcement;
    self.divider = divider;
    if([BCPCommon IS_IPAD]&&self.frame.size.width==320)
        return;
    int scale = 1;
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] && [[UIScreen mainScreen] scale] == 2.0)
        scale = 2;
    self.view = [NSString stringWithFormat:@"%@%i%i%i%i",announcement,divider,(int)self.frame.size.width,[BCPCommon TABLEVIEW_CELL_HEIGHT],scale];
    if([[BCPCommon data] loadCellWithKey:self.view]==nil) {
        CGRect frame = CGRectMake(0, 0, self.frame.size.width, [BCPCommon TABLEVIEW_CELL_HEIGHT]);
        [[BCPCommon data] saveCell:[BCPContentViewAnnouncementsCell drawCellWithFrame:frame withScale:scale withAnnouncement:announcement withDivider:divider selected:NO] withKey:self.view];
        [[BCPCommon data] saveCell:[BCPContentViewAnnouncementsCell drawCellWithFrame:frame withScale:scale withAnnouncement:announcement withDivider:divider selected:YES] withKey:[self.view stringByAppendingString:@"selected"]];
        [[BCPCommon data] saveDictionary];
    }
    UIImage *backgroundView = [UIImage imageWithData:[[BCPCommon data] loadCellWithKey:self.view]];
    UIImage *selectedBackgroundView = [UIImage imageWithData:[[BCPCommon data] loadCellWithKey:[self.view stringByAppendingString:@"selected"]]];
    self.backgroundView = [[UIImageView alloc] initWithImage:backgroundView];
    self.selectedBackgroundView = [[UIImageView alloc] initWithImage:selectedBackgroundView];
}

@end
