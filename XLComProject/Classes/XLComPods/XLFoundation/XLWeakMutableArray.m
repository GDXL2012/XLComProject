//
//  XLWeakMutableArray.m
//  XLComProject
//
//  Created by GDXL2012 on 2019/11/24.
//  Copyright © 2019 GDXL2012. All rights reserved.
//

#import "XLWeakMutableArray.h"

@interface XLWeakMutableArray()
@property (nonatomic, strong) NSPointerArray  *pointerArray;

@end

@implementation XLWeakMutableArray
- (instancetype)init {
    self = [super init];
    if (self) {
        _pointerArray = [NSPointerArray weakObjectsPointerArray];
    }
    return self;
}

+ (instancetype)array{
    XLWeakMutableArray *array = [[XLWeakMutableArray alloc] init];
    return array;
}
+ (instancetype)arrayWithObject:(id)anObject{
    XLWeakMutableArray *array = [[XLWeakMutableArray alloc] init];
    [array.pointerArray addPointer:(__bridge void *)(anObject)];
    return array;
}
+ (instancetype)arrayWithArray:(NSArray<id> *)array{
    XLWeakMutableArray *weakArray = [[XLWeakMutableArray alloc] init];
    NSInteger count = array.count;
    for (NSInteger index = 0; index < count; index ++) {
        NSObject *object = [array objectAtIndex:index];
        [weakArray.pointerArray addPointer:(__bridge void *)(object)];
    }
    return weakArray;
}

- (void)compact{    // eliminate NULLs
    [self.pointerArray compact];
}

- (void)addObject:(id)anObject{
    [self.pointerArray addPointer:(__bridge void *)(anObject)];
}

- (void)insertObject:(id)anObject atIndex:(NSUInteger)index{
    [self.pointerArray insertPointer:(__bridge void *)(anObject) atIndex:index];
}

- (void)removeLastObject{
    NSInteger count = self.pointerArray.count;
    if(count > 0){
        [self.pointerArray removePointerAtIndex:count - 1];
    }
}

- (void)removeObjectAtIndex:(NSUInteger)index{
    [self.pointerArray removePointerAtIndex:index];
}

- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject{
    [self.pointerArray replacePointerAtIndex:index withPointer:(__bridge void *)(anObject)];
}

- (void)addObjectsFromArray:(NSArray<id> *)otherArray{
    NSInteger count = otherArray.count;
    for (NSInteger index = 0; index < count; index ++) {
        NSObject *object = [otherArray objectAtIndex:index];
        [self.pointerArray addPointer:(__bridge void *)(object)];
    }
}

- (void)exchangeObjectAtIndex:(NSUInteger)idx1 withObjectAtIndex:(NSUInteger)idx2{
    void *idx1Ob = [self.pointerArray pointerAtIndex:idx1];
    void *idx2Ob = [self.pointerArray pointerAtIndex:idx2];
    [self.pointerArray replacePointerAtIndex:idx1 withPointer:idx2Ob];
    [self.pointerArray replacePointerAtIndex:idx2 withPointer:idx1Ob];
}
- (void)removeAllObjects{
    self.pointerArray = [NSPointerArray weakObjectsPointerArray];
}

-(NSArray *)allObjects{
    return self.pointerArray.allObjects;
}

-(NSInteger)count{
    return self.pointerArray.count;
}

/**
 *  获取数组中的对象(可以获取到NULL对象)
 *
 *  @param index 数组下标
 *
 *  @return 对象
 */
- (id)objectAtIndex:(NSUInteger)index{
    void *pointer = [self.pointerArray pointerAtIndex:index];
    return (__bridge id)(pointer);
}
@end
