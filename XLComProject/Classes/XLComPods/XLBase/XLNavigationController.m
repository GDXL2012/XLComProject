//
//  XLNavigationController.m
//  XLComProject
//
//  Created by GDXL2012 on 2019/11/27.
//  Copyright © 2019 GDXL2012. All rights reserved.
//

#import "XLNavigationController.h"
#import "XLMacroColor.h"
#import "XLMacroFont.h"
#import "UIImage+XLCategory.h"

@interface XLNavigationController ()<UINavigationBarDelegate>
/// 页面已加载
@property(assign,nonatomic) BOOL viewHasLoad;
@end

@implementation XLNavigationController

- (void)setShowBarMetrics:(BOOL)showBarMetrics{
    _showBarMetrics = showBarMetrics;
    if (self.viewHasLoad) {
        [self setNavgationBarShadowHidden:!showBarMetrics];
    }
}

-(void)setNavigationBarTranslucent:(BOOL)navigationBarTranslucent{
    _navigationBarTranslucent = navigationBarTranslucent;
    if (self.viewHasLoad) {
        self.navigationBar.translucent = navigationBarTranslucent;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _viewHasLoad = YES;
    // Do any additional setup after loading the view.
    [self configNavigationBarStyle];
}

/// 设置导航栏分割线显示状态
/// @param shadowHidden shadowHidden description
-(void)setNavgationBarShadowHidden:(BOOL)shadowHidden{
    UIImage *themeImage = [UIImage imageWithColor:XLThemeColor];
    if (shadowHidden) {
        UIImage *image = [UIImage sepImageWithColor:XLComSepColor alpha:1.0f];
        [self.navigationBar setShadowImage:image];
        [self.navigationBar setBackgroundImage:themeImage forBarMetrics:UIBarMetricsDefault];
    } else {
        UIImage *image = [UIImage sepImageWithColor:XLThemeColor alpha:1.0f];
        [self.navigationBar setShadowImage:image];
        [self.navigationBar setBackgroundImage:themeImage forBarMetrics:UIBarMetricsDefault];
    }
}

/**
 配置导航栏风格
 */
-(void)configNavigationBarStyle {
    [self setNavgationBarShadowHidden:!self.showBarMetrics];
    
    // 此处代码移动到了基类中 因为会影响调用的系统界面标题颜色（比如发短信）
    self.navigationBar.translucent = self.navigationBarTranslucent;
    // 导航栏图标颜色
    [self.navigationBar setTintColor:XLBarTitleColor];
    // 导航栏背景色
    [self.navigationBar setBarTintColor:XLThemeColor];
    // 标题颜色字体大小
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:XLBarTitleColor, NSFontAttributeName : XLBarTitleFont};
    
    /// 导航栏左右Item字体大小、颜色
    [[UIBarButtonItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:XLBarItemFont, NSFontAttributeName,XLBarItemColor,NSForegroundColorAttributeName,nil] forState:UIControlStateNormal];
    [[UIBarButtonItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:XLBarItemFont, NSFontAttributeName,[XLBarItemColor colorWithAlphaComponent:0.5],NSForegroundColorAttributeName,nil] forState:UIControlStateHighlighted];
}

/**
 状态栏文本
 
 @return <#return value description#>
 */
-(UIStatusBarStyle)preferredStatusBarStyle{
    return [self.topViewController preferredStatusBarStyle];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 屏幕旋转屏
- (BOOL)shouldAutorotate {
    return [self.topViewController shouldAutorotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return [self.topViewController supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return [self.topViewController preferredInterfaceOrientationForPresentation];
}

/**
 标签页基类控制器
 
 @param vc 标签页
 @return 控制器
 */
+(XLNavigationController *)tabMainNavigationControllerWithVC:(UIViewController *)vc{
    XLNavigationController *nv = [[XLNavigationController alloc] initWithRootViewController:vc];
    return nv;
}

/// 底部标签栏设置
/// @param title <#title description#>
/// @param icon <#icon description#>
/// @param selIcon <#selIcon description#>
-(void)tabBarTitle:(NSString *)title icon:(NSString *)icon selIcon:(NSString *)selIcon{
    // 名称
    self.tabBarItem.title = title;
    UIImage *image = [UIImage imageNamed:icon];
    self.tabBarItem.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIImage *selImage = [UIImage imageNamed:selIcon];
    self.tabBarItem.selectedImage = [selImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor]} forState:UIControlStateNormal];
    [self.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:XLThemeColor} forState:UIControlStateSelected];
}

/// 底部标签栏设置
/// @param title <#title description#>
/// @param normal <#normal description#>
/// @param selected <#selected description#>
/// @param icon <#icon description#>
/// @param selIcon <#selIcon description#>
-(void)tabBarTitle:(NSString *)title normal:(UIColor *)normal selected:(UIColor *)selected icon:(NSString *)icon selIcon:(NSString *)selIcon{
    // 名称
    self.tabBarItem.title = title;
    UIImage *norImg = [UIImage imageNamed:icon];
    self.tabBarItem.image = [norImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIImage *selImg = [UIImage imageNamed:selIcon];
    self.tabBarItem.selectedImage = [selImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    [self.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:normal} forState:UIControlStateNormal];
    [self.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:selected} forState:UIControlStateSelected];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
