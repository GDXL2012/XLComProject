//
//  XLNavigationController.m
//  XLComProject
//
//  Created by GDXL2012 on 2019/11/27.
//  Copyright © 2019 GDXL2012. All rights reserved.
//

#import "XLNavigationController.h"
#import "XLBaseViewController.h"
#import "XLMacroColor.h"
#import "XLMacroFont.h"
#import "UIImage+XLCategory.h"
#import "XLSystemMacro.h"
#import "NSString+XLCategory.h"

@interface XLNavigationController ()
/// 页面已加载
@property(nonatomic, assign) BOOL viewHasLoad;

@property(nonatomic, assign) BOOL hasPopViewController;
@end

@implementation XLNavigationController

-(instancetype)init{
    self = [super init];
    if (self) {
        _showBarMetrics = YES;
        _hasPopViewController = NO;
    }
    return self;
}

-(instancetype)initWithRootViewController:(UIViewController *)rootViewController{
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        _showBarMetrics = YES;
    }
    return self;
}

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
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance *barApp = self.navigationBar.scrollEdgeAppearance;
        if (barApp == nil) {
            barApp = [UINavigationBarAppearance new];
        }
        if (shadowHidden) {
            barApp.shadowColor = nil;
            barApp.backgroundColor = XLThemeColor;
        } else {
            barApp.shadowColor = XLComSepColor;
            barApp.backgroundColor = XLThemeColor;
        }
        self.navigationBar.scrollEdgeAppearance = barApp;
        self.navigationBar.standardAppearance = barApp;
    } else {
        UIImage *themeImage = [UIImage imageWithColor:XLThemeColor];
        if (shadowHidden) {
            UIImage *image = [UIImage sepImageWithColor:XLThemeColor alpha:1.0f];
            [self.navigationBar setShadowImage:image];
            [self.navigationBar setBackgroundImage:themeImage forBarMetrics:UIBarMetricsDefault];
        } else {
            UIImage *image = [UIImage sepImageWithColor:XLComSepColor alpha:1.0f];
            [self.navigationBar setShadowImage:image];
            [self.navigationBar setBackgroundImage:themeImage forBarMetrics:UIBarMetricsDefault];
        }
    }
}

/**
 配置导航栏风格
 */
-(void)configNavigationBarStyle {
    [self setNavgationBarShadowHidden:!self.showBarMetrics];
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance *barApp = self.navigationBar.scrollEdgeAppearance;
        if (barApp == nil) {
            barApp = [UINavigationBarAppearance new];
        }
        barApp.titleTextAttributes = @{NSForegroundColorAttributeName:XLBarTitleColor, NSFontAttributeName : XLBarTitleFont};
        self.navigationBar.scrollEdgeAppearance = barApp;
        self.navigationBar.standardAppearance = barApp;
    } else {
        // 导航栏图标颜色
        [self.navigationBar setTintColor:XLBarTitleColor];
        // 导航栏背景色
        [self.navigationBar setBarTintColor:XLThemeColor];
        
        // 标题颜色字体大小
        self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:XLBarTitleColor, NSFontAttributeName : XLBarTitleFont};
    }
    // 此处代码移动到了基类中 因为会影响调用的系统界面标题颜色（比如发短信）
    self.navigationBar.translucent = self.navigationBarTranslucent;
    
    /// 导航栏左右Item字体大小、颜色
    [[UIBarButtonItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:XLBarItemFont, NSFontAttributeName,XLBarItemColor,NSForegroundColorAttributeName,nil] forState:UIControlStateNormal];
    [[UIBarButtonItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:XLBarItemFont, NSFontAttributeName,[XLBarItemColor colorWithAlphaComponent:0.5],NSForegroundColorAttributeName,nil] forState:UIControlStateHighlighted];
    
    NSString *backImageName = [XLConfigManager xlConfigManager].adaptationConfig.backImageName;
    // 替换系统自带的返回按钮
    if (![NSString isEmpty:backImageName]) {
        // 替换系统自带的返回按钮
        UIImage *buttonNormal = [[UIImage imageNamed:backImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        if (@available(iOS 15.0, *)) {
            UINavigationBarAppearance *appearance = self.navigationController.navigationBar.scrollEdgeAppearance;
            if (appearance == nil) {
                appearance = [[UINavigationBarAppearance alloc] init];
            }
            [appearance setBackIndicatorImage:buttonNormal transitionMaskImage:buttonNormal];
            [[UINavigationBar appearance] setScrollEdgeAppearance:appearance];
            [[UINavigationBar appearance] setStandardAppearance:appearance];
        } else {
            [self.navigationController.navigationBar setBackIndicatorImage:buttonNormal];
            [self.navigationController.navigationBar setBackIndicatorTransitionMaskImage:buttonNormal];
        }
    }
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

/**
 手动实现左滑代理之后，手势返回不会触发：navigationBar:shouldPopItem:
 iOS 13 1）返回按钮判断navigationBar:shouldPopItem:，返回YES后导航栏跟页面自动执行pop操作
        2）手动调用popViewControllerAnimated 方法不会触发navigationBar:shouldPopItem:方法
        3）实现navigationBar:shouldPopItem:方法后不需要调用popViewControllerAnimated:方法
        4）手势会触发navigationBar:shouldPopItem:方法，返回YES后自动触发popViewControllerAnimated:
 iOS 12 1）返回按钮判断navigationBar:shouldPopItem:，返回YES后导航栏返回到前一页面，
        同时调用popViewControllerAnimated：方法返回页面
        2）手动调用popViewControllerAnimated，会触发navigationBar:shouldPopItem:方法，
        3）实现navigationBar:shouldPopItem:方法后需要调用popViewControllerAnimated:方法
        4）手势会触发navigationBar:shouldPopItem:方法，返回YES后会自动触发popViewControllerAnimated:
        5）⚠️注意 手势与手动调用popViewControllerAnimated方法的执行顺序不同
 */
/// iOS 13:popViewControllerAnimated 方法不会触发【navigationBar:shouldPopItem】
/// iOS 12及以下:popViewControllerAnimated 方法会触发【navigationBar:shouldPopItem】
- (UIViewController *)popViewControllerAnimated:(BOOL)animated{
    if (!XLAvailableiOS13) {
        self.hasPopViewController = YES;
    }
    return [super popViewControllerAnimated:animated];
}

- (NSArray<__kindof UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (!XLAvailableiOS13) {
        self.hasPopViewController = YES;
    }
    return [super popToViewController:viewController animated:animated];
}

- (NSArray<__kindof UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated{
    if (!XLAvailableiOS13) {
        self.hasPopViewController = YES;
    }
    return [super popToRootViewControllerAnimated:animated];
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    self.hasPopViewController = NO;
    [super pushViewController:viewController animated:animated];
    viewController = nil;
}

#pragma mark - Bar Button
/// iOS 13 该方法控制导航栏跟页面pop操作
/// iOS 12 方法仅仅控制导航栏
- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item{
    if(@available(iOS 13.0, *) || !self.hasPopViewController){
        UIViewController *topVc = self.topViewController;
        if ([topVc isKindOfClass:[XLBaseViewController class]]) {
            XLBaseViewController *baseVC = (XLBaseViewController *)topVc;
            if ([baseVC xlShouldPopViewControllerForGesture:NO]) {
                return [super navigationBar:navigationBar shouldPopItem:item];
            } else {
                return NO;
            }
        } else {
            return [super navigationBar:navigationBar shouldPopItem:item];
        }
    } else {
        return [super navigationBar:navigationBar shouldPopItem:item];
    }
}

- (void)navigationBar:(UINavigationBar *)navigationBar didPopItem:(UINavigationItem *)item{
    if (!XLAvailableiOS13) {
        self.hasPopViewController = NO;
    }
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
    if (XLAvailableiOS13) {
        /// 适配iOS 13发现设置UITabBarItem的颜色，未选中状态下无效为默认颜色，选中状态下有效
        UITabBarAppearance *bar = [UITabBarAppearance new];
        [bar.stackedLayoutAppearance.normal setTitleTextAttributes:@{NSForegroundColorAttributeName:normal}];
        [bar.stackedLayoutAppearance.selected setTitleTextAttributes:@{NSForegroundColorAttributeName:selected}];
        if(@available(iOS 15.0, *)){
            self.tabBarItem.scrollEdgeAppearance = bar;
        }
        self.tabBarItem.standardAppearance = bar;
    } else {
        [self.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:normal} forState:UIControlStateNormal];
        [self.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:selected} forState:UIControlStateSelected];
    }
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
