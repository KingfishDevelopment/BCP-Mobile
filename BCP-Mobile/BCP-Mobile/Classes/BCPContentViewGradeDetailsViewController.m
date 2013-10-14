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
    BCPContentViewGradesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GradeDetailsCell2"];
    if(cell==nil) {
        cell = [[BCPContentViewGradesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"GradeDetailsCell3"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    }
    
    NSString *title, *grade, *percent;
    if(indexPath.section==0&&[self.currentClass objectForKey:@"assignments"]) {
        NSDictionary *section = [[self.currentClass objectForKey:@"assignments"] objectAtIndex:indexPath.row];
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
        NSDictionary *section = [[self.currentClass objectForKey:@"categories"] objectAtIndex:indexPath.row];
        title = [section objectForKey:@"category"];
        grade = [section objectForKey:@"letter"];
        if([section objectForKey:@"percent"]&&![[section objectForKey:@"percent"] isEqualToString:@""])
            percent = [[section objectForKey:@"percent"] stringByAppendingString:@"%"];
        else
            percent = @"";
    }
    [cell setTextWithTitle:title grade:grade percent:percent withDivder:indexPath.row>0];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return ([self numberOfSectionsInTableView:tableView]>1?[BCPCommon TABLEVIEW_HEADER_HEIGHT]:0);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [BCPCommon TABLEVIEW_CELL_HEIGHT];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if([self numberOfSectionsInTableView:tableView]>1) {
        UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, [BCPCommon TABLEVIEW_HEADER_HEIGHT])];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake([BCPCommon TABLEVIEW_HEADER_PADDING], 0, header.frame.size.width-[BCPCommon TABLEVIEW_HEADER_PADDING]*2, header.frame.size.height)];
        [label setBackgroundColor:[BCPCommon BLUE]];
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

- (void)viewDidLoad {
    [self.tableView registerClass:[BCPContentViewGradesCell class] forCellReuseIdentifier:@"GradeDetailsCell"];
}

@end
