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
    self.classes = [[[[BCPCommon data] objectForKey:@"grades"] objectForKey:@"semester1"] sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        if([[a objectForKey:@"course"] isEqualToString:@"Homeroom"])
            return NSOrderedDescending;
        else if([[b objectForKey:@"course"] isEqualToString:@"Homeroom"])
            return NSOrderedAscending;
        else
            return [[a objectForKey:@"course"] compare:[b objectForKey:@"course"]];
    }];
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
    
    NSDictionary *class = [self.classes objectAtIndex:indexPath.row];
    [cell setClassLabelText:[class objectForKey:@"course"]];
    [cell setGradeLabelText:[class objectForKey:@"letter"]];
    [cell setPercentLabelText:[class objectForKey:@"percent"]];
    [cell setSelectionStyle:(![class objectForKey:@"letter"]||![class objectForKey:@"percent"]?UITableViewCellSelectionStyleNone:UITableViewCellSelectionStyleGray)];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSDictionary *class = [self.classes objectAtIndex:indexPath.row];
    if([class objectForKey:@"letter"]&&[class objectForKey:@"percent"]) {
        NSLog(@"hi");
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [BCPCommon TABLEVIEW_CELL_HEIGHT];
}

- (void)viewDidLoad {
    [self.tableView registerClass:[BCPContentViewGradesCell class] forCellReuseIdentifier:@"GradesCell"];
}

@end
