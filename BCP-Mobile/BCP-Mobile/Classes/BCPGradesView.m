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
        
        self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        [self.scrollView setAutoresizingMask:UIViewAutoresizingFlexibleSize];
        [self.scrollView setPagingEnabled:YES];
        [self.scrollView setScrollEnabled:NO];
        [self.scrollView setShowsHorizontalScrollIndicator:NO];
        [self.scrollView setShowsVerticalScrollIndicator:NO];
        [self.scrollView setTag:[self currentSemester]*2];
        [self addSubview:self.scrollView];
        
        self.tableViews = [[NSMutableArray alloc] init];
        for(int i=0;i<4;i++) {
            UITableView *tableView = [[UITableView alloc] init];
            [tableView setBackgroundColor:[UIColor BCPOffWhiteColor]];
            [tableView setDataSource:self];
            [tableView setDelegate:self];
            [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
            [tableView setTag:i];
            [self.scrollView addSubview:tableView];
            [self.tableViews addObject:tableView];
            
            UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 0)];
            [header setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
            [tableView setTableHeaderView:header];
            
            UIView *divider = [[UIView alloc] initWithFrame:CGRectMake(0, -1, tableView.bounds.size.width, 1)];
            [divider setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
            [divider setBackgroundColor:[UIColor BCPLightGrayColor]];
            [header addSubview:divider];
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
    [self.scrollView setTag:newSemester*2];
    [UIView animateWithDuration:BCP_TRANSITION_DURATION animations:^{
       [self.scrollView setContentOffset:CGPointMake(self.scrollView.bounds.size.width*(self.scrollView.tag%2), self.scrollView.bounds.size.height*(self.scrollView.tag/2))];
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
    [self.scrollView setContentSize:CGSizeMake(self.bounds.size.width*2, self.bounds.size.height*2)];
    for(int i=0;i<[self.tableViews count];i++) {
        [[self.tableViews objectAtIndex:i] setFrame:CGRectMake(self.scrollView.bounds.size.width*(i%2), self.scrollView.bounds.size.height*(i/2), self.scrollView.bounds.size.width, self.scrollView.bounds.size.height)];
    }
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.bounds.size.width*(self.scrollView.tag%2), self.scrollView.bounds.size.height*(self.scrollView.tag/2))];
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
            [cell setTitle:[course objectForKey:@"course"] withGrade:[course objectForKey:@"letter"]];
        }
    }
    else if(self.selectedCourse) {
        
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView.tag%2==0) {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        self.selectedCourse = [[[[BCPData data] objectForKey:@"grades"] objectForKey:[NSString stringWithFormat:@"semester%i",((int)tableView.tag/2)+1]] objectAtIndex:indexPath.row];
        
        __unsafe_unretained typeof(self) weakSelf = self;
        [self.navigationController setNavigationBarText:[self.selectedCourse objectForKey:@"course"]];
        [self.navigationController setLeftButtonImageName:@"ArrowLeft"];
        [self.navigationController setLeftButtonTapped:^{
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
            [weakSelf.scrollView setTag:[weakSelf currentSemester]*2];
            [UIView animateWithDuration:BCP_TRANSITION_DURATION animations:^{
                [weakSelf.scrollView setContentOffset:CGPointMake(weakSelf.scrollView.bounds.size.width*(weakSelf.scrollView.tag%2), weakSelf.scrollView.bounds.size.height*(weakSelf.scrollView.tag/2))];
            }];
        }];
        [self.navigationController setRightButtonImageName:nil];
        [self.navigationController setRightButtonTapped:nil];
        [self updateNavigation];
        
        [self.scrollView setTag:tableView.tag+1];
        [UIView animateWithDuration:BCP_TRANSITION_DURATION animations:^{
            [self.scrollView setContentOffset:CGPointMake(self.scrollView.bounds.size.width*(self.scrollView.tag%2), self.scrollView.bounds.size.height*(self.scrollView.tag/2))];
        }];
    }
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
    else {
        
    }
    return 0;
}

@end
