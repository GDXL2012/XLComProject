//
//  NSDictionary+XLCategory.m
//  XLComProject
//
//  Created by GDXL2012 on 2019/11/24.
//  Copyright © 2019 GDXL2012. All rights reserved.
//

#import "NSDictionary+XLCategory.h"
#import "NSString+XLCategory.h"

@implementation NSDictionary (XLCategory)
/**
 字典判空
 
 @param dictionary 目标字典
 @return YES 空
 */
+ (BOOL)isEmpty:(NSDictionary *)dictionary{
    if(!dictionary || dictionary.allKeys.count == 0){
        return YES;
    }
    return NO;
}

/**
 JSON转字典
 
 @param jsonString json字符串
 @return 字典实例
 */
+ (NSDictionary *)dictionaryWithJSON:(NSString *)jsonString{
    if ([NSString isEmpty:jsonString]) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    if(error) {
        NSLog(@"json解析失败：%@",error);
        return nil;
    }
    return dic;
}

/**
 字典转JSON字符串
 
 @return json字符串
 */
- (NSString *)convertToJSONString{
    // 1.字典转字符串
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = nil;
    if (jsonData) {
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }else{
        NSLog(@"convertToJSONString error %@", error);
        return @"";
    }
    
    // 2.去掉字符串中的空格
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    NSRange range = {0, jsonString.length};
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    
    // 3.去掉字符串中的换行符
    NSRange range2 = {0, mutStr.length};
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    
    return [mutStr copy];
}

/**
 字典转NSData
 
 @return json字符串
 */
- (NSData *)convertToData{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
    if (jsonData) {
        return jsonData;
    }else{
        NSLog(@"convertToJSONString error %@", error);
        return nil;
    }
}
@end
