//
//  NSArray+XLCategory.m
//  XLComProject
//
//  Created by GDXL2012 on 2019/11/24.
//  Copyright © 2019 GDXL2012. All rights reserved.
//

#import "NSArray+XLCategory.h"
#import "NSString+XLCategory.h"

@implementation NSArray (XLCategory)
/**
 数组判空
 
 @param array 目标数组
 @return YES 空
 */
+ (BOOL)isEmpty:(NSArray *)array{
    if(!array || array.count == 0){
        return YES;
    }
    return NO;
}

/**
 JSON转数组
 
 @param jsonString json字符串
 @return 数组实例
 */
+ (NSArray *)arrayWithJSON:(NSString *)jsonString{
    if ([NSString isEmpty:jsonString]) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSArray *array = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
    if(error) {
        NSLog(@"json解析失败：%@",error);
        return nil;
    }
    return array;
}

/**
 数组转JSON字符串
 
 @return json字符串
 */
- (NSString *)convertToJSONString{
    NSData *data = [NSJSONSerialization dataWithJSONObject:self options:NSJSONReadingMutableLeaves | NSJSONReadingAllowFragments error:nil];
    if (data == nil) {
        return nil;
    }
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return string;
}

/**
 数组转Data
 
 @return json字符串
 */
- (NSData *)convertToData{
    NSData *data = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:nil];
    return data;
}
@end
