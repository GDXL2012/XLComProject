//
//  XLColorConfig.h
//  XLComProject
//
//  Created by GDXL2012 on 2019/11/22.
//  Copyright © 2019 GDXL2012. All rights reserved.
//

#import "XLBaseConfig.h"
#import <UIKit/UIKit.h>

@interface XLColorConfig : XLBaseConfig
/// 主题色：默认@"#FFFFFF"
@property (nonatomic, strong) UIColor *xlThemeColor;
/// 适配iOS 13 适配深色模式：使用该方法color与darkColor请不要使用动态颜色
/// @param color <#color description#>
/// @param darkColor <#darkColor description#>
-(void)setXlThemColor:(UIColor *)color dark:(UIColor *)darkColor;

/// 导航栏颜色：默认"#030303"
@property (nonatomic, strong) UIColor *xlBarTitleColor;
-(void)setXlBarTitleColor:(UIColor *)xlBarTitleColor dark:(UIColor *)darkColor;

/// 导航栏颜色：xlBarTitleColor
@property (nonatomic, strong) UIColor *xlBarItemColor;
-(void)setXlBarItemColor:(UIColor *)xlBarItemColor dark:(UIColor *)darkColor;

/// 背景颜色：默认"#F6F6F6"
@property (nonatomic, strong) UIColor *xlComBGColor;
-(void)setXlComBGColor:(UIColor *)xlComBGColor dark:(UIColor *)darkColor;

/// 内容背景颜色：默认"#FFFFFF"
@property (nonatomic, strong) UIColor *xlContBGColor;
-(void)setXlContBGColor:(UIColor *)xlContBGColor dark:(UIColor *)darkColor;

/// 内容分割背景颜色：默认"#F6F6F6"
@property (nonatomic, strong) UIColor *xlContSepColor;
-(void)setXlContSepColor:(UIColor *)xlContSepColor dark:(UIColor *)darkColor;

/// 分割线颜色：默认"#E6E6E6"
@property (nonatomic, strong) UIColor *xlComSepColor;
-(void)setXlComSepColor:(UIColor *)xlComSepColor dark:(UIColor *)darkColor;

/// 标题颜色：默认"#333333"
@property (nonatomic, strong) UIColor *xlTitleColor;
-(void)setXlTitleColor:(UIColor *)xlTitleColor dark:(UIColor *)darkColor;

/// 副标题颜色：默认"#999999"
@property (nonatomic, strong) UIColor *xlSubTitleColor;
-(void)setXlSubTitleColor:(UIColor *)xlSubTitleColor dark:(UIColor *)darkColor;

/// 详情颜色：默认"#333333"
@property (nonatomic, strong) UIColor *xlDetailColor;
-(void)setXlDetailColor:(UIColor *)xlDetailColor dark:(UIColor *)darkColor;

/// 提示语颜色：默认"#999999"
@property (nonatomic, strong) UIColor *xlTipsColor;
-(void)setXlTipsColor:(UIColor *)xlTipsColor dark:(UIColor *)darkColor;

/// 提醒、警示语颜色"#FA5151"
@property (nonatomic, strong) UIColor *xlWarningColor;
-(void)setXlWarningColor:(UIColor *)xlWarningColor dark:(UIColor *)darkColor;

/// 占位符颜色：默认"#999999"
@property (nonatomic, strong) UIColor *xlHolderColor;
-(void)setXlHolderColor:(UIColor *)xlHolderColor dark:(UIColor *)darkColor;

/// 其他信息颜色：时间等 默认"#999999"
@property (nonatomic, strong) UIColor *xlOtherColor;
-(void)setXlOtherColor:(UIColor *)xlOtherColor dark:(UIColor *)darkColor;

#pragma mark - Ext Color
-(UIColor *)xlExtColorForKey:(NSString *)key;

/// 设置扩展颜色
/// @param key 颜色key值
/// @param color color description
-(void)setXLExtColorForKey:(NSString *)key color:(UIColor *)color;

/// 设置扩展颜色
/// @param key 颜色key值
/// @param light 默认模式颜色
/// @param darkColor 深色模式
-(void)setXLExtColorForKey:(NSString *)key light:(UIColor *)light dark:(UIColor *)darkColor;

@end
