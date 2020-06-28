//
//  XLComCheckTools.h
//  XLComProject
//
//  Created by GDXL2012 on 2019/11/27.
//  Copyright © 2019 GDXL2012. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 规则类型
typedef NS_ENUM(NSInteger, XLPredicateRegexType){
    XLPredicateRegexPassword,
    XLPredicateRegexAccount,
    XLPredicateRegexMobile,
    XLPredicateRegexTel,       /// 座机
    XLPredicateRegexEmail,
    XLPredicateRegexIdCard     /// 身份证
};

/// 通用校验方法
@interface XLComCheckTools : NSObject

/// 注入正则匹配格式
/// @param Regex <#Regex description#>
/// @param regexType <#regexType description#>
+(void)injectioRegex:(NSString *)Regex type:(XLPredicateRegexType)regexType;

/// 字符串正则表达式匹配
/// @param string <#string description#>
/// @param regex <#regex description#>
+(BOOL)predicateString:(NSString *)string regex:(NSString *)regex;

/**
 是否是数字

 @param string <#string description#>
 @return <#return value description#>
 */
+(BOOL)isNumber:(NSString *)string;

/**
 校验账号是否合法
 
 @param account 待校验账号
 @return YES 账号验证通过  NO 账号校验不通过
 */
+(BOOL)checkAccount:(NSString *)account error:(NSError **)error;

/**
 校验密码是否合法
 
 @param password 待校验账号
 @param error 校验不通过时改值不为空
 @return YES 账号验证通过  NO 账号校验不通过
 */
+(BOOL)checkPassword:(NSString *)password error:(NSError **)error;

/**
 校验密码格式是否错误
 
 @param password 待校验密码
 @return YES 格式正确 NO 格式错误
 */
+(BOOL)isPasswordFormat:(NSString *)password;

/**
 校验字符串是否为手机号
 
 @param mobile 待校验字符串
 @return YES 手机号  NO 非手机号
 */
+(BOOL)isMobileNumber:(NSString *)mobile;

/**
 校验字符串是否为座机号码

 @param phone 带校验字符串
 @return YES 座机号  NO 非座机号
 */
+(BOOL)isTelephone:(NSString *)phone;

/**
 校验字符串是否为号码：手机号/座机号

 @param phone 带校验字符串
 @return YES 手机号/座机号号  NO 非号码
 */
+(BOOL)isPhoneNumber:(NSString *)phone;

/**
 邮箱验证

 @param email 待验证字符串
 @return YES 邮箱 NO 非邮箱
 */
+(BOOL)isEmailString:(NSString *)email;

/**
 身份证验证

 @param card 待验证字符串
 @return YES 身份证 NO 非身份证
 */
+(BOOL)isIdentityCard:(NSString *)card;
@end

NS_ASSUME_NONNULL_END
