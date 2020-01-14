//
//  NSObject+XLCategory.m
//  XLComProject
//
//  Created by GDXL2012 on 2019/11/24.
//  Copyright © 2019 GDXL2012. All rights reserved.
//

#import "NSObject+XLCategory.h"
#import <objc/runtime.h>

@implementation NSObject (XLCategory)
/**
 方法替换
 @param cls  需要替换方法的类
 @param original 需要被替换的方法
 @param newSel 新方法
 @param classMethod yes 类方法
 */
+(void)exchangeClassImplementations:(Class)cls originalSel:(SEL)original newSel:(SEL)newSel forClassMethod:(BOOL)classMethod{
    Method originalMethod = nil;
    Method newMethod = nil;
    
    if (classMethod) {
        originalMethod = class_getClassMethod(cls, original);
        newMethod = class_getClassMethod(cls, newSel);
    } else {
        originalMethod = class_getInstanceMethod(cls, original);
        newMethod = class_getInstanceMethod(cls, newSel);
    }
    
    if (!originalMethod) {
        NSLog(@"Error: originalMethod 为空, 是否拼写错误? %@", originalMethod);
        return;
    }
    method_exchangeImplementations(originalMethod, newMethod);
}
@end
