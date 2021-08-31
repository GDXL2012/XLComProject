//
//  XLComCheckTools.m
//  XLComProject
//
//  Created by GDXL2012 on 2019/11/27.
//  Copyright © 2019 GDXL2012. All rights reserved.
//

#import "XLComCheckTools.h"
#import "NSString+XLCategory.h"
#import "NSError+XLCategory.h"
#import "XLComMacro.h"

#define XLPredRegexPreKey           @"XLPredicateRegexKey_"

@implementation XLComCheckTools

/// <#Description#>
/// @param regexType <#regexType description#>
+(NSString *)regexKeyForType:(XLPredicateRegexType)regexType{
    NSString *string = [NSString stringWithInterger:regexType];
    return [XLPredRegexPreKey stringByAppendingString:string];
}

/// 注入正则匹配格式
/// @param Regex <#Regex description#>
/// @param regexType <#regexType description#>
+(void)injectioRegex:(NSString *)regex type:(XLPredicateRegexType)regexType{
    NSString *key = [XLComCheckTools regexKeyForType:regexType];
    [XLUserDefaults setValue:regex forKey:key];
    [XLUserDefaults synchronize];
}

/// 获取正则表达式
/// @param regexType <#regexType description#>
+(NSString *)regexStringWithType:(XLPredicateRegexType)regexType{
    NSString *key = [XLComCheckTools regexKeyForType:regexType];
    NSString *regex = [XLUserDefaults valueForKey:key];
    if ([NSString isEmpty:regex]) {
        switch (regexType) {
            case XLPredicateRegexPassword:
                regex = @"^[a-z0-9]{6,18}$";
                break;
            case XLPredicateRegexAccount: /// 默认按手机号处理
                regex = @"^(1[0-9][0-9])+\\d{8}$";
                break;
            case XLPredicateRegexMobile:
                regex = @"^(1[0-9][0-9])+\\d{8}$";
                break;
            case XLPredicateRegexTel:
                regex = @"^(0[0-9]{2,3})?([2-9][0-9]{6,7})+(-[0-9]{1,4})?$|(^(0[0-9]{2,3}-)?([2-9][0-9]{6,7})+(-[0-9]{1,4})?$)";
                break;
            case XLPredicateRegexEmail:
                regex = @"[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
                break;
            case XLPredicateRegexIdCard:
                regex = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
                break;
            default:
                break;
        }
    }
    return regex;
}

/// 字符串正则表达式匹配
/// @param string <#string description#>
/// @param regex <#regex description#>
+(BOOL)predicateString:(NSString *)string regex:(NSString *)regex{
    if (string.length == 0 || regex.length == 0) {
        return NO;
    }
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pred evaluateWithObject:string];
}

/**
 是否是数字
 
 @param string <#string description#>
 @return <#return value description#>
 */
+(BOOL)isNumber:(NSString *)string{
    NSString *regex = @"[0-9]*";
    return [XLComCheckTools predicateString:string regex:regex];
}

/// 整形判断(整形返回yes ,否则为no)
+(BOOL)isPureInt:(NSString *)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

/// 浮点形判断(整形/浮点型等数字均会返回YES,其他为NO):
+(BOOL)isPureFloat:(NSString *)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return [scan scanFloat:&val] && [scan isAtEnd];
}

/**
 校验账号是否合法
 
 @param account 待校验账号
 @param error 校验不通过时改值不为空
 @return YES 账号验证通过  NO 账号校验不通过
 */
+(BOOL)checkAccount:(NSString *)account error:(NSError **)error{
    if ([NSString isEmptyString:account]) {
        *error = [NSError errorWithCode:XLErrorMobileNumberEmpty];
        return NO;
    } else if (![XLComCheckTools checkAccount:account]){
        *error = [NSError errorWithCode:XLErrorInvalidAccount];
        return NO;
    }
    return YES;
}

/**
 校验账号是否合法
 
 @param account 待校验账号
 @return YES 账号验证通过  NO 账号校验不通过
 */
+(BOOL)checkAccount:(NSString *)account{
    NSString *regex = [XLComCheckTools regexStringWithType:XLPredicateRegexAccount];
    return [XLComCheckTools predicateString:account regex:regex];
}

/**
 校验密码是否合法
 
 @param password 待校验账号
 @param error 校验不通过时改值不为空
 @return YES 账号验证通过  NO 账号校验不通过
 */
+(BOOL)checkPassword:(NSString *)password error:(NSError **)error{
    if ([NSString isEmpty:password]) {
        *error = [NSError errorWithCode:XLErrorPasswordEmpty];
        return NO;
    } else if (![XLComCheckTools isPasswordFormat:password]){
        *error = [NSError errorWithCode:XLErrorPasswordFormat];
        return NO;
    }
    return YES;
}

/**
 校验密码格式是否错误

 @param password 待校验密码
 @return YES 格式正确 NO 格式错误
 */
+(BOOL)isPasswordFormat:(NSString *)password{
    NSString *regex = [XLComCheckTools regexStringWithType:XLPredicateRegexPassword];
    return [XLComCheckTools predicateString:password regex:regex];
}

/**
 校验字符串是否为手机号

 @param mobile 待校验字符串
 @return YES 手机号  NO 非手机号
 */
+(BOOL)isMobileNumber:(NSString *)mobile{
    /// 过滤特殊字符
    mobile = [NSString filterCharacterForPhone:mobile];
    if (mobile.length != 11) {
        return NO;
    }
    NSString *regex = [XLComCheckTools regexStringWithType:XLPredicateRegexMobile];
    return [XLComCheckTools predicateString:mobile regex:regex];
}

/**
 校验字符串是否为座机号码
 
 @param phone 带校验字符串
 @return YES 座机号  NO 非座机号
 */
+(BOOL)isTelephone:(NSString *)phone{
    //验证输入的固话中不带"-"与带"-"符号
    NSString *regex = [XLComCheckTools regexStringWithType:XLPredicateRegexTel];
    return [XLComCheckTools predicateString:phone regex:regex];
}

/**
 校验字符串是否为号码：手机号/座机号
 
 @param phone 带校验字符串
 @return YES 手机号/座机号号  NO 非号码
 */
+(BOOL)isPhoneNumber:(NSString *)phone{
    //验证输入的固话中不带"-"与带"-"符号
    NSString *regex = [XLComCheckTools regexStringWithType:XLPredicateRegexMobile];
    if ([XLComCheckTools predicateString:phone regex:regex]) {
        return YES;
    } else {
        regex = [XLComCheckTools regexStringWithType:XLPredicateRegexTel];
        return [XLComCheckTools predicateString:phone regex:regex];
    }
}

/**
 邮箱验证
 
 @param email 待验证字符串
 @return YES 邮箱 NO 非邮箱
 */
+(BOOL)isEmailString:(NSString *)email{
    NSString *regex = [XLComCheckTools regexStringWithType:XLPredicateRegexEmail];
    return [XLComCheckTools predicateString:email regex:regex];
}

/**
 身份证验证
 
 @param card 待验证字符串
 @return YES 身份证 NO 非身份证
 */
+(BOOL)isIdentityCard:(NSString *)card{
    NSString *regex = [XLComCheckTools regexStringWithType:XLPredicateRegexIdCard];
    return [XLComCheckTools predicateString:card regex:regex];
}
@end
