//
//  UIViewController+XLToast.m
//  XLComProject
//
//  Created by GDXL2012 on 2019/11/27.
//  Copyright © 2019 GDXL2012. All rights reserved.
//

#import "UIViewController+XLToast.h"
#import "XLProgressHUDHelper.h"
#import "NSString+XLCategory.h"

@implementation UIViewController (XLToast)
#pragma mark - show tips
/**
 当前视图页面内显示提示信息
 @param toast 提示文本
 */
-(void)showToast:(NSString *)toast{
    [self showToast:toast inView:self.view];
}

/**
 在主窗口显示提示信息
 @param toast 提示文本
 */
-(void)showToastInWindow:(NSString *)toast{
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    [self showToast:toast inView:window];
}

/**
 在指定view中显示提示信息
 @param toast 提示信息
 @param view 指定视图view
 */
-(void)showToast:(NSString *)toast inView:(UIView *)view{
    [XLProgressHUDHelper toast:toast inView:view];
}

#pragma mark - show wait tips
/**
 显示等待框
 
 @param message 等待框提示语
 */
-(void)showWaitingMessage:(NSString *)message{
    [self hideWaitingMessage];
    [XLProgressHUDHelper waitInfo:message inView:self.view];
}
/**
 隐藏指定view中的等待框
 */
-(void)hideWaitingMessage {
    [XLProgressHUDHelper hidenHubFromView:self.view];
}

/**
 在当前window中显示等待框
 
 @param message 等待框信息
 */
-(void)showWaitingMessageInWindow:(NSString *)message{
    [XLProgressHUDHelper waitInfo:message];
}

/**
 从window中移除等待框
 */
-(void)hideWaitingMessageInWindow{
    [XLProgressHUDHelper hideHud];
}

#pragma mark - 显示弹框
-(void)showAlertMsg:(NSString *)msg actions:(NSArray<UIAlertAction *> *)array cancel:(UIAlertAction *)cancel{
    [self showAlertTitle:nil msg:msg actions:array cancel:cancel style:UIAlertControllerStyleAlert];
}
-(void)showAlertTitle:(NSString *)title msg:(NSString *)msg actions:(NSArray<UIAlertAction *> *)array cancel:(UIAlertAction *)cancel{
    [self showAlertTitle:title msg:msg actions:array cancel:cancel style:UIAlertControllerStyleAlert];
}

-(void)showAlertMsg:(NSString *)msg actionTitles:(NSArray<NSString *> *)titlesArray cancel:(NSString *)cancel{
    [self showAlertTitle:nil msg:msg actionTitles:titlesArray cancel:cancel style:UIAlertControllerStyleAlert];
}
-(void)showAlertTitle:(NSString *)title msg:(NSString *)msg actionTitles:(NSArray<NSString *> *)titlesArray cancel:(NSString *)cancel{
    [self showAlertTitle:title msg:msg actionTitles:titlesArray cancel:cancel style:UIAlertControllerStyleAlert];
}

// 点击事件:子类覆盖
-(void)alertViewClickAtIndex:(NSInteger)index{
    
}
-(void)alertViewCancelClick{
    
}

#pragma mark - 显示ActionSheet弹框
-(void)showActionSheetMsg:(NSString *)msg actions:(NSArray<UIAlertAction *> *)array cancel:(UIAlertAction *)cancel{
    [self showAlertTitle:nil msg:msg actions:array cancel:cancel style:UIAlertControllerStyleActionSheet];
}
-(void)showActionSheetTitle:(NSString *)title msg:(NSString *)msg actions:(NSArray<UIAlertAction *> *)array cancel:(UIAlertAction *)cancel{
    [self showAlertTitle:title msg:msg actions:array cancel:cancel style:UIAlertControllerStyleActionSheet];
}

-(void)showActionSheetMsg:(NSString *)msg actionTitles:(NSArray<NSString *> *)titlesArray cancel:(NSString *)cancel{
    [self showAlertTitle:nil msg:msg actionTitles:titlesArray cancel:cancel style:UIAlertControllerStyleActionSheet];
}
-(void)showActionSheetTitle:(NSString *)title msg:(NSString *)msg actionTitles:(NSArray<NSString *> *)titlesArray cancel:(NSString *)cancel{
    [self showAlertTitle:title msg:msg actionTitles:titlesArray cancel:cancel style:UIAlertControllerStyleActionSheet];
}

// 点击事件
-(void)actionSheetViewClickAtIndex:(NSInteger)index{
    
}
-(void)actionSheetViewCancelClick{
    
}

#pragma mark - 弹窗
-(void)showAlertTitle:(NSString *)title msg:(NSString *)msg actions:(NSArray<UIAlertAction *> *)array cancel:(UIAlertAction *)cancel style:(UIAlertControllerStyle)style{
    UIAlertController *alert = nil;
    alert = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:style];
    NSInteger count = array.count;
    for (NSInteger index = 0; index < count; index ++) {
        UIAlertAction *action = array[index];
        [alert addAction:action];
    }
    if (cancel) {
        [alert addAction:cancel];
    }
    UIViewController *topVC = self;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    [topVC presentViewController:alert animated:YES completion:nil];
}

-(void)showAlertTitle:(NSString *)title msg:(NSString *)msg actionTitles:(NSArray<NSString *> *)titlesArray cancel:(NSString *)cancel style:(UIAlertControllerStyle)style{
    UIAlertController *alert = nil;
    alert = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:style];
    NSInteger count = titlesArray.count;
    for (NSInteger index = 0; index < count; index ++) {
        NSString *actionTitle = titlesArray[index];
        UIAlertAction *action = nil;
        action = [UIAlertAction actionWithTitle:actionTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self alertViewClickAtIndex:index style:style];
        }];
        [alert addAction:action];
    }
    if (![NSString isEmpty:cancel]) {
        UIAlertAction *action = nil;
        action = [UIAlertAction actionWithTitle:cancel style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self alertViewCancelClickForStyle:style];
        }];
        [alert addAction:action];
    }
    UIViewController *topVC = self;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    [topVC presentViewController:alert animated:YES completion:nil];
}

// 点击事件
-(void)alertViewClickAtIndex:(NSInteger)index style:(UIAlertControllerStyle)style{
    if (style == UIAlertControllerStyleActionSheet) {
        [self actionSheetViewClickAtIndex:index];
    } else {
        [self alertViewClickAtIndex:index];
    }
}
-(void)alertViewCancelClickForStyle:(UIAlertControllerStyle)style{
    if (style == UIAlertControllerStyleActionSheet) {
        [self actionSheetViewCancelClick];
    } else {
        [self alertViewCancelClick];
    }
}

#pragma mark - UIAlertAction
-(UIAlertAction *)actionWithTitle:(NSString *)title handler:(void (^)(UIAlertAction *action))handler{
    UIAlertAction *action = nil;
    action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:handler];
    return action;
}

-(UIAlertAction *)cancelActionWithTitle:(NSString *)title{
    UIAlertAction *action = nil;
    action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleCancel handler:nil];
    return action;
}

-(UIAlertAction *)cancelActionWithTitle:(NSString *)title handler:(void (^)(UIAlertAction *action))handler{
    UIAlertAction *action = nil;
    action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleCancel handler:handler];
    return action;
}
@end
