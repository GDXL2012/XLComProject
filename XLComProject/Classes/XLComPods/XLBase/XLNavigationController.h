//
//  XLNavigationController.h
//  XLComProject
//
//  Created by GDXL2012 on 2019/11/27.
//  Copyright © 2019 GDXL2012. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XLNavigationController : UINavigationController

/// 显示导航栏分割线：默认YES
@property(nonatomic,assign) BOOL showBarMetrics;
/// 导航栏头透明：默认NO
@property(nonatomic,assign) BOOL navigationBarTranslucent;

/**
 标签页基类控制器
 
 @param vc 标签页
 @return 控制器
 */
+(XLNavigationController *)tabMainNavigationControllerWithVC:(UIViewController *)vc;

/// 底部标签栏设置
/// @param title <#title description#>
/// @param icon <#icon description#>
/// @param selIcon <#selIcon description#>
-(void)tabBarTitle:(NSString *)title icon:(NSString *)icon selIcon:(NSString *)selIcon;

/// 底部标签栏设置
/// @param title <#title description#>
/// @param normal <#normal description#>
/// @param selected <#selected description#>
/// @param icon <#icon description#>
/// @param selIcon <#selIcon description#>
-(void)tabBarTitle:(NSString *)title normal:(UIColor *)normal selected:(UIColor *)selected icon:(NSString *)icon selIcon:(NSString *)selIcon;
@end

NS_ASSUME_NONNULL_END
