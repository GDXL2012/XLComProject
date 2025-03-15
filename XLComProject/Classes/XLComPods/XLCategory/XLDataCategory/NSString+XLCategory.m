//
//  NSString+XLCategory.m
//  XLComProject
//
//  Created by GDXL2012 on 2019/11/24.
//  Copyright © 2019 GDXL2012. All rights reserved.
//

#import "NSString+XLCategory.h"
#import <CommonCrypto/CommonCrypto.h>
@implementation NSString (XLCategory)

// 字符串加密
-(NSString *)sha1String{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    memset(digest, 0x0, CC_SHA1_DIGEST_LENGTH);
    
    CC_SHA1(data.bytes, (CC_LONG)data.length, digest);
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * sizeof(unsigned char)];
    for (int index = 0; index < CC_SHA1_DIGEST_LENGTH; index ++) {
        [output appendFormat:@"%02x", digest[index]];
    }
    return output;
}

/// 返回安全字符：
/// @param string <#string description#>
+(NSString *)safeString:(NSString *)string{
    if ([NSString isEmptyString:string]) {
        return @"";
    } else {
        return string;
    }
}

/**
 根据Key获取国际化文本
 
 @param keyString key
 @return <#return value description#>
 */
+(NSString *)stringWithKey:(NSString *)keyString{
    return NSLocalizedString(keyString, keyString);
}

/**
 字符串所占区域
 
 @param font 字体
 @param maxSize 最大区域
 @param string 字符串
 @return 区域
 */
+(CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize string:(NSString *)string{
    if ([NSString isEmptyString:string]) {
        return CGSizeZero;
    }
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineBreakMode:NSLineBreakByWordWrapping];
    NSAttributedStringKey fontKey = NSFontAttributeName;
    NSAttributedStringKey styleKey = NSParagraphStyleAttributeName;
    NSDictionary *attributes = @{fontKey  : font,
                                 styleKey : paragraphStyle};
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin;
    CGRect rect = [string boundingRectWithSize:maxSize
                                       options:options
                                    attributes:attributes
                                       context:nil];
    return rect.size;
}

/**
 生成唯一UUID：非设备标识
 
 @return <#return value description#>
 */
+(NSString *)xlUUID{
    CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
    CFStringRef uuidStringRef = CFUUIDCreateString(kCFAllocatorDefault, uuidRef);
    NSString *uniqueId = (__bridge NSString *)(uuidStringRef);
    // release the uuidRef
    CFRelease(uuidRef);
    return uniqueId;
}

/**
 是否为空字符串：不过滤空格
 
 @param string <#string description#>
 @return <#return value description#>
 */
+(BOOL)isNilString:(NSString *)string{
    if (string == nil) {
        return YES;
    }
    if (string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    return NO;
}

/**
 是否为空字符串：不过滤空格, 字符串长度
 
 @param string <#string description#>
 @return <#return value description#>
 */
+(BOOL)isEmptyString:(NSString *)string{
    if ([NSString isNilString:string]) {
        return YES;
    }
    if (string.length == 0) {
        return YES;
    }
    return NO;
}

/**
 字符串是否为空
 
 @param string 目标字符串
 @return YES 空
 */
+ (BOOL)isEmpty:(NSString *)string{
    if ([NSString isNilString:string]) {
        return YES;
    }
    // 去除字符串两端空格
    if ([string isKindOfClass:[NSString class]] && [[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

/**
 手机号码过滤特殊字符
 
 @param phone <#phone description#>
 @return <#return value description#>
 */
+(NSString *)filterCharacterForPhone:(NSString *)phone{
    NSCharacterSet *setForRemoe = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    NSArray *characters = [phone componentsSeparatedByCharactersInSet:setForRemoe];
    phone = [characters componentsJoinedByString:@""];
    if ([phone hasPrefix:@"86"]) {
        phone = [phone substringFromIndex:2];
    } else if ([phone hasPrefix:@"+86"] || [phone hasPrefix:@"086"]) {
        phone = [phone substringFromIndex:3];
    } else if ([phone hasPrefix:@"0086"]) {
        phone = [phone substringFromIndex:4];
    }
    return phone;
}

/** 数字转字符串 */
+(NSString *)stringWithInt:(int)value{
    NSDecimalNumber *number = [NSDecimalNumber numberWithInt:value];
    return number.stringValue;
}
+(NSString *)stringWithLong:(long)value{
    NSDecimalNumber *number = [NSDecimalNumber numberWithLong:value];
    return number.stringValue;
}
+(NSString *)stringWithFloat:(float)value{
    NSDecimalNumber *number = [NSDecimalNumber numberWithFloat:value];
    return number.stringValue;
}

+(NSString *)stringWithFloat:(float)value decimal:(long)decimal{
    NSString *format = @"%f";
    if (decimal == 0) {
        format = @"%.0f";
    } else if (decimal == 1){
        format = @"%.1f";
    } else if (decimal == 2){
        format = @"%.2f";
    } else if (decimal == 3){
        format = @"%.3f";
    } else if (decimal == 4){
        format = @"%.4f";
    }
    return [NSString stringWithFormat:format, value];
}

+(NSString *)stringWithDouble:(double)value{
    // 避免显示无意义的0
    NSDecimalNumber *number = [NSDecimalNumber numberWithDouble:value];
    return number.stringValue;
}

+(NSString *)stringWithDouble:(double)value decimal:(long)decimal{
    NSString *format = @"%f";
    if (decimal == 0) {
        format = @"%.0f";
    } else if (decimal == 1){
        format = @"%.1f";
    } else if (decimal == 2){
        format = @"%.2f";
    } else if (decimal == 3){
        format = @"%.3f";
    } else if (decimal == 4){
        format = @"%.4f";
    }
    
    return [NSString stringWithFormat:format, value];
}

+(NSString *)stringWithInterger:(NSInteger)value{
    NSDecimalNumber *number = [NSDecimalNumber numberWithInteger:value];
    return number.stringValue;
}
+(NSString *)stringWithLongLong:(long long)value{
    NSDecimalNumber *number = [NSDecimalNumber numberWithLongLong:value];
    return number.stringValue;
}

// Base64互转
+(NSString *)base64ForString:(NSString *)string{
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    return [data base64EncodedStringWithOptions:0];
}

+(NSString *)encodeBase64FromString:(NSString *)string{
    NSData *nStr = [[NSData alloc] initWithBase64EncodedString:string options:0];
    NSString *encodeStr = [[NSString alloc]initWithData:nStr encoding:NSUTF8StringEncoding];
    return encodeStr;
}

// UTF-8
-(NSString *)addingPercentEncoding{
    return [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

-(NSString *)removingPercentEncoding{
    return [self stringByRemovingPercentEncoding];
}
@end
