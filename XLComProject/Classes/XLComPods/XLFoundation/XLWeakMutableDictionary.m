//
//  XLWeakMutableDictionary.m
//  XLComProject
//
//  Created by GDXL2012 on 2019/11/24.
//  Copyright © 2019 GDXL2012. All rights reserved.
//

#import "XLWeakMutableDictionary.h"
@interface XLWeakMutableDictionary()

@property (nonatomic, strong) NSMapTable *mapTable;

/**
 *  元素个数
 */
@property (nonatomic, assign) NSUInteger count;

@end

@implementation XLWeakMutableDictionary

+ (instancetype)dictionary{
    XLWeakMutableDictionary *weakDic = [[XLWeakMutableDictionary alloc] init];
    return weakDic;
}

+ (instancetype)dictionaryWithDictionary:(NSDictionary *)dict{
    XLWeakMutableDictionary *weakDic = [[XLWeakMutableDictionary alloc] init];
    [weakDic.mapTable setValuesForKeysWithDictionary:dict];
    return weakDic;
}

-(instancetype)init{
    self = [super init];
    if (self) {
        // 强引用key值弱引用object
        _mapTable = [NSMapTable strongToWeakObjectsMapTable];
    }
    return self;
}

/**
 *  获取对象
 *
 *  @param aKey 键值
 *  @return 对象 值
 */
- (id)objectForKey:(id)aKey{
    return [self.mapTable objectForKey:aKey];
}

/**
 *  根据键值移除对象
 *
 *  @param aKey 键值
 */
- (void)removeObjectForKey:(id)aKey{
    [self.mapTable removeObjectForKey:aKey];
}

/**
 *  添加对象
 *
 *  @param anObject 对象
 *  @param aKey     键值
 */
- (void)setObject:(id)anObject forKey:(id)aKey{
    if (anObject == nil || aKey == nil){
        NSLog(@"object or key should not be nil.");
        return;
    }
    [self.mapTable setObject:anObject forKey:aKey];
}

/**
 *  键值枚举器
 *
 *  @return 枚举器
 */
- (NSEnumerator *)keyEnumerator{
    return self.mapTable.keyEnumerator;
}

/**
 *  对象枚举器
 *
 *  @return 对象枚举器
 */
- (NSEnumerator *)objectEnumerator{
    return self.mapTable.objectEnumerator;
}

/**
 *  移除所有对象
 */
- (void)removeAllObjects{
    [self.mapTable removeAllObjects];
}

/**
 *  返回字典
 *
 *  @return 字典
 */
- (NSDictionary *)dictionaryRepresentation{
    return [self.mapTable dictionaryRepresentation];
}

- (NSUInteger)count{
    return self.mapTable.count;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@", self.mapTable.dictionaryRepresentation];
}
@end
