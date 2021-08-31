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

@interface XLNavigationController ()<UINavigationBarDelegate>
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
    
    NSLog(@"self.navigationBar.delegate = %@", self.navigationBar.delegate);
}

/// 设置导航栏分割线显示状态
/// @param shadowHidden shadowHidden description
-(void)setNavgationBarShadowHidden:(BOOL)shadowHidden{
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
    
    NSString *string = [XLConfigManager xlConfigManager].adaptationConfig.backImageName;
    // 替换系统自带的返回按钮
    if (![NSString isEmpty:string]) {
        UIImage *buttonNormal = [[UIImage imageNamed:string] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [self.navigationController.navigationBar setBackIndicatorImage:buttonNormal];
        [self.navigationController.navigationBar setBackIndicatorTransitionMaskImage:buttonNormal];
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

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    self.hasPopViewController = NO;
    [super pushViewController:viewController animated:animated];
    viewController = nil;
}

#pragma mark - Bar Button
/// iOS 13 该方法控制导航栏跟页面pop操作
/// iOS 12 方法仅仅控制导航栏
- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item{
    if(!XLAvailableiOS13){
        return [self unavailableiOS13_navigationBar:navigationBar shouldPopItem:item];
    } else {
        return [self availableiOS13_navigationBar:navigationBar shouldPopItem:item];
    }
}

- (void)navigationBar:(UINavigationBar *)navigationBar didPopItem:(UINavigationItem *)item{
    NSLog(@"navigationBar didPopItem");
}

-(BOOL)unavailableiOS13_navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item{
    /// 注意：iOS 13以下，左滑手势会触发该方法，切只在层级超过3级及以上时才会触发
    /// 切手势方法不需要手动执行popViewControllerAnimated方法
    /// 导航栏左侧点击需要手动执行popViewControllerAnimated
    if (item.backBarButtonItem) {
        id target = item.backBarButtonItem.target;
        if (target && [target isKindOfClass:[XLBaseViewController class]]) {
            XLBaseViewController *baseVC = (XLBaseViewController *)target;
            if ([baseVC xlShouldPopViewControllerForGesture:NO]) {
//                if (!baseVC.xlPOPForGesture && !self.hasPopViewController) {
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        /// 需要自己调用pop方法，否者不能返回上级页面
//                        [self popViewControllerAnimated:YES];
//                        self.hasPopViewController = NO;
//                    });
//                } else {
//                    self.hasPopViewController = NO;
//                }
                if ((!baseVC.xlPOPForGesture && !self.hasPopViewController) || !self.hasPopViewController) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        /// 需要自己调用pop方法，否者不能返回上级页面
                        [self popViewControllerAnimated:YES];
                        self.hasPopViewController = NO;
                    });
                } else {
                    self.hasPopViewController = NO;
                }
                baseVC.xlPOPForGesture = NO;
                return YES;
            } else {
//                if (!baseVC.xlPOPForGesture || !self.hasPopViewController) {
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        /// 需要自己调用pop方法，否者不能返回上级页面
//                        [self popViewControllerAnimated:YES];
//                        self.hasPopViewController = NO;
//                    });
//                } else {
//                    self.hasPopViewController = NO;
//                }
                self.hasPopViewController = NO;
                baseVC.xlPOPForGesture = NO;
                return NO;
            }
        }
    }
    if (!self.hasPopViewController) {
        dispatch_async(dispatch_get_main_queue(), ^{
            /// 需要自己调用pop方法，否者不能返回上级页面
            [self popViewControllerAnimated:YES];
            self.hasPopViewController = NO;
        });
    }
    return YES;
}

-(BOOL)availableiOS13_navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item{
    /// iOS 13 手势方法不会触该方法
    /// 导航栏左侧点击触发该方法，但会自动执行pop操作
    if (item.backBarButtonItem) {
        id target = item.backBarButtonItem.target;
        if (target && [target isKindOfClass:[XLBaseViewController class]]) {
            XLBaseViewController *baseVC = (XLBaseViewController *)target;
            if ([baseVC xlShouldPopViewControllerForGesture:NO]) {
                return YES;
            } else {
                return NO;
            }
        }
    }
    return YES;
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
        /// 但push后再返回，tabBarItem选中颜色变为系统蓝色：iOS 13及以上需针对tabbar实例对象设置
        /// 实例代码如下:
        /// self.tabBar.tintColor = [UIColor blueColor];
        /// self.tabBar.unselectedItemTintColor = [UIColor lightGrayColor];
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
