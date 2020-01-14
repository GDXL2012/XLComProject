//
//  NSDate+XLFormatter.h
//  XLComProject
//
//  Created by GDXL2012 on 2019/11/24.
//  Copyright © 2019 GDXL2012. All rights reserved.
//
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
// Hour&Minute&second
extern NSString *const XLDFHHMM;
extern NSString *const XLDFHHMM_ZH;
extern NSString *const XLDFHHMMSS;
extern NSString *const XLDFHHMMSS_ZH;
// Month&Day
extern NSString *const XLDFMMDD;
extern NSString *const XLDFMMDD_MINUS;
extern NSString *const XLDFMMDD_ZH;
extern NSString *const XLDFMMDD_ZH1;
// Month&DayHour&Minute
extern NSString *const XLDFMMDDHHMM;
extern NSString *const XLDFMMDDHHMM_MINUS;
extern NSString *const XLDFMMDDHHMM_ZH;
extern NSString *const XLDFMMDDHHMM_ZH1;
// Year&Month
extern NSString *const XLDFYYYYMM;
extern NSString *const XLDFYYYYMM_MINUS;
extern NSString *const XLDFYYYYMM_ZH;
// Year&Month&Day
extern NSString *const XLDFYYYYMMDD;
extern NSString *const XLDFYYYYMMDD_MINUS;
extern NSString *const XLDFYYYYMMDD_ZH;
extern NSString *const XLDFYYYYMMDD_ZH1;
// Year&Month&Day&Hour&Minute
extern NSString *const XLDFYYYYMMDDHHMM;
extern NSString *const XLDFYYYYMMDDHHMM_MINUS;
extern NSString *const XLDFYYYYMMDDHHMM_ZH;
extern NSString *const XLDFYYYYMMDDHHMM_ZH1;
// Year&Month&Day&Hour&Minute&second
extern NSString *const XLDFYYYYMMDDHHMMSS;
extern NSString *const XLDFYYYYMMDDHHMMSS2;
extern NSString *const XLDFYYYYMMDDHHMMSS_MINUS;
extern NSString *const XLDFYYYYMMDDHHMMSS_ZH;
extern NSString *const XLDFYYYYMMDDHHMMSS_ZH1;

@interface NSDate (XLFormatter)
/**
 通用时间格式化
 
 @param dateString 时间字符串：默认格式 YYYY/MM/DD HH:MM:SS
 @return 默认规则格式化后的时间描述字符串
 */
+(NSString *)formatDateString:(NSString *)dateString;

/**
 通用时间格式化
 
 @param dateString 时间字符串
 @param format 传入的时间字符串格式
 @return 默认规则格式化后的时间描述字符串
 */
+(NSString *)formatDateString:(NSString *)dateString format:(NSString *)format;

/**
 通用时间格式化
 
 @param dateString 时间字符串
 @param format 传入的时间字符串格式
 @return 默认规则格式化后的时间描述字符串(带有时分)
 */
+(NSString *)hhmmformatDateString:(NSString *)dateString format:(NSString *)format;

/**
 通用时间格式化:忽略年份
 
 @param dateString 时间字符串
 @param format 传入的时间字符串格式
 @return 默认规则格式化后的时间描述字符串
 */
+(NSString *)formatDateIgnoredYear:(NSString *)dateString format:(NSString *)format;

/**
 时间格式化
 
 @param dateString 时间字符串
 @param format 传入的时间字符串格式
 @param toFormat 输出时间格式
 @return 返回指定格式时间
 */
+(NSString *)formatDateString:(NSString *)dateString format:(NSString *)format toFormat:(NSString *)toFormat;

/**
 获取星期描述
 
 @param inter 星期【0周日-6】
 @return 星期描述
 */
+(NSString *)getWeekDesForInt:(NSInteger)inter;

/**
 获取时间

 @param string 时间字符串
 @param format 格式
 @return <#return value description#>
 */
+ (NSDate *)dateWithString:(NSString *)string format:(NSString *)format;

/**
  距离当前的时间间隔描述

 @return 描述字符串
 */
- (NSString *)timeIntervalDescription;

/**
 时间格式化字符串
 
 @return 返回时间的完整格式：默认 YYYY/MM/DD HH:MM:SS
 */
-(NSString *)formattedTime;

/**
 获取制定格式的时间字符串
 
 @param format 指定格式时间
 @return 格式化时间
 */
-(NSString *)formatTimeWithFormat:(NSString *)format;

/**
 消息页时间格式化
 
 @return <#return value description#>
 */
-(NSString *)formatDateStringForMessage;
@end

NS_ASSUME_NONNULL_END
