//
//  BCPNewsView.h
//  BCP-Mobile
//
//  Created by Bryce Pauken on 4/13/14.
//  Copyright (c) 2014 Kingfish. All rights reserved.
//

#import "BCPContentView.h"

@interface BCPNewsView : BCPContentView <UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate, UIWebViewDelegate>

@property (nonatomic, retain) UIView *divider;
@property (nonatomic) BOOL firstLoadCompleted;
@property (nonatomic) BOOL scrollingBack;
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) UIWebView *webView;
@property (nonatomic, retain) UIActivityIndicatorView *webViewSpinner;

@end
