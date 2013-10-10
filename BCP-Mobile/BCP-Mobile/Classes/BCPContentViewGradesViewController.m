//
//  BCPContentViewGradesViewController.m
//  BCP-Mobile
//
//  Created by Bryce Pauken on 10/7/13.
//  Copyright (c) 2013 Kingfish. All rights reserved.
//

#import "BCPContentViewGradesViewController.h"

@interface BCPContentViewGradesViewController ()

@end

@implementation BCPContentViewGradesViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
    }
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[[BCPCommon data] objectForKey:@"grades"] objectForKey:@"semester1"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BCPContentViewGradesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GradesCell"];
    if(cell==nil) {
        cell = [[BCPContentViewGradesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"GradesCell"];
    }
    [cell setDividerHidden:(indexPath.row==0)];
    
    NSDictionary *class = [[[[BCPCommon data] objectForKey:@"grades"] objectForKey:@"semester1"] objectAtIndex:indexPath.row];
    [cell setClassLabelText:[class objectForKey:@"course"]];
    [cell setGradeLabelText:[class objectForKey:@"letter"]];
    [cell setPercentLabelText:[class objectForKey:@"percent"]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [BCPCommon TABLEVIEW_CELL_HEIGHT];
}

- (void)viewDidLoad {
    [self.tableView registerClass:[BCPContentViewGradesCell class] forCellReuseIdentifier:@"GradesCell"];
}

@end
