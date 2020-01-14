//
//  UIViewController+XLToast.h
//  XLComProject
//
//  Created by GDXL2012 on 2019/11/27.
//  Copyright © 2019 GDXL2012. All rights reserved.
//
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (XLToast)
#pragma mark - show toast
/**
 当前视图页面内显示提示信息
 @param toast 提示文本
 */
-(void)showToast:(NSString *)toast;

/**
 在主窗口显示提示信息
 @param toast 提示文本
 */
-(void)showToastInWindow:(NSString *)toast;

/**
 在指定view中显示提示信息
 @param toast 提示信息
 @param view 指定视图view
 */
-(void)showToast:(NSString *)toast inView:(UIView *)view;

#pragma mark - show wait tips
/**
 显示等待框
 
 @param message 等待框提示语
 */
-(void)showWaitingMessage:(NSString *)message;

/**
 隐藏指定view中的等待框
 */
-(void)hideWaitingMessage;

/**
 在当前window中显示等待框
 
 @param message 等待框信息
 */
-(void)showWaitingMessageInWindow:(NSString *)message;

/**
 从window中移除等待框
 */
-(void)hideWaitingMessageInWindow;

#pragma mark - 显示Alert弹框
-(void)showAlertMsg:(NSString *)msg actions:(NSArray<UIAlertAction *> *)array cancel:(UIAlertAction *)cancel;
-(void)showAlertTitle:(NSString *)title msg:(NSString *)msg actions:(NSArray<UIAlertAction *> *)array cancel:(UIAlertAction *)cancel;

-(void)showAlertMsg:(NSString *)msg actionTitles:(NSArray<NSString *> *)titlesArray cancel:(NSString *)cancel;
-(void)showAlertTitle:(NSString *)title msg:(NSString *)msg actionTitles:(NSArray<NSString *> *)titlesArray cancel:(NSString *)cancel;

// 点击事件
-(void)alertViewClickAtIndex:(NSInteger)index;
-(void)alertViewCancelClick;

#pragma mark - 显示ActionSheet弹框
-(void)showActionSheetMsg:(NSString *)msg actions:(NSArray<UIAlertAction *> *)array cancel:(UIAlertAction *)cancel;
-(void)showActionSheetTitle:(NSString *)title msg:(NSString *)msg actions:(NSArray<UIAlertAction *> *)array cancel:(UIAlertAction *)cancel;

-(void)showActionSheetMsg:(NSString *)msg actionTitles:(NSArray<NSString *> *)titlesArray cancel:(NSString *)cancel;
-(void)showActionSheetTitle:(NSString *)title msg:(NSString *)msg actionTitles:(NSArray<NSString *> *)titlesArray cancel:(NSString *)cancel;

#pragma mark - UIAlertAction
-(UIAlertAction *)actionWithTitle:(NSString *)title handler:(void (^)(UIAlertAction *action))handler;
-(UIAlertAction *)cancelActionWithTitle:(NSString *)title;
-(UIAlertAction *)cancelActionWithTitle:(NSString *)title handler:(void (^)(UIAlertAction *action))handler;
// 点击事件
-(void)actionSheetViewClickAtIndex:(NSInteger)index;
-(void)actionSheetViewCancelClick;
@end

NS_ASSUME_NONNULL_END
