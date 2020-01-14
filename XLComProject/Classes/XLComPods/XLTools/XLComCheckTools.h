//
//  XLComCheckTools.h
//  XLComProject
//
//  Created by GDXL2012 on 2019/11/27.
//  Copyright © 2019 GDXL2012. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 通用校验方法
@interface XLComCheckTools : NSObject
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
+(NSString *)mobileCarriers:(NSString *)mobile;

/**
 校验字符串是否为手机号:简单校验
 
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
