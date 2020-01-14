//
//  XLWeakMutableArray.h
//  XLComProject
//
//  Created by GDXL2012 on 2019/11/24.
//  Copyright © 2019 GDXL2012. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XLWeakMutableArray : NSObject

+ (instancetype)array;
+ (instancetype)arrayWithObject:(id)anObject;
+ (instancetype)arrayWithArray:(NSArray<id> *)array;

- (void)addObject:(id)anObject;
- (void)insertObject:(id)anObject atIndex:(NSUInteger)index;
- (void)removeLastObject;
- (void)removeObjectAtIndex:(NSUInteger)index;
- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject;

- (void)addObjectsFromArray:(NSArray<id> *)otherArray;
- (void)exchangeObjectAtIndex:(NSUInteger)idx1 withObjectAtIndex:(NSUInteger)idx2;
- (void)removeAllObjects;

- (void)compact;   // eliminate NULLs

/**
 *  获取所有对象
 */
@property (nonatomic, strong, readonly) NSArray *allObjects;

/**
 *  数组中有对象的个数
 */
@property (nonatomic, readonly) NSInteger count;

/**
 *  获取数组中的对象(可以获取到NULL对象)
 *
 *  @param index 数组下标
 *
 *  @return 对象
 */
- (id)objectAtIndex:(NSUInteger)index;
@end

NS_ASSUME_NONNULL_END
