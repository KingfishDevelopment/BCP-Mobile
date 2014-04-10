//
//  BCPGradesView.m
//  BCP-Mobile
//
//  Created by Bryce Pauken on 4/8/14.
//  Copyright (c) 2014 Kingfish. All rights reserved.
//

#import "BCPGradesView.h"

#import "BCPGradesCell.h"

@implementation BCPGradesView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.firstLoadCompleted = NO;
        __unsafe_unretained typeof(self) weakSelf = self;
        
        self.scrollViews = [[NSMutableArray alloc] init];
        for(int i=0;i<3;i++) {
            UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:i<2?self.bounds:CGRectMake(0, self.bounds.size.height, self.bounds.size.width, self.bounds.size.height)];
            if(i>0) {
                [scrollView setDecelerationRate:UIScrollViewDecelerationRateFast];
                [scrollView setDelegate:self];
            }
            [scrollView setBounces:NO];
            [scrollView setPagingEnabled:i==0];
            [scrollView setScrollEnabled:NO];
            [scrollView setShowsHorizontalScrollIndicator:NO];
            [scrollView setShowsVerticalScrollIndicator:NO];
            [scrollView setTag:i==0?[self currentSemester]*3:0];
            [self.scrollViews addObject:scrollView];
            if(i==0) {
                [self addSubview:scrollView];
            }
            else {
                [[self.scrollViews objectAtIndex:0] addSubview:scrollView];
            }
        }
        
        self.tableViews = [[NSMutableArray alloc] init];
        for(int i=0;i<4;i++) {
            UITableView *tableView = [[UITableView alloc] init];
            [tableView setBackgroundColor:[UIColor BCPOffWhiteColor]];
            [tableView setDataSource:self];
            [tableView setDelegate:self];
            [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
            [tableView setTag:i];
            [[self.scrollViews objectAtIndex:i/2+1] addSubview:tableView];
            [self.tableViews addObject:tableView];
            
            UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 0)];
            [header setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
            [tableView setTableHeaderView:header];
            
            UIView *divider = [[UIView alloc] initWithFrame:CGRectMake(0, -1, tableView.bounds.size.width, 1)];
            [divider setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
            [divider setBackgroundColor:[UIColor BCPLightGrayColor]];
            [header addSubview:divider];
        }
        
        self.dividers = [[NSMutableArray alloc] init];
        for(int i=0;i<5;i++) {
            UIView *divider = [[UIView alloc] init];
            [divider setBackgroundColor:[UIColor BCPLightGrayColor]];
            [[self.scrollViews objectAtIndex:i==0?0:(i-1)/2+1] addSubview:divider];
            [self.dividers addObject:divider];
        }
        
        [self setNeedsLayout];
        
        [self.navigationController setNavigationBarText:[NSString stringWithFormat:@"Grades (Semester %i)",[self currentSemester]+1]];
        self.navigationController.rightButtonImageName = [self currentSemester]==0?@"ArrowDown":@"ArrowUp";
        self.navigationController.rightButtonTapped = ^{
            [weakSelf changeSemester];
        };
    }
    return self;
}

- (void)changeSemester {
    int newSemester = [self currentSemester]==0?1:0;
    [[BCPData data] setObject:[NSNumber numberWithInt:newSemester] forKey:@"lastGradesSemester"];
    [BCPData saveDictionary];
    [self.navigationController setNavigationBarText:[NSString stringWithFormat:@"Grades (Semester %i)",newSemester+1]];
    self.navigationController.rightButtonImageName = newSemester==0?@"ArrowDown":@"ArrowUp";
    [self updateNavigation];
    [[self.scrollViews objectAtIndex:0] setTag:newSemester*3];
    [UIView animateWithDuration:BCP_TRANSITION_DURATION animations:^{
        [self layoutSubviews];
    }];
}

- (int)currentSemester {
    if(![[BCPData data] objectForKey:@"lastGradesSemester"]) {
        NSDate *date = [NSDate date];
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *components = [calendar components:NSMonthCalendarUnit fromDate:date];
        [[BCPData data] setObject:[NSNumber numberWithInt:[components month]>=7?0:1] forKey:@"lastGradesSemester"];
        [BCPData saveDictionary];
    }
    return [[[BCPData data] objectForKey:@"lastGradesSemester"] intValue];
}

- (void)layoutSubviews {
    for(int i=0;i<3;i++) {
        [[self.scrollViews objectAtIndex:i] setFrame:i<2?self.bounds:CGRectMake(0, self.bounds.size.height, self.bounds.size.width, self.bounds.size.height)];
        if(i==0) {
            [[self.scrollViews objectAtIndex:i] setContentSize:CGSizeMake(self.bounds.size.width, self.bounds.size.height*2+1)];
        }
        else {
            [[self.scrollViews objectAtIndex:i] setContentSize:CGSizeMake(MAX(0,(self.bounds.size.width+1)*(self.selectedDetail?3:2)-1), self.bounds.size.height)];
        }
    }
    for(int i=0;i<[self.tableViews count];i++) {
        [[self.tableViews objectAtIndex:i] setFrame:CGRectMake((self.bounds.size.width+1)*(i%2), 0, self.bounds.size.width, self.bounds.size.height)];
    }
    for(int i=0;i<[self.dividers count];i++) {
        [[self.dividers objectAtIndex:i] setFrame:CGRectMake(i==0?0:self.bounds.size.width*((i-1)%2+1)+(i%2==1?0:1), i==0?self.bounds.size.height:0, i==0?self.bounds.size.width*2+1:1, i==0?1:self.bounds.size.height)];
    }
    for(UIScrollView *scrollView in self.scrollViews) {
        [scrollView setContentOffset:CGPointMake((scrollView.bounds.size.width+1)*(scrollView.tag%3), (scrollView.bounds.size.height+1)*(scrollView.tag/3))];
    }
}

- (void)loadGrades {
    [BCPData sendRequest:@"grades" withDetails:[NSDictionary dictionaryWithObjectsAndKeys:[[[BCPData data] objectForKey:@"login"] objectForKey:@"token"],@"token",nil] onCompletion:^(NSString *error) {
        if(!error&&[[BCPData data] objectForKey:@"grades"]) {
            for(int i=0;i<[self.tableViews count];i++) {
                [[self.tableViews objectAtIndex:i] performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
            }
        }
        else {
            NSLog(@"error: %@",error);
        }
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(tableView.tag%2==0) {
        if([[BCPData data] objectForKey:@"grades"]&&[[[BCPData data] objectForKey:@"grades"] objectForKey:[NSString stringWithFormat:@"semester%i",[self currentSemester]+1]]) {
            return 1;
        }
    }
    else if(self.selectedCourse) {
        int numberOfCateories = 0;
        if([self.selectedCourse objectForKey:@"assignments"]) {
            numberOfCateories++;
        }
        if([self.selectedCourse objectForKey:@"categories"]) {
            numberOfCateories++;
        }
        return numberOfCateories;
    }
    return 0;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if(scrollView.contentOffset.x>0) {
        NSUInteger currentIndex = (NSUInteger)(scrollView.contentOffset.x / scrollView.bounds.size.width + 0.5f);
        if(!decelerate) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [scrollView setContentOffset:CGPointMake(currentIndex*(self.frame.size.width+1), 0) animated:YES];
            });
        }
        if(currentIndex==0&&scrollView.tag>0) {
            __unsafe_unretained typeof(self) weakSelf = self;
            [self.navigationController setNavigationBarText:[NSString stringWithFormat:@"Grades (Semester %i)",[weakSelf currentSemester]+1]];
            self.navigationController.leftButtonImageName = @"Sidebar";
            self.navigationController.leftButtonTapped = ^{
                [[BCPCommon viewController] showSideBar];
            };
            self.navigationController.rightButtonImageName = [self currentSemester]==0?@"ArrowDown":@"ArrowUp";
            self.navigationController.rightButtonTapped = ^{
                [weakSelf changeSemester];
            };
            [self updateNavigation];
            [[self.scrollViews objectAtIndex:[self currentSemester]+1] setScrollEnabled:NO];
            [[self.scrollViews objectAtIndex:[self currentSemester]+1] setTag:0];
            [UIView animateWithDuration:BCP_TRANSITION_DURATION animations:^{
                [self layoutSubviews];
            }];
        }
        else if(currentIndex>0&&scrollView.tag>1) {
            [[self.scrollViews objectAtIndex:[self currentSemester]+1] setTag:1];
        }
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    NSUInteger nearestIndex = (NSUInteger)(targetContentOffset->x / scrollView.bounds.size.width + 0.5f);
    nearestIndex = MAX(MIN(nearestIndex, 1), 0);
    CGFloat xOffset = nearestIndex * scrollView.bounds.size.width;
    xOffset = xOffset==0?1:xOffset;
    if(velocity.x!=0&&nearestIndex==0&&scrollView.tag>0) {
        *targetContentOffset = CGPointMake(0, targetContentOffset->y);
        dispatch_async(dispatch_get_main_queue(), ^{
            [scrollView setContentOffset:CGPointMake(0, targetContentOffset->y) animated:YES];
        });
        __unsafe_unretained typeof(self) weakSelf = self;
        [self.navigationController setNavigationBarText:[NSString stringWithFormat:@"Grades (Semester %i)",[weakSelf currentSemester]+1]];
        self.navigationController.leftButtonImageName = @"Sidebar";
        self.navigationController.leftButtonTapped = ^{
            [[BCPCommon viewController] showSideBar];
        };
        self.navigationController.rightButtonImageName = [self currentSemester]==0?@"ArrowDown":@"ArrowUp";
        self.navigationController.rightButtonTapped = ^{
            [weakSelf changeSemester];
        };
        [self updateNavigation];
        [[self.scrollViews objectAtIndex:[self currentSemester]+1] setScrollEnabled:NO];
        [[self.scrollViews objectAtIndex:[self currentSemester]+1] setTag:0];
        [UIView animateWithDuration:BCP_TRANSITION_DURATION animations:^{
            [self layoutSubviews];
        }];
    }
    else if(nearestIndex>0) {
        *targetContentOffset = CGPointMake((scrollView.bounds.size.width+1)*nearestIndex, targetContentOffset->y);
        dispatch_async(dispatch_get_main_queue(), ^{
            [scrollView setContentOffset:CGPointMake((scrollView.bounds.size.width+1)*nearestIndex, targetContentOffset->y) animated:YES];
        });
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(scrollView.contentOffset.x==scrollView.bounds.size.width+1) {
        self.selectedDetail = nil;
        [self layoutSubviews];
    }
}

- (void)setHidden:(BOOL)hidden {
    [super setHidden:hidden];
    if(!hidden&&!self.firstLoadCompleted) {
        [self loadGrades];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BCPGradesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GradesCell"];
    if (cell == nil) {
        cell = [[BCPGradesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"GradesCell"];
    }
    if(tableView.tag%2==0) {
        NSMutableDictionary *course = [[[[BCPData data] objectForKey:@"grades"] objectForKey:[NSString stringWithFormat:@"semester%i",((int)tableView.tag/2)+1]] objectAtIndex:indexPath.row];
        if(course) {
            [cell setUserInteractionEnabled:[course objectForKey:@"letter"]&&[[course objectForKey:@"letter"] length]>0];
            [cell setTitle:[course objectForKey:@"course"] withGrade:[course objectForKey:@"letter"]];
        }
    }
    else if(self.selectedCourse) {
        if(indexPath.section==0&&[self.selectedCourse objectForKey:@"assignments"]) {
            [cell setTitle:[[[self.selectedCourse objectForKey:@"assignments"] objectAtIndex:indexPath.row] objectForKey:@"name"] withGrade:[[[self.selectedCourse objectForKey:@"assignments"] objectAtIndex:indexPath.row] objectForKey:@"letter"]];
        }
        else if([self.selectedCourse objectForKey:@"categories"]) {
            [cell setTitle:[[[self.selectedCourse objectForKey:@"categories"] objectAtIndex:indexPath.row] objectForKey:@"category"] withGrade:[[[self.selectedCourse objectForKey:@"categories"] objectAtIndex:indexPath.row] objectForKey:@"letter"]];
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView.tag%2==0) {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        self.selectedCourse = [[[[BCPData data] objectForKey:@"grades"] objectForKey:[NSString stringWithFormat:@"semester%i",((int)tableView.tag/2)+1]] objectAtIndex:indexPath.row];
        for(int i=0;i<[self.tableViews count];i++) {
            [[self.tableViews objectAtIndex:i] performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
            if(i==tableView.tag+1) {
                UIView *tableViewHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[self.tableViews objectAtIndex:i] bounds].size.width, 60)];
                [tableViewHeader setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
                for(int i=0;i<2;i++) {
                    UILabel *label = [[UILabel alloc] init];
                    [label setAutoresizingMask:i==0?UIViewAutoresizingFlexibleRightMargin:UIViewAutoresizingFlexibleLeftMargin];
                    [label setBackgroundColor:[UIColor BCPOffWhiteColor]];
                    [label setFrame:CGRectMake(i==0?10:(tableViewHeader.bounds.size.width-20)*0.5, 4, (tableViewHeader.bounds.size.width-20)*0.5, tableViewHeader.bounds.size.height-8)];
                    [label setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18]];
                    [label setText:i==0?@"Total Grade:":[NSString stringWithFormat:@"%@ — %@",[self.selectedCourse objectForKey:@"percent"],[self.selectedCourse objectForKey:@"letter"]]];
                    [label setTextAlignment:i==0?NSTextAlignmentLeft:NSTextAlignmentRight];
                    [label setTextColor:[UIColor BCPOffBlackColor]];
                    [tableViewHeader addSubview:label];
                }
                UIView *divider = [[UIView alloc] initWithFrame:CGRectMake(0, -1, tableViewHeader.bounds.size.width, 1)];
                [divider setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
                [divider setBackgroundColor:[UIColor BCPLightGrayColor]];
                [tableViewHeader addSubview:divider];
                [[self.tableViews objectAtIndex:i] setTableHeaderView:tableViewHeader];
                [[self.tableViews objectAtIndex:i] setContentOffset:CGPointZero];
            }
        }
        
        __unsafe_unretained typeof(self) weakSelf = self;
        [self.navigationController setNavigationBarText:[self.selectedCourse objectForKey:@"course"]];
        [self.navigationController setLeftButtonImageName:@"ArrowLeft"];
        [self.navigationController setLeftButtonTapped:^{
            int newTag = (int)[[weakSelf.scrollViews objectAtIndex:[weakSelf currentSemester]+1] tag]-1;
            if(newTag==0) {
                [weakSelf.navigationController setNavigationBarText:[NSString stringWithFormat:@"Grades (Semester %i)",[weakSelf currentSemester]+1]];
                weakSelf.navigationController.leftButtonImageName = @"Sidebar";
                weakSelf.navigationController.leftButtonTapped = ^{
                    [[BCPCommon viewController] showSideBar];
                };
                weakSelf.navigationController.rightButtonImageName = [weakSelf currentSemester]==0?@"ArrowDown":@"ArrowUp";
                weakSelf.navigationController.rightButtonTapped = ^{
                    [weakSelf changeSemester];
                };
                [weakSelf updateNavigation];
                [[weakSelf.scrollViews objectAtIndex:[weakSelf currentSemester]+1] setScrollEnabled:NO];
            }
            [[weakSelf.scrollViews objectAtIndex:[weakSelf currentSemester]+1] setTag:newTag];
            [UIView animateWithDuration:BCP_TRANSITION_DURATION animations:^{
                [weakSelf layoutSubviews];
            }];
        }];
        [self.navigationController setRightButtonImageName:nil];
        [self.navigationController setRightButtonTapped:nil];
        [self updateNavigation];
        
        [[self.scrollViews objectAtIndex:tableView.tag/2+1] setScrollEnabled:YES];
        [[self.scrollViews objectAtIndex:tableView.tag/2+1] setTag:1];
        [UIView animateWithDuration:BCP_TRANSITION_DURATION animations:^{
            [self layoutSubviews];
        }];
    }
    else {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        self.selectedDetail = [NSMutableDictionary dictionary];
        [[self.scrollViews objectAtIndex:tableView.tag/2+1] setScrollEnabled:YES];
        [[self.scrollViews objectAtIndex:tableView.tag/2+1] setTag:2];
        [UIView animateWithDuration:BCP_TRANSITION_DURATION animations:^{
            [self layoutSubviews];
        }];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return tableView.tag%2==1?BCP_TABLEVIEW_HEADER_HEIGHT:0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return BCP_TABLEVIEW_CELL_HEIGHT;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(tableView.tag%2==0) {
        if([[BCPData data] objectForKey:@"grades"]&&[[[BCPData data] objectForKey:@"grades"] objectForKey:[NSString stringWithFormat:@"semester%i",[self currentSemester]+1]]) {
            return [[[[BCPData data] objectForKey:@"grades"] objectForKey:[NSString stringWithFormat:@"semester%i",((int)tableView.tag/2)+1]] count];
        }
    }
    else if(self.selectedCourse) {
        if(section==0&&[self.selectedCourse objectForKey:@"assignments"]) {
            return [[self.selectedCourse objectForKey:@"assignments"] count];
        }
        else if([self.selectedCourse objectForKey:@"categories"]) {
            return [[self.selectedCourse objectForKey:@"categories"] count];
        }
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(tableView.tag%2==1) {
        return section==0&&[self.selectedCourse objectForKey:@"assignments"]?@"Assignments":@"Categories";
    }
    return @"";
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if(tableView.tag%2==1) {
        UIView *view  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, [self tableView:tableView heightForHeaderInSection:section])];
        [view setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [view setBackgroundColor:[UIColor BCPMoreOffWhiteColor]];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 4, view.bounds.size.width-20, view.bounds.size.height-8)];
        [label setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [label setBackgroundColor:[UIColor BCPMoreOffWhiteColor]];
        [label setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:14]];
        [label setText:[self tableView:tableView titleForHeaderInSection:section]];
        [label setTextColor:[UIColor BCPOffBlackColor]];
        [view addSubview:label];
        
        return view;
    }
    return nil;
}

@end
