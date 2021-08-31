//
//  XLBaseCollectionViewController.h
//  AFNetworking
//
//  Created by GDXL2012 on 2020/9/7.
//

#import "XLBaseViewController.h"
#import "XLCollectionView.h"

NS_ASSUME_NONNULL_BEGIN

@interface XLBaseCollectionViewController : XLBaseViewController <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>
@property (nonatomic, strong) XLCollectionView *xlCollectionView;

/// 父类方法不能覆写，否则会导致xlTableView不能初始化
-(void)xlInitViewDisplay DEPRECATED_MSG_ATTRIBUTE("Please use [XLBaseTableViewController xlUserCustomizationView]");
/**
 用户自定义View：取代基类的xlInitViewDisplay，子类继承后不要复写xlInitViewDisplay
 */
-(void)xlUserCustomizationView;

/// 子类实现后可设置CollectionView控件位置
-(void)xlMakeCollectionViewConstraints;

-(UICollectionViewFlowLayout *)flowLayout;
@end

NS_ASSUME_NONNULL_END
