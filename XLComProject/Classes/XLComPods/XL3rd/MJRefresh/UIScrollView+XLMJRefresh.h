//
//  UIScrollView+XLMJRefresh.h
//  XLComProject
//
//  Created by GDXL2012 on 2019/11/24.
//  Copyright © 2019 GDXL2012. All rights reserved.
//
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (XLMJRefresh)
// MJRefresh 刷新方法替换
+(void)exchangeHeaderFooterMethod;
@end

NS_ASSUME_NONNULL_END
