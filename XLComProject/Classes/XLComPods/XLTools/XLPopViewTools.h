//
//  XLPopViewTools.h
//  XLComProject
//
//  Created by GDXL2012 on 2019/11/27.
//  Copyright © 2019 GDXL2012. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
/**
弹窗通用辅助类
*/
@interface XLPopViewTools : NSObject
/**
 Windon主窗口中显示弹窗

 @param view 被弹出View
 */
+(void)showPopViewInWindow:(UIView *)view;

/**
 指定窗口中弹窗

 @param popView 弹窗
 @param superView 目标View
 */
+(void)showPopView:(UIView *)popView inView:(UIView *)superView;
@end

NS_ASSUME_NONNULL_END
