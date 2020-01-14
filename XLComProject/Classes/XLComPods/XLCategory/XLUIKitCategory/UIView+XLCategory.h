//
//  UIView+XLCategory.h
//  XLComProject
//
//  Created by GDXL2012 on 2019/11/26.
//  Copyright © 2019 GDXL2012. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (XLCategory)
/**
 设置圆角
 
 @param radius 圆角
 */
-(void)setCornerRadius:(CGFloat)radius;

/**
 设置部分圆角(绝对布局，View 已设置大小)
 
 @param corners 需要设置为圆角的角 UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerAllCorners
 @param radii 需要设置的圆角大小 例如 CGSizeMake(20.0f, 20.0f)
 */
- (void)addRoundedCorners:(UIRectCorner)corners
                withRadii:(CGSize)radii;

/**
 设置部分圆角(相对布局)
 
 @param corners 需要设置为圆角的角 UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerAllCorners
 @param radii 需要设置的圆角大小 例如 CGSizeMake(20.0f, 20.0f)
 @param rect 需要设置的圆角view的rect
 */
- (void)addRoundedCorners:(UIRectCorner)corners
                withRadii:(CGSize)radii
                 viewRect:(CGRect)rect;

#pragma mark - Separator View
/**
 设置底部非闭合分割线：默认"XLLayoutConfig xlHMargin"
 
 @return 分割线实例
 */
-(UIView *)showUnclosedSeparator;

/**
 显示底部底部分割线：左右间距为0
 
 @return 分割线实例
 */
-(UIView *)showSeparator;

/**
 设置底部分割线
 
 @param margin 边距
 @return 分割线实例
 */
-(UIView *)showSeparatorMargin:(CGFloat)margin;

/// 设置分割显示/隐藏
/// @param hidden <#hidden description#>
-(void)setSeparatorHidden:(BOOL)hidden;
@end

NS_ASSUME_NONNULL_END
