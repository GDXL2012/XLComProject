//
//  NSDateFormatter+XLCategory.h
//  XLComProject
//
//  Created by GDXL2012 on 2019/11/24.
//  Copyright © 2019 GDXL2012. All rights reserved.
//
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDateFormatter (XLCategory)
+ (instancetype)dateFormatter;
+ (instancetype)defaultDateFormatter;   /*yyyy-MM-dd HH:mm:ss*/
+ (instancetype)dateFormatterWithFormat:(NSString *)dateFormat;

@end

NS_ASSUME_NONNULL_END
