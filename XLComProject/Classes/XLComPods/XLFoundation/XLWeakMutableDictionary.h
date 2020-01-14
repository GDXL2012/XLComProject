//
//  XLWeakMutableDictionary.h
//  XLComProject
//
//  Created by GDXL2012 on 2019/11/24.
//  Copyright © 2019 GDXL2012. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XLWeakMutableDictionary : NSObject
/**
 *  元素个数
 */
@property (nonatomic ,readonly) NSUInteger count;

+ (instancetype)dictionary;
+ (instancetype)dictionaryWithDictionary:(NSDictionary *)dict;

/**
 *  获取对象
 *
 *  @param aKey 键值
 *  @return 对象 值
 */
- (id)objectForKey:(id)aKey;

/**
 *  根据键值移除对象
 *
 *  @param aKey 键值
 */
- (void)removeObjectForKey:(id)aKey;

/**
 *  添加对象
 *
 *  @param anObject 对象
 *  @param aKey     键值
 */
- (void)setObject:(id)anObject forKey:(id)aKey;

/**
 *  键值枚举器:遍历用
 *
 *  @return 枚举器
 */
- (NSEnumerator *)keyEnumerator;

/**
 *  对象枚举器：遍历用
 *
 *  @return 对象枚举器
 */
- (NSEnumerator *)objectEnumerator;

/**
 *  移除所有对象
 */
- (void)removeAllObjects;

/**
 *  返回字典
 *
 *  @return 字典
 */
- (NSDictionary *)dictionaryRepresentation;
@end

NS_ASSUME_NONNULL_END
