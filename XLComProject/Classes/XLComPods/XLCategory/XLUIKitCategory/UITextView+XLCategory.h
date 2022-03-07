//
//  UITextView+XLCategory.h
//  XLComProject
//
//  Created by GDXL2012 on 2019/11/27.
//  Copyright © 2019 GDXL2012. All rights reserved.
//
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextView (XLCategory)

#pragma mark - 常规字体
-(void)xlThemeFont:(CGFloat)fontSize;        /// 主题色字体配置
-(void)xlTitleFont:(CGFloat)fontSize;       /// 标题字体
-(void)xlSubTitleFont:(CGFloat)fontSize;    /// 副标题字体
-(void)xlDetailFont:(CGFloat)fontSize;      /// 详情字体
-(void)xlTipsFont:(CGFloat)fontSize;        /// 提醒字体
-(void)xlWarningFont:(CGFloat)fontSize;     /// 警告字体
-(void)xlPlaceholderFont:(CGFloat)fontSize; /// 占位符字体
-(void)xlOhterFont:(CGFloat)fontSize;       /// 其他颜色字体
-(void)xlWhiteFont:(CGFloat)fontSize;       /// 白色字体

#pragma mark -  加粗
-(void)xlBThemeFont:(CGFloat)fontSize;        /// 主题色字体配置
-(void)xlBTitleFont:(CGFloat)fontSize;       /// 标题字体
-(void)xlBSubTitleFont:(CGFloat)fontSize;    /// 副标题字体
-(void)xlBDetailFont:(CGFloat)fontSize;      /// 详情字体
-(void)xlBTipsFont:(CGFloat)fontSize;        /// 提醒字体
-(void)xlBWarningFont:(CGFloat)fontSize;     /// 警告字体
-(void)xlBPlaceholderFont:(CGFloat)fontSize; /// 占位符字体
-(void)xlBOhterFont:(CGFloat)fontSize;       /// 其他颜色字体
-(void)xlBWhiteFont:(CGFloat)fontSize;       /// 白色字体
@end

NS_ASSUME_NONNULL_END
