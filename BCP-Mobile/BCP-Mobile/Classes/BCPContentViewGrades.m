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
        self.tableViewController = [[BCPContentViewGradesViewController alloc] init];
        
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
    }
    return self;
}

- (void)responseReturnedError:(BOOL)error {
    [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    [self.navigationBar setFrame:CGRectMake(0, 0, self.frame.size.width, [BCPCommon NAVIGATION_BAR_HEIGHT])];
    [self.tableView setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}

- (void)setHidden:(BOOL)hidden {
    [super setHidden:hidden];
    
    if(!hidden&&[BCPCommon loggedIn]&&!self.loaded) {
        self.loaded = true;
        [[BCPCommon data] sendRequest:@"grades" withDelegate:self];
    }
}

@end
