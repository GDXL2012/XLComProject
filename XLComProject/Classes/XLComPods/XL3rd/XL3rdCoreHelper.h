//
//  XL3rdCoreHelper.h
//  XLComProject
//
//  Created by GDXL2012 on 2019/11/24.
//  Copyright © 2019 GDXL2012. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XL3rdCoreHelper : NSObject
/**
 第三方库初始化配置
 */
+(void)em3rdCoreConfig;

#pragma mark - IQKeyboardManager Setting
/**
 设置 开启/关闭 全局键盘监听
 */
+ (void)enableIQKeyBoard:(BOOL)enable;

/**
 设置 开启/关闭 键盘上的工具条
 
 @param enable <#enable description#>
 */
+ (void)enableAutoToolbar:(BOOL)enable;
@end

NS_ASSUME_NONNULL_END
