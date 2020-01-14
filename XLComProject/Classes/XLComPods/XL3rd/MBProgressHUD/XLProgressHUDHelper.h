//
//  XLProgressHUDHelper.h
//  XLComProject
//
//  Created by GDXL2012 on 2019/11/24.
//  Copyright © 2019 GDXL2012. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XLProgressHUDHelper : NSObject
#pragma mark - Toast
/**
 显示提示信息
 
 @param toast <#toast description#>
 */
+(void)toast:(NSString *)toast;

/**
 指定View上显示提示信息
 
 @param toast <#toast description#>
 @param view <#view description#>
 */
+(void)toast:(NSString *)toast inView:(UIView *)view;

#pragma mark - Waiting
/**
 window显示等待框
 
 @param tips <#tips description#>
 */
+(void)waitInfo:(NSString *)tips;

/**
 window上移除等待框
 */
+(void)hideHud;

/**
 view上显示等待框
 
 @param tips <#tips description#>
 @param view <#view description#>
 */
+(void)waitInfo:(NSString *)tips inView:(UIView *)view;

/**
 从view上移除等待框
 
 @param view <#view description#>
 */
+(void)hidenHubFromView:(UIView *)view;
@end

NS_ASSUME_NONNULL_END
