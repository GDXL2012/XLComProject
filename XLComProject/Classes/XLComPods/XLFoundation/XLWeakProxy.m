//
//  XLWeakProxy.m
//  XLComProject
//
//  Created by GDXL2012 on 2019/11/24.
//  Copyright © 2019 GDXL2012. All rights reserved.
//

#import "XLWeakProxy.h"

@interface XLWeakProxy ()
@property (nonatomic, weak) id weakTarget;
@end

@implementation XLWeakProxy

+(instancetype)proxyWithTarget:(id)target {
    return [[self alloc] initWithTarget:target];
}

-(instancetype)initWithTarget:(id)target {
    _weakTarget = target;
    return self;
}

-(void)forwardInvocation:(NSInvocation *)invocation {
    SEL sel = [invocation selector];
    if (self.weakTarget && [self.weakTarget respondsToSelector:sel]) {
        [invocation invokeWithTarget:self.weakTarget];
    }
}

//返回方法的签名。
-(NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    return [self.weakTarget methodSignatureForSelector:sel];
}

-(BOOL)respondsToSelector:(SEL)aSelector {
    return [self.weakTarget respondsToSelector:aSelector];
}
@end
