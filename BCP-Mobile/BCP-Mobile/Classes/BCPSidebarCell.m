//
//  BCPSidebarCell.m
//  BCP-Mobile
//
//  Created by Bryce Pauken on 11/23/13.
//  Copyright (c) 2013 Kingfish. All rights reserved.
//

#import "BCPSidebarCell.h"

@implementation BCPSidebarCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
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
        
        self.divider = [[UILabel alloc] initWithFrame:CGRectMake(SIDEBAR_CELL_PADDING, 0, self.bounds.size.width-SIDEBAR_CELL_PADDING*2, 1)];
        [self.divider setAlpha:0.1];
        [self.divider setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:self.divider];
        
        self.icon = [[UIImageView alloc] initWithFrame:CGRectMake(SIDEBAR_CELL_PADDING, SIDEBAR_CELL_PADDING, self.bounds.size.height-SIDEBAR_CELL_PADDING*2, self.bounds.size.height-SIDEBAR_CELL_PADDING*2)];
        [self addSubview:self.icon];
        
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(self.icon.bounds.size.width+SIDEBAR_CELL_PADDING*2, SIDEBAR_CELL_PADDING, self.bounds.size.width-self.icon.bounds.size.width+SIDEBAR_CELL_PADDING*3, self.bounds.size.height-SIDEBAR_CELL_PADDING*2)];
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
    if(highlighted!=self.highlighted) {
        [super setHighlighted:highlighted animated:animated];
        [self.highlight setHidden:!highlighted];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    if(selected!=self.selected) {
        [super setSelected:selected animated:animated];
        [self.highlight setHidden:!selected];
    }
}

- (void)setText:(NSString *)text {
    [self.label setText:text];
    UIImage *tabImage = [UIImage imageNamed:[@"Tab" stringByAppendingString:[text stringByReplacingOccurrencesOfString:@" " withString:@""]]];
    [self.icon setImage:tabImage];
}

@end
