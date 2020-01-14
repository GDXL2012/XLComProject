//
//  UIFont+XLCategory.h
//  XLComProject
//
//  Created by GDXL2012 on 2019/11/24.
//  Copyright © 2019 GDXL2012. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIFont (XLCategory)
+ (UIFont *)gradeFontWithName:(NSString *)fontName size:(CGFloat)fontSize;
+ (UIFont *)gradeSystemFontOfSize:(CGFloat)fontSize;
+ (UIFont *)gradeBoldSystemFontOfSize:(CGFloat)fontSize;
+ (UIFont *)gradeItalicSystemFontOfSize:(CGFloat)fontSize;
@end

NS_ASSUME_NONNULL_END
