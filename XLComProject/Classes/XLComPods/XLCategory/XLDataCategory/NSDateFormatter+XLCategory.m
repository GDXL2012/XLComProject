//
//  NSDateFormatter+XLCategory.m
//  XLComProject
//
//  Created by GDXL2012 on 2019/11/24.
//  Copyright © 2019 GDXL2012. All rights reserved.
//

#import "NSDateFormatter+XLCategory.h"

@implementation NSDateFormatter (XLCategory)
#pragma mark - Class Method
+ (instancetype)dateFormatter{
    return [[self alloc] init];
}

+ (instancetype)defaultDateFormatter{
    return [self dateFormatterWithFormat:@"yyyy-MM-dd HH:mm:ss"];
}

+ (instancetype)dateFormatterWithFormat:(NSString *)dateFormat{
    NSDateFormatter *dateFormatter = [[self alloc] init];
    dateFormatter.dateFormat = dateFormat;
    return dateFormatter;
}

@end
