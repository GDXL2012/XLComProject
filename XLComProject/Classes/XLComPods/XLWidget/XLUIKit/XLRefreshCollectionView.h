//
//  XLRefreshCollectionView.h
//  AFNetworking
//
//  Created by GDXL2012 on 2020/9/9.
//

#import "XLCollectionView.h"

NS_ASSUME_NONNULL_BEGIN

@class XLRefreshCollectionView;
@protocol XLRefreshCollectionViewDelegate <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>
@optional
// 下拉/上拉回调
-(void)refreshCollectionViewDidRefresh:(XLRefreshCollectionView *)refreshCollectionView;
-(void)refreshCollectionViewDidLoadMore:(XLRefreshCollectionView *)refreshCollectionView;

@required
// 设置是否需要下拉/上拉刷新
- (BOOL)isSetupCollectionViewRefreshModule:(XLRefreshCollectionView*)refreshCollectionView;
- (BOOL)isSetupCollectionViewLoadmoreModule:(XLRefreshCollectionView*)refreshCollectionView;
@end

@interface XLRefreshCollectionView : XLCollectionView

// 是否需要重置代理：NO 不需要 Default，YES 重置 在执行endRefreshing方法后生效
@property (nonatomic, assign) BOOL configForEndRefresh;
// 是否需要重置代理：NO 不需要 Default，YES 重置 在执行stopLoadingView方法后生效
@property (nonatomic, assign) BOOL configForEndLoadMore;

// 设置代理方法
-(void)configDelegate:(id<XLRefreshCollectionViewDelegate>)delegate;

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
