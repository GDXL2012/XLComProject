//
//  XL3rdCoreHelper.m
//  XLComProject
//
//  Created by GDXL2012 on 2019/11/24.
//  Copyright © 2019 GDXL2012. All rights reserved.
//

#import "XL3rdCoreHelper.h"
#import <UIKit/UIKit.h>
#import "UIScrollView+XLMJRefresh.h"
#import "IQKeyboardManager.h"
#import "MBProgressHUD.h"

@implementation XL3rdCoreHelper
/**
 第三方库初始化配置
 */
+(void)em3rdCoreConfig{
    // 1.下拉刷新
    [UIScrollView exchangeHeaderFooterMethod];
    
    // 1.全局键盘监听：默认启动
    [XL3rdCoreHelper enableIQKeyBoard:YES];
    
    [UIActivityIndicatorView appearanceWhenContainedInInstancesOfClasses:@[[MBProgressHUD class]]].color = [UIColor whiteColor];
}

#pragma mark - IQKeyboardManager Setting
/**
 设置 开启/关闭 全局键盘监听
 */
+ (void)enableIQKeyBoard:(BOOL)enable{
    [IQKeyboardManager sharedManager].enable = enable;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = enable;
}

/**
 设置 开启/关闭 键盘上的工具条
 
 @param enable <#enable description#>
 */
+ (void)enableAutoToolbar:(BOOL)enable{
    [IQKeyboardManager sharedManager].enableAutoToolbar = enable;
}
@end
