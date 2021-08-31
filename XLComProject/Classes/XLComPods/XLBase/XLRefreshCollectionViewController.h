//
//  XLRefreshCollectionViewController.h
//  AFNetworking
//
//  Created by GDXL2012 on 2020/9/9.
//

#import "XLBaseViewController.h"
#import "XLRefreshCollectionView.h"

NS_ASSUME_NONNULL_BEGIN

@interface XLRefreshCollectionViewController : XLBaseViewController <XLRefreshCollectionViewDelegate>
@property (nonatomic, strong) XLRefreshCollectionView    *xlRefreshCollectionView;

/// 默认：
/// @param layout <#layout description#>
-(instancetype)initWithLayout:(nullable UICollectionViewLayout *)layout;
/// 父类方法不能覆写，否则会导致xlTableView不能初始化
-(void)xlInitViewDisplay DEPRECATED_MSG_ATTRIBUTE("Please use [XLRefreshCollectionViewController xlUserCustomizationView]");
/**
 用户自定义View：取代基类的xlInitViewDisplay，子类继承后不要复写xlInitViewDisplay
 */
-(void)xlUserCustomizationView;

/// 子类实现后可设置TableView控件位置
-(void)xlMakeTableViewConstraints;

// 下拉刷新
-(void)reloadTableViewForRefresh;

// 上拉刷新
-(void)reloadTableViewForLoadmore;
@end

NS_ASSUME_NONNULL_END
