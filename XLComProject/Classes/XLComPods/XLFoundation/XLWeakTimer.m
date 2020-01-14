//
//  XLWeakTimer.m
//  XLComProject
//
//  Created by GDXL2012 on 2019/11/24.
//  Copyright © 2019 GDXL2012. All rights reserved.
//

#import "XLWeakTimer.h"
#import "XLWeakProxy.h"

@interface XLWeakTimer ()
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation XLWeakTimer
+ (instancetype)weakTimerWithTimeInterval:(NSTimeInterval)time target:(id)target selector:(SEL)selector userInfo:(id)userInfo repeats:(BOOL)repeats{
    return [[XLWeakTimer alloc] initWithTimeInterval:time target:target selector:selector userInfo:userInfo repeats:repeats];
}

/**
 <#Description#>
 
 @param weakTimer <#weakTimer description#>
 @param mode <#mode description#>
 */
+ (void)addWeakTimer:(XLWeakTimer *)weakTimer forMode:(NSRunLoopMode)mode{
    [[NSRunLoop mainRunLoop] addTimer:weakTimer.timer forMode:mode];
}

-(void)dealloc{
    if (_timer && [_timer isValid]) {
        [_timer invalidate];
        _timer = nil;
    }
}

-(instancetype)initWithTimeInterval:(NSTimeInterval)time target:(id)target selector:(SEL)selector userInfo:(id)userInfo repeats:(BOOL)repeats{
    self = [super init];
    if (self) {
        XLWeakProxy *weakProxy = [XLWeakProxy proxyWithTarget:target];
        _timer = [NSTimer scheduledTimerWithTimeInterval:time target:weakProxy selector:selector userInfo:userInfo repeats:repeats];
    }
    return self;
}

-(void)fire{
    [self.timer fire];
}

#pragma mark -
-(NSDate *)fireDate{
    return [self.timer fireDate];
}

-(void)setFireDate:(NSDate *)fireDate{
    self.timer.fireDate = fireDate;
}

-(NSTimeInterval)timeInterval{
    return self.timer.timeInterval;
}

-(NSTimeInterval)tolerance{
    return self.timer.tolerance;
}

-(void)setTolerance:(NSTimeInterval)tolerance{
    self.timer.tolerance = tolerance;
}

- (void)invalidate{
    [self.timer invalidate];
}

-(BOOL)isValid{
    return [self.timer isValid];
}

-(id)userInfo{
    return [self.timer userInfo];
}
@end
