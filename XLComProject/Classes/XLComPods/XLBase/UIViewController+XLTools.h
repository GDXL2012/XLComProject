//
//  UIViewController+XLTools.h
//  XLComProject
//
//  Created by GDXL2012 on 2019/11/27.
//  Copyright © 2019 GDXL2012. All rights reserved.
//
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (XLTools)

/**
 设置右侧按钮
 
 @param action 右侧按钮事件
 @param normalName 正常状态图标
 @param highName 高亮状态图标
 */
-(void)setRightBarButtonAction:(SEL)action normalImageName:(NSString *)normalName highImageName:(NSString *)highName;

/**
 设置右侧按钮
 
 @param action 右侧按钮事件
 @param title 正常状态
 */
-(void)setRightBarButtonAction:(SEL)action title:(NSString *)title;

/**
 多个导航栏右侧按钮selctNameArray、norImgArray,heightImgArray，selctNameArray数组大小须相同
 
 @param selctNameArray 点击回调事件
 @param normalNames 常态时按钮图标
 @param highNames 高亮时按钮图标
 */
-(void)setRightBarButtons:(NSArray *)selctNameArray normalImageNames:(NSArray *)normalNames highImageNames:(NSArray *)highNames;

/**
 多个导航栏右侧按钮selctNameArray、nameArray数组大小须相同
 
 @param selctNameArray 点击回调事件
 @param names 按钮名字
 
 */
-(void)setRightBarButtons:(NSArray *)selctNameArray names:(NSArray *)names;
/**
 设置多个导航栏右侧按钮tiles、actions数组大小须相同
 
 @param tiles 标题
 @param actions 事件回调
 */
-(void)setRightBarTiles:(NSArray *)tiles actions:(NSArray *)actions;
#pragma mark - NavigationItem Control
/**
 *隐藏右item
 */
-(void)hiddenRightBarButtonItem;
-(void)setRightBarButtonItemHidden:(BOOL)hidden;

/// 设置右键按钮是否可点击
/// @param enable <#enable description#>
-(void)setRightBarButtonEnable:(BOOL)enable;

#pragma mark - Common Method

/**
 销毁当前控制器
 */
-(void)popViewController;

/**
 弹出控制器
 
 @param viewController 弹出控制器
 */
-(void)pushViewController:(UIViewController *)viewController;
-(void)pushViewControllerWithName:(NSString *)controllerName;

/**
 * default：hidesBottomBarWhenPushed = NO
 */
-(void)pushViewControllerWithOutBottomBarHides:(UIViewController *)viewController;
-(void)pushViewControllerNameWithOutBottomBarHides:(NSString *)controllerName;
@end

NS_ASSUME_NONNULL_END
