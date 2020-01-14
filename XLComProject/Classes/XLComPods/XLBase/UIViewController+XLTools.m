//
//  UIViewController+XLTools.m
//  XLComProject
//
//  Created by GDXL2012 on 2019/11/27.
//  Copyright © 2019 GDXL2012. All rights reserved.
//

#import "UIViewController+XLTools.h"
#import "XLBarButtonItem.h"
#import "XLBaseViewController.h"
#import "NSString+XLCategory.h"

@implementation UIViewController (XLTools)
#pragma mark - NavigationItem InitMethod

/**
 设置右侧按钮
 
 @param action 右侧按钮事件
 @param normalName 正常状态图标
 @param highName 高亮状态图标
 */
-(void)setRightBarButtonAction:(SEL)action normalImageName:(NSString *)normalName highImageName:(NSString *)highName {
    XLRightBarButtonItem *barButton = [[XLRightBarButtonItem alloc] initWithTarget:self action:action normalImage:normalName highImage:highName];
    self.navigationItem.rightBarButtonItem = barButton;
}

/**
 设置右侧按钮
 
 @param action 右侧按钮事件
 @param title 正常状态
 */
-(void)setRightBarButtonAction:(SEL)action title:(NSString *)title {
    XLRightBarButtonItem *barButton = [[XLRightBarButtonItem alloc] initWithTarget:self action:action title:title];
    self.navigationItem.rightBarButtonItem = barButton;
}

/**
 设置多个导航栏右侧按钮selctNameArray、norImgArray,heightImgArray，selctNameArray数组大小须相同
 
 @param selctNameArray 点击回调事件
 @param normalNames 常态时按钮图标
 @param highNames 高亮时按钮图标
 */
-(void)setRightBarButtons:(NSArray *)selctNameArray normalImageNames:(NSArray *)normalNames highImageNames:(NSArray *)highNames{
    NSMutableArray *barArray = [NSMutableArray array];
    NSInteger count = selctNameArray.count;
    for (NSInteger index = 0; index < count; index ++) {
        NSString *normalName = nil;
        if(normalNames){
            normalName = normalNames[index];
        }
        NSString *highName = nil;
        if (highNames) {
            highName = highNames[index];
        }
        SEL select = NSSelectorFromString(selctNameArray[index]);
        XLRightBarButtonItem *item = [[XLRightBarButtonItem alloc] initWithTarget:self action:select normalImage:normalName highImage:highName];
        [barArray addObject:item];
    }
    self.navigationItem.rightBarButtonItems = barArray;
}

/**
 多个导航栏右侧按钮selctNameArray、nameArray数组大小须相同
 
 @param selctNameArray 点击回调事件
 @param names 按钮名字
 
 */
-(void)setRightBarButtons:(NSArray *)selctNameArray names:(NSArray *)names
{
    NSMutableArray *barArray = [NSMutableArray array];
    NSInteger count = selctNameArray.count;
    for (NSInteger index = 0; index < count; index ++) {
        SEL select = NSSelectorFromString(selctNameArray[index]);
        XLRightBarButtonItem *item = [[XLRightBarButtonItem alloc] initWithTarget:self action:select title:names[index]];
        [barArray addObject:item];
    }
    self.navigationItem.rightBarButtonItems = barArray;
}
/**
 设置多个导航栏右侧按钮tiles、actions数组大小须相同
 
 @param tiles 标题
 @param actions 事件回调
 */
-(void)setRightBarTiles:(NSArray *)tiles actions:(NSArray *)actions{
    NSMutableArray *barArray = [NSMutableArray array];
    NSInteger count = tiles.count;
    for (NSInteger index = 0; index < count; index ++) {
        NSString *title = tiles[index];
        SEL select = NSSelectorFromString(actions[index]);
        XLRightBarButtonItem *item = [[XLRightBarButtonItem alloc] initWithTarget:self action:select title:title];
        [barArray insertObject:item atIndex:0];
    }
    self.navigationItem.rightBarButtonItems = barArray;
}


#pragma mark - NavigationItem Control
/**
 *隐藏右item
 */
-(void)hiddenRightBarButtonItem {
    if (self.navigationItem.rightBarButtonItems.count > 1) {
        for (UIBarButtonItem *item in self.navigationItem.rightBarButtonItems) {
            item.customView.hidden = YES;
        }
    } else {
        self.navigationItem.rightBarButtonItem.customView.hidden = YES;
    }
}

-(void)setRightBarButtonItemHidden:(BOOL)hidden{
    if (self.navigationItem.rightBarButtonItems.count > 1) {
        for (UIBarButtonItem *item in self.navigationItem.rightBarButtonItems) {
            item.customView.hidden = hidden;
        }
    } else {
        self.navigationItem.rightBarButtonItem.customView.hidden = hidden;
    }
}

/// 设置右键按钮是否可点击
/// @param enable <#enable description#>
-(void)setRightBarButtonEnable:(BOOL)enable{
    if (self.navigationItem.rightBarButtonItems.count > 1) {
        for (UIBarButtonItem *item in self.navigationItem.rightBarButtonItems) {
            UIView *view = item.customView;
            [self customButtonView:view enable:enable];
        }
    } else {
        UIView *view = self.navigationItem.rightBarButtonItem.customView;
        [self customButtonView:view enable:enable];
    }
}

/// 设置按钮点击状态
/// @param view <#view description#>
/// @param enable enable description
-(void)customButtonView:(UIView *)view enable:(BOOL)enable{
    if ([view isKindOfClass:[UIButton class]]) {
        UIButton *button = (UIButton *)view;
        [button setEnabled:enable];
    } else {
        view.userInteractionEnabled = enable;
    }
}

#pragma mark - Common Method

/**
 销毁当前控制器
 */
-(void)popViewController {
    if (self.presentingViewController){
        if(self.navigationController &&
           self.navigationController.childViewControllers.count > 1){
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

/**
 弹出控制器
 
 @param viewController 本弹出控制器
 */
-(void)pushViewController:(UIViewController *)viewController {
    viewController.hidesBottomBarWhenPushed = YES;
    [self setPreviewTitleForController:viewController];
    [self.navigationController pushViewController:viewController animated:YES];
}

-(void)pushViewControllerWithName:(NSString *)controllerName{
    UIViewController * controller = nil;
    controller =[[NSClassFromString(controllerName) alloc] init];
    [self setPreviewTitleForController:controller];
    [self pushViewController:controller];
}

/**
 * default：hidesBottomBarWhenPushed = NO
 */
-(void)pushViewControllerWithOutBottomBarHides:(UIViewController *)viewController{
    viewController.hidesBottomBarWhenPushed = NO;
    [self setPreviewTitleForController:viewController];
    [self.navigationController pushViewController:viewController animated:YES];
}

-(void)pushViewControllerNameWithOutBottomBarHides:(NSString *)controllerName{
    UIViewController * controller = nil;
    controller =[[NSClassFromString(controllerName) alloc] init];
    [self setPreviewTitleForController:controller];
    [self pushViewControllerWithOutBottomBarHides:controller];
}

-(void)setPreviewTitleForController:(UIViewController *)controller{
    /// 默认导航栏会显示上级页面的文字，不需要单独处理
//    if ([self isKindOfClass:[XLBaseViewController class]] &&
//        [controller isKindOfClass:[XLBaseViewController class]]) {
//        NSString *title = self.title;
//        if ([NSString isEmpty:title]) {
//            title = self.navigationItem.title;
//        }
//        ((XLBaseViewController *)controller).previewTitle = title;
//    }
}
@end
