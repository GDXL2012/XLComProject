//
//  XLBaseViewController.h
//  XLComProject
//
//  Created by GDXL2012 on 2019/11/27.
//  Copyright © 2019 GDXL2012. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XLBaseViewController : UIViewController
// 上一个页面的标题:默认不需要设置
@property (nonatomic, copy) NSString *previewTitle;

@property (nonatomic, assign) BOOL xlPOPForGesture; /// 是否是手势返回
@property (nonatomic, assign) BOOL showBottomAdapterView; /// 底部适配view，遮挡view

#pragma mark - @Override - 生命周期方法：viewDidLoad调用
/**
 初始化成员变量：invoke at first in viewDidLoad
 覆写后父类自动调用
 */
-(void)xlInitMemberVariable;

/**
 初始化导航条：invoke after xlInitMemberVariable
 覆写后父类自动调用
 */
-(void)xlInitNavigationBar;

/**
 初始化页面：invoke after xlInitNavigationBar
 覆写后父类自动调用
 */
-(void)xlInitViewDisplay;

/**
 页面数据初始化：在xlInitViewDisplay方法之后调用，网络请求/数据库查询等
 覆写后父类自动调用
 */
-(void)xlInitViewData;

#pragma mark - @Override - 通用配置
/**
 是否需要导航栏隐藏
 覆写后父类自动调用
 
 @return default NO 显示，YES 隐藏
 */
-(BOOL)xlNeedNavigationBarHidden;

/**
 是否需要拦截返回手势
 覆写后父类自动调用
 
 @return default NO 不拦截，YES 拦截
 */
-(BOOL)xlNeedInterceptPopGesture;

/**
 是否需要返回：返回按钮及手势均会触发该方法
 覆写后父类自动调用
 @param forGesture YES 手势返回，NO 返回按钮点击
*/
-(BOOL)xlShouldPopViewControllerForGesture:(BOOL)forGesture;

/**
 注册通知
 覆写后父类自动调用
 */
-(void)xlRegisterNotification;

/**
 注销通知
 覆写后父类自动调用
 */
-(void)xlUnregisterNotification;

/// 移除当前控制器
-(void)removeCurrentViewController;
@end

NS_ASSUME_NONNULL_END
