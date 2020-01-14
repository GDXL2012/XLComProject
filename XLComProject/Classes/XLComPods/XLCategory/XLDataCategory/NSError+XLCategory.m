//
//  NSError+XLCategory.m
//  XLComProject
//
//  Created by GDXL2012 on 2019/11/27.
//  Copyright © 2019 GDXL2012. All rights reserved.
//

#import "NSError+XLCategory.h"
#import "NSString+XLCategory.h"
/// 自定义错误描述信息
NSString *const XLUserDefinedErrorMSG   = @"com.xlComProject.ErrorDomain";

@implementation NSError (XLCategory)

#pragma mark - Public Class Method

/**
 实例对象
 
 @param code 错误码
 @return 实例对象
 */
+(instancetype)errorWithCode:(NSInteger)code{
    NSString *des = [NSError getErrorDesWithCode:code];
    NSDictionary *userInfo = [NSError userInfoWithDes:des];
    return [NSError errorWithDomain:XLUserDefinedErrorMSG code:code userInfo:userInfo];
}

/**
 实例对象
 
 @param code 错误码
 @param des 描述
 @return 实例对象
 */
+(instancetype)errorWithCode:(NSInteger)code des:(NSString *)des{
    NSDictionary *userInfo = [NSError userInfoWithDes:des];
    return [NSError errorWithDomain:XLUserDefinedErrorMSG code:code userInfo:userInfo];
}

/**
 获取描述信息

 @return 描述信息
 */
-(NSString *)errorDes{
    NSString *des = nil;
    if (self.userInfo) {
        des = [self.userInfo valueForKey:XLUserDefinedErrorMSG];
        if ([NSString isEmpty:des]) {
            des = self.localizedDescription;
        }
    } else {
        NSString *des = [NSError getErrorDesWithCode:self.code];
        if ([NSString isEmpty:des]) {
            des = self.localizedDescription;
        }
    }
    return des;
}

#pragma makr - Private Class Method
/**
 获取错误信息
 
 @param code 错误码
 @return 错误信息
 */
+(NSString *)getErrorDesWithCode:(NSInteger)code{
    static NSDictionary *errorDesInfo = nil;
    if (!errorDesInfo) {
        errorDesInfo = @{@"221001" : @"账号无效",
                         @"221002" : @"密码无效",
                         
                         @"321001" : @"手机号码无效",
                         @"321002" : @"手机号码为空",
                         @"321003" : @"密码格式错误",
                         @"321004" : @"密码不能为空"
                         };
    }
    NSString *codeToSTring = [NSString stringWithInterger:code];
    NSString *des = errorDesInfo[codeToSTring];
    if ([NSString isEmpty:des]) {
        des = @"";
    }
    return des;
}

/**
 错误信息
 
 @param des 错误描述
 @return 错误信息
 */
+(NSDictionary *)userInfoWithDes:(NSString *)des{
    if ([NSString isEmpty:des]) {
        des = @"";
    }
    return @{XLUserDefinedErrorMSG : des, NSLocalizedDescriptionKey : des};
}
@end
