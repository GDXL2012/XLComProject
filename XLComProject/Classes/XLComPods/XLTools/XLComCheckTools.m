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

@implementation XLComCheckTools
/**
 是否是数字
 
 @param string <#string description#>
 @return <#return value description#>
 */
+(BOOL)isNumber:(NSString *)string{
    if (string.length == 0) {
        return NO;
    }
    NSString *regex = @"[0-9]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if ([pred evaluateWithObject:string]) {
        return YES;
    }
    return NO;
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
    } else if (![XLComCheckTools isMobileNumber:account]){
        *error = [NSError errorWithCode:XLErrorMobileNumberInvalid];
        return NO;
    }
    return YES;
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
    NSString *passwordNUM = @"^[a-z0-9]{6,18}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passwordNUM];
    if ([pred evaluateWithObject:password]) {
        return YES;
    }
    return NO;
}

/**
 获取移动运营商
 移动
 139、138、137、136、135、134、159、158、157、150、151、152、
 147（数据卡）、188、187、182、183、184、178
 联通
 130、131、132、156、155、186、185、145（数据卡）、176
 电信
 133、153、189、180、181、177、173（待放）
 
 前3位是网络识别号 ,  4-7位是地区编码 ,  8-11位是用户号码
 @param mobile 号码
 @return 移动、联通、电信、其他则为空@""
 */
+(NSString *)mobileCarriers:(NSString *)mobile{
    /**
     * 移动号段正则表达式
     */
    NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
    if ([pred evaluateWithObject:mobile]) {
        return @"中国移动";
    }
    
    /**
     * 联通号段正则表达式
     */
    NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
    pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
    if([pred evaluateWithObject:mobile]){
        return @"中国联通";
    }
    
    /**
     * 电信号段正则表达式
     */
    NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
    pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
    if([pred evaluateWithObject:mobile]){
        return @"中国电信";
    }
    
    return @"";
}

/**
 校验字符串是否为手机号

 @param mobile 待校验字符串
 @return YES 手机号  NO 非手机号
 */
+(BOOL)isMobileNumber:(NSString *)mobile{
    /// 过滤特殊字符
    mobile = [NSString filterCharacterForPone:mobile];
    if (mobile.length != 11) {
        return NO;
    }
    NSString *MOBILE = @"^(1[0-9][0-9])+\\d{8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    BOOL res = [regextestmobile evaluateWithObject:mobile];
    if (res) {
        return YES;
    } else {
        return NO;
    }
}

/**
 校验字符串是否为座机号码
 
 @param phone 带校验字符串
 @return YES 座机号  NO 非座机号
 */
+(BOOL)isTelephone:(NSString *)phone{
    //验证输入的固话中不带"-"与带"-"符号
    NSString *strNum = @"^(0[0-9]{2,3})?([2-9][0-9]{6,7})+(-[0-9]{1,4})?$|(^(0[0-9]{2,3}-)?([2-9][0-9]{6,7})+(-[0-9]{1,4})?$)";
    NSPredicate *checktest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", strNum];
    return [checktest evaluateWithObject:phone];
}

/**
 校验字符串是否为号码：手机号/座机号
 
 @param phone 带校验字符串
 @return YES 手机号/座机号号  NO 非号码
 */
+(BOOL)isPhoneNumber:(NSString *)phone{
    //验证输入的固话中不带"-"与带"-"符号
    NSString *strNum = @"^(0[0-9]{2,3})?([2-9][0-9]{6,7})+(-[0-9]{1,4})?$|(^(0[0-9]{2,3}-)?([2-9][0-9]{6,7})+(-[0-9]{1,4})?$)|(^(0|86|17951)?(13[0-9]|15[012356789]|17[0678]|18[0-9]|14[57])[0-9]{8}$)";
    NSPredicate *checktest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", strNum];
    return [checktest evaluateWithObject:phone];
}

/**
 邮箱验证
 
 @param email 待验证字符串
 @return YES 邮箱 NO 非邮箱
 */
+(BOOL)isEmailString:(NSString *)email{
    NSString *emailRegex = @"[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",emailRegex];
    return [pre evaluateWithObject:email];
}

/**
 身份证验证
 
 @param card 待验证字符串
 @return YES 身份证 NO 非身份证
 */
+(BOOL)isIdentityCard:(NSString *)card{
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [pre evaluateWithObject:card];
}
@end
