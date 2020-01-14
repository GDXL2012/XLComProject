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

@interface XLNavigationController ()<UINavigationBarDelegate>

@end

@implementation XLNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configNavigationBarStyle];
}

/**
 配置导航栏风格
 */
-(void)configNavigationBarStyle {
    // 此处代码移动到了基类中 因为会影响调用的系统界面标题颜色（比如发短信）
    self.navigationBar.translucent = NO;
    UIColor *themColor = XLThemeColor;
    // 导航栏图标颜色
    [self.navigationBar setTintColor:XLBarTitleColor];
    // 导航栏背景色黑色
    [self.navigationBar setBarTintColor:themColor];
    // 标题颜色字体大小
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:XLBarTitleColor, NSFontAttributeName : XLBarTitleFont};
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

/**
 设置标签
 
 @param title 标题
 @param imgName 默认图标
 @param selImgName 选中时图标
 */
-(void)setBarTitle:(NSString *)title imgName:(NSString *)imgName selImgName:(NSString *)selImgName{
    // 名称
    self.tabBarItem.title = title;
    UIImage *image = [UIImage imageNamed:imgName];
    self.tabBarItem.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIImage *selImage = [UIImage imageNamed:selImgName];
    self.tabBarItem.selectedImage = [selImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor]} forState:UIControlStateNormal];
    [self.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:XLThemeColor} forState:UIControlStateSelected];
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
