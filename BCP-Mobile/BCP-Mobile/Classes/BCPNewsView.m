//
//  BCPNewsView.m
//  BCP-Mobile
//
//  Created by Bryce Pauken on 4/13/14.
//  Copyright (c) 2014 Kingfish. All rights reserved.
//

#import "BCPNewsView.h"

#import "BCPGenericCell.h"

@implementation BCPNewsView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.firstLoadCompleted = NO;
        self.scrollingBack = NO;
        
        self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        [self.scrollView setAutoresizingMask:UIViewAutoresizingFlexibleSize];
        [self.scrollView setBounces:NO];
        [self.scrollView setDelegate:self];
        [self.scrollView setScrollEnabled:NO];
        [self.scrollView setScrollsToTop:NO];
        [self.scrollView setShowsHorizontalScrollIndicator:NO];
        [self.scrollView setShowsVerticalScrollIndicator:NO];
        [self.scrollView setTag:0];
        [self addSubview:self.scrollView];
        
        self.tableView = [[UITableView alloc] initWithFrame:self.bounds];
        [self.tableView setBackgroundColor:[UIColor BCPOffWhiteColor]];
        [self.tableView setDataSource:self];
        [self.tableView setDelegate:self];
        [self.tableView setScrollsToTop:NO];
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        if([BCPCommon isIOS7]) {
            [self.tableView registerClass:[BCPGenericCell class] forCellReuseIdentifier:@"NewsCell"];
        }
        [self.scrollView addSubview:self.tableView];
        
        UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 0)];
        [header setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        UIView *divider = [[UIView alloc] initWithFrame:CGRectMake(0, -1, self.tableView.bounds.size.width, 1)];
        [divider setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [divider setBackgroundColor:[UIColor BCPLightGrayColor]];
        [header addSubview:divider];
        [self.tableView setTableHeaderView:header];
        
        self.divider = [[UIView alloc] init];
        [self.divider setBackgroundColor:[UIColor BCPLightGrayColor]];
        [self.scrollView addSubview:self.divider];
        
        self.webView = [[UIWebView alloc] init];
        [self.webView setDelegate:self];
        [((UIScrollView *)[[self.webView subviews] objectAtIndex:0]) setScrollsToTop:NO];
        [self.scrollView addSubview:self.webView];
        
        self.webViewSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self.webViewSpinner setHidesWhenStopped:YES];
        [self.webViewSpinner setTransform:CGAffineTransformScale(CGAffineTransformIdentity, 2, 2)];
        [self.webViewSpinner stopAnimating];
        [self.scrollView addSubview:self.webViewSpinner];
        
        [self setNeedsLayout];
        
        __unsafe_unretained typeof(self) weakSelf = self;
        [self.tableView addPullToRefreshWithActionHandler:^{
            [weakSelf loadNews];
        }];
        [self updateCurrentScrollView];
        [self.navigationController setNavigationBarText:@"News"];
    }
    return self;
}

- (void)layoutSubviews {
    [self.scrollView setContentSize:CGSizeMake(self.bounds.size.width*2+1, self.bounds.size.height)];
    [self.tableView setFrame:CGRectMake(0, 0, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height)];
    [self.webView setFrame:CGRectMake(self.bounds.size.width+1, 0, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height)];
    [self.webViewSpinner setFrame:CGRectMake(self.bounds.size.width+1+(self.bounds.size.width-self.webViewSpinner.bounds.size.width)/2, (self.bounds.size.height-self.webViewSpinner.bounds.size.height)/2, self.webViewSpinner.bounds.size.width, self.webViewSpinner.bounds.size.height)];
    [self.divider setFrame:CGRectMake(self.bounds.size.width, 0, 1, self.bounds.size.height)];
    [self.scrollView setContentOffset:CGPointMake((self.bounds.size.width+1)*self.scrollView.tag, 0)];
}

- (void)loadNews {
    [BCPData sendRequest:@"news" withDetails:nil onCompletion:^(NSString *error) {
        [[self.tableView pullToRefreshView] stopAnimating];
        if(!error&&[[BCPData data] objectForKey:@"news"]) {
            [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
        }
        else {
            [TSMessage showNotificationWithTitle:@"An Error has Occurred" subtitle:@"Please seek help if the problem persists." type:TSMessageNotificationTypeError];
        }
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if([scrollView isKindOfClass:[UITableView class]]||self.scrollingBack) {
        self.scrollingBack = NO;
        return;
    }
    int nearestIndex = (scrollView.contentOffset.x / (scrollView.bounds.size.width+1) + 0.5f);
    [scrollView setTag:nearestIndex];
    dispatch_async(dispatch_get_main_queue(), ^{
        [scrollView setContentOffset:CGPointMake((scrollView.bounds.size.width+1)*nearestIndex, 0) animated:YES];
    });
    if(nearestIndex==0) {
        self.navigationController.leftButtonImageName = @"Sidebar";
        self.navigationController.leftButtonTapped = ^{
            [[BCPCommon viewController] showSideBar];
        };
        [self updateNavigation];
        [self.scrollView setScrollEnabled:NO];
    }
    [self updateCurrentScrollView];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if([scrollView isKindOfClass:[UITableView class]]||velocity.x==0) {
        return;
    }
    self.scrollingBack = YES;
    int nearestIndex = (targetContentOffset->x / (scrollView.bounds.size.width+1) + 0.25f);
    [scrollView setTag:nearestIndex];
    *targetContentOffset = CGPointMake((scrollView.bounds.size.width+1)*nearestIndex, targetContentOffset->y);
    dispatch_async(dispatch_get_main_queue(), ^{
        [scrollView setContentOffset:CGPointMake((scrollView.bounds.size.width+1)*nearestIndex, targetContentOffset->y) animated:YES];
    });
    if(nearestIndex==0) {
        self.navigationController.leftButtonImageName = @"Sidebar";
        self.navigationController.leftButtonTapped = ^{
            [[BCPCommon viewController] showSideBar];
        };
        [self updateNavigation];
        [self.scrollView setScrollEnabled:NO];
    }
    [self updateCurrentScrollView];
}

- (void)setHidden:(BOOL)hidden {
    [super setHidden:hidden];
    if(!hidden&&!self.firstLoadCompleted) {
        self.firstLoadCompleted = YES;
        [self.tableView triggerPullToRefresh];
        [self loadNews];
    }
    [self updateCurrentScrollView];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BCPGenericCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsCell"];
    if (cell == nil) {
        cell = [[BCPGenericCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NewsCell"];
    }
    NSDictionary *article = [[[BCPData data] objectForKey:@"news"] objectAtIndex:indexPath.row];
    [cell setText:[article objectForKey:@"title"]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self.webViewSpinner startAnimating];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
    
    NSDictionary *article = [[[BCPData data] objectForKey:@"news"] objectAtIndex:indexPath.row];
    BOOL numericID = [[article objectForKey:@"id"] rangeOfCharacterFromSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet]].location == NSNotFound;
    NSString *url = numericID?[@"https://kingfi.sh/api/bellarmine/v2/news/" stringByAppendingString:[article objectForKey:@"id"]]:[article objectForKey:@"id"];
    
    __unsafe_unretained typeof(self) weakSelf = self;
    [self.navigationController setLeftButtonImageName:@"ArrowLeft"];
    [self.navigationController setLeftButtonTapped:^{
        weakSelf.navigationController.leftButtonImageName = @"Sidebar";
        weakSelf.navigationController.leftButtonTapped = ^{
            [[BCPCommon viewController] showSideBar];
        };
        [weakSelf updateNavigation];
        [weakSelf.scrollView setScrollEnabled:NO];
        [weakSelf.scrollView setTag:0];
        [UIView animateWithDuration:BCP_TRANSITION_DURATION animations:^{
            [weakSelf.scrollView setContentOffset:CGPointZero];
        }];
        [weakSelf updateCurrentScrollView];
    }];
    [self updateNavigation];
    
    [self.scrollView setScrollEnabled:YES];
    [self.scrollView setTag:1];
    [UIView animateWithDuration:BCP_TRANSITION_DURATION animations:^{
        [self layoutSubviews];
    } completion:^(BOOL finished) {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    }];
    [self updateCurrentScrollView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGSize labelSize = [BCPCommon sizeOfText:[[[[BCPData data] objectForKey:@"news"] objectAtIndex:indexPath.row] objectForKey:@"title"] withFont:[BCPGenericCell font] constrainedToWidth:self.tableView.bounds.size.width-[BCPCommon tableViewPadding]*2];
    return MAX(labelSize.height+30,50);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[BCPData data] objectForKey:@"news"] count];
}

- (void)updateCurrentScrollView {
    if(!self.hidden) {
        [[BCPCommon viewController] setScrollsToTop:self.scrollView.tag==0?self.tableView:((UIScrollView *)[[self.webView subviews] objectAtIndex:0])];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if(![webView.request.URL.absoluteString isEqualToString:@"about:blank"]) {
        [self.webViewSpinner stopAnimating];
    }
}

@end
