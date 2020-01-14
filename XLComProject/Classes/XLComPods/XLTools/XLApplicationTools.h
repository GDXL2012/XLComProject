//
//  XLApplicationTools.h
//  XLComProject
//
//  Created by GDXL2012 on 2019/11/27.
//  Copyright © 2019 GDXL2012. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>

NS_ASSUME_NONNULL_BEGIN
/// 应用工具
@interface XLApplicationTools : NSObject
/**
 是否能跳转
 
 @param urlScheme <#urlScheme description#>
 @return <#return value description#>
 */
+(BOOL)canOpenURLScheme:(NSString *)urlScheme;

/**
 打开连接或跳转第三方应用
 
 @param urlScheme <#urlScheme description#>
 */
+(void)openURLScheme:(NSString *)urlScheme;

/**
 调用系统拨号
 
 @param phoneNumber <#phoneNumber description#>
 */
+(void)makePhoneCall:(NSString *)phoneNumber;

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
      delegate:(id<MFMessageComposeViewControllerDelegate>)delegate;

/// 执行方法
/// @param selectName <#selectName description#>
/// @param target <#target description#>
+(void)runFuncation:(NSString *)selectName target:(id)target;
@end

NS_ASSUME_NONNULL_END
