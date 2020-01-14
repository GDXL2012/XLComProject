//
//  UIView+XLConstraints.m
//  XLComProject
//
//  Created by GDXL2012 on 2019/11/24.
//  Copyright © 2019 GDXL2012. All rights reserved.
//

#import "UIView+XLConstraints.h"
#import "Masonry.h"
#import "XLSystemMacro.h"
#import "XLDeviceMacro.h"
#import "UIView+XLAdditions.h"

@implementation UIView (XLConstraints)
/**
 设置约束条件
 
 @param view <#view description#>
 */
-(void)makeConstraintsWithView:(UIView *)view{
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        if (XLAvailableiOS11) {
            // 版本适配
            make.left.mas_equalTo(view.mas_safeLeft);
            make.right.mas_equalTo(view.mas_safeRight);
            make.bottom.mas_equalTo(view.mas_safeBottom);
            make.top.mas_equalTo(view.mas_safeTop);
        } else {
            make.left.mas_equalTo(view);
            make.right.mas_equalTo(view);
            make.bottom.mas_equalTo(view);
            make.top.mas_equalTo(view);
        }
    }];
}

/**
 设置约束条件：不考虑安全域
 
 @param view <#view description#>
 */
-(void)makeUnsafeConstraintsWithView:(UIView *)view{
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(view);
        make.right.mas_equalTo(view);
        make.bottom.mas_equalTo(view);
        make.top.mas_equalTo(view);
    }];
}

/**
 设置约束条件
 
 @param view <#view description#>
 */
-(void)makeConstraintsWithView:(UIView *)view edge:(UIEdgeInsets)insets{
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        if (XLAvailableiOS11) {
            // 版本适配
            make.left.mas_equalTo(view.mas_safeLeft).offset(insets.left);
            make.right.mas_equalTo(view.mas_safeRight).offset(-insets.right);
            make.bottom.mas_equalTo(view.mas_safeBottom).offset(-insets.bottom);
            make.top.mas_equalTo(view.mas_safeTop).offset(insets.top);
        } else {
            make.left.mas_equalTo(view).offset(insets.left);
            make.right.mas_equalTo(view).offset(-insets.right);
            make.bottom.mas_equalTo(view).offset(-insets.bottom);
            make.top.mas_equalTo(view).offset(insets.top);
        }
    }];
}

/**
 设置约束条件：不考虑安全域
 
 @param view <#view description#>
 */
-(void)makeUnsafeConstraintsWithView:(UIView *)view edge:(UIEdgeInsets)insets{
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(view).offset(insets.left);
        make.right.mas_equalTo(view).offset(-insets.right);
        make.bottom.mas_equalTo(view).offset(-insets.bottom);
        make.top.mas_equalTo(view).offset(insets.top);
    }];
}

/**
 设置约束条件
 
 @param view <#view description#>
 @param height <#view description#>
 */
-(void)makeConstraintsWithView:(UIView *)view height:(CGFloat)height{
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        if (XLAvailableiOS11) {
            // 版本适配
            make.left.mas_equalTo(view.mas_safeLeft);
            make.right.mas_equalTo(view.mas_safeRight);
            make.top.mas_equalTo(view.mas_safeTop);
        } else {
            make.left.mas_equalTo(view);
            make.right.mas_equalTo(view);
            make.top.mas_equalTo(view);
        }
        make.height.mas_equalTo(height);
    }];
}

/**
 设置约束条件：不考虑安全域
 
 @param view <#view description#>
 @param height <#view description#>
 */
-(void)makeUnsafeConstraintsWithView:(UIView *)view height:(CGFloat)height{
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(view);
        make.right.mas_equalTo(view);
        make.top.mas_equalTo(view);
        make.height.mas_equalTo(height);
    }];
}

/**
 设置约束条件
 
 @param view <#view description#>
 @param height <#view description#>
 */
-(void)makeConstraintsWithViewBottom:(UIView *)view height:(CGFloat)height{
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        if (XLAvailableiOS11) {
            // 版本适配
            make.left.mas_equalTo(view.mas_safeLeft);
            make.right.mas_equalTo(view.mas_safeRight);
            make.bottom.mas_equalTo(view.mas_safeBottom);
        } else {
            make.left.mas_equalTo(view);
            make.right.mas_equalTo(view);
            make.bottom.mas_equalTo(view);
        }
        make.height.mas_equalTo(height);
    }];
}

/**
 设置约束条件：不考虑安全域
 
 @param view <#view description#>
 @param height <#view description#>
 */
-(void)makeUnsafeConstraintsWithViewBottom:(UIView *)view height:(CGFloat)height{
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(view);
        make.right.mas_equalTo(view);
        make.bottom.mas_equalTo(view);
        make.height.mas_equalTo(height);
    }];
}

/**
 设置约束条件：顶部
 
 @param view <#view description#>
 @param ratio 宽高比
 */
-(void)makeConstraintsWithView:(UIView *)view ratio:(CGFloat)ratio{
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        if (XLAvailableiOS11) {
            // 版本适配
            make.left.mas_equalTo(view.mas_safeLeft);
            make.right.mas_equalTo(view.mas_safeRight);
            make.top.mas_equalTo(view.mas_safeTop);
        } else {
            make.left.mas_equalTo(view);
            make.right.mas_equalTo(view);
            make.top.mas_equalTo(view);
        }
        make.height.mas_equalTo(view.mas_width).multipliedBy(ratio);
    }];
}

/**
 设置约束条件：顶部 不考虑安全域
 
 @param view <#view description#>
 @param ratio 宽高比
 */
-(void)makeUnsafeConstraintsWithView:(UIView *)view ratio:(CGFloat)ratio{
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(view);
        make.right.mas_equalTo(view);
        make.top.mas_equalTo(view);
        make.height.mas_equalTo(view.mas_width).multipliedBy(ratio);
    }];
}

/**
 设置约束条件：底部
 
 @param view <#view description#>
 @param ratio 宽高比
 */
-(void)makeConstraintsWithViewBottom:(UIView *)view ratio:(CGFloat)ratio{
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        if (XLAvailableiOS11) {
            // 版本适配
            make.left.mas_equalTo(view.mas_safeLeft);
            make.right.mas_equalTo(view.mas_safeRight);
            make.bottom.mas_equalTo(view.mas_safeBottom);
        } else {
            make.left.mas_equalTo(view);
            make.right.mas_equalTo(view);
            make.bottom.mas_equalTo(view);
        }
        make.height.mas_equalTo(view.mas_width).multipliedBy(ratio);
    }];
}

/**
 设置约束条件：底部
 
 @param view <#view description#>
 @param ratio 宽高比
 */
-(void)makeUnsafeConstraintsWithViewBottom:(UIView *)view ratio:(CGFloat)ratio{
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(view);
        make.right.mas_equalTo(view);
        make.bottom.mas_equalTo(view);
        make.height.mas_equalTo(view.mas_width).multipliedBy(ratio);
    }];
}

/**
 设置约束条件
 
 @param view 父View
 @param header 头部
 @param bottom 底部
 */
-(void)makeConstraintsWithView:(UIView *)view header:(UIView *)header bottom:(UIView *)bottom{
    if (!header && !bottom) {
        [self makeConstraintsWithView:view];
    } else if (header && !bottom) {
        [self makeConstraintsWithView:view header:header];
    } else if (!header && bottom) {
        [self makeConstraintsWithView:view bottom:bottom];
    } else {
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            if (XLAvailableiOS11) {
                // 版本适配
                make.left.mas_equalTo(view.mas_safeLeft);
                make.right.mas_equalTo(view.mas_safeRight);
            } else {
                make.left.mas_equalTo(view);
                make.right.mas_equalTo(view);
            }
            make.top.mas_equalTo(header.mas_bottom);
            make.bottom.mas_equalTo(bottom.mas_top);
        }];
    }
}

/**
 设置约束条件
 
 @param view 父View
 @param header 头部
 @param bottom 底部
 */
-(void)makeUnsafeConstraintsWithView:(UIView *)view header:(UIView *)header bottom:(UIView *)bottom{
    if (!header && !bottom) {
        [self makeUnsafeConstraintsWithView:view];
    } else if (header && !bottom) {
        [self makeUnsafeConstraintsWithView:view header:header];
    } else if (!header && bottom) {
        [self makeUnsafeConstraintsWithView:view bottom:bottom];
    } else {
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(view);
            make.right.mas_equalTo(view);
            make.top.mas_equalTo(header.mas_bottom);
            make.bottom.mas_equalTo(bottom.mas_top);
        }];
    }
}

/**
 设置约束条件
 
 @param view 父View
 @param header 头部
 */
-(void)makeConstraintsWithView:(UIView *)view header:(UIView *)header{
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        if (XLAvailableiOS11) {
            // 版本适配
            make.left.mas_equalTo(view.mas_safeLeft);
            make.right.mas_equalTo(view.mas_safeRight);
            make.bottom.mas_equalTo(view.mas_safeBottom);
        } else {
            make.left.mas_equalTo(view);
            make.right.mas_equalTo(view);
            make.bottom.mas_equalTo(view);
        }
        make.top.mas_equalTo(header.mas_bottom);
    }];
}

/**
 设置约束条件
 
 @param view 父View
 @param header 头部
 */
-(void)makeUnsafeConstraintsWithView:(UIView *)view header:(UIView *)header{
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(view);
        make.right.mas_equalTo(view);
        make.bottom.mas_equalTo(view);
        make.top.mas_equalTo(header.mas_bottom);
    }];
}

/**
 设置约束条件
 
 @param view 父View
 @param bottom 底部
 */
-(void)makeConstraintsWithView:(UIView *)view bottom:(UIView *)bottom{
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        if (XLAvailableiOS11) {
            // 版本适配
            make.left.mas_equalTo(view.mas_safeLeft);
            make.right.mas_equalTo(view.mas_safeRight);
            make.top.mas_equalTo(view.mas_safeTop);
        } else {
            make.left.mas_equalTo(view);
            make.right.mas_equalTo(view);
            make.top.mas_equalTo(view);
        }
        make.bottom.mas_equalTo(bottom.mas_top);
    }];
}

/**
 设置约束条件
 
 @param view 父View
 @param bottom 底部
 */
-(void)makeUnsafeConstraintsWithView:(UIView *)view bottom:(UIView *)bottom{
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(view);
        make.right.mas_equalTo(view);
        make.top.mas_equalTo(view);
        make.bottom.mas_equalTo(bottom.mas_top);
    }];
}

/// 设置View抗压缩
-(void)setContentCompressionHugging{
    [self setContentHorCompressionHugging];
    [self setContentVerCompressionHugging];
}
/**
 设置view抗压缩
 */
-(void)setContentHorCompressionHugging{
    [self setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
}

/**
 设置view抗压缩
 */
-(void)setContentVerCompressionHugging{
    [self setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
}
@end
