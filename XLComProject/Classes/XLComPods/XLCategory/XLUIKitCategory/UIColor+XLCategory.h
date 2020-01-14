//
//  UIColor+XLCategory.h
//  XLComProject
//
//  Created by GDXL2012 on 2019/11/24.
//  Copyright © 2019 GDXL2012. All rights reserved.
//
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (XLCategory)
/**
 获取16进制颜色
 
 @param hexValue 16进制数值
 @return UIColor
 */
+ (instancetype)hexColor:(int)hexValue;

/**
 获取16进制颜色
 
 @param hexValue 16进制数值
 @param alpha 透明度 0.0f ~ 1.0f
 @return UIColor
 */
+(instancetype)hexColor:(int)hexValue alpha:(CGFloat)alpha;

/**
 获取16进制颜色
 
 @param string 16进制字符串【#XXXXXX】
 @return UIColor
 */
+ (instancetype)colorWithHexString:(NSString *)string;

/**
 获取16进制颜色
 
 @param string 16进制字符串【#XXXXXX】
 @param alpha 透明度 0.0f ~ 1.0f
 @return UIColor
 */
+ (instancetype)colorWithHexString:(NSString *)string alpha:(CGFloat)alpha;

#pragma mark - Dynamic Color iOS 13动态颜色
/// 自动动态颜色：即颜色自动简单反转
/// @param string <#string description#>
+ (instancetype)automaticDynamicColorHex:(NSString *)string API_AVAILABLE(ios(13.0), tvos(13.0)) API_UNAVAILABLE(watchos);
/// 自动动态颜色：即颜色自动简单反转
/// @param string <#string description#>
+ (instancetype)automaticDynamicColorHex:(NSString *)string alpha:(CGFloat)alpha API_AVAILABLE(ios(13.0), tvos(13.0)) API_UNAVAILABLE(watchos);
+ (instancetype)dynamicColorHex:(NSString *)light darkHex:(NSString *)dark API_AVAILABLE(ios(13.0), tvos(13.0)) API_UNAVAILABLE(watchos);
+ (instancetype)dynamicColorHex:(NSString *)light darkHex:(NSString *)dark alpha:(CGFloat)alpha API_AVAILABLE(ios(13.0), tvos(13.0)) API_UNAVAILABLE(watchos);
+ (instancetype)dynamicColor:(UIColor *)light dark:(UIColor *)dark API_AVAILABLE(ios(13.0), tvos(13.0)) API_UNAVAILABLE(watchos);
@end

NS_ASSUME_NONNULL_END
