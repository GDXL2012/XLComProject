//
//  NSDictionary+XLCategory.h
//  XLComProject
//
//  Created by GDXL2012 on 2019/11/24.
//  Copyright © 2019 GDXL2012. All rights reserved.
//
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (XLCategory)
/**
 字典判空
 
 @param dictionary 目标字典
 @return YES 空
 */
+ (BOOL)isEmpty:(NSDictionary *)dictionary;

/**
 JSON转字典
 
 @param jsonString json字符串
 @return 字典实例
 */
+ (NSDictionary *)dictionaryWithJSON:(NSString *)jsonString;

/**
 字典转JSON字符串
 
 @return json字符串
 */
- (NSString *)convertToJSONString;

/**
 字典转NSData
 
 @return json字符串
 */
- (NSData *)convertToData;
@end

NS_ASSUME_NONNULL_END
