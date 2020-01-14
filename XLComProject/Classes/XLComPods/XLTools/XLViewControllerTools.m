//
//  XLViewControllerTools.m
//  XLComProject
//
//  Created by GDXL2012 on 2019/11/27.
//  Copyright © 2019 GDXL2012. All rights reserved.
//

#import "XLViewControllerTools.h"

@implementation XLViewControllerTools
/**
 *  获取当前窗口rootViewController
 *
 *  @return 当前窗口根视图
 */
+(UIViewController *)xlRootViewController {
    return [[UIApplication sharedApplication].delegate window].rootViewController;
}

/**
 *  获取当前窗口最上层viewcontroller
 *
 *  @return 当前窗口顶部视图
 */
+(UIViewController *)xlTopViewController {
    id rootViewController = [[UIApplication sharedApplication].delegate window].rootViewController;
    if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        // 导航控制器，获取控制器中最上层viewController
        UINavigationController *naVc = (UINavigationController *)rootViewController;
        rootViewController = naVc.topViewController;
        if([rootViewController isKindOfClass:[UITabBarController class]]){
            // TabBar控制器，获取当前选中viewController
            rootViewController = [(UITabBarController *)rootViewController selectedViewController];
            if ([rootViewController isKindOfClass:[UINavigationController class]]) {
                // 当前选中为导航控制器，获取控制器中最上层viewController
                UINavigationController *naVc = (UINavigationController *)rootViewController;
                return naVc.topViewController;
            } else {
                // 不是导航控制器，直接返回
                return ((UIViewController *)rootViewController);
            }
        } else {
            return naVc.topViewController;
        }
    } else if([rootViewController isKindOfClass:[UITabBarController class]]){
        // TabBar控制器，获取当前选中viewController
        rootViewController = [(UITabBarController *)rootViewController selectedViewController];
        if ([rootViewController isKindOfClass:[UINavigationController class]]) {
            // 当前选中为导航控制器，获取控制器中最上层viewController
            UINavigationController *naVc = (UINavigationController *)rootViewController;
            return naVc.topViewController;
        } else {
            // 不是导航控制器，直接返回
            return ((UIViewController *)rootViewController);
        }
    } else {
        // 不是导航控制器，直接返回
        return ((UIViewController *)rootViewController);
    }
}

/**
 获取当前窗口最上层的模态视图：可能为nil
 
 @return nil 没有模态弹出页面
 */
+(UIViewController *)xlTopPresentViewController{
    // 1.1 获取当前窗口最上层非模态视图
    UIViewController *topNonePresentVC = [XLViewControllerTools xlTopViewController];
    UIViewController *topPresentController = topNonePresentVC;
    // 1.2 遍历获取到最上层的模态视图
    while (topPresentController.presentedViewController) {
        topPresentController = topPresentController.presentedViewController;
    }
    // 1.3 视图窗与最上层是不一致
    if (topPresentController != topNonePresentVC) {
        if ([topPresentController isKindOfClass:[UINavigationController class]]) {
            return [(UINavigationController *)topPresentController topViewController];
        } else {
            return topPresentController;
        }
    } else {
        // 1.4 一致，没有模态视图弹出
        return nil;
    }
}
@end
