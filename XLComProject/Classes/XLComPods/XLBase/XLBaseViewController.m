//
//  XLBaseViewController.m
//  XLComProject
//
//  Created by GDXL2012 on 2019/11/27.
//  Copyright © 2019 GDXL2012. All rights reserved.
//

#import "XLBaseViewController.h"
#import "XLSystemMacro.h"
#import "XLConfigManager.h"
#import "XLMacroColor.h"
#import "NSString+XLCategory.h"
#import "XLMacroFont.h"
#import <objc/runtime.h>
#import "UIViewController+XLTools.h"
#import "XLDeviceMacro.h"
#import "Masonry.h"
#import "UIView+XLAdditions.h"
#import "XLNotificationTools.h"

@interface XLBaseViewController () <UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIView *bottomAdapterView;
@end

@implementation XLBaseViewController
-(void)xlInitOperation{
    [self xlInitMemberVariable];
    self.modalPresentationStyle = [XLConfigManager xlConfigManager].adaptationConfig.modalPresentationStyle;
}

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self xlInitOperation];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)coder{
    self = [super initWithCoder:coder];
    if (self) {
        [self xlInitOperation];
    }
    return self;
}

//-(instancetype)init{
//    self = [super init];
//    if (self) {
////        [self xlInitOperation];
//    }
//    return self;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self navigationBarStyleConfig];
    [self baseInitViewDisplay];
    [self xlInitNavigationBar];
    [self xlInitViewDisplay];
    [self xlInitViewData];
    
    [self base_xlRegisterNotification];
}

-(void)dealloc{
    [self base_xlUnregisterNotification];
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
    self.xlPOPForGesture = NO;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if ([self xlNeedInterceptPopGesture]) {
        [self xlBasePopGestureConfig];
    } else {
        if ([self xlPopGestureDelegate]) {
            [self xlInteractivePopGestureRecognizer].delegate = [self xlPopGestureDelegate];
            [self bindingPopGestureDelegate:nil];
        }
    }
    self.xlPOPForGesture = NO;
}

/**
 导航栏风格配置
 */
-(void)navigationBarStyleConfig{
    /// 返回按钮
    if (self.navigationController) {
        NSString *backImgStr = [XLConfigManager xlConfigManager].adaptationConfig.backImageName;
        if (![NSString isEmpty:backImgStr]) {
            // 替换系统自带的返回按钮
            UIImage *buttonNormal = [[UIImage imageNamed:backImgStr] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
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
}

-(void)xlBasePopGestureConfig{
    if (self.navigationController &&
        [self xlNeedInterceptPopGesture] &&
        [self xlInteractivePopGestureRecognizer].delegate != self) {
        [self bindingPopGestureDelegate:[self xlInteractivePopGestureRecognizer].delegate];
        [self xlInteractivePopGestureRecognizer].delegate = self;
    }
}

-(id<UIGestureRecognizerDelegate>)xlPopGestureDelegate{
    if (self.navigationController) {
        return objc_getAssociatedObject(self.navigationController, @selector(xlPopGestureDelegate));
    } else {
        return nil;
    }
}

-(void)bindingPopGestureDelegate:(id<UIGestureRecognizerDelegate>)delegate{
    if (self.navigationController) {
        objc_setAssociatedObject(self.navigationController, @selector(xlPopGestureDelegate), delegate, OBJC_ASSOCIATION_ASSIGN);
    }
}

#pragma mark - UIGestureRecognizerDelegate 手势
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if ([self xlInteractivePopGestureRecognizer] == gestureRecognizer) {
        /// 滑动手势收起键盘
        [[UIApplication sharedApplication].keyWindow endEditing:YES];
        if (self.navigationController.viewControllers.count == 1) {
            return NO;
        }
        BOOL sholdPop = [self xlShouldPopViewControllerForGesture:YES];
        if (sholdPop) {
            self.xlPOPForGesture = YES;
        } else {
            self.xlPOPForGesture = NO;
        }
        return sholdPop;
    }
    return YES;
}

#pragma mark - @Override - 生命周期方法： init调用
/**
 初始化成员变量：invoke at first in init
 覆写后父类自动调用
 */
-(void)xlInitMemberVariable{}

#pragma mark -  @Override - 生命周期方法：viewDidLoad调用
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
 是否需要拦截返回手势
 覆写后父类自动调用
 
 @return 【iOS 13 default NO 不拦截，YES 拦截】【iOS 12及以下 default YES 拦截，NO 不拦截】
 */
-(BOOL)xlNeedInterceptPopGesture{
    if(XLAvailableiOS13){
        return NO;
    } else {
        return YES;
    }
}

/**
 是否需要返回：返回按钮及手势均会触发该方法
 覆写后父类自动调用
 
 @param forGesture YES 手势返回，NO 返回按钮点击
*/
-(BOOL)xlShouldPopViewControllerForGesture:(BOOL)forGesture{
//    if (forGesture) {
//        id<UIGestureRecognizerDelegate>delete = nil;
//        delete = [self xlPopGestureDelegate];
//        if(delete){
//            return [delete gestureRecognizerShouldBegin:[self xlInteractivePopGestureRecognizer]];
//        }
//    }
    return YES;
}

-(UIGestureRecognizer *)xlInteractivePopGestureRecognizer{
    return self.navigationController.interactivePopGestureRecognizer;
}

/**
 注册通知
 覆写后父类自动调用
 */
-(void)base_xlRegisterNotification{
    // 横竖屏切换通知
    if (XLIsiPad()) {
        [XLNotificationTools addObserver:self selector:@selector(xlIpadDidChangeStatusBarNotification:) name:UIApplicationDidChangeStatusBarOrientationNotification];
    }
    
    [self xlRegisterNotification];
}

/**
 注销通知
 覆写后父类自动调用
 */
-(void)base_xlUnregisterNotification{
    if (XLIsiPad()) {
        [XLNotificationTools removeObserver:self name:UIApplicationDidChangeStatusBarOrientationNotification];
    }
    [self xlUnregisterNotification];
}

#pragma mark - Notificaton
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

// iPad 旋转监听：子类可以复写，处理回调
-(void)xlIpadDidChangeStatusBarNotification:(NSNotification *)notification{
    NSLog(@"xlIpadDidChangeStatusBarNotification");
}

#pragma mark - Other
/// 移除当前控制器
-(void)removeCurrentViewController{
    /// 此处逻辑：移除当前页面，同时设置返回按钮文本
    NSArray *tmpArray = self.navigationController.viewControllers;
    NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:tmpArray];
    /// 1.设置返回按钮文本
    BOOL showBackTitle = [XLConfigManager xlConfigManager].adaptationConfig.showBackTitle;
    if (showBackTitle) {
        NSInteger index = [viewControllers indexOfObject:self];
        if (index > 0) {
            UIViewController *preVC = [viewControllers objectAtIndex:index - 1];
            UIViewController *lastVC = [viewControllers objectAtIndex:index + 1];
            if ([preVC isKindOfClass:[XLBaseViewController class]] &&
                [lastVC isKindOfClass:[XLBaseViewController class]]) {
                NSString *previewTitle = ((XLBaseViewController *)lastVC).previewTitle;
                ((XLBaseViewController *)preVC).previewTitle = previewTitle;
                if (![NSString isEmpty:previewTitle]) {
                    // 设置返回按钮文字
                    NSInteger maxCount = 13;
                    if (XLMiniScreen()) {
                        maxCount = 10;
                    }
                    if (previewTitle.length > maxCount) {
                        previewTitle = [previewTitle substringToIndex:maxCount];
                        previewTitle = [previewTitle stringByAppendingString:@"..."];
                    }
                    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:previewTitle style:UIBarButtonItemStylePlain target:nil action:nil];
                    [backItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:XLBFont(17.0f), NSFontAttributeName,XLBarTitleColor,NSForegroundColorAttributeName,nil] forState:UIControlStateNormal];
                    [backItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:XLBFont(17.0f), NSFontAttributeName,[XLBarTitleColor colorWithAlphaComponent:0.5], NSForegroundColorAttributeName,nil] forState:UIControlStateHighlighted];
                    preVC.navigationItem.backBarButtonItem = backItem;
                }
            }
        }
    }
    /// 2.移除当前页面
    [viewControllers removeObject:self];
    self.navigationController.viewControllers = viewControllers;
}

/**
 状态栏文本
 
 @return <#return value description#>
 */
-(UIStatusBarStyle)preferredStatusBarStyle{
    return [XLConfigManager xlConfigManager].adaptationConfig.preferredStatusBarStyle;
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
    self.view.backgroundColor = [UIColor whiteColor];
    
    _bottomAdapterView = [[UIView alloc] init];
    _bottomAdapterView.backgroundColor = XLComBGColor;
    [self.view addSubview:_bottomAdapterView];
    [_bottomAdapterView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (XLAvailableiOS11) {
            make.left.mas_equalTo(self.view.mas_safeLeft);
            make.right.mas_equalTo(self.view.mas_safeRight);
        } else {
            make.left.mas_equalTo(self.view);
            make.right.mas_equalTo(self.view);
        }
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(1.0f);
        make.height.mas_equalTo(XLNavBottomHeight() + 1.0f);
    }];
    
    if (self.showBottomAdapterView) {
        self.bottomAdapterView.hidden = NO;
    } else {
        self.bottomAdapterView.hidden = YES;
    }
    _bottomAdapterView.layer.zPosition = 1.0f;
}

-(void)setShowBottomAdapterView:(BOOL)showBottomAdapterView{
    _showBottomAdapterView = showBottomAdapterView;
    if (_bottomAdapterView) {
        _bottomAdapterView.hidden = !showBottomAdapterView;
    }
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

@end
