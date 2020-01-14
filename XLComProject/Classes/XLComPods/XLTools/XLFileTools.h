//
//  XLFileTools.h
//  XLComProject
//
//  Created by GDXL2012 on 2019/11/27.
//  Copyright © 2019 GDXL2012. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class AVAssetExportSession;
@interface XLFileTools : NSObject
/**
 写入文件

 @param filePath 文件路径
 @param data 文件内容
 @param error 错误返回
 @return YES 写入成功 NO 写入失败
 */
+ (BOOL)writeToFile:(NSString *)filePath data:(NSData *)data error:(NSError *)error;

/**
 删除文件
 
 @param filePath 文件路径
 @param error 错误返回
 @return YES 删除成功 NO 删除失败
 */
+ (BOOL)deleteFile:(NSString *)filePath error:(NSError *)error;

/**
 获取文件大小

 @param filePath <#filePath description#>
 @return <#return value description#>
 */
+ (long long)fileSizeAtPath:(NSString*)filePath;

/**
 获取媒体文件时长：语音/视频

 @param filePath <#filePath description#>
 @return <#return value description#>
 */
+ (NSTimeInterval)durationForMediaFile:(NSString *)filePath;

/**
 获取媒体文件时长描述：时分秒 语音/视频
 
 @param time 时长，单位s
 @return <#return value description#>
 */
+ (NSString *)desForMediaFielDuration:(NSTimeInterval)time;

/**
 获取媒体文件时长描述：时分秒 语音/视频

 @param filePath 路径
 @return <#return value description#>
 */
+ (NSString *)durationDesForMediaFile:(NSString *)filePath;

/**
 检查路径是否存在，不存在则创建
 
 @param directry 路径
 */
+(void)checkDirectryCreatIfNotExit:(NSString *)directry;

/**
 检查文件存在
 
 @param filePath 路径
 */
+(BOOL)fileIsExit:(NSString *)filePath;

/**
 获取生成唯一的文件名
 
 @param key <#key description#>
 @return <#return value description#>
 */
+(NSString *)cachedFileNameForKey:(NSString *)key;

/// 视频转换
/// @param sourcePath 资源路径
/// @param toPath 转换后路径
/// @param comepleteBlock <#comepleteBlock description#>
/// @param sessionBlock <#sessionBlock description#>
+ (void)movFile:(NSString *)sourcePath
  toMP4WithPath:(NSString *)toPath
     completion:(void(^)(NSString *mp4FilePath))comepleteBlock
        session:(void(^)(AVAssetExportSession *session))sessionBlock;
@end

NS_ASSUME_NONNULL_END
