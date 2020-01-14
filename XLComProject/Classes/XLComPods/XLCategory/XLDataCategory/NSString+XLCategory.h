//
//  NSString+XLCategory.h
//  XLComProject
//
//  Created by GDXL2012 on 2019/11/24.
//  Copyright © 2019 GDXL2012. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (XLCategory)
/// 返回安全字符：
/// @param string <#string description#>
+(NSString *)safeString:(NSString *)string;

/**
 根据Key获取国际化文本
 
 @param keyString key
 @return <#return value description#>
 */
+(NSString *)stringWithKey:(NSString *)keyString;

/**
 字符串所占区域
 
 @param font 字体
 @param maxSize 最大区域
 @param string 字符串
 @return 区域
 */
+(CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize string:(NSString *)string;

/**
 生成唯一UUID：非设备标识
 
 @return <#return value description#>
 */
+(NSString *)moUUID;

/**
 是否为空字符串：不过滤空格
 
 @param string <#string description#>
 @return <#return value description#>
 */
+(BOOL)isNilString:(NSString *)string;

/**
 是否为空字符串：不过滤空格, 只考虑字符串长度
 
 @param string <#string description#>
 @return <#return value description#>
 */
+(BOOL)isEmptyString:(NSString *)string;

/**
 字符串是否为空:过滤空格
 
 @param string 目标字符串
 @return YES 空
 */
+(BOOL)isEmpty:(NSString *)string;

/**
 手机号码过滤特殊字符
 
 @param phone <#phone description#>
 @return <#return value description#>
 */
+(NSString *)filterCharacterForPone:(NSString *)phone;

/** 数字转字符串 */
+(NSString *)stringWithInt:(int)value;
+(NSString *)stringWithLong:(long)value;
+(NSString *)stringWithFloat:(float)value;
// 只支持0-4位
+(NSString *)stringWithFloat:(float)value decimal:(long)decimal;
+(NSString *)stringWithDouble:(double)value;
// 只支持0-4位
+(NSString *)stringWithDouble:(double)value decimal:(long)decimal;
+(NSString *)stringWithInterger:(NSInteger)value;
+(NSString *)stringWithLongLong:(long long)value;

// Base64互转
+(NSString *)base64ForString:(NSString *)string;
+(NSString *)encodeBase64FromString:(NSString *)string;
@end

NS_ASSUME_NONNULL_END
