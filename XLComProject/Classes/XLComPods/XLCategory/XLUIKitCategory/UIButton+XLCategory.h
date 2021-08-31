//
//  UIButton+XLCategory.h
//  XLComProject
//
//  Created by GDXL2012 on 2021/2/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (XLCategory)

-(void)xlButtonTitle:(nullable NSString *)title;
-(void)xlHButtonTitle:(nullable NSString *)hTitle;
-(void)xlAddButtonClick:(SEL)action target:(nullable id)target;

#pragma mark - 常规字体
-(void)xlThemFont:(CGFloat)fontSize;        /// 主题色字体配置
-(void)xlTitleFont:(CGFloat)fontSize;       /// 标题字体
-(void)xlSubTitleFont:(CGFloat)fontSize;    /// 副标题字体
-(void)xlDetailFont:(CGFloat)fontSize;      /// 详情字体
-(void)xlTipsFont:(CGFloat)fontSize;        /// 提醒字体
-(void)xlWarningFont:(CGFloat)fontSize;     /// 警告字体
-(void)xlPlaceholderFont:(CGFloat)fontSize; /// 占位符字体
-(void)xlOhterFont:(CGFloat)fontSize;       /// 其他颜色字体
-(void)xlWhiteFont:(CGFloat)fontSize;       /// 白色字体

#pragma mark - 高亮
-(void)xlHThemFont:(CGFloat)fontSize;        /// 主题色字体配置
-(void)xlHTitleFont:(CGFloat)fontSize;       /// 标题字体
-(void)xlHSubTitleFont:(CGFloat)fontSize;    /// 副标题字体
-(void)xlHDetailFont:(CGFloat)fontSize;      /// 详情字体
-(void)xlHTipsFont:(CGFloat)fontSize;        /// 提醒字体
-(void)xlHWarningFont:(CGFloat)fontSize;     /// 警告字体
-(void)xlHPlaceholderFont:(CGFloat)fontSize; /// 占位符字体
-(void)xlHOhterFont:(CGFloat)fontSize;       /// 其他颜色字体
-(void)xlHWhiteFont:(CGFloat)fontSize;       /// 白色字体

#pragma mark -  常规加粗
-(void)xlBThemFont:(CGFloat)fontSize;        /// 主题色字体配置
-(void)xlBTitleFont:(CGFloat)fontSize;       /// 标题字体
-(void)xlBSubTitleFont:(CGFloat)fontSize;    /// 副标题字体
-(void)xlBDetailFont:(CGFloat)fontSize;      /// 详情字体
-(void)xlBTipsFont:(CGFloat)fontSize;        /// 提醒字体
-(void)xlBWarningFont:(CGFloat)fontSize;     /// 警告字体
-(void)xlBPlaceholderFont:(CGFloat)fontSize; /// 占位符字体
-(void)xlBOhterFont:(CGFloat)fontSize;       /// 其他颜色字体
-(void)xlBWhiteFont:(CGFloat)fontSize;       /// 白色字体

#pragma mark - 加粗高亮
-(void)xlHBThemFont:(CGFloat)fontSize;        /// 主题色字体配置
-(void)xlHBTitleFont:(CGFloat)fontSize;       /// 标题字体
-(void)xlHBSubTitleFont:(CGFloat)fontSize;    /// 副标题字体
-(void)xlHBDetailFont:(CGFloat)fontSize;      /// 详情字体
-(void)xlHBTipsFont:(CGFloat)fontSize;        /// 提醒字体
-(void)xlHBWarningFont:(CGFloat)fontSize;     /// 警告字体
-(void)xlHBPlaceholderFont:(CGFloat)fontSize; /// 占位符字体
-(void)xlHBOhterFont:(CGFloat)fontSize;       /// 其他颜色字体
-(void)xlHBWhiteFont:(CGFloat)fontSize;       /// 白色字体
@end

NS_ASSUME_NONNULL_END
