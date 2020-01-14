//
//  XLViewControllerTools.h
//  XLComProject
//
//  Created by GDXL2012 on 2019/11/27.
//  Copyright © 2019 GDXL2012. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 控制器工具类
@interface XLViewControllerTools : NSObject
/**
 获取当前窗口rootViewController
 
 @return 当前窗口根视图
 */
+(UIViewController *)xlRootViewController;

/**
 获取当前窗口最上层viewcontroller
 
 @return 当前窗口顶部视图
 */
+(UIViewController *)xlTopViewController;

/**
 获取当前窗口最上层的模态视图：可能为nil
 
 @return nil 没有模态弹出页面
 */
+(UIViewController *)xlTopPresentViewController;
@end

NS_ASSUME_NONNULL_END
