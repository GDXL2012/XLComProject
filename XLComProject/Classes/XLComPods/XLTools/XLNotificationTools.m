//
//  XLNotificationTools.m
//  XLComProject
//
//  Created by GDXL2012 on 2019/11/27.
//  Copyright © 2019 GDXL2012. All rights reserved.
//

#import "XLNotificationTools.h"

#define XLNotifiCenter   [NSNotificationCenter defaultCenter]   // 通知单例

@implementation XLNotificationTools
#pragma mark 注册通知监听
+(void)addObserver:(id)observer selector:(SEL)selector name:(NSString *)name{
    [XLNotifiCenter addObserver:observer selector:selector name:name object:nil];
}
+(void)addObserver:(id)observer selector:(SEL)selector name:(NSString *)name object:(id)object{
    [XLNotifiCenter addObserver:observer selector:selector name:name object:object];
}

#pragma mark 移除通知监听
+(void)removeObserver:(id)observer{
    [XLNotifiCenter removeObserver:self];
}
+(void)removeObserver:(id)observer name:(NSString *)name{
    [XLNotifiCenter removeObserver:observer name:name object:nil];
}
+(void)removeObserver:(id)observer name:(NSString *)name object:(id)object{
    [XLNotifiCenter removeObserver:observer name:name object:object];
}

#pragma mark 发送通知
+(void)postNotificationName:(NSString *)name{
    [XLNotifiCenter postNotificationName:name object:nil];
}
+(void)postNotificationName:(NSString *)name object:(id)object{
    [XLNotifiCenter postNotificationName:name object:object];
}
+(void)postNotificationName:(NSString *)name object:(id)object userInfo:(NSDictionary *)userInfo{
    [XLNotifiCenter postNotificationName:name object:object userInfo:userInfo];
}
@end
