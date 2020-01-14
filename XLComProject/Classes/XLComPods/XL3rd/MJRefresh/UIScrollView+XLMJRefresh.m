//
//  UIScrollView+XLMJRefresh.m
//  XLComProject
//
//  Created by GDXL2012 on 2019/11/24.
//  Copyright © 2019 GDXL2012. All rights reserved.
//

#import "UIScrollView+XLMJRefresh.h"
#import "UIScrollView+MJRefresh.h"
#import "MJRefreshHeader.h"
#import "MJRefreshFooter.h"
#import <objc/runtime.h>
#import "NSObject+XLCategory.h"

@implementation UIScrollView (XLMJRefresh)
// MJRefresh 刷新方法替换
+(void)exchangeHeaderFooterMethod{
    Class class = [UIScrollView class];
    SEL method1 = @selector(setMj_header:);
    SEL method2 = @selector(setXL_header:);
    [NSObject exchangeClassImplementations:class originalSel:method1 newSel:method2 forClassMethod:NO];
    
    SEL method3 = @selector(mj_header);
    SEL method4 = @selector(XL_header);
    [NSObject exchangeClassImplementations:class originalSel:method3 newSel:method4 forClassMethod:NO];
    
    SEL method5 = @selector(setMj_footer:);
    SEL method6 = @selector(setXL_footer:);
    [NSObject exchangeClassImplementations:class originalSel:method5 newSel:method6 forClassMethod:NO];
    
    SEL method7 = @selector(mj_footer);
    SEL method8 = @selector(XL_footer);
    [NSObject exchangeClassImplementations:class originalSel:method7 newSel:method8 forClassMethod:NO];
}

static const char XLRefreshHeaderKey = '\0';
- (void)setXL_header:(MJRefreshHeader *)mj_header {
    if (mj_header != self.mj_header) {
        // 删除旧的，添加新的
        if (self.mj_header) {
            [self.mj_header removeFromSuperview];
        }
        if (mj_header) {
            [self insertSubview:mj_header atIndex:0];
        }
        // 存储新的
        objc_setAssociatedObject(self, &XLRefreshHeaderKey,
                                 mj_header, OBJC_ASSOCIATION_RETAIN);
    }
}

- (MJRefreshHeader *)XL_header {
    return objc_getAssociatedObject(self, &XLRefreshHeaderKey);
}

static const char XLRefreshFooterKey = '\0';
-(void)setXL_footer:(MJRefreshFooter *)mj_footer{
    if (mj_footer != self.mj_footer) {
        // 删除旧的，添加新的
        if(self.mj_footer){
            [self.mj_footer removeFromSuperview];
        }
        if (mj_footer) {
            [self insertSubview:mj_footer atIndex:0];
        }
        // 存储新的
        objc_setAssociatedObject(self, &XLRefreshFooterKey,
                                 mj_footer, OBJC_ASSOCIATION_RETAIN);
    }
}

- (MJRefreshFooter *)XL_footer {
    return objc_getAssociatedObject(self, &XLRefreshFooterKey);
}
@end
