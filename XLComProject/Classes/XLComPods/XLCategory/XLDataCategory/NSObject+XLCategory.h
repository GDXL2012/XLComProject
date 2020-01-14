//
//  NSObject+XLCategory.h
//  XLComProject
//
//  Created by GDXL2012 on 2019/11/24.
//  Copyright © 2019 GDXL2012. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (XLCategory)
/**
 方法替换
 @param cls  需要替换方法的类
 @param original 需要被替换的方法
 @param newSel 新方法
 @param classMethod yes 类方法
 */
+(void)exchangeClassImplementations:(Class)cls originalSel:(SEL)original newSel:(SEL)newSel forClassMethod:(BOOL)classMethod;
@end

NS_ASSUME_NONNULL_END
