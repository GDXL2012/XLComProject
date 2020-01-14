//
//  XLRefreshTableView.m
//  XLComProject
//
//  Created by GDXL2012 on 2019/11/27.
//  Copyright © 2019 GDXL2012. All rights reserved.
//

#import "XLRefreshTableView.h"
#import "MJRefresh.h"
#import "XLComMacro.h"

@interface XLRefreshTableView ()
@property (nonatomic, weak) id<XLRefreshTableViewDelegate> xlDelegate;
@end

@implementation XLRefreshTableView

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self initTableViewStyle];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initTableViewStyle];
    }
    return self;
}

-(void)initTableViewStyle{
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    _configForEndRefresh = NO;
}

-(void)configDelegate:(id<UITableViewDataSource,UITableViewDelegate,XLRefreshTableViewDelegate>)delegate{
    [super configDelegate:delegate];
    self.xlDelegate = delegate;
    // 配置代理方法后初始化刷新等
    [self configRefreshView];
}

/**
 重置刷新View
 */
-(void)reConfigRefreshView{
    [self configRefreshView];
}

/**
 配置刷新View
 */
-(void)configRefreshView{
    [self configHeaderRefreshView];
    [self configFooterRefreshView];
}

// 结束刷新操作
-(void)endRefreshing{
    // 1. 头部刷新结束
    BOOL configRefresh = self.configForEndRefresh;
    self.configForEndRefresh = NO;
    if(self.mj_header){
        XLWeakSelf
        [self.mj_header endRefreshingWithCompletionBlock:^{
            XLStrongSelf
            if (configRefresh) {
                [strongSelf configHeaderRefreshView];
            }
        }];
    } else {
        if (configRefresh) {
            [self configHeaderRefreshView];
        }
    }
}

// 结束上拉操作
-(void)stopLoadingView{
    // 2. 底部刷新
    BOOL configRefresh = self.configForEndLoadMore;
    self.configForEndLoadMore = NO;
    if (self.mj_footer) {
        XLWeakSelf
        [self.mj_footer endRefreshingWithCompletionBlock:^{
            XLStrongSelf
            if (configRefresh) {
                [strongSelf configFooterRefreshView];
            }
        }];
    } else {
        if (configRefresh) {
            [self configFooterRefreshView];
        }
    }
}

/**
 配置头部刷新View
 */
-(void)configHeaderRefreshView{
    if (self.xlDelegate) {
        BOOL refresh = [self.xlDelegate isSetupRefreshModule:self];
        if (refresh) {
            // 需要下拉刷新
            MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(xlLoadNewData)];
            self.mj_header = header;
        } else {
            self.mj_header = nil;
        }
    } else {
        self.mj_header = nil;
    }
}

/**
 配置头部刷新View
 */
-(void)configFooterRefreshView{
    if (self.xlDelegate) {
        BOOL loadMore = [self.xlDelegate isSetupLoadmoreModule:self];
        if (loadMore) {
            MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(xlLoadMoreData)];
            self.mj_footer = footer;
        } else {
            self.mj_footer = nil;
        }
    } else {
        self.mj_footer = nil;
    }
}

// 显示没有更多数据
-(void)noticeNoMoreData{
    [self.mj_footer endRefreshingWithNoMoreData];
}

// 重置没有更多的数据（消除没有更多数据的状态）
-(void)resetNoticeNoMoreData{
    [self.mj_footer resetNoMoreData];
}

#pragma mark - Load Data
-(void)xlLoadNewData{
    if (self.xlDelegate &&
        [self.xlDelegate respondsToSelector:@selector(refreshTableViewDidRefresh:)]) {
        [self.mj_header beginRefreshing];
        [self.xlDelegate refreshTableViewDidRefresh:self];
    }
}

-(void)xlLoadMoreData{
    if (self.xlDelegate &&
        [self.xlDelegate respondsToSelector:@selector(refreshTableViewDidLoadMore:)]) {
        [self.mj_footer beginRefreshing];
        [self.xlDelegate refreshTableViewDidLoadMore:self];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
