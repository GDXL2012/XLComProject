//
//  XLApplicationTools.m
//  XLComProject
//
//  Created by GDXL2012 on 2019/11/27.
//  Copyright © 2019 GDXL2012. All rights reserved.
//

#import "XLApplicationTools.h"
#import "NSString+XLCategory.h"
#import "XLSystemMacro.h"

@implementation XLApplicationTools

/**
 是否能跳转
 
 @param urlScheme <#urlScheme description#>
 @return <#return value description#>
 */
+(BOOL)canOpenURLScheme:(NSString *)urlScheme{
    if ([NSString isEmpty:urlScheme]) {
        return NO;
    }
    UIApplication *application = [UIApplication sharedApplication];
    NSURL *URL = [NSURL URLWithString:urlScheme];
    if ([application canOpenURL:URL]) {
        return YES;
    } else {
        return NO;
    }
}

/**
 打开连接或跳转第三方应用
 
 @param urlScheme <#urlScheme description#>
 */
+(void)openURLScheme:(NSString *)urlScheme{
    if ([NSString isEmpty:urlScheme]) {
        return;
    }
    UIApplication *application = [UIApplication sharedApplication];
    NSURL *URL = [NSURL URLWithString:urlScheme];
    if (XLAvailableiOS10) {
        [application openURL:URL options:@{} completionHandler:nil];
    } else {
        [application openURL:URL];
    }
}

/**
 调用系统拨号
 
 @param phoneNumber <#phoneNumber description#>
 */
+(void)makePhoneCall:(NSString *)phoneNumber{
    if ([NSString isEmpty:phoneNumber]) {
        return;
    }
    NSString *urlScheme = [NSString stringWithFormat:@"tel://%@", phoneNumber];
    [XLApplicationTools openURLScheme:urlScheme];
}

/**
 调用系统发送消息：初始消息为空
 
 @param controller <#controller description#>
 @param recipients <#recipients description#>
 @param body <#body#>
 @param delegate <#delegate description#>
 */
+(void)sendSMS:(UIViewController *)controller
    recipients:(NSArray *)recipients
          body:(NSString *)body
      delegate:(id<MFMessageComposeViewControllerDelegate>)delegate;{
    MFMessageComposeViewController *msgVC = [[MFMessageComposeViewController alloc] init];
    if([MFMessageComposeViewController canSendText]) {
        msgVC.body = body;
        msgVC.recipients = recipients;
        msgVC.messageComposeDelegate = delegate;
        [controller presentViewController:msgVC animated:YES completion:nil];
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示信息" message:@"该设备暂无法发送短信" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *setting = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:setting];
        [controller presentViewController:alert animated:YES completion:nil];
    }
}

/// 执行方法
/// @param selectName <#selectName description#>
/// @param target <#target description#>
+(void)runFuncation:(NSString *)selectName target:(id)target{
    if (![NSString isEmpty:selectName] && target != nil) {
        SEL selector = NSSelectorFromString(selectName);
        IMP imp = [target methodForSelector:selector];
        CGRect (*func)(id, SEL) = (void *)imp;
        func(target, selector);
    }
}
@end
