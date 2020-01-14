//
//  UIView+XLCategory.m
//  XLComProject
//
//  Created by GDXL2012 on 2019/11/26.
//  Copyright © 2019 GDXL2012. All rights reserved.
//

#import "UIView+XLCategory.h"
#import "XLMacroLayout.h"
#import "XLMacroColor.h"
#import "XLMacroFont.h"
#import "Masonry.h"
#import <objc/runtime.h>

@interface UIView (XLSepView)
@property (nonatomic, strong) UIView *xlSepView;            /// 分割线
@property (nonatomic, assign) CGFloat xlSepViewMargin;      /// 分割线间距
@end

@implementation UIView (XLSepView)
#pragma mark - SepView
static const char XLSepViewKey = '\0';
-(void)setXlSepView:(UIView *)xlSepView{
    if (xlSepView != self.xlSepView) {
        // 删除旧的，添加新的
        [self.xlSepView removeFromSuperview];
        // 存储新的
        objc_setAssociatedObject(self, &XLSepViewKey,
                                 xlSepView, OBJC_ASSOCIATION_RETAIN);
    }
}

-(UIView *)xlSepView{
    return objc_getAssociatedObject(self, &XLSepViewKey);
}

#pragma mark - Margin
static const char XLSepViewMarginKey = '\0';
-(void)setXlSepViewMargin:(CGFloat)xlSepViewMargin{
    if (xlSepViewMargin != self.xlSepViewMargin) {
        // 存储新的
        objc_setAssociatedObject(self, &XLSepViewKey,
                                 @(xlSepViewMargin), OBJC_ASSOCIATION_ASSIGN);
    }
}

-(CGFloat)xlSepViewMargin{
    NSNumber *number = objc_getAssociatedObject(self, &XLSepViewMarginKey);
    return [number floatValue];
}
@end

@implementation UIView (XLCategory)
#pragma mark - Common Method 工具方法
/**
 设置圆角
 
 @param radius 圆角
 */
-(void)setCornerRadius:(CGFloat)radius{
    self.layer.cornerRadius = radius;
    self.layer.masksToBounds = YES;
}

/**
 设置部分圆角
 
 @param corners 需要设置为圆角的角 UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerAllCorners
 @param radii 需要设置的圆角大小 例如 CGSizeMake(20.0f, 20.0f)
 */
- (void)addRoundedCorners:(UIRectCorner)corners
                withRadii:(CGSize)radii{
    UIBezierPath* rounded = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:radii];
    CAShapeLayer* shape = [[CAShapeLayer alloc] init];
    [shape setPath:rounded.CGPath];
    shape.backgroundColor = self.layer.backgroundColor;
    self.layer.mask = shape;
}

/**
 设置部分圆角
 
 @param corners 需要设置为圆角的角 UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerAllCorners
 @param radii 需要设置的圆角大小 例如 CGSizeMake(20.0f, 20.0f)
 @param rect 需要设置的圆角view的rect
 */
- (void)addRoundedCorners:(UIRectCorner)corners
                withRadii:(CGSize)radii
                 viewRect:(CGRect)rect{
    UIBezierPath* rounded = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corners cornerRadii:radii];
    CAShapeLayer* shape = [[CAShapeLayer alloc] init];
    [shape setPath:rounded.CGPath];
    self.layer.mask = shape;
}

#pragma mark - Separator View
/**
 设置底部非闭合分割线：默认"XLLayoutConfig xlHMargin"
 
 @return 分割线实例
 */
-(UIView *)showUnclosedSeparator{
    return [self showSeparatorMargin:XLHMargin];
}

/**
 显示底部底部分割线：左右间距为0
 
 @return 分割线实例
 */
-(UIView *)showSeparator{
    return [self showSeparatorMargin:0.0f];
}

/**
 设置底部分割线
 
 @param margin 边距
 @return 分割线实例
 */
-(UIView *)showSeparatorMargin:(CGFloat)margin{
    if (!self.xlSepView) {
        self.xlSepView = [[UIView alloc] init];
        self.xlSepView.backgroundColor = XLComSepColor;
        /// 分割线不添加到contentView上
        /// 当存在AccessoryView，因为可能会显示异常
        [self addSubview:self.xlSepView];
        [self.xlSepView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).offset(XLHMargin);
            make.right.mas_equalTo(self);
            make.bottom.mas_equalTo(self);
            make.height.mas_equalTo(XLCellSepHeight);
        }];
    } else {
        self.xlSepView.hidden = NO;
        if(self.xlSepViewMargin != margin){
            /// 需要更新边距
            [self.xlSepView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self).offset(XLHMargin);
                make.right.mas_equalTo(self);
                make.bottom.mas_equalTo(self);
                make.height.mas_equalTo(XLCellSepHeight);
            }];
        }
    }
    self.xlSepViewMargin = margin;
    return self.xlSepView;
}

/// 设置分割显示/隐藏
/// @param hidden <#hidden description#>
-(void)setSeparatorHidden:(BOOL)hidden{
    if (self.xlSepView) {
        self.xlSepView.hidden = hidden;
    } else if (!hidden){
        /// 显示分割线
        [self showUnclosedSeparator];
    }
}
@end
