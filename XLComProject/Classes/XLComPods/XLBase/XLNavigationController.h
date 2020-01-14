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
/**
 标签页基类控制器
 
 @param vc 标签页
 @return 控制器
 */
+(XLNavigationController *)tabMainNavigationControllerWithVC:(UIViewController *)vc;

/**
 设置标签
 
 @param title 标题
 @param imgName 默认图标
 @param selImgName 选中时图标
 */
-(void)setBarTitle:(NSString *)title imgName:(NSString *)imgName selImgName:(NSString *)selImgName;
@end

NS_ASSUME_NONNULL_END
