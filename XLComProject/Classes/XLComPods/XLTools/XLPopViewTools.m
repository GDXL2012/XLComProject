//
//  XLPopViewTools.m
//  XLComProject
//
//  Created by GDXL2012 on 2019/11/27.
//  Copyright © 2019 GDXL2012. All rights reserved.
//

#import "XLPopViewTools.h"
#import "Masonry.h"

@implementation XLPopViewTools
/**
 Windon主窗口中显示弹窗
 
 @param view 被弹出View
 */
+(void)showPopViewInWindow:(UIView *)view{
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    [window addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(window);
    }];
}

/**
 指定窗口中弹窗
 
 @param popView 弹窗
 @param superView 目标View
 */
+(void)showPopView:(UIView *)popView inView:(UIView *)superView{
    [superView addSubview:popView];
    [popView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(superView);
    }];
}
@end
