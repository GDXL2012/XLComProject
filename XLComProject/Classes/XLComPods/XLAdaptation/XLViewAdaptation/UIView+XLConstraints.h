//
//  UIView+XLConstraints.h
//  XLComProject
//
//  Created by GDXL2012 on 2019/11/24.
//  Copyright © 2019 GDXL2012. All rights reserved.
//
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (XLConstraints)
/**
 设置约束条件
 
 @param view <#view description#>
 */
-(void)makeConstraintsWithView:(UIView *)view;

/**
 设置约束条件：不考虑安全域
 
 @param view <#view description#>
 */
-(void)makeUnsafeConstraintsWithView:(UIView *)view;

/**
 设置约束条件
 
 @param view <#view description#>
 */
-(void)makeConstraintsWithView:(UIView *)view edge:(UIEdgeInsets)insets;

/**
 设置约束条件：顶部
 
 @param view <#view description#>
 @param height <#view description#>
 */
-(void)makeConstraintsWithView:(UIView *)view height:(CGFloat)height;

/**
 设置约束条件：底部
 
 @param view <#view description#>
 @param height <#view description#>
 */
-(void)makeConstraintsWithViewBottom:(UIView *)view height:(CGFloat)height;

/**
 设置约束条件：顶部
 
 @param view <#view description#>
 @param ratio 宽高比
 */
-(void)makeConstraintsWithView:(UIView *)view ratio:(CGFloat)ratio;

/**
 设置约束条件：底部
 
 @param view <#view description#>
 @param ratio 宽高比
 */
-(void)makeConstraintsWithViewBottom:(UIView *)view ratio:(CGFloat)ratio;

/**
 设置约束条件
 
 @param view 父View
 @param header 头部
 @param bottom 底部
 */
-(void)makeConstraintsWithView:(UIView *)view header:(UIView *)header bottom:(UIView *)bottom;

/**
 设置约束条件
 
 @param view <#view description#>
 */
-(void)makeUnsafeConstraintsWithView:(UIView *)view edge:(UIEdgeInsets)insets;

/**
 设置约束条件：顶部
 
 @param view <#view description#>
 @param height <#view description#>
 */
-(void)makeUnsafeConstraintsWithView:(UIView *)view height:(CGFloat)height;

/**
 设置约束条件：底部
 
 @param view <#view description#>
 @param height <#view description#>
 */
-(void)makeUnsafeConstraintsWithViewBottom:(UIView *)view height:(CGFloat)height;

/**
 设置约束条件：顶部
 
 @param view <#view description#>
 @param ratio 宽高比
 */
-(void)makeUnsafeConstraintsWithView:(UIView *)view ratio:(CGFloat)ratio;

/**
 设置约束条件：底部
 
 @param view <#view description#>
 @param ratio 宽高比
 */
-(void)makeUnsafeConstraintsWithViewBottom:(UIView *)view ratio:(CGFloat)ratio;

/**
 设置约束条件
 
 @param view 父View
 @param header 头部
 @param bottom 底部
 */
-(void)makeUnsafeConstraintsWithView:(UIView *)view header:(UIView *)header bottom:(UIView *)bottom;

/// 设置View抗压缩
-(void)setContentCompressionHugging;
/// 设置view横向抗压缩
-(void)setContentHorCompressionHugging;
/// 设置view纵向抗压缩
-(void)setContentVerCompressionHugging;
@end

NS_ASSUME_NONNULL_END
