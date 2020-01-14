//
//  NSDate+XLCategory.h
//  XLComProject
//
//  Created by GDXL2012 on 2019/11/24.
//  Copyright © 2019 GDXL2012. All rights reserved.
//

#import <Foundation/Foundation.h>

// 日历单例
#define CurrentCalendar [NSCalendar currentCalendar]

extern NSTimeInterval const XLDateMinute;   // 分钟
extern NSTimeInterval const XLDateHour;     // 小时
extern NSTimeInterval const XLDateDay;      // 天
extern NSTimeInterval const XLDateWeek;     // 一星期
extern NSTimeInterval const XLDateMonth;    // 一个月：30天
extern NSTimeInterval const XLDateYear;     // 年


NS_ASSUME_NONNULL_BEGIN

@interface NSDate (XLCategory)

// 时间间隔
+ (NSDate *)dateWithTimeIntervalInMilliSecondSince1970:(double)timeIntervalInMilliSecond;

// Relative dates from the current date
+ (NSDate *)dateTomorrow;                                   // 明天
+ (NSDate *)dateWithDaysFromNow:(NSInteger)days;            // days天之后
+ (NSDate *)dateWithHoursFromNow:(NSInteger)dHours;         // hours小时后
+ (NSDate *)dateWithMinutesFromNow:(NSInteger)dMinutes;     // minutes分钟后

+ (NSDate *)dateYesterday;                                  // 昨天
+ (NSDate *)dateWithDaysBeforeNow:(NSInteger)days;          // days天前
+ (NSDate *)dateWithHoursBeforeNow:(NSInteger)dHours;       // hours小时前
+ (NSDate *)dateWithMinutesBeforeNow:(NSInteger)dMinutes;   // minutes分钟前

/**
 指定年月的某一天

 @param month 月
 @param year 年
 @return 日期
 */
+ (NSDate *)dateForMonth:(NSInteger)month inYear:(NSInteger)year;
// 时间间隔
- (NSTimeInterval)timeIntervalSince1970InMilliSecond;

// Comparing dates
- (BOOL)isEqualToDate:(NSDate *)aDate;  // 比较日期，忽略时间
- (BOOL)isToday;
- (BOOL)isTomorrow;
- (BOOL)isYesterday;
- (BOOL)isSameWeekAsDate:(NSDate *)aDate;
- (BOOL)isThisWeek;
- (BOOL)isNextWeek;
- (BOOL)isLastWeek;
- (BOOL)isSameMonthAsDate:(NSDate *)aDate;
- (BOOL)isThisMonth;
- (BOOL)isSameYearAsDate:(NSDate *)aDate;
- (BOOL)isThisYear;
- (BOOL)isNextYear;
- (BOOL)isLastYear;
- (BOOL)isEarlierThanDate:(NSDate *)aDate;
- (BOOL)isLaterThanDate:(NSDate *)aDate;
- (BOOL)isInFuture;
- (BOOL)isInPast;

// Date roles
- (BOOL)isTypicallyWorkday;
- (BOOL)isTypicallyWeekend;

- (NSDate *)previousMonthDate;    // 上个月的某一天
- (NSDate *)nextMonthDate;        // 下个月的某一天
- (NSInteger)totalDaysInMonth;    // 对应的月份的总天数
- (NSInteger)firstWeekDayInMonth; // 应月份当月第一天的所属星期

// Adjusting dates
- (NSDate *)dateByAddingDays:(NSInteger)dDays;
- (NSDate *)dateBySubtractingDays:(NSInteger)dDays;
- (NSDate *)dateByAddingHours:(NSInteger)dHours;
- (NSDate *)dateBySubtractingHours:(NSInteger)dHours;
- (NSDate *)dateByAddingMinutes:(NSInteger)dMinutes;
- (NSDate *)dateBySubtractingMinutes:(NSInteger)dMinutes;
- (NSDate *)dateAtStartOfDay;

// Retrieving intervals
- (NSInteger)minutesAfterDate:(NSDate *)aDate;
- (NSInteger)minutesBeforeDate:(NSDate *)aDate;
- (NSInteger)hoursAfterDate:(NSDate *)aDate;
- (NSInteger)hoursBeforeDate:(NSDate *)aDate;
- (NSInteger)daysAfterDate:(NSDate *)aDate;
- (NSInteger)daysBeforeDate:(NSDate *)aDate;
- (NSInteger)distanceInDaysToDate:(NSDate *)anotherDate;

// Decomposing dates
@property (readonly) NSInteger nearestHour;
@property (readonly) NSInteger hour;
@property (readonly) NSInteger minute;
@property (readonly) NSInteger seconds;
@property (readonly) NSInteger day;
@property (readonly) NSInteger month;
@property (readonly) NSInteger week;        // weekOfYear
@property (readonly) NSInteger weekOfMonth; // weekOfYear
@property (readonly) NSInteger weekday;
@property (readonly) NSInteger nthWeekday; // e.g. 2nd Tuesday of the month == 2
@property (readonly) NSInteger year;

@end

NS_ASSUME_NONNULL_END
