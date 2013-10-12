
//
//  NSObject_BCPDelegates_h.h
//  BCP-Mobile
//
//  Created by Bryce Pauken on 10/5/13.
//  Copyright (c) 2013 Kingfish. All rights reserved.
//

@protocol BCPDataDelegate<NSObject>
- (void)responseReturnedError:(BOOL)error;
@end

@protocol BCPKeyboardDelegate<NSObject>
- (void)keyboardHidden:(NSNotification*)notification;
- (void)keyboardShown:(NSNotification*)notification;
@end

@protocol BCPTableViewDelegate<NSObject>
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
@end

@protocol BCPViewControllerDelegate<NSObject>
- (void)dismissKeyboard;
- (void)error:(NSString *)error;
- (void)reloadLoginViews;
- (void)reloadSidebar;
- (void)selectLogin;
- (void)setKeyboardOwner:(NSObject<BCPKeyboardDelegate> *)keyboardDelegate;
- (void)setInterfaceScrollViewEnabled:(BOOL)enabled;
- (void)setScrollsToTop:(UIScrollView *)scrollView;
- (void)showContentView:(NSString *)view;
- (void)sidebarReselect;
- (BOOL)viewIsVisable:(NSString *)view;
@end