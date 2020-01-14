//
//  UITextField+XLCategory.h
//  XLComProject
//
//  Created by GDXL2012 on 2019/11/25.
//  Copyright © 2019 GDXL2012. All rights reserved.
//
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextField (XLCategory)

/**
 设置占位文字颜色

 @param placeholder 占位文字
 @param color 颜色
 */
-(void)setPlaceholder:(NSString *)placeholder color:(UIColor *)color;
@end

NS_ASSUME_NONNULL_END
