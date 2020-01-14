//
//  XLProgressHUDHelper.m
//  XLComProject
//
//  Created by GDXL2012 on 2019/11/24.
//  Copyright © 2019 GDXL2012. All rights reserved.
//

#import "XLProgressHUDHelper.h"
#import "MBProgressHUD.h"
#import "XLMacroFont.h"
#import "XLDeviceMacro.h"
#import "NSString+XLCategory.h"

NSTimeInterval const toastShowTime      = 1.5f;
NSTimeInterval const toastMinShowTime   = 0.3f;
CGFloat        const toastTextFontSize  = 14.0f;
CGFloat        const toastMargin        = 10.0f;

@implementation XLProgressHUDHelper
/**
 显示提示信息
 
 @param toast <#toast description#>
 */
+(void)toast:(NSString *)toast{
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    [XLProgressHUDHelper toast:toast inView:window];
}

/**
 指定View上显示提示信息
 
 @param toast <#toast description#>
 @param view <#view description#>
 */
+(void)toast:(NSString *)toast inView:(UIView *)view{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = nil;
    hud.detailsLabel.text = toast;
    hud.margin = toastMargin;
    hud.minShowTime = toastMinShowTime;
    hud.removeFromSuperViewOnHide = YES;
    hud.userInteractionEnabled = NO;
    hud.detailsLabel.font = XLFont(toastTextFontSize);
    [hud hideAnimated:YES afterDelay:toastShowTime];
    hud.bezelView.backgroundColor = [UIColor colorWithWhite:0 alpha:1];
    UIColor *whiteColor = [UIColor whiteColor];
    hud.detailsLabel.textColor = whiteColor;
    hud.label.textColor = whiteColor;
}

/**
 window显示等待框
 
 @param tips <#tips description#>
 */
+(void)waitInfo:(NSString *)tips{
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    [XLProgressHUDHelper waitInfo:tips inView:window];
}

/**
 window上移除等待框
 */
+(void)hideHud{
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    [XLProgressHUDHelper hidenHubFromView:window];
}

/**
 view上显示等待框
 
 @param tips <#tips description#>
 @param view <#view description#>
 */
+(void)waitInfo:(NSString *)tips inView:(UIView *)view{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    if (![NSString isEmpty:tips]) {
        hud.label.text = tips;
    }
    hud.margin = toastMargin;
    CGPoint offset = hud.offset;
    offset.y = -XLNavTopHeight;
    hud.offset = offset;
    hud.minShowTime = toastMinShowTime;
    hud.removeFromSuperViewOnHide = YES;
    hud.bezelView.backgroundColor = [UIColor colorWithWhite:0 alpha:1];
    UIColor *whiteColor = [UIColor whiteColor];
    hud.detailsLabel.textColor = whiteColor;
    hud.label.textColor = whiteColor;
}

/**
 从view上移除等待框
 
 @param view <#view description#>
 */
+(void)hidenHubFromView:(UIView *)view{
    [MBProgressHUD hideHUDForView:view animated:NO];
}
@end
