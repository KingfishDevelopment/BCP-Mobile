//
//  BCPSidebarCell.m
//  BCP-Mobile
//
//  Created by Bryce Pauken on 4/5/14.
//  Copyright (c) 2014 Kingfish. All rights reserved.
//

#import "BCPSidebarCell.h"

@implementation BCPSidebarCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [[self contentView] setClipsToBounds:NO];
        [[[self contentView] superview] setClipsToBounds:NO];
        [self setBackgroundColor:[UIColor clearColor]];
        [self setClipsToBounds:NO];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        self.highlight = [[UIView alloc] initWithFrame:CGRectMake(-1000, 0, 4000, self.bounds.size.height)];
        [self.highlight setAlpha:0.2];
        [self.highlight setBackgroundColor:[UIColor whiteColor]];
        [self.highlight setHidden:YES];
        [self addSubview:self.highlight];
        
        self.divider = [[UIView alloc] initWithFrame:CGRectMake(BCP_SIDEBAR_CELL_PADDING, 0, self.bounds.size.width-BCP_SIDEBAR_CELL_PADDING*2, 1)];
        [self.divider setAlpha:0.1];
        [self.divider setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:self.divider];
        
        self.icon = [[UIImageView alloc] initWithFrame:CGRectMake(BCP_SIDEBAR_CELL_PADDING, BCP_SIDEBAR_CELL_PADDING, self.bounds.size.height-BCP_SIDEBAR_CELL_PADDING*2, self.bounds.size.height-BCP_SIDEBAR_CELL_PADDING*2)];
        [self addSubview:self.icon];
        
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(self.icon.bounds.size.width+BCP_SIDEBAR_CELL_PADDING*2, BCP_SIDEBAR_CELL_PADDING, self.bounds.size.width-self.icon.bounds.size.width+BCP_SIDEBAR_CELL_PADDING*3, self.bounds.size.height-BCP_SIDEBAR_CELL_PADDING*2)];
        [self.label setBackgroundColor:[UIColor clearColor]];
        [self.label setFont:[UIFont systemFontOfSize:16]];
        [self.label setOpaque:NO];
        [self.label setTextColor:[UIColor whiteColor]];
        [self addSubview:self.label];
    }
    return self;
}

- (void)setDividerHidden:(BOOL)hidden {
    [self.divider setHidden:hidden];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
}

- (void)setText:(NSString *)text {
    [self.label setText:text];
    UIImage *tabImage = [UIImage imageNamed:[@"Tab" stringByAppendingString:[text stringByReplacingOccurrencesOfString:@" " withString:@""]]];
    [self.icon setImage:tabImage];
}

- (void)setUserInteractionEnabled:(BOOL)userInteractionEnabled {
    [super setUserInteractionEnabled:userInteractionEnabled];
    [self.icon setAlpha:userInteractionEnabled?1:0.5];
    [self.label setAlpha:userInteractionEnabled?1:0.5];
}

@end
