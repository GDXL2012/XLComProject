//
//  XLBarButtonItem.h
//  XLComProject
//
//  Created by GDXL2012 on 2019/11/27.
//  Copyright © 2019 GDXL2012. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

// 预定义导航栏按钮风格
//typedef NS_ENUM(NSInteger, MOBarButtonItemType) {
//    MOBarButtonItemTypeBack     = 0,    // 返回【<】
//    MOBarButtonItemTypeMore     = 1,    // 更多【···】
//    MOBarButtonItemTypeAdd      = 2     // 添加【+】
//};

@interface XLBarButtonItem : UIBarButtonItem

/**
 初始化
 
 @param target 回调目标对象
 @param action 按钮事件
 @param normalName 图片名称
 @param highName 图片名称
 @return 返回实例对象
 */
- (XLBarButtonItem *)initWithTarget:(id)target action:(SEL)action normalImage:(NSString *)normalName highImage:(NSString *)highName;

/**
 初始化
 
 @param target 回调目标对象
 @param action 按钮事件
 @param title 标题
 @return 返回实例对象
 */
- (XLBarButtonItem *)initWithTarget:(id)target action:(SEL)action title:(NSString *)title;

/**
 初始化
 
 @param target 回调目标对象
 @param action 按钮事件
 @param title 标题
 @param color 标题颜色
 @return 返回实例对象
 */
- (XLBarButtonItem *)initWithTarget:(id)target action:(SEL)action title:(NSString *)title color:(UIColor *)color;
@end

/**
 导航栏左侧按钮
 */
@interface XLLeftBarButtonItem : XLBarButtonItem

-(XLLeftBarButtonItem *)initWithTarget:(id)target action:(SEL)action title:(NSString *)title;

@end

/**
 导航栏右侧按钮
 */
@interface XLRightBarButtonItem : XLBarButtonItem

@end

NS_ASSUME_NONNULL_END
