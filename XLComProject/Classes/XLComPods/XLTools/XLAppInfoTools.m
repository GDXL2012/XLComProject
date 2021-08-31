//
//  XLAppInfoTools.m
//  XLComProject
//
//  Created by GDXL2012 on 2019/11/27.
//  Copyright © 2019 GDXL2012. All rights reserved.
//

#import "XLAppInfoTools.h"

@implementation XLAppInfoTools
/**
 App名称
 
 @return App名称
 */
+(NSString *)appName{
    return [[XLAppInfoTools infoDictionary] objectForKey:@"CFBundleDisplayName"];
}

/**
 App版本
 
 @return App版本信息
 */
+(NSString *)appVersion{
    return [[XLAppInfoTools infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

/**
 App构建版本号
 
 @return App构建版本
 */
+(NSString *)appBuildVersion{
    return [[XLAppInfoTools infoDictionary] objectForKey:@"CFBundleVersion"];
}

/**
 App Bundle信息
 
 @return App Bundle信息字典
 */
+(NSDictionary *)infoDictionary{
    return [[NSBundle mainBundle] infoDictionary];;
}

/// 设备唯一标识符:相对唯一
+(NSString *)deviceUUID{
    NSUUID *uuid = [[UIDevice currentDevice] identifierForVendor];
    NSString *strIDFV = [uuid UUIDString];
    uuid = nil;
    return strIDFV;
}

/// 系统版本
+(NSString *)systemString{
    NSString *version= [UIDevice currentDevice].systemVersion;
    return [NSString stringWithFormat:@"iOS %@", version];
}
@end
