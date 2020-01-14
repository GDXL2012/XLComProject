//
//  XLBaseTableViewController.h
//  XLComProject
//
//  Created by GDXL2012 on 2019/11/27.
//  Copyright © 2019 GDXL2012. All rights reserved.
//

#import "XLBaseViewController.h"
#import "XLTableView.h"

NS_ASSUME_NONNULL_BEGIN

/// 列表控制器
@interface XLBaseTableViewController : XLBaseViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) XLTableView *xlTableView;

/// 初始化：默认UITableViewStylePlain
/// @param style <#style description#>
-(instancetype)initWithTableViewStyle:(UITableViewStyle)style;

/// 父类方法不能覆写，否则会导致xlTableView不能初始化
-(void)initViewDisplay DEPRECATED_MSG_ATTRIBUTE("Please use [XLBaseTableViewController xlUserCustomizationView]");
/**
 用户自定义View：取代基类的initViewDisplay，子类继承后不要复写initViewDisplay
 */
-(void)xlUserCustomizationView;

/**
 配置Empty HeadFooter View
 */
-(void)xlConfigEmptyHeadFooterView;

/// 子类实现后可设置TableView控件位置
-(void)xlMakeTableViewConstraints;
@end

NS_ASSUME_NONNULL_END
