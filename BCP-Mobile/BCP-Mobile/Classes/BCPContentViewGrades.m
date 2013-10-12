//
//  BCPContentViewGrades.m
//  BCP-Mobile
//
//  Created by Bryce Pauken on 10/6/13.
//  Copyright (c) 2013 Kingfish. All rights reserved.
//

#import "BCPContentViewGrades.h"

@implementation BCPContentViewGrades

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.tableViewController = [[BCPContentViewGradesViewController alloc] initWithDelegate:self];
        
        self.tableView = [[UITableView alloc] init];
        [self.tableView setBackgroundColor:[BCPCommon BLUE]];
        [self.tableView setContentInset:UIEdgeInsetsMake([BCPCommon NAVIGATION_BAR_HEIGHT], 0, 0, 0)];
        [self.tableView setDataSource:self.tableViewController];
        [self.tableView setDelegate:self.tableViewController];
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self addSubview:self.tableView];
        
        self.navigationBar = [[BCPNavigationBar alloc] init];
        [self.navigationBar setText:@"Grades"];
        [self addSubview:self.navigationBar];
        
        self.scrollView = [[UIScrollView alloc] init];
        [self.scrollView setBounces:NO];
        [self.scrollView setDelegate:self];
        [self.scrollView setPagingEnabled:YES];
        [self.scrollView setShowsHorizontalScrollIndicator:NO];
        [self.scrollView setUserInteractionEnabled:NO];
        [self addSubview:self.scrollView];
        
        self.tableViewDetailsController = [[BCPContentViewGradeDetailsViewController alloc] init];
        
        self.tableViewDetails = [[UITableView alloc] init];
        [self.tableViewDetails setBackgroundColor:[BCPCommon BLUE]];
        [self.tableViewDetails setContentInset:UIEdgeInsetsMake([BCPCommon NAVIGATION_BAR_HEIGHT], 0, 0, 0)];
        [self.tableViewDetails setDataSource:self.tableViewDetailsController];
        [self.tableViewDetails setDelegate:self.tableViewDetailsController];
        [self.tableViewDetails setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self.scrollView addSubview:self.tableViewDetails];
        
        self.navigationBarDetails = [[BCPNavigationBar alloc] init];
        [self.navigationBarDetails setText:@"Details"];
        [self.scrollView addSubview:self.navigationBarDetails];
        
        self.scrollViewShadow = [[UIImageView alloc] init];
        [self.scrollViewShadow setImage:[UIImage imageNamed:@"ShadowRight"]];
        [BCPImage registerView:self.scrollViewShadow withGetter:@"image" withSetter:@"setImage:" withImage:[UIImage imageNamed:@"ShadowRight"]];
        [self.scrollView addSubview:self.scrollViewShadow];
    }
    return self;
}

- (void)responseReturnedError:(BOOL)error {
    [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.scrollViewShadow setFrame:CGRectMake(self.frame.size.width-MAX(0,MIN([BCPCommon SHADOW_SIZE],self.scrollView.contentOffset.x)), 0, [BCPCommon SHADOW_SIZE], self.scrollView.frame.size.height)];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if(targetContentOffset->x==0) {
        [BCPCommon setInterfaceScrollViewEnabled:YES];
        [self.scrollView setUserInteractionEnabled:NO];
    }
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    [self.navigationBar setFrame:CGRectMake(0, 0, self.frame.size.width, [BCPCommon NAVIGATION_BAR_HEIGHT])];
    [self.navigationBarDetails setFrame:CGRectMake(self.frame.size.width, 0, self.frame.size.width, [BCPCommon NAVIGATION_BAR_HEIGHT])];
    [self.scrollView setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [self.scrollView setContentSize:CGSizeMake(self.frame.size.width*2, self.frame.size.height)];
    [self.tableView setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [self.tableViewDetails setFrame:CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height)];
    [self.scrollViewShadow setFrame:CGRectMake(self.frame.size.width-MAX(0,MIN([BCPCommon SHADOW_SIZE],self.scrollView.contentOffset.x)), 0, [BCPCommon SHADOW_SIZE], self.scrollView.frame.size.height)];
}

- (void)setHidden:(BOOL)hidden {
    [super setHidden:hidden];
    
    if(!hidden&&[BCPCommon loggedIn]&&!self.loaded) {
        self.loaded = true;
        [[BCPCommon data] sendRequest:@"grades" withDelegate:self];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.tableViewDetailsController.currentClass = [self.tableViewController.classes objectAtIndex:indexPath.row];
    
    self.tableViewDetails = [[UITableView alloc] init];
    [self.tableViewDetails setBackgroundColor:[BCPCommon BLUE]];
    [self.tableViewDetails setContentInset:UIEdgeInsetsMake([BCPCommon NAVIGATION_BAR_HEIGHT], 0, 0, 0)];
    [self.tableViewDetails setDataSource:self.tableViewDetailsController];
    [self.tableViewDetails setDelegate:self.tableViewDetailsController];
    [self.tableViewDetails setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.scrollView addSubview:self.tableViewDetails];
    [self.scrollView bringSubviewToFront:self.navigationBarDetails];
    [self.navigationBarDetails setText:[[self.tableViewController.classes objectAtIndex:indexPath.row] objectForKey:@"course"]];
    [self setFrame:self.frame];
    [UIView animateWithDuration:0.25 delay:0 options:0 animations:^ {
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width, 0)];
    } completion:^(BOOL finished) {
        [BCPCommon setInterfaceScrollViewEnabled:NO];
        [self.scrollView setUserInteractionEnabled:YES];
    }];
}

@end
