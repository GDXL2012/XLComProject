//
//  XLRefreshTableView.h
//  XLComProject
//
//  Created by GDXL2012 on 2019/11/27.
//  Copyright © 2019 GDXL2012. All rights reserved.
//

#import "XLTableView.h"

NS_ASSUME_NONNULL_BEGIN
@class XLRefreshTableView;
@protocol XLRefreshTableViewDelegate <UITableViewDataSource, UITableViewDelegate>
@optional
// 下拉/上拉回调
-(void)refreshTableViewDidRefresh:(XLRefreshTableView *)refreshTableView;
-(void)refreshTableViewDidLoadMore:(XLRefreshTableView *)refreshTableView;

@required
// 设置是否需要下拉/上拉刷新
- (BOOL)isSetupRefreshModule:(XLRefreshTableView*)refreshTableView;
- (BOOL)isSetupLoadmoreModule:(XLRefreshTableView*)refreshTableView;
@end
@interface XLRefreshTableView : XLTableView

// 是否需要重置代理：NO 不需要 Default，YES 重置 在执行endRefreshing方法后生效
@property (nonatomic, assign) BOOL configForEndRefresh;
// 是否需要重置代理：NO 不需要 Default，YES 重置 在执行stopLoadingView方法后生效
@property (nonatomic, assign) BOOL configForEndLoadMore;

// 设置代理方法
-(void)configDelegate:(id<XLRefreshTableViewDelegate>)delegate;

/**
 重置刷新View: 主动调用设置上拉/下拉刷新View，
 */
-(void)reConfigRefreshView;
-(void)configHeaderRefreshView;
-(void)configFooterRefreshView;

// 结束刷新操作
-(void)endRefreshing;
// 结束上拉操作
-(void)stopLoadingView;

// 显示没有更多数据
-(void)noticeNoMoreData;

// 重置没有更多的数据（消除没有更多数据的状态）
-(void)resetNoticeNoMoreData;
@end

NS_ASSUME_NONNULL_END
