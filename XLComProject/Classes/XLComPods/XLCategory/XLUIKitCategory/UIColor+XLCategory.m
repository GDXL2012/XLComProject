//
//  UIColor+XLCategory.m
//  XLComProject
//
//  Created by GDXL2012 on 2019/11/24.
//  Copyright © 2019 GDXL2012. All rights reserved.
//

#import "UIColor+XLCategory.h"
#import "XLSystemMacro.h"

@implementation UIColor (XLCategory)
/**
 获取16进制颜色
 
 @param hexValue 16进制数值
 @return UIColor
 */
+ (instancetype)hexColor:(int)hexValue{
    return [UIColor hexColor:hexValue alpha:1.0f];
}

/**
 获取16进制颜色
 
 @param hexValue 16进制数值
 @param alpha 透明度 0.0f ~ 1.0f
 @return UIColor
 */
+ (UIColor *)hexColor:(int)hexValue alpha:(CGFloat)alpha {
    float red   = ((float)((hexValue & 0xFF0000) >> 16)) / 255.0;
    float green = ((float)((hexValue & 0xFF00) >> 8)) / 255.0;
    float blue  = ((float)(hexValue & 0xFF)) / 255.0;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

/**
 获取16进制颜色
 
 @param string 16进制字符串【#XXXXXX】
 @return UIColor
 */
+ (instancetype)colorWithHexString:(NSString *)string{
    return [UIColor colorWithHexString:string alpha:1.0f];
}

/**
 获取16进制颜色
 
 @param string 16进制字符串【#XXXXXX】
 @param alpha 透明度 0.0f ~ 1.0f
 @return UIColor
 */
+ (instancetype)colorWithHexString:(NSString *)string alpha:(CGFloat)alpha {
    // 去除首尾的空格
    string = [[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // 字符串必须是6位以上
    if ([string length] < 6) {
        return [UIColor clearColor];
    }
    
    // 去除【0X】【#】标识位
    if ([string hasPrefix:@"0X"]) {
        string = [string substringFromIndex:2];
    }
    if ([string hasPrefix:@"#"]) {
        string = [string substringFromIndex:1];
    }
    // 再次判断字符串长度是否符合
    if ([string length] != 6) {
        return [UIColor clearColor];
    }
    // 分割RGB色值：每两位为一个色值
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [string substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [string substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [string substringWithRange:range];
    
    // 扫描字符串并转换16进制为10进制
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:alpha];
}

#pragma mark - Dynamic Color iOS 13动态颜色
/// 自动动态颜色：即颜色自动简单反转
/// @param string <#string description#>
+ (instancetype)automaticDynamicColorHex:(NSString *)string API_AVAILABLE(ios(13.0), tvos(13.0)) API_UNAVAILABLE(watchos){
    return [UIColor automaticDynamicColorHex:string alpha:1.0f];
}

/// 自动动态颜色：即颜色自动简单反转
/// @param string <#string description#>
+ (instancetype)automaticDynamicColorHex:(NSString *)string alpha:(CGFloat)alpha API_AVAILABLE(ios(13.0), tvos(13.0)) API_UNAVAILABLE(watchos){
    // 去除首尾的空格
    string = [[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // 字符串必须是6位以上
    if ([string length] < 6) {
        return [UIColor clearColor];
    }
    
    // 去除【0X】【#】标识位
    if ([string hasPrefix:@"0X"]) {
        string = [string substringFromIndex:2];
    }
    if ([string hasPrefix:@"#"]) {
        string = [string substringFromIndex:1];
    }
    // 再次判断字符串长度是否符合
    if ([string length] != 6) {
        return [UIColor clearColor];
    }
    // 分割RGB色值：每两位为一个色值
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [string substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [string substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [string substringWithRange:range];
    
    // 扫描字符串并转换16进制为10进制
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    UIColor *lightColor = [UIColor colorWithRed:((float) r / 255.0f)
                                          green:((float) g / 255.0f)
                                           blue:((float) b / 255.0f)
                                          alpha:alpha];
    UIColor *darkColor = [UIColor colorWithRed:((float) (255.0f - r) / 255.0f)
                                         green:((float) (255.0f - g) / 255.0f)
                                          blue:((float) (255.0f - b) / 255.0f)
                                         alpha:alpha];
    return [UIColor dynamicColor:lightColor dark:darkColor];
}

+ (instancetype)dynamicColorHex:(NSString *)light darkHex:(NSString *)dark  API_AVAILABLE(ios(13.0), tvos(13.0)) API_UNAVAILABLE(watchos){
    UIColor *lightColor = [UIColor colorWithHexString:light];
    UIColor *darkColor = [UIColor colorWithHexString:dark];
    return [UIColor dynamicColor:lightColor dark:darkColor];
}

/// 获取动态颜色
/// @param light 传入nil或者
/// @param dark <#dark description#>
/// @param alpha <#alpha description#>
+ (instancetype)dynamicColorHex:(NSString *)light darkHex:(NSString *)dark alpha:(CGFloat)alpha  API_AVAILABLE(ios(13.0), tvos(13.0)) API_UNAVAILABLE(watchos){
    UIColor *lightColor = [UIColor colorWithHexString:light alpha:alpha];
    UIColor *darkColor = [UIColor colorWithHexString:dark alpha:alpha];
    return [UIColor dynamicColor:lightColor dark:darkColor];
}

/// 动态颜色
/// @param lightColor <#lightColor description#>
/// @param darkColor <#darkColor description#>
+ (instancetype)dynamicColor:(UIColor *)lightColor dark:(UIColor *)darkColor  API_AVAILABLE(ios(13.0), tvos(13.0)) API_UNAVAILABLE(watchos){
    if (darkColor == nil || lightColor == nil) {
        return lightColor;
    }
    UIColor *dyColor = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
        if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleLight) {
            return lightColor;
        } else {
            return darkColor;
        }
    }];
    return dyColor;
}
@end
