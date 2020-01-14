//
//  NSDate+XLCategory.m
//  XLComProject
//
//  Created by GDXL2012 on 2019/11/24.
//  Copyright © 2019 GDXL2012. All rights reserved.
//

#import "NSDate+XLCategory.h"
#import "NSDateFormatter+XLCategory.h"
#import "NSDate+XLFormatter.h"

NSTimeInterval const XLDateMinute   = 60.0f;        // 分钟
NSTimeInterval const XLDateHour     = 3600.0f;      // 小时
NSTimeInterval const XLDateDay      = 86400.0f;     // 天
NSTimeInterval const XLDateWeek     = 604800.0f;    // 一星期
NSTimeInterval const XLDateMonth    = 2592000.0f;   // 一个月：30天
NSTimeInterval const XLDateYear     = 31536000.0f;  // 年

NSTimeInterval const XLDateMilliSecond = 140000000000;  // 用于判断是否是毫秒级别时间戳

NSCalendarUnit const XLUnitFlags = NSCalendarUnitSecond | NSCalendarUnitMinute | NSCalendarUnitHour | NSCalendarUnitDay | NSCalendarUnitWeekOfMonth | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitWeekdayOrdinal | NSCalendarUnitWeekday;

@implementation NSDate (XLCategory)

- (double)timeIntervalSince1970InMilliSecond {
    double ret;
    ret = [self timeIntervalSince1970] * 1000;
    
    return ret;
}

+ (NSDate *)dateWithTimeIntervalInMilliSecondSince1970:(double)timeIntervalInMilliSecond {
    NSDate *ret = nil;
    double timeInterval = timeIntervalInMilliSecond;
    // judge if the argument is in secconds(for former data structure).
    if(timeIntervalInMilliSecond > XLDateMilliSecond) {
        timeInterval = timeIntervalInMilliSecond / 1000;
    }
    ret = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    
    return ret;
}

+ (NSString *)formattedTimeFromTimeInterval:(long long)time{
    return [[NSDate dateWithTimeIntervalInMilliSecondSince1970:time] formattedTime];
}

#pragma mark Relative Dates
+ (NSDate *)dateWithDaysFromNow:(NSInteger)days {
    return [[NSDate date] dateByAddingDays:days];
}

+ (NSDate *)dateWithDaysBeforeNow:(NSInteger)days {
    return [[NSDate date] dateBySubtractingDays:days];
}

+ (NSDate *)dateTomorrow {
    return [NSDate dateWithDaysFromNow:1];
}

+ (NSDate *)dateYesterday {
    return [NSDate dateWithDaysBeforeNow:1];
}

+ (NSDate *)dateWithHoursFromNow:(NSInteger)hours{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + XLDateHour * hours;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

+ (NSDate *)dateWithHoursBeforeNow:(NSInteger)hours{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - XLDateHour * hours;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

+ (NSDate *)dateWithMinutesFromNow:(NSInteger)minutes{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + XLDateMinute * minutes;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

+ (NSDate *)dateWithMinutesBeforeNow:(NSInteger)minutes{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - XLDateMinute * minutes;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

/**
 指定年月的某一天
 
 @param month 月
 @param year 年
 @return 日期
 */
+ (NSDate *)dateForMonth:(NSInteger)month inYear:(NSInteger)year{
    NSDateComponents *components = [CurrentCalendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:[NSDate date]];
    components.day = 10;    // 定位到当月第10天
    components.hour = 9;    // 设置小时为9小时，规避时差
    components.month = month;
    components.year = year;
    NSDate *date = [CurrentCalendar dateFromComponents:components];
    return date;
}

#pragma mark Comparing Dates

- (BOOL)isEqualToDate:(NSDate *)date{
    NSDateComponents *components1 = [CurrentCalendar components:XLUnitFlags fromDate:self];
    NSDateComponents *components2 = [CurrentCalendar components:XLUnitFlags fromDate:date];
    return ((components1.year == components2.year) &&
            (components1.month == components2.month) &&
            (components1.day == components2.day));
}

- (BOOL)isToday{
    return [self isEqualToDate:[NSDate date]];
}

- (BOOL)isTomorrow{
    return [self isEqualToDate:[NSDate dateTomorrow]];
}

- (BOOL)isYesterday{
    return [self isEqualToDate:[NSDate dateYesterday]];
}

// This hard codes the assumption that a week is 7 days
- (BOOL)isSameWeekAsDate:(NSDate *)aDate{
    NSDateComponents *components1 = [CurrentCalendar components:XLUnitFlags fromDate:self];
    NSDateComponents *components2 = [CurrentCalendar components:XLUnitFlags fromDate:aDate];
    
    // Must be same week. 12/31 and 1/1 will both be week "1" if they are in the same week
    if (components1.weekOfYear != components2.weekOfYear) {
        return NO;
    }
    
    // Must have a time interval under 1 week.
    return (fabs([self timeIntervalSinceDate:aDate]) < XLDateWeek);
}

- (BOOL)isThisWeek{
    return [self isSameWeekAsDate:[NSDate date]];
}

- (BOOL)isNextWeek{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + XLDateWeek;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    
    return [self isSameWeekAsDate:newDate];
}

- (BOOL)isLastWeek{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - XLDateWeek;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    
    return [self isSameWeekAsDate:newDate];
}

- (BOOL)isSameMonthAsDate:(NSDate *) aDate {
    NSCalendarUnit unitFlag = NSCalendarUnitYear | NSCalendarUnitMonth;
    NSDateComponents *components1 = [CurrentCalendar components:unitFlag fromDate:self];
    NSDateComponents *components2 = [CurrentCalendar components:unitFlag fromDate:aDate];
    
    return ((components1.month == components2.month) &&
            (components1.year == components2.year));
}

- (BOOL)isThisMonth{
    return [self isSameMonthAsDate:[NSDate date]];
}

- (BOOL)isSameYearAsDate:(NSDate *)aDate{
    NSDateComponents *components1 = [CurrentCalendar components:NSCalendarUnitYear fromDate:self];
    NSDateComponents *components2 = [CurrentCalendar components:NSCalendarUnitYear fromDate:aDate];
    
    return (components1.year == components2.year);
}

- (BOOL)isThisYear{
    return [self isSameYearAsDate:[NSDate date]];
}

- (BOOL)isNextYear{
    NSDateComponents *components1 = [CurrentCalendar components:NSCalendarUnitYear fromDate:self];
    NSDateComponents *components2 = [CurrentCalendar components:NSCalendarUnitYear fromDate:[NSDate date]];
    
    return (components1.year == (components2.year + 1));
}

- (BOOL)isLastYear{
    NSDateComponents *components1 = [CurrentCalendar components:NSCalendarUnitYear fromDate:self];
    NSDateComponents *components2 = [CurrentCalendar components:NSCalendarUnitYear fromDate:[NSDate date]];
    
    return (components1.year == (components2.year - 1));
}

- (BOOL)isEarlierThanDate:(NSDate *)aDate {
    return ([self compare:aDate] == NSOrderedAscending);
}

- (BOOL)isLaterThanDate:(NSDate *)aDate {
    return ([self compare:aDate] == NSOrderedDescending);
}

- (BOOL)isInFuture{
    return ([self isLaterThanDate:[NSDate date]]);
}

- (BOOL)isInPast{
    return ([self isEarlierThanDate:[NSDate date]]);
}

#pragma mark Roles
- (BOOL)isTypicallyWeekend{
    NSDateComponents *components = [CurrentCalendar components:NSCalendarUnitWeekday fromDate:self];
    if ((components.weekday == 1) ||
        (components.weekday == 7))
        return YES;
    return NO;
}

- (BOOL)isTypicallyWorkday{
    return ![self isTypicallyWeekend];
}

- (NSDate *)previousMonthDate{    // 上个月的某一天
    NSDateComponents *components = [CurrentCalendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self];
    components.day = 10;     // 定位到当月第10天：规避时差8小时
    
    if (components.month == 1) {
        components.month = 12;
        components.year -= 1;
    } else {
        components.month -= 1;
    }
    
    NSDate *previousDate = [CurrentCalendar dateFromComponents:components];
    return previousDate;
}

- (NSDate *)nextMonthDate{        // 下个月的某一天
    NSDateComponents *components = [CurrentCalendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self];
    components.day = 10;     // 定位到当月第10天：规避时差8小时
    
    if (components.month == 12) {
        components.month = 1;
        components.year += 1;
    } else {
        components.month += 1;
    }
    
    NSDate *nextDate = [CurrentCalendar dateFromComponents:components];
    return nextDate;
}

- (NSInteger)totalDaysInMonth{    // 对应的月份的总天数
    NSInteger totalDays = [CurrentCalendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self].length;
    return totalDays;
}

- (NSInteger)firstWeekDayInMonth{ // 应月份当月第一天的所属星期
    NSDateComponents *components = [CurrentCalendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self];
    components.day = 1; // 定位到当月第一天
    NSDate *firstDay = [CurrentCalendar dateFromComponents:components];
    
    // 默认一周第一天序号为 1 ，而日历中约定为 0 ，故需要减一
    NSInteger firstWeekday = [CurrentCalendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:firstDay] - 1;
    
    return firstWeekday;
}


#pragma mark Adjusting Dates
- (NSDate *)dateByAddingDays:(NSInteger)dDays{
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + XLDateDay * dDays;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

- (NSDate *)dateBySubtractingDays:(NSInteger)dDays{
    return [self dateByAddingDays:(dDays * -1)];
}

- (NSDate *)dateByAddingHours:(NSInteger)dHours{
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + XLDateHour * dHours;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

- (NSDate *)dateBySubtractingHours:(NSInteger)dHours{
    return [self dateByAddingHours: (dHours * -1)];
}

- (NSDate *)dateByAddingMinutes:(NSInteger)dMinutes{
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + XLDateMinute * dMinutes;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

- (NSDate *)dateBySubtractingMinutes:(NSInteger)dMinutes{
    return [self dateByAddingMinutes:(dMinutes * -1)];
}

- (NSDate *)dateAtStartOfDay{
    NSDateComponents *components = [CurrentCalendar components:XLUnitFlags fromDate:self];
    components.hour = 0;
    components.minute = 0;
    components.second = 0;
    return [CurrentCalendar dateFromComponents:components];
}

- (NSDateComponents *)componentsWithOffsetFromDate:(NSDate *)aDate{
    NSDateComponents *dTime = [CurrentCalendar components:XLUnitFlags fromDate:aDate toDate:self options:0];
    return dTime;
}

#pragma mark Retrieving Intervals

- (NSInteger)minutesAfterDate:(NSDate *)aDate{
    NSTimeInterval ti = [self timeIntervalSinceDate:aDate];
    return (NSInteger) (ti / XLDateMinute);
}

- (NSInteger)minutesBeforeDate:(NSDate *)aDate{
    NSTimeInterval ti = [aDate timeIntervalSinceDate:self];
    return (NSInteger) (ti / XLDateMinute);
}

- (NSInteger)hoursAfterDate:(NSDate *)aDate{
    NSTimeInterval ti = [self timeIntervalSinceDate:aDate];
    return (NSInteger) (ti / XLDateHour);
}

- (NSInteger)hoursBeforeDate:(NSDate *)aDate{
    NSTimeInterval ti = [aDate timeIntervalSinceDate:self];
    return (NSInteger) (ti / XLDateHour);
}

- (NSInteger)daysAfterDate:(NSDate *)aDate{
    NSTimeInterval ti = [self timeIntervalSinceDate:aDate];
    return (NSInteger) (ti / XLDateDay);
}

- (NSInteger)daysBeforeDate:(NSDate *)aDate{
    NSTimeInterval ti = [aDate timeIntervalSinceDate:self];
    return (NSInteger) (ti / XLDateDay);
}

// I have not yet thoroughly tested this
- (NSInteger)distanceInDaysToDate:(NSDate *)anotherDate {
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitDay fromDate:self toDate:anotherDate options:0];
    return components.day;
}

#pragma mark Decomposing Dates
- (NSInteger)nearestHour{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + XLDateMinute * 30;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    NSDateComponents *components = [CurrentCalendar components:NSCalendarUnitHour fromDate:newDate];
    return components.hour;
}

- (NSInteger)hour{
    NSDateComponents *components = [CurrentCalendar components:XLUnitFlags fromDate:self];
    return components.hour;
}

- (NSInteger)minute{
    NSDateComponents *components = [CurrentCalendar components:XLUnitFlags fromDate:self];
    return components.minute;
}

- (NSInteger)seconds{
    NSDateComponents *components = [CurrentCalendar components:XLUnitFlags fromDate:self];
    return components.second;
}

- (NSInteger)day{
    NSDateComponents *components = [CurrentCalendar components:XLUnitFlags fromDate:self];
    return components.day;
}

- (NSInteger)month{
    NSDateComponents *components = [CurrentCalendar components:XLUnitFlags fromDate:self];
    return components.month;
}

- (NSInteger)week{
    NSDateComponents *components = [CurrentCalendar components:XLUnitFlags fromDate:self];
    return components.weekOfYear;
}

- (NSInteger)weekOfMonth{
    NSDateComponents *components = [CurrentCalendar components:XLUnitFlags fromDate:self];
    return components.weekOfMonth;
}

- (NSInteger)weekday{
    NSDateComponents *components = [CurrentCalendar components:XLUnitFlags fromDate:self];
    return components.weekday - 1;
}

// e.g. 2nd Tuesday of the month is 2
- (NSInteger)nthWeekday{
    NSDateComponents *components = [CurrentCalendar components:XLUnitFlags fromDate:self];
    return components.weekdayOrdinal;
}

- (NSInteger)year{
    NSDateComponents *components = [CurrentCalendar components:XLUnitFlags fromDate:self];
    return components.year;
}
@end
