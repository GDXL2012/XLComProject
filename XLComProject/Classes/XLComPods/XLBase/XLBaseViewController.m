//
//  XLBaseViewController.m
//  XLComProject
//
//  Created by GDXL2012 on 2019/11/27.
//  Copyright © 2019 GDXL2012. All rights reserved.
//

#import "XLBaseViewController.h"
#import "XLSystemMacro.h"
#import "XLComPods.h"
#import "XLMacroColor.h"
#import "NSString+XLCategory.h"

@interface XLBaseViewController ()
@end

@implementation XLBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self navigationBarStyleConfig];
    [self baseInitViewDisplay];
    [self xlInitNavigationBar];
    [self xlInitMemberVariable];
    [self xlInitViewData];
    [self xlInitViewDisplay];
    
    [self xlRegisterNotification];
    
    self.modalPresentationStyle = [XLComPods manager].adaptationConfig.modalPresentationStyle;
}

-(void)dealloc{
    [self xlUnregisterNotification];
#ifdef DEBUG
    NSLog(@"%s dealloc", __FILE_NAME__);
#endif
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 状态栏为白色
    if ([self xlNeedNavigationBarHidden] &&
        !self.navigationController.navigationBarHidden) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    } else if(![self xlNeedNavigationBarHidden] &&
              self.navigationController.navigationBarHidden){
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
}

/**
 导航栏风格配置
 */
-(void)navigationBarStyleConfig{
    NSString *string = [XLComPods manager].adaptationConfig.backImageName;
    if (![NSString isEmpty:string] && self.navigationController) {
        // 替换系统自带的返回按钮
        UIImage *buttonNormal = [[UIImage imageNamed:string] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [self.navigationController.navigationBar setBackIndicatorImage:buttonNormal];
        [self.navigationController.navigationBar setBackIndicatorTransitionMaskImage:buttonNormal];
        
        BOOL showBackTitle = [XLComPods manager].adaptationConfig.showBackTitle;
        if (!showBackTitle) {
            // 设置没有返回按钮后面的文字
            UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
            self.navigationItem.backBarButtonItem = backItem;
        } else if (![NSString isEmpty:self.previewTitle]){
            UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:self.previewTitle style:UIBarButtonItemStylePlain target:nil action:nil];
            self.navigationItem.backBarButtonItem = backItem;
        }
    }
}

#pragma mark - @Override - 生命周期方法：viewDidLoad调用
/**
 初始化成员变量：invoke at first in viewDidLoad
 覆写后父类自动调用
 */
-(void)xlInitMemberVariable{}

/**
 初始化导航条：invoke after xlInitMemberVariable
 覆写后父类自动调用
 */
-(void)xlInitNavigationBar{}

/**
 初始化页面：invoke after xlInitNavigationBar
 覆写后父类自动调用
 */
-(void)xlInitViewDisplay{}

/**
 页面数据初始化：在xlInitViewDisplay方法之后调用，网络请求/数据库查询等
 覆写后父类自动调用
 */
-(void)xlInitViewData{}

#pragma mark - @Override - 通用配置
/**
 是否需要导航栏隐藏
 覆写后父类自动调用
 
 @return default NO 显示，YES 隐藏
 */
-(BOOL)xlNeedNavigationBarHidden{
    return NO;
}

/**
 注册通知
 覆写后父类自动调用
 */
-(void)xlRegisterNotification{}

/**
 注销通知
 覆写后父类自动调用
 */
-(void)xlUnregisterNotification{}

/**
 状态栏文本
 
 @return <#return value description#>
 */
-(UIStatusBarStyle)preferredStatusBarStyle{
    return [XLComPods manager].adaptationConfig.preferredStatusBarStyle;
}

/**
 状态栏状态
 
 @return <#return value description#>
 */
-(BOOL)prefersStatusBarHidden{
    return NO;
}

#pragma mark - Private Method
/**
 基类视图初始化
 */
-(void)baseInitViewDisplay {
    if (XLAvailableiOS11) {
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.view.backgroundColor = XLComBGColor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 屏幕旋转屏
- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
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
