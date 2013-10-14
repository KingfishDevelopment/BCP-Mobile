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

- (void)preloadCells:(NSDictionary *)currentClass {
    NSIndexPath *indexPath = self.selectedPath;
    [((BCPContentViewGradesCell *)[self.tableView cellForRowAtIndexPath:indexPath]) performSelectorOnMainThread:@selector(showSpinner) withObject:nil waitUntilDone:NO];
    int sections = 0;
    if(currentClass!=nil&&[currentClass objectForKey:@"assignments"])
        sections++;
    if(currentClass!=nil&&[currentClass objectForKey:@"categories"])
        sections++;
    for(int section=0;section<sections;section++) {
        int rows = 0;
        if(section==0&&[currentClass objectForKey:@"assignments"]) {
            rows = [[currentClass objectForKey:@"assignments"] count];
        }
        else
            rows = [[currentClass objectForKey:@"categories"] count];
        for(int row=0;row<rows;row++) {
            if(![indexPath isEqual:self.selectedPath]) {
                [((BCPContentViewGradesCell *)[self.tableView cellForRowAtIndexPath:indexPath]) performSelectorOnMainThread:@selector(hideSpinner) withObject:nil waitUntilDone:NO];
                [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
                return;
            }
            NSString *title, *grade, *percent;
            if(section==0&&[currentClass objectForKey:@"assignments"]) {
                NSDictionary *section = [[currentClass objectForKey:@"assignments"] objectAtIndex:row];
                title = [section objectForKey:@"name"];
                grade = [section objectForKey:@"letter"];
                if([[section objectForKey:@"max"] floatValue]==0) {
                    if([section objectForKey:@"grade"]&&![[section objectForKey:@"grade"] isEqualToString:@""]&&[[section objectForKey:@"grade"] floatValue]!=0) {
                        percent = @"(NA)";
                    }
                    else {
                        grade = @"";
                        percent = @"";
                    }
                }
                else if([section objectForKey:@"grade"]&&![[section objectForKey:@"grade"] isEqualToString:@""])
                    percent = [NSString stringWithFormat:@"%.02f%%",[[section objectForKey:@"grade"] floatValue]*100/[[section objectForKey:@"max"] floatValue]];
                else
                    percent = @"";
            }
            else {
                NSDictionary *section = [[currentClass objectForKey:@"categories"] objectAtIndex:row];
                title = [section objectForKey:@"category"];
                grade = [section objectForKey:@"letter"];
                if([section objectForKey:@"percent"]&&![[section objectForKey:@"percent"] isEqualToString:@""])
                    percent = [[section objectForKey:@"percent"] stringByAppendingString:@"%"];
                else
                    percent = @"";
            }
            CGRect frame = CGRectMake(0, 0, self.frame.size.width, [BCPCommon TABLEVIEW_CELL_HEIGHT]);
            int scale = 1;
            if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] && [[UIScreen mainScreen] scale] == 2.0)
                scale = 2;
            if(grade==nil)
                grade = @"";
            if(percent==nil)
                percent = @"";
            NSString *key = [NSString stringWithFormat:@"%@%@%@%i%i%i%i",title,grade,percent,(row>0),(int)frame.size.width,[BCPCommon TABLEVIEW_CELL_HEIGHT],scale];
            if([[BCPCommon data] loadCellWithKey:key]==nil) {
                [[BCPCommon data] saveCell:[BCPContentViewGradesCell drawCellWithFrame:frame withScale:scale withTitle:title withGrade:grade withPercent:percent withDivider:(row>0) selected:NO] withKey:key];
                [[BCPCommon data] saveCell:[BCPContentViewGradesCell drawCellWithFrame:frame withScale:scale withTitle:title withGrade:grade withPercent:percent withDivider:(row>0) selected:YES] withKey:[key stringByAppendingString:@"selected"]];
            }
        }
    }
    [[BCPCommon data] saveDictionary];
    [self performSelectorOnMainThread:@selector(showDetails) withObject:nil waitUntilDone:NO];
}

- (void)responseReturnedError:(BOOL)error {
    [self performSelectorOnMainThread:@selector(showGrades) withObject:nil waitUntilDone:NO];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.scrollViewShadow setFrame:CGRectMake(self.frame.size.width-MAX(0,MIN([BCPCommon SHADOW_SIZE],self.scrollView.contentOffset.x)), 0, [BCPCommon SHADOW_SIZE], self.scrollView.frame.size.height)];
    if(scrollView.contentOffset.x==0) {
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

- (void)showDetails {
    [self.tableView deselectRowAtIndexPath:self.selectedPath animated:NO];
    [((BCPContentViewGradesCell *)[self.tableView cellForRowAtIndexPath:self.selectedPath]) performSelectorOnMainThread:@selector(hideSpinner) withObject:nil waitUntilDone:NO];
    
    self.tableViewDetails = [[UITableView alloc] init];
    [self.tableViewDetails setBackgroundColor:[BCPCommon BLUE]];
    [self.tableViewDetails setContentInset:UIEdgeInsetsMake([BCPCommon NAVIGATION_BAR_HEIGHT], 0, 0, 0)];
    [self.tableViewDetails setDataSource:self.tableViewDetailsController];
    [self.tableViewDetails setDelegate:self.tableViewDetailsController];
    [self.tableViewDetails setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.scrollView addSubview:self.tableViewDetails];
    [self.scrollView bringSubviewToFront:self.navigationBarDetails];
    [self setFrame:self.frame];
    [UIView animateWithDuration:0.25 delay:0 options:0 animations:^ {
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width, 0)];
    } completion:^(BOOL finished) {
        [BCPCommon setInterfaceScrollViewEnabled:NO];
        [self.scrollView setUserInteractionEnabled:YES];
    }];
}

- (void)showGrades {
    self.tableView = [[UITableView alloc] init];
    [self.tableView setBackgroundColor:[BCPCommon BLUE]];
    [self.tableView setContentInset:UIEdgeInsetsMake([BCPCommon NAVIGATION_BAR_HEIGHT], 0, 0, 0)];
    [self.tableView setDataSource:self.tableViewController];
    [self.tableView setDelegate:self.tableViewController];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self addSubview:self.tableView];
    [self bringSubviewToFront:self.navigationBar];
     [self bringSubviewToFront:self.scrollView];
    [self setFrame:self.frame];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedPath = indexPath;
    self.tableViewDetailsController.currentClass = [self.tableViewController.classes objectAtIndex:indexPath.row];
    [self performSelectorInBackground:@selector(preloadCells:) withObject:[self.tableViewController.classes objectAtIndex:indexPath.row]];
    [self.navigationBarDetails setText:[[self.tableViewController.classes objectAtIndex:indexPath.row] objectForKey:@"course"]];
}

@end
