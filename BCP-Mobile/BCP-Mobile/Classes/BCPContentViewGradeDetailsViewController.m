//
//  BCPContentViewGradeDetailsViewController.m
//  BCP-Mobile
//
//  Created by Bryce Pauken on 10/10/13.
//  Copyright (c) 2013 Kingfish. All rights reserved.
//

#import "BCPContentViewGradeDetailsViewController.h"

@interface BCPContentViewGradeDetailsViewController ()

@end

@implementation BCPContentViewGradeDetailsViewController

- (id)initWithClass:(NSDictionary *)class;
{
    self = [super init];
    if (self) {
        self.currentClass = class;
    }
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    int sections = 0;
    if(self.currentClass!=nil&&[self.currentClass objectForKey:@"assignments"])
        sections++;
    if(self.currentClass!=nil&&[self.currentClass objectForKey:@"categories"])
        sections++;
    return sections;
}

- (void)reloadTable {
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section==0&&[self.currentClass objectForKey:@"assignments"]) {
        return [[self.currentClass objectForKey:@"assignments"] count];
    }
    else
        return [[self.currentClass objectForKey:@"categories"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BCPContentViewGradesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GradeDetailsCell"];
    if(cell==nil) {
        cell = [[BCPContentViewGradesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"GradeDetailsCell"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    }
    [cell setDividerHidden:(indexPath.row==0)];
    
    if(indexPath.section==0&&[self.currentClass objectForKey:@"assignments"]) {
        NSDictionary *section = [[self.currentClass objectForKey:@"assignments"] objectAtIndex:indexPath.row];
        [cell setClassLabelText:[section objectForKey:@"name"]];
        [cell setGradeLabelText:[section objectForKey:@"letter"]];
        if([[section objectForKey:@"max"] floatValue]==0) {
            if([section objectForKey:@"grade"]&&![[section objectForKey:@"grade"] isEqualToString:@""]&&[[section objectForKey:@"grade"] floatValue]!=0) {
                [cell setPercentLabelText:@"(NA)"];
            }
            else {
                [cell setGradeLabelText:@"((NA))"];
                [cell setPercentLabelText:@"((NA))"];
            }
        }
        else if([section objectForKey:@"grade"]&&![[section objectForKey:@"grade"] isEqualToString:@""])
            [cell setPercentLabelText:[NSString stringWithFormat:@"%.02f%%",[[section objectForKey:@"grade"] floatValue]*100/[[section objectForKey:@"max"] floatValue]]];
        else
            [cell setPercentLabelText:@""];
    }
    else {
        NSDictionary *section = [[self.currentClass objectForKey:@"categories"] objectAtIndex:indexPath.row];
        [cell setClassLabelText:[section objectForKey:@"category"]];
        [cell setGradeLabelText:[section objectForKey:@"letter"]];
        if([section objectForKey:@"percent"]&&![[section objectForKey:@"percent"] isEqualToString:@""])
            [cell setPercentLabelText:[[section objectForKey:@"percent"] stringByAppendingString:@"%"]];
        else
            [cell setPercentLabelText:@""];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return ([self numberOfSectionsInTableView:tableView]>1?[BCPCommon TABLEVIEW_HEADER_HEIGHT]:0);
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if([self numberOfSectionsInTableView:tableView]>1) {
        UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, [BCPCommon TABLEVIEW_HEADER_HEIGHT])];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake([BCPCommon TABLEVIEW_HEADER_PADDING], 0, header.frame.size.width-[BCPCommon TABLEVIEW_HEADER_PADDING]*2, header.frame.size.height)];
        [label setFont:[BCPFont boldSystemFontOfSize:16]];
        [label setText:(section==0&&[self.currentClass objectForKey:@"assignments"]?@"Assignments":@"Categories")];
        [label setTextColor:[BCPColor colorWithWhite:1 alpha:1]];
        [header addSubview:label];
        [header setBackgroundColor:[BCPCommon BLUE]];
        return header;
    }
    else {
        UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 0)];
        return header;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [BCPCommon TABLEVIEW_CELL_HEIGHT];
}

- (void)viewDidLoad {
    [self.tableView registerClass:[BCPContentViewGradesCell class] forCellReuseIdentifier:@"GradeDetailsCell"];
}

@end
