//
//  NSError+XLCategory.h
//  XLComProject
//
//  Created by GDXL2012 on 2019/11/27.
//  Copyright © 2019 GDXL2012. All rights reserved.
//
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, XLErrorCode) {
    XLErrorInvalidAccount           = 221001,   // 账号无效
    XLErrorInvalidPassword          = 221002,   // 密码无效
    
    XLErrorMobileNumberInvalid      = 321001,   // 手机号码无效
    XLErrorMobileNumberEmpty        = 321002,   // 手机号码为空
    XLErrorPasswordFormat           = 321003,   // 密码格式错误
    XLErrorPasswordEmpty            = 321004,   // 密码为空
};
/// 自定义错误描述信息
extern NSString *const XLUserDefinedErrorMSG;

@interface NSError (XLCategory)

@property (nonatomic, copy, readonly) NSString *errorDes;   // 错误描述

/**
 实例对象

 @param code 错误码
 @return 实例对象
 */
+(instancetype)errorWithCode:(NSInteger)code;

/**
 实例对象

 @param code 错误码
 @param des 描述
 @return 实例对象
 */
+(instancetype)errorWithCode:(NSInteger)code des:(NSString *)des;

/**
 获取错误信息
 
 @param code 错误码
 @return 错误信息
 */
+(NSString *)getErrorDesWithCode:(NSInteger)code;

@end

NS_ASSUME_NONNULL_END
