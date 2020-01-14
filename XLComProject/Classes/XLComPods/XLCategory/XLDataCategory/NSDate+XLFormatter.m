//
//  NSDate+XLFormatter.m
//  XLComProject
//
//  Created by GDXL2012 on 2019/11/24.
//  Copyright © 2019 GDXL2012. All rights reserved.
//

#import "NSDate+XLFormatter.h"
#import "NSString+XLCategory.h"
#import "NSDate+XLCategory.h"
#import "NSDateFormatter+XLCategory.h"

// Hour&Minute&second
NSString *const XLDFHHMM        = @"HH:mm";
NSString *const XLDFHHMM_ZH     = @"HH时mm分";
NSString *const XLDFHHMMSS      = @"HH:mm:ss";
NSString *const XLDFHHMMSS_ZH   = @"HH时mm分ss秒";

// Month&Day
NSString *const XLDFMMDD        = @"MM/dd";
NSString *const XLDFMMDD_MINUS  = @"MM-dd";
NSString *const XLDFMMDD_ZH     = @"MM月dd日";
NSString *const XLDFMMDD_ZH1    = @"MM月dd";

// Month&DayHour&Minute
NSString *const XLDFMMDDHHMM        = @"MM/dd HH:mm";
NSString *const XLDFMMDDHHMM_MINUS  = @"MM-dd HH:mm";
NSString *const XLDFMMDDHHMM_ZH     = @"MM月dd日 HH:mm";
NSString *const XLDFMMDDHHMM_ZH1    = @"MM月dd HH:mm";

// Year&Month
NSString *const XLDFYYYYMM        = @"yyyy/MM";
NSString *const XLDFYYYYMM_MINUS  = @"yyyy-MM";
NSString *const XLDFYYYYMM_ZH     = @"yyyy年MM月";

// Year&Month&Day
NSString *const XLDFYYYYMMDD        = @"yyyy/MM/dd";
NSString *const XLDFYYYYMMDD_MINUS  = @"yyyy-MM-dd";
NSString *const XLDFYYYYMMDD_ZH     = @"yyyy年MM月dd日";
NSString *const XLDFYYYYMMDD_ZH1    = @"yyyy年MM月dd";

// Year&Month&Day&Hour&Minute
NSString *const XLDFYYYYMMDDHHMM        = @"yyyy/MM/dd HH:mm";
NSString *const XLDFYYYYMMDDHHMM_MINUS  = @"yyyy-MM-dd HH:mm";
NSString *const XLDFYYYYMMDDHHMM_ZH     = @"yyyy年MM月dd日 HH时mm分";
NSString *const XLDFYYYYMMDDHHMM_ZH1    = @"yyyy年MM月dd日 HH:mm";

// Year&Month&Day&Hour&Minute&second
NSString *const XLDFYYYYMMDDHHMMSS        = @"yyyy/MM/dd HH:mm:ss";
NSString *const XLDFYYYYMMDDHHMMSS2       = @"yyyyMMddHHmmss";
NSString *const XLDFYYYYMMDDHHMMSS_MINUS  = @"yyyy-MM-dd HH:mm:ss";
NSString *const XLDFYYYYMMDDHHMMSS_ZH     = @"yyyy年MM月dd日 HH时mm分ss秒";
NSString *const XLDFYYYYMMDDHHMMSS_ZH1    = @"yyyy年MM月dd日 HH:mm:ss";

@implementation NSDate (XLFormatter)
/**
 通用时间格式化
 
 @param dateString 时间字符串：默认格式 YYYY/MM/DD HH:mm:ss
 @return 默认规则格式化后的时间描述字符串
 */
+(NSString *)formatDateString:(NSString *)dateString{
    return [NSDate formatDateString:dateString format:XLDFYYYYMMDDHHMMSS];
}

/**
 通用时间格式化
 
 @param dateString 时间字符串
 @param format 传入的时间字符串格式
 @return 默认规则格式化后的时间描述字符串
 */
+(NSString *)formatDateString:(NSString *)dateString format:(NSString *)format{
    if ([NSString isEmpty:dateString]) {
        return @"";
    }
    NSDateFormatter *fmt = [NSDateFormatter dateFormatterWithFormat:format];
    NSDate *date = [fmt dateFromString:dateString];
    
    if ([date isThisYear]) {    // 今年
        if ([date isYesterday]) {   // 昨天
            return @"昨天";
        } else if ([date isToday]) { // 今天
            fmt.dateFormat = XLDFHHMM;
            return[fmt stringFromDate:date];
        } else {    // MM:DD
            fmt.dateFormat = XLDFMMDD;
            return [fmt stringFromDate:date];
        }
    } else { // 跨年
        fmt.dateFormat = XLDFYYYYMMDDHHMM;
        return [fmt stringFromDate:date];
    }
}

/**
 通用时间格式化
 
 @param dateString 时间字符串
 @param format 传入的时间字符串格式
 @return 默认规则格式化后的时间描述字符串
 */
+(NSString *)hhmmformatDateString:(NSString *)dateString format:(NSString *)format{
    if ([NSString isEmpty:dateString]) {
        return @"";
    }
    NSDateFormatter *fmt = [NSDateFormatter dateFormatterWithFormat:format];
    NSDate *date = [fmt dateFromString:dateString];
    
    if ([date isThisYear]) {    // 今年
        if ([date isYesterday]) {   // 昨天
            fmt.dateFormat = XLDFHHMM;
            return [@"昨天 " stringByAppendingString:[fmt stringFromDate:date]];
        } else if ([date isToday]) { // 今天
            fmt.dateFormat = XLDFMMDDHHMM_ZH;
            return[fmt stringFromDate:date];
        } else {    // MM:DD
            fmt.dateFormat = XLDFMMDDHHMM_ZH;
            return [fmt stringFromDate:date];
        }
    } else { // 跨年
        fmt.dateFormat = XLDFMMDDHHMM_ZH;
        return [fmt stringFromDate:date];
    }
}

/**
 通用时间格式化:忽略年份
 
 @param dateString 时间字符串
 @param format 传入的时间字符串格式
 @return 默认规则格式化后的时间描述字符串
 */
+(NSString *)formatDateIgnoredYear:(NSString *)dateString format:(NSString *)format{
    if ([NSString isEmpty:dateString]) {
        return @"";
    }
    NSDateFormatter *fmt = [NSDateFormatter dateFormatterWithFormat:format];
    NSDate *date = [fmt dateFromString:dateString];
    
    if ([date isYesterday]) {   // 昨天
        return @"昨天";
    } else if ([date isToday]) { // 今天
        return @"今天";
    } else {    // MM:DD
        fmt.dateFormat = XLDFMMDD_ZH1;
        return [fmt stringFromDate:date];
    }
}

/**
 时间格式化
 
 @param dateString 时间字符串
 @param format 传入的时间字符串格式
 @param toFormat 输出时间格式
 @return 返回指定格式时间
 */
+(NSString *)formatDateString:(NSString *)dateString format:(NSString *)format toFormat:(NSString *)toFormat{
    if ([NSString isEmpty:dateString]) {
        return @"";
    }
    NSDateFormatter *fmt = [NSDateFormatter dateFormatterWithFormat:format];
    NSDate *date = [fmt dateFromString:dateString];
    fmt.dateFormat = toFormat;
    return[fmt stringFromDate:date];
}

/**
 获取星期描述
 
 @param inter 星期【0周日-6】
 @return 星期描述
 */
+(NSString *)getWeekDesForInt:(NSInteger)inter{
    NSString *weekDes = @"";
    switch (inter) {
        case 0:
            weekDes = @"周日";
            break;
        case 1:
            weekDes = @"周一";
            break;
        case 2:
            weekDes = @"周二";
            break;
        case 3:
            weekDes = @"周三";
            break;
        case 4:
            weekDes = @"周四";
            break;
        case 5:
            weekDes = @"周五";
            break;
        case 6:
            weekDes = @"周六";
            break;
        case 7:
            weekDes = @"周日";
            break;
        default:
            weekDes = @"周一";
            break;
    }
    return weekDes;
}

/**
 获取时间
 
 @param string 时间字符串
 @param format 格式
 @return <#return value description#>
 */
+ (NSDate *)dateWithString:(NSString *)string format:(NSString *)format{
    if ([NSString isEmpty:string]) {
        return nil;
    }
    NSDateFormatter *fmt = [NSDateFormatter dateFormatterWithFormat:format];
    return [fmt dateFromString:string];
}

#pragma mark - Instance Method
/**
 距离当前的时间间隔描述
 
 @return 描述字符串
 */
- (NSString *)timeIntervalDescription{
    // 距离当前的时间间隔描述
    NSTimeInterval timeInterval = - [self timeIntervalSinceNow];
    if (timeInterval < XLDateMinute) {
        return @"1分钟内";
    } else if (timeInterval < XLDateHour) {
        return [NSString stringWithFormat:@"%.f分钟前", timeInterval / XLDateMinute];
    } else if (timeInterval < XLDateDay) {
        return [NSString stringWithFormat:@"%.f小时前", timeInterval / XLDateHour];
    } else if (timeInterval < XLDateMonth) {//30天内
        return [NSString stringWithFormat:@"%.f天前", timeInterval / XLDateDay];
    } else if (timeInterval < XLDateYear) {//30天至1年内
        NSDateFormatter *dateFormatter = [NSDateFormatter dateFormatterWithFormat:XLDFMMDD];
        return [dateFormatter stringFromDate:self];
    } else {
        return [NSString stringWithFormat:@"%.f年前", timeInterval / XLDateYear];
    }
}

/**
 时间格式化字符串

 @return 返回时间的完整格式：默认 YYYY/MM/DD HH:mm:ss
 */
-(NSString *)formattedTime{
    return [self formatTimeWithFormat:XLDFYYYYMMDDHHMMSS];
}

/**
 获取制定格式的时间字符串

 @param format 指定格式时间
 @return 格式化时间
 */
-(NSString *)formatTimeWithFormat:(NSString *)format{
    NSDateFormatter *formatter = [NSDateFormatter dateFormatterWithFormat:format];
    return [formatter stringFromDate:self];
}

/**
 消息页时间格式化

 @return <#return value description#>
 */
-(NSString *)formatDateStringForMessage{
    if ([self isThisYear]) {    // 今年
        if ([self isYesterday]) {   // 昨天
            NSDateFormatter *fmt = [NSDateFormatter dateFormatterWithFormat:XLDFHHMM];
            NSString *des = [fmt stringFromDate:self];
            return [NSString stringWithFormat:@"昨天 %@", des];
        } else if ([self isToday]) { // 今天
            NSDateFormatter *fmt = [NSDateFormatter dateFormatterWithFormat:XLDFHHMM];
            return [fmt stringFromDate:self];
        } else {    // MM:DD
            NSDateFormatter *fmt = [NSDateFormatter dateFormatterWithFormat:XLDFMMDDHHMM];
            return [fmt stringFromDate:self];
        }
    } else { // 跨年
        NSDateFormatter *fmt = [NSDateFormatter dateFormatterWithFormat:XLDFYYYYMMDDHHMM];
        return [fmt stringFromDate:self];
    }
}
@end
