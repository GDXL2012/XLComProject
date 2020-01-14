//
//  XLBarButtonItem.m
//  XLComProject
//
//  Created by GDXL2012 on 2019/11/27.
//  Copyright © 2019 GDXL2012. All rights reserved.
//

#import "XLBarButtonItem.h"
#import "NSString+XLCategory.h"
#import "XLMacroColor.h"
#import "XLMacroFont.h"
#import "XLAdaptation.h"

#define BarButtonFrame       CGRectMake(0.0f, 0.0f, 46.0f, 30.0f)
#define RightBarButtonFrame  CGRectMake(0.0f, 0.0f, 40.0f, 30.0f)

@interface XLBarButtonItem ()
/**
 获取button对象
 
 @param buttonType button类型
 @return 返回button对象
 */
-(UIButton *)buttonWithType:(UIButtonType)buttonType;

@end

@implementation XLBarButtonItem

/**
 初始化
 
 @param target 回调目标对象
 @param action 按钮事件
 @param normalName 图片名称
 @param highName 图片名称
 @return 返回实例对象
 */
- (instancetype)initWithTarget:(id)target action:(SEL)action normalImage:(NSString *)normalName highImage:(NSString *)highName {
    UIButton *button = [self buttonWithType:UIButtonTypeCustom];
    self = [super initWithCustomView:button];
    if (self) {
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        if (![NSString isEmpty:normalName]) {
            [button setImage:[UIImage imageNamed:normalName] forState:UIControlStateNormal];
        } else if (![NSString isEmpty:highName]) {
            [button setImage:[UIImage imageNamed:highName] forState:UIControlStateNormal];
        }
        if (![NSString isEmpty:highName]) {
            [button setImage:[UIImage imageNamed:highName] forState:UIControlStateHighlighted];
        }
    }
    return self;
}

/**
 初始化
 
 @param target 回调目标对象
 @param action 按钮事件
 @param title 标题
 @return 返回实例对象
 */
- (instancetype)initWithTarget:(id)target action:(SEL)action title:(NSString *)title {
    return [self initWithTarget:target action:action title:title color:XLBarItemColor];
}

/**
 初始化
 
 @param target 回调目标对象
 @param action 按钮事件
 @param title 标题
 @param color 标题颜色
 @return 返回实例对象
 */
- (instancetype)initWithTarget:(id)target action:(SEL)action title:(NSString *)title color:(UIColor *)color {
    UIButton *button = [self buttonWithType:UIButtonTypeCustom];
    self = [super initWithCustomView:button];
    if (self) {
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:color forState:UIControlStateNormal];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
        button.titleLabel.font = XLBarItemFont;
        [button setTitle:title forState:UIControlStateNormal];
        [button sizeToFit];
    }
    return self;
}

/**
 获取button对象
 
 @param buttonType button类型
 @return 返回button对象
 */
-(UIButton *)buttonWithType:(UIButtonType)buttonType{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [button setFrame:BarButtonFrame];
    button.titleLabel.font = XLBarItemFont;
    return button;
}

@end

@implementation XLLeftBarButtonItem
/**
 获取button对象
 
 @param buttonType button类型
 @return 返回button对象
 */
-(UIButton *)buttonWithType:(UIButtonType)buttonType{
    UIButton *button = [super buttonWithType:buttonType];
    [button setFrame:BarButtonFrame];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    return button;
}

/**
 初始化
 
 @param target 回调目标对象
 @param action 按钮事件
 @param title 标题
 @return 返回实例对象
 */
- (instancetype)initWithTarget:(id)target action:(SEL)action title:(NSString *)title{
    title = @"";
    UIButton *button = [self buttonWithType:UIButtonTypeCustom];
    self = [super initWithCustomView:button];
    if (self) {
        UIImage *image = [UIImage imageNamed:@"icon_navigation_back"];
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        [button setImage:image forState:UIControlStateNormal];
        [button setImage:image forState:UIControlStateHighlighted];
        if ([NSString isEmpty:title]) {
            title = XLNSLocalized(@"返回");
        }
        // 处理返回按钮文本过长问题
        if(title.length >= 2){
            CGSize size = [NSString sizeWithFont:XLFont(16.0f) maxSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) string:title];
            CGRect rect = BarButtonFrame;
            if (size.width + 20 > rect.size.width) {
                rect.size.width = size.width + 20;
                [button setFrame:rect];
            }
        }
        
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitle:title forState:UIControlStateHighlighted];
        button.titleLabel.font = XLFont(16.0f);
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 8, 0, 0)];
    }
    return self;
}
@end

@implementation XLRightBarButtonItem

/**
 获取button对象
 
 @param buttonType button类型
 @return 返回button对象
 */
-(UIButton *)buttonWithType:(UIButtonType)buttonType{
    UIButton *button = [super buttonWithType:buttonType];
    [button setFrame:RightBarButtonFrame];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    button.imageView.contentMode = UIViewContentModeScaleAspectFit;
    return button;
}
@end
