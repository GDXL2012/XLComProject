//
//  XLColorConfig.m
//  XLComProject
//
//  Created by GDXL2012 on 2019/11/22.
//  Copyright © 2019 GDXL2012. All rights reserved.
//

#import "XLColorConfig.h"
#import "UIColor+XLCategory.h"
#import "XLSystemMacro.h"
#import <objc/runtime.h>
#import "XLComMacro.h"

@interface XLColorConfig ()
#ifdef XLAvailableiOS13
/// iOS 13适配动态颜色
/// 主题色：默认@"#FFFFFF"
@property (nonatomic, strong) UIColor *xlThemeColorDark;

/// 导航栏颜色：默认"#030303"
@property (nonatomic, strong) UIColor *xlBarTitleColorDark;

/// 导航栏颜色：xlBarTitleColor
@property (nonatomic, strong) UIColor *xlBarItemColorDark;

/// 背景颜色：默认"#F6F6F6"
@property (nonatomic, strong) UIColor *xlComBGColorDark;

/// 内容背景颜色：默认"#FFFFFF"
@property (nonatomic, strong) UIColor *xlContBGColorDark;

/// 内容分割背景颜色：默认"#F6F6F6"
@property (nonatomic, strong) UIColor *xlContSepColorDark;

/// 分割线颜色：默认"#E6E6E6"
@property (nonatomic, strong) UIColor *xlComSepColorDark;

/// 标题颜色：默认"#333333"
@property (nonatomic, strong) UIColor *xlTitleColorDark;

/// 副标题颜色：默认"#999999"
@property (nonatomic, strong) UIColor *xlSubTitleColorDark;

/// 详情颜色：默认"#333333"
@property (nonatomic, strong) UIColor *xlDetailColorDark;

/// 提示语颜色：默认"#999999"
@property (nonatomic, strong) UIColor *xlTipsColorDark;

/// 提醒、警示语颜色"#FA5151"
@property (nonatomic, strong) UIColor *xlWarningColorDark;

/// 占位符颜色：默认"#999999"
@property (nonatomic, strong) UIColor *xlHolderColorDark;

/// 其他信息颜色：时间等 默认"#999999"
@property (nonatomic, strong) UIColor *xlOtherColorDark;

@property (nonatomic, copy) NSMutableDictionary *xlExtColor;
#endif
@end
@implementation XLColorConfig
@synthesize xlThemeColor        = _xlThemeColor;
@synthesize xlThemeColorDark    = _xlThemeColorDark;
@synthesize xlBarTitleColor     = _xlBarTitleColor;
@synthesize xlBarTitleColorDark = _xlBarTitleColorDark;
@synthesize xlBarItemColor      = _xlBarItemColor;
@synthesize xlBarItemColorDark  = _xlBarItemColorDark;
@synthesize xlComBGColor        = _xlComBGColor;
@synthesize xlComBGColorDark    = _xlComBGColorDark;
@synthesize xlContBGColor       = _xlContBGColor;
@synthesize xlContBGColorDark   = _xlContBGColorDark;
@synthesize xlContSepColor      = _xlContSepColor;
@synthesize xlContSepColorDark  = _xlContSepColorDark;
@synthesize xlComSepColor       = _xlComSepColor;
@synthesize xlComSepColorDark   = _xlComSepColorDark;
@synthesize xlTitleColor        = _xlTitleColor;
@synthesize xlTitleColorDark    = _xlTitleColorDark;
@synthesize xlSubTitleColor     = _xlSubTitleColor;
@synthesize xlSubTitleColorDark = _xlSubTitleColorDark;
@synthesize xlDetailColor       = _xlDetailColor;
@synthesize xlDetailColorDark   = _xlDetailColorDark;
@synthesize xlTipsColor         = _xlTipsColor;
@synthesize xlTipsColorDark     = _xlTipsColorDark;
@synthesize xlWarningColor      = _xlWarningColor;
@synthesize xlWarningColorDark  = _xlWarningColorDark;
@synthesize xlHolderColor       = _xlHolderColor;
@synthesize xlHolderColorDark   = _xlHolderColorDark;
@synthesize xlOtherColor        = _xlOtherColor;
@synthesize xlOtherColorDark    = _xlOtherColorDark;

/// 默认配置
+(instancetype)defaultConfig{
    XLColorConfig *config = [[XLColorConfig alloc] init];
    [config defaultConfig];
    return config;
}

-(NSMutableDictionary *)xlExtColor{
    if (!_xlExtColor) {
        _xlExtColor = [NSMutableDictionary dictionary];
    }
    return _xlExtColor;
}

-(instancetype)init{
    self = [super init];
    if (self) {
        [self defaultConfig];
    }
    return self;
}

-(void)defaultConfig{
    UIColor *color = [UIColor colorWithHexString:@"#FFFFFF"];
    [self setXlThemColor:color dark:color];
    /// 导航栏颜色：默认"#030303"
    color = [UIColor colorWithHexString:@"#030303"];
    [self setXlBarTitleColor:color dark:color];

    /// 导航栏颜色：xlBarTitleColor
    color = [UIColor colorWithHexString:@"#030303"];
    [self setXlBarItemColor:color dark:color];

    /// 背景颜色：默认"#F6F6F6"
    color = [UIColor colorWithHexString:@"#F6F6F6"];
    [self setXlComBGColor:color dark:color];

    /// 内容背景颜色：默认"#FFFFFF"
    color = [UIColor colorWithHexString:@"#FFFFFF"];
    [self setXlContBGColor:color dark:color];

    /// 内容分割背景颜色：默认"#F6F6F6"
    color = [UIColor colorWithHexString:@"#F6F6F6"];
    [self setXlContSepColor:color dark:color];

    /// 分割线颜色：默认"#E6E6E6"
    color = [UIColor colorWithHexString:@"#E6E6E6"];
    [self setXlComSepColor:color dark:color];

    /// 标题颜色：默认"#333333"
    color = [UIColor colorWithHexString:@"#333333"];
    [self setXlTitleColor:color dark:color];

    /// 副标题颜色：默认"#999999"
    color = [UIColor colorWithHexString:@"#999999"];
    [self setXlSubTitleColor:color dark:color];

    /// 详情颜色：默认"#333333"
    color = [UIColor colorWithHexString:@"#333333"];
    [self setXlDetailColor:color dark:color];

    /// 提示语颜色：默认"#999999"
    color = [UIColor colorWithHexString:@"#999999"];
    [self setXlTipsColor:color dark:color];

    /// 提醒、警示语颜色"#FA5151"
    color = [UIColor colorWithHexString:@"#FA5151"];
    [self setXlWarningColor:color dark:color];

    /// 占位符颜色：默认"#999999"
    color = [UIColor colorWithHexString:@"#999999"];
    [self setXlHolderColor:color dark:color];

    /// 其他信息颜色：时间等 默认"#999999"
    color = [UIColor colorWithHexString:@"#999999"];
    [self setXlOtherColor:color dark:color];
}

#pragma mark - xlThemeColor
-(UIColor *)xlThemeColor{
    if (XLAvailableiOS13) {
        UIColor *color      = _xlThemeColor;
        UIColor *darkColor  = _xlThemeColorDark;
        return [UIColor dynamicColor:color dark:darkColor];
    } else {
        return _xlThemeColor;
    }
}

-(void)setXlThemeColor:(UIColor *)xlThemeColor{
    _xlThemeColor = xlThemeColor;
    _xlThemeColorDark = nil;
}

/// 适配iOS 13 深色模式
/// @param color <#color description#>
/// @param darkColor <#darkColor description#>
-(void)setXlThemColor:(UIColor *)color dark:(UIColor *)darkColor{
    _xlThemeColor = color;
    if (XLAvailableiOS13) {
        _xlThemeColorDark = darkColor;
    }
}

#pragma mark xlBarTitleColor
/// 导航栏颜色：默认"#030303"
-(UIColor *)xlBarTitleColor{
    if (XLAvailableiOS13) {
        UIColor *color      = _xlBarTitleColor;
        UIColor *darkColor  = _xlBarTitleColorDark;
        return [UIColor dynamicColor:color dark:darkColor];
    } else {
        return _xlBarTitleColor;
    }
}

-(void)setXlBarTitleColor:(UIColor *)xlBarTitleColor{
    _xlBarTitleColor = xlBarTitleColor;
    if (XLAvailableiOS13) {
        _xlBarTitleColorDark = xlBarTitleColor;
    }
    if(!_xlBarItemColor){
        [self setXlBarItemColor:xlBarTitleColor dark:xlBarTitleColor];
    }
}

-(void)setXlBarTitleColor:(UIColor *)xlBarTitleColor dark:(UIColor *)darkColor{
    _xlBarTitleColor = xlBarTitleColor;
    if (XLAvailableiOS13) {
        _xlBarTitleColorDark = darkColor;
    }
    if(!_xlBarItemColor){
        [self setXlBarItemColor:xlBarTitleColor dark:darkColor];
    }
}

#pragma mark xlBarItemColor
/// 导航栏颜色：默认xlBarTitleColor
-(UIColor *)xlBarItemColor{
    if (XLAvailableiOS13) {
        UIColor *color      = _xlBarItemColor;
        UIColor *darkColor  = _xlBarItemColorDark;
        return [UIColor dynamicColor:color dark:darkColor];
    } else {
        return _xlBarItemColor;
    }
}

-(void)setXlBarItemColor:(UIColor *)xlBarItemColor{
    _xlBarItemColor = xlBarItemColor;
    if (XLAvailableiOS13) {
        _xlBarTitleColorDark = xlBarItemColor;
    }
}

-(void)setXlBarItemColor:(UIColor *)xlBarItemColor dark:(UIColor *)darkColor{
    _xlBarItemColor = xlBarItemColor;
    if (XLAvailableiOS13) {
        _xlBarTitleColorDark = darkColor;
    }
}

#pragma mark - xlComBGColor
/// 背景颜色：默认"#F6F6F6"
-(UIColor *)xlComBGColor{
    if (XLAvailableiOS13) {
        UIColor *color      = _xlComBGColor;
        UIColor *darkColor  = _xlComBGColorDark;
        return [UIColor dynamicColor:color dark:darkColor];
    } else {
        return _xlComBGColor;
    }
}

-(void)setXlComBGColor:(UIColor *)xlComBGColor{
    _xlComBGColor = xlComBGColor;
    if (XLAvailableiOS13) {
        _xlComBGColorDark = xlComBGColor;
    }
}

-(void)setXlComBGColor:(UIColor *)xlComBGColor dark:(UIColor *)darkColor{
    _xlComBGColor = xlComBGColor;
    if (XLAvailableiOS13) {
        _xlComBGColorDark = darkColor;
    }
}

#pragma mark - xlContBGColor
/// 内容背景颜色：默认"#FFFFFF"
-(UIColor *)xlContBGColor{
    if (XLAvailableiOS13) {
        UIColor *color      = _xlContBGColor;
        UIColor *darkColor  = _xlContBGColorDark;
        return [UIColor dynamicColor:color dark:darkColor];
    } else {
        return _xlContBGColor;
    }
}

-(void)setXlContBGColor:(UIColor *)xlContBGColor{
    _xlContBGColor = xlContBGColor;
    if (XLAvailableiOS13) {
        _xlContBGColorDark = xlContBGColor;
    }
}
-(void)setXlContBGColor:(UIColor *)xlContBGColor dark:(UIColor *)darkColor{
    _xlContBGColor = xlContBGColor;
    if (XLAvailableiOS13) {
        _xlContBGColorDark = darkColor;
    }
}

#pragma mark - xlContSepColor
/// 内容分割背景颜色：默认"#F6F6F6"
-(UIColor *)xlContSepColor{
    if (XLAvailableiOS13) {
        UIColor *color      = _xlContSepColor;
        UIColor *darkColor  = _xlContSepColorDark;
        return [UIColor dynamicColor:color dark:darkColor];
    } else {
        return _xlContSepColor;
    }
}

-(void)setXlContSepColor:(UIColor *)xlContSepColor{
    _xlContSepColor = xlContSepColor;
    if (XLAvailableiOS13) {
        _xlContSepColorDark = xlContSepColor;
    }
}

-(void)setXlContSepColor:(UIColor *)xlContSepColor dark:(UIColor *)darkColor{
    _xlContSepColor = xlContSepColor;
    if (XLAvailableiOS13) {
        _xlContSepColorDark = darkColor;
    }
}

#pragma mark - xlComSepColor
/// 分割线颜色：默认"#E6E6E6"
-(UIColor *)xlComSepColor{
    if (XLAvailableiOS13) {
        UIColor *color      = _xlComSepColor;
        UIColor *darkColor  = _xlComSepColorDark;
        return [UIColor dynamicColor:color dark:darkColor];
    } else {
        return _xlComSepColor;
    }
}

-(void)setXlComSepColor:(UIColor *)xlComSepColor{
    _xlComSepColor = xlComSepColor;
    if (XLAvailableiOS13) {
        _xlComSepColorDark = xlComSepColor;
    }
}

-(void)setXlComSepColor:(UIColor *)xlComSepColor dark:(UIColor *)darkColor{
    _xlComSepColor = xlComSepColor;
    if (XLAvailableiOS13) {
        _xlComSepColorDark = darkColor;
    }
}

#pragma mark - xlTitleColor
/// 标题颜色：默认"#333333"
-(UIColor *)xlTitleColor{
    if (XLAvailableiOS13) {
        UIColor *color      = _xlTitleColor;
        UIColor *darkColor  = _xlTitleColorDark;
        return [UIColor dynamicColor:color dark:darkColor];
    } else {
        return _xlTitleColor;
    }
}

-(void)setXlTitleColor:(UIColor *)xlTitleColor{
    _xlTitleColor = xlTitleColor;
    if (XLAvailableiOS13) {
        _xlTitleColorDark = xlTitleColor;
    }
}

-(void)setXlTitleColor:(UIColor *)xlTitleColor dark:(UIColor *)darkColor{
    _xlTitleColor = xlTitleColor;
    if (XLAvailableiOS13) {
        _xlTitleColorDark = darkColor;
    }
}

#pragma mark - xlSubTitleColor
/// 副标题颜色：默认"#999999"
-(UIColor *)xlSubTitleColor{
    if (XLAvailableiOS13) {
        UIColor *color      = _xlSubTitleColor;
        UIColor *darkColor  = _xlSubTitleColorDark;
        return [UIColor dynamicColor:color dark:darkColor];
    } else {
        return _xlSubTitleColor;
    }
}

-(void)setXlSubTitleColor:(UIColor *)xlSubTitleColor{
    _xlSubTitleColor = xlSubTitleColor;
    if (XLAvailableiOS13) {
        _xlSubTitleColorDark = xlSubTitleColor;
    }
}

-(void)setXlSubTitleColor:(UIColor *)xlSubTitleColor dark:(UIColor *)darkColor{
    _xlSubTitleColor = xlSubTitleColor;
    if (XLAvailableiOS13) {
        _xlSubTitleColorDark = darkColor;
    }
}

#pragma mark - xlDetailColor
/// 详情颜色：默认"#333333"
-(UIColor *)xlDetailColor{
    if (XLAvailableiOS13) {
        UIColor *color      = _xlDetailColor;
        UIColor *darkColor  = _xlDetailColorDark;
        return [UIColor dynamicColor:color dark:darkColor];
    } else {
        return _xlDetailColor;
    }
}

-(void)setXlDetailColor:(UIColor *)xlDetailColor{
    _xlDetailColor = xlDetailColor;
    if (XLAvailableiOS13) {
        _xlDetailColorDark = xlDetailColor;
    }
}

-(void)setXlDetailColor:(UIColor *)xlDetailColor dark:(UIColor *)darkColor{
    _xlDetailColor = xlDetailColor;
    if (XLAvailableiOS13) {
        _xlDetailColorDark = darkColor;
    }
}

#pragma mark - xlTipsColor
/// 提示语颜色：默认"#999999"
-(UIColor *)xlTipsColor{
    if (XLAvailableiOS13) {
        UIColor *color      = _xlTipsColor;
        UIColor *darkColor  = _xlTipsColorDark;
        return [UIColor dynamicColor:color dark:darkColor];
    } else {
        return _xlTipsColor;
    }
}

-(void)setXlTipsColor:(UIColor *)xlTipsColor{
    _xlTipsColor = xlTipsColor;
    if (XLAvailableiOS13) {
        _xlTipsColorDark = xlTipsColor;
    }
}

-(void)setXlTipsColor:(UIColor *)xlTipsColor dark:(UIColor *)darkColor{
    _xlTipsColor = xlTipsColor;
    if (XLAvailableiOS13) {
        _xlTipsColorDark = darkColor;
    }
}

#pragma mark - xlWarningColor
/// 提醒、警示语颜色"#FA5151"
-(UIColor *)xlWarningColor{
    if (XLAvailableiOS13) {
        UIColor *color = _xlWarningColor;
        UIColor *darkColor = _xlWarningColorDark;
        return [UIColor dynamicColor:color dark:darkColor];
    } else {
        return _xlWarningColor;
    }
}

-(void)setXlWarningColor:(UIColor *)xlWarningColor{
    _xlWarningColor = xlWarningColor;
    if (XLAvailableiOS13) {
        _xlWarningColorDark = xlWarningColor;
    }
}

-(void)setXlWarningColor:(UIColor *)xlWarningColor dark:(UIColor *)darkColor{
    _xlWarningColor = xlWarningColor;
    if (XLAvailableiOS13) {
        _xlWarningColorDark = darkColor;
    }
}

#pragma mark - xlHolderColor
/// 占位符颜色：默认"#999999"
-(UIColor *)xlHolderColor{
    if (XLAvailableiOS13) {
        UIColor *color = _xlHolderColor;
        UIColor *darkColor = _xlHolderColorDark;
        return [UIColor dynamicColor:color dark:darkColor];
    } else {
        return _xlHolderColor;
    }
}

-(void)setXlHolderColor:(UIColor *)xlHolderColor{
    _xlHolderColor = xlHolderColor;
    if (XLAvailableiOS13) {
        _xlHolderColorDark = xlHolderColor;
    }
}

-(void)setXlHolderColor:(UIColor *)xlHolderColor dark:(UIColor *)darkColor{
    _xlHolderColor = xlHolderColor;
    if (XLAvailableiOS13) {
        _xlHolderColorDark = darkColor;
    }
}

#pragma mark - xlOtherColor
/// 其他信息颜色：时间等 默认"#999999"
-(UIColor *)xlOtherColor{
    if (XLAvailableiOS13) {
        UIColor *color = _xlOtherColor;
        UIColor *darkColor = _xlOtherColorDark;
        return [UIColor dynamicColor:color dark:darkColor];
    } else {
        return _xlOtherColor;
    }
}

-(void)setXlOtherColor:(UIColor *)xlOtherColor{
    _xlOtherColor = xlOtherColor;
    if (XLAvailableiOS13) {
        _xlOtherColorDark = xlOtherColor;
    }
}

-(void)setXlOtherColor:(UIColor *)xlOtherColor dark:(UIColor *)darkColor{
    _xlOtherColor = xlOtherColor;
    if (XLAvailableiOS13) {
        _xlOtherColorDark = darkColor;
    }
}

#pragma mark - Ext Color
-(UIColor *)xlExtColorForKey:(NSString *)key{
    UIColor *color = [self.xlExtColor valueForKey:key];
    if (!color) {
        return nil;
    }
    if (XLAvailableiOS13) {
        NSString *darkKey =  [key stringByAppendingString:@"_dark"];
        UIColor *darkColor = [self.xlExtColor valueForKey:darkKey];
        return [UIColor dynamicColor:color dark:darkColor];
    } else {
        return color;
    }
}

/// 设置扩展颜色
/// @param key 颜色key值
/// @param color <#color description#>
-(void)setXLExtColorForKey:(NSString *)key color:(UIColor *)color{
    [self.xlExtColor setValue:color forKey:key];
}

/// 设置扩展颜色
/// @param key 颜色key值
/// @param light 默认模式颜色
/// @param darkColor 深色模式
-(void)setXLExtColorForKey:(NSString *)key light:(UIColor *)light dark:(UIColor *)darkColor{
    [self.xlExtColor setValue:light forKey:key];
    NSString *darkKey =  [key stringByAppendingString:@"_dark"];
    [self.xlExtColor setValue:darkColor forKey:darkKey];
}

@end
