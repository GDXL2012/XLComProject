//
//  XLFileTools.m
//  XLComProject
//
//  Created by GDXL2012 on 2019/11/27.
//  Copyright © 2019 GDXL2012. All rights reserved.
//

#import "XLFileTools.h"
#import <AVFoundation/AVFoundation.h>
#import <CommonCrypto/CommonDigest.h>
#import "XLComMacro.h"
#import "NSString+XLCategory.h"

@implementation XLFileTools
//文件的写入
+ (BOOL)writeToFile:(NSString *)filePath data:(NSData *)data error:(NSError *)error{
    /// 把NSData对象写入到文件中
    /// NSDataWritingAtomicb表示对象会先将数据写入临时文件，成功后再移动至指定文件
    BOOL written = [data writeToFile:filePath options:NSDataWritingAtomic error:&error];
    
    if (!written) {
        return NO;
    }
    return YES;
}

/**
 删除文件
 
 @param filePath 文件路径
 @param error 错误返回
 @return YES 删除成功 NO 删除失败
 */
+ (BOOL)deleteFile:(NSString *)filePath error:(NSError *)error{
    BOOL res=[XLFileManager removeItemAtPath:filePath error:&error];
    if (res) {
        return res;
    }else {
        // 文件不存在，则返回成功
        return [XLFileManager isExecutableFileAtPath:filePath];
    }
}

/**
 获取文件大小
 
 @param filePath <#filePath description#>
 @return <#return value description#>
 */
+ (long long)fileSizeAtPath:(NSString*)filePath {
    if ([XLFileManager fileExistsAtPath:filePath]){
        return [[XLFileManager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

/**
 获取媒体文件时长：语音/视频
 
 @param filePath <#filePath description#>
 @return <#return value description#>
 */
+ (NSTimeInterval)durationForMediaFile:(NSString *)filePath{
    NSURL *fileUrl = [NSURL fileURLWithPath:filePath];
    AVURLAsset* audioAsset =[AVURLAsset URLAssetWithURL:fileUrl options:nil];
    if (audioAsset) {
        CMTime audioDuration = audioAsset.duration;
        return CMTimeGetSeconds(audioDuration);
    } else {
        return 0.0f;
    }
}

/**
 获取媒体文件时长描述：时分秒 语音/视频
 
 @param time 时长，单位s
 @return <#return value description#>
 */
+ (NSString *)desForMediaFielDuration:(NSTimeInterval)time{
    NSString *timeStr = [NSString stringWithFloat:time decimal:0];
    long long seconds = [timeStr longLongValue];
    
    //format of hour
    NSString *strHour = [NSString stringWithFormat:@"%02lld",seconds/3600];
    //format of minute
    NSString *strMinute = [NSString stringWithFormat:@"%02lld",(seconds%3600)/60];
    //format of second
    NSString *strSecond = [NSString stringWithFormat:@"%02lld",seconds%60];
    //format of time
    NSString *formatTime = @"";
    if ([strHour integerValue] > 0) {
        formatTime = [NSString stringWithFormat:@"%@:%@′%@″", strHour, strMinute, strSecond];
    } else {
        formatTime = [NSString stringWithFormat:@"%@′%@″", strMinute, strSecond];
    }
    return formatTime;
}

/**
 获取媒体文件时长描述：时分秒 语音/视频
 
 @param filePath 路径
 @return <#return value description#>
 */
+ (NSString *)durationDesForMediaFile:(NSString *)filePath{
    if ([NSString isEmpty:filePath]) {
        return @"0‘";
    }
    NSTimeInterval time = [XLFileTools durationForMediaFile:filePath];
    return [XLFileTools desForMediaFielDuration:time];
}

/**
 检查路径是否存在，不存在则创建
 
 @param directry 路径
 */
+(void)checkDirectryCreatIfNotExit:(NSString *)directry{
    BOOL isDir = NO;
    BOOL existed = [XLFileManager fileExistsAtPath:directry isDirectory:&isDir];
    if (!(isDir == YES && existed == YES)) {
        NSError *error = nil;
        [XLFileManager createDirectoryAtPath:directry withIntermediateDirectories:YES attributes:nil error:&error];
        if (error != nil) {
            NSLog(@"createDirectoryAtPath error I%@", error);
        }
    }
}

/**
 检查文件存在
 
 @param filePath 路径
 */
+(BOOL)fileIsExit:(NSString *)filePath{
    BOOL isDir = NO;
    BOOL existed = [XLFileManager fileExistsAtPath:filePath isDirectory:&isDir];
    if (isDir == NO && existed == YES) {
        // 存在，且不是文件夹
        return YES;
    } else {
        return NO;
    }
}

/**
 获取生成唯一的文件名
 
 @param key <#key description#>
 @return <#return value description#>
 */
+ (NSString *)cachedFileNameForKey:(NSString *)key {
    const char *str = key.UTF8String;
    if (str == NULL) {
        str = "";
    }
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), r);
    NSString *pathExtension = [key.pathExtension isEqualToString:@""] ? @"" : [NSString stringWithFormat:@".%@", key.pathExtension];
    NSString *format = @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%@";
    NSString *filename = [NSString stringWithFormat:format,
                          r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10],
                          r[11], r[12], r[13], r[14], r[15], pathExtension];
    
    return filename;
}

/// 视频转换
/// @param sourcePath 资源路径
/// @param toPath 转换后路径
/// @param comepleteBlock <#comepleteBlock description#>
/// @param sessionBlock <#sessionBlock description#>
+ (void)movFile:(NSString *)sourcePath
  toMP4WithPath:(NSString *)toPath
     completion:(void(^)(NSString *mp4FilePath))comepleteBlock
        session:(void(^)(AVAssetExportSession *session))sessionBlock{
    NSURL *sourceUrl = [NSURL URLWithString:sourcePath];
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:sourceUrl options:nil];
    
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    
    if ([compatiblePresets containsObject:AVAssetExportPresetMediumQuality]) {
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPresetMediumQuality];
        exportSession.outputURL = [NSURL fileURLWithPath:toPath];
        exportSession.outputFileType = AVFileTypeMPEG4;
        exportSession.shouldOptimizeForNetworkUse = YES;
        
        //如有此文件则直接返回
        if ([XLFileManager fileExistsAtPath:toPath]) {
            if (comepleteBlock) {
                comepleteBlock(toPath);
            }
            return;
        }
        [exportSession exportAsynchronouslyWithCompletionHandler:^(void) {
            if (exportSession.status == AVAssetExportSessionStatusCompleted) {
                if (comepleteBlock){
                    comepleteBlock(toPath);
                }
            } else if (sessionBlock){
                sessionBlock(exportSession);
            }
         }];
    }
}
@end
