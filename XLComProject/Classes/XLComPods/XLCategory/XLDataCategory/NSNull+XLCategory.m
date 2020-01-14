//
//  NSNull+XLCategory.m
//  XLComProject
//
//  Created by GDXL2012 on 2019/11/24.
//  Copyright © 2019 GDXL2012. All rights reserved.
//

#import "NSNull+XLCategory.h"

@implementation NSNull (XLCategory)
/**
 * 添加的目的是为了解决一部分与数据为NULL时相关的崩溃问题
 * 将你调用的不存在的方法重定向到一个其他声明了这个方法的类，只需要你返回一个有这个方法的target
 */
-(id)forwardingTargetForSelector:(SEL)aSelector{
#ifdef Debug
    NSString *targetString = @"";
    return targetString;
#else
    return self;
#endif
    
}
@end
