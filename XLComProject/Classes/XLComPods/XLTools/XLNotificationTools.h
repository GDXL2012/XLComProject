//
//  XLNotificationTools.h
//  XLComProject
//
//  Created by GDXL2012 on 2019/11/27.
//  Copyright © 2019 GDXL2012. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 通知工具
@interface XLNotificationTools : NSObject
#pragma mark 注册通知监听
+(void)addObserver:(id)observer selector:(SEL)selector name:(NSString *)name;
+(void)addObserver:(id)observer selector:(SEL)selector name:(NSString *)name object:(id)object;

#pragma mark 移除通知监听
+(void)removeObserver:(id)observer;
+(void)removeObserver:(id)observer name:(NSString *)name;
+(void)removeObserver:(id)observer name:(NSString *)name object:(id)object;

#pragma mark 发送通知
+(void)postNotificationName:(NSString *)name;
+(void)postNotificationName:(NSString *)name object:(id)object;
+(void)postNotificationName:(NSString *)name object:(id)object userInfo:(NSDictionary *)userInfo;
@end

NS_ASSUME_NONNULL_END
