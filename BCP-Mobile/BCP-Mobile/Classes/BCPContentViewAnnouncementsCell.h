//
//  BCPContentViewAnnouncementsCell.h
//  BCP-Mobile
//
//  Created by Bryce Pauken on 10/17/13.
//  Copyright (c) 2013 Kingfish. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BCPContentViewAnnouncementsCell : UITableViewCell

@property (nonatomic, retain) NSString *announcement;
@property (nonatomic) BOOL divider;
@property (nonatomic, retain) NSString *view;

+ (NSData *)drawCellWithFrame:(CGRect)frame withScale:(int)scale withAnnouncement:(NSString *)announcement withDivider:(BOOL)divider selected:(BOOL)selected;
- (void)setTextWithAnnouncement:(NSString *)announcement withDivder:(BOOL)divider;

@end
