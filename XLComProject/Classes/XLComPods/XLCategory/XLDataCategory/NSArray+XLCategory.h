//
//  NSArray+XLCategory.h
//  XLComProject
//
//  Created by GDXL2012 on 2019/11/24.
//  Copyright © 2019 GDXL2012. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (XLCategory)
/**
 数组判空
 
 @param array 目标数组
 @return YES 空
 */
+ (BOOL)isEmpty:(NSArray *)array;

/**
 JSON转数组
 
 @param jsonString json字符串
 @return 数组实例
 */
+ (NSArray *)arrayWithJSON:(NSString *)jsonString;

/**
 数组转JSON字符串
 
 @return json字符串
 */
- (NSString *)convertToJSONString;

/**
 数组转Data
 
 @return json字符串
 */
- (NSData *)convertToData;
@end

NS_ASSUME_NONNULL_END
