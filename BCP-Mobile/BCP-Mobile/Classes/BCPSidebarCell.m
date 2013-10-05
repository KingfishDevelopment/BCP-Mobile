//
//  BCPSidebarCell.m
//  BCP-Mobile
//
//  Created by Bryce Pauken on 10/2/13.
//  Copyright (c) 2013 Kingfish. All rights reserved.
//

#import "BCPSidebarCell.h"

@implementation BCPSidebarCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBackgroundColor:[BCPCommon SIDEBAR_COLOR]];
        
        self.divider = [[UIView alloc] init];
        [self.divider setBackgroundColor:[BCPCommon SIDEBAR_ACCENT_COLOR]];
        [self addSubview:self.divider];
        
        self.icon = [[UIImageView alloc] init];
        [BCPImage registerView:self.icon withGetter:@"image" withSetter:@"setImage:" withImage:nil];
        [self addSubview:self.icon];
        
        self.label = [[UILabel alloc] init];
        [self.label setBackgroundColor:[UIColor clearColor]];
        [self.label setFont:[BCPFont boldSystemFontOfSize:18]];
        [self.label setTextColor:[BCPCommon SIDEBAR_TEXT_COLOR]];
        [self addSubview:self.label];
        
        self.disabledOverlay = [[UIView alloc] init];
        [self.disabledOverlay setAlpha:0];
        [self.disabledOverlay setBackgroundColor:[BCPCommon SIDEBAR_DISABLED_COLOR]];
        [self addSubview:self.disabledOverlay];
        
        [self setFrame:self.frame];
    }
    return self;
}

- (void)setDividerHidden:(BOOL)hidden {
    [self.divider setHidden:hidden];
}

- (void)setEnabled:(BOOL)enabled {
    [self setUserInteractionEnabled:enabled];
    [self.disabledOverlay setAlpha:enabled?0:[BCPCommon SIDEBAR_DISABLED_ALPHA]];
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    [self.divider setFrame:CGRectMake(0, 0, frame.size.width, 1)];
    [self.icon setFrame:CGRectMake([BCPCommon SIDEBAR_CELL_PADDING], [BCPCommon SIDEBAR_CELL_PADDING], frame.size.height-([BCPCommon SIDEBAR_CELL_PADDING]*2), frame.size.height-([BCPCommon SIDEBAR_CELL_PADDING]*2))];
    [self.label setFrame:CGRectMake(self.icon.frame.size.width+[BCPCommon SIDEBAR_CELL_PADDING]*2, [BCPCommon SIDEBAR_CELL_PADDING], frame.size.width-self.icon.frame.size.width-[BCPCommon SIDEBAR_CELL_PADDING], frame.size.height-([BCPCommon SIDEBAR_CELL_PADDING]*2))];
    [self.disabledOverlay setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
}

- (void)setLabelText:(NSString *)text {
    [self.label setText:text];
    UIImage *tabImage = [UIImage imageNamed:[@"Tab" stringByAppendingString:[text stringByReplacingOccurrencesOfString:@" " withString:@""]]];
    [self.icon setImage:tabImage];
    [BCPImage registerView:self.icon withGetter:@"image" withSetter:@"setImage:" withImage:tabImage];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [self setBackgroundColor:(highlighted?[BCPCommon SIDEBAR_SELECTED_COLOR]:[BCPCommon SIDEBAR_COLOR])];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [self setBackgroundColor:(selected?[BCPCommon SIDEBAR_SELECTED_COLOR]:[BCPCommon SIDEBAR_COLOR])];
}

@end
