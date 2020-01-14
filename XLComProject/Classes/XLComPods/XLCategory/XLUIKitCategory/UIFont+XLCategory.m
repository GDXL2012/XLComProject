//
//  UIFont+XLCategory.m
//  XLComProject
//
//  Created by GDXL2012 on 2019/11/24.
//  Copyright © 2019 GDXL2012. All rights reserved.
//

#import "UIFont+XLCategory.h"
#import "XLComPods.h"

@implementation UIFont (XLCategory)
+ (UIFont *)gradeFontWithName:(NSString *)fontName size:(CGFloat)fontSize{
    // 计算缩放后的字体大小
    CGFloat transFontsize = fontSize * [[XLComPods manager].fontConfig userFontScal];
    return [UIFont fontWithName:fontName size:transFontsize];
}

+ (UIFont *)gradeSystemFontOfSize:(CGFloat)fontSize{
    // 计算缩放后的字体大小
    CGFloat transFontsize = fontSize * [[XLComPods manager].fontConfig userFontScal];
    return [UIFont systemFontOfSize:transFontsize];
}

+ (UIFont *)gradeBoldSystemFontOfSize:(CGFloat)fontSize{
    // 计算缩放后的字体大小
    CGFloat transFontsize = fontSize * [[XLComPods manager].fontConfig userFontScal];
    return [UIFont boldSystemFontOfSize:transFontsize];
}

+ (UIFont *)gradeItalicSystemFontOfSize:(CGFloat)fontSize{
    // 计算缩放后的字体大小
    CGFloat transFontsize = fontSize * [[XLComPods manager].fontConfig userFontScal];
    return [UIFont italicSystemFontOfSize:transFontsize];
}
@end
