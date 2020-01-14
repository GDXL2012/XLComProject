//
//  XLWeakTimer.h
//  XLComProject
//
//  Created by GDXL2012 on 2019/11/24.
//  Copyright © 2019 GDXL2012. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XLWeakTimer : NSObject
+ (instancetype)weakTimerWithTimeInterval:(NSTimeInterval)time target:(id)aTarget selector:(SEL)aSelector userInfo:(id)userInfo repeats:(BOOL)repeats;

/**
 加入RunLoop中

 @param weakTimer <#weakTimer description#>
 @param mode <#mode description#>
 */
+ (void)addWeakTimer:(XLWeakTimer *)weakTimer forMode:(NSRunLoopMode)mode;

-(void)fire;

- (void)invalidate;

@property (copy) NSDate *fireDate;
@property (readonly) NSTimeInterval timeInterval;

@property NSTimeInterval tolerance API_AVAILABLE(macos(10.9), ios(7.0), watchos(2.0), tvos(9.0));

@property (readonly, getter=isValid) BOOL valid;

@property (readonly, retain) id userInfo;
@end

NS_ASSUME_NONNULL_END
