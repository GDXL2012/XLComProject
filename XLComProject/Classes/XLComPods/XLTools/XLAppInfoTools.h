//
//  XLAppInfoTools.h
//  XLComProject
//
//  Created by GDXL2012 on 2019/11/27.
//  Copyright © 2019 GDXL2012. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 应用信息工具类
@interface XLAppInfoTools : NSObject
/**
 App名称
 
 @return App名称
 */
+(NSString *)appName;

/**
 App版本
 
 @return App版本信息
 */
+(NSString *)appVersion;

/**
 App构建版本号
 
 @return App构建版本
 */
+(NSString *)appBuildVersion;
@end

NS_ASSUME_NONNULL_END
