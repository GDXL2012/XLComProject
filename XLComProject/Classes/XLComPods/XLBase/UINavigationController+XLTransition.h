//
//  UINavigationController+XLTransition.h
//  AFNetworking
//
//  Created by GDXL2012 on 2020/8/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol XLControllerTransitioningDelegate <NSObject>

-(void)xlPopAnimationEnded;
-(void)xlPushAnimationEnded;

@end

/// 转场动画
@interface UINavigationController (XLTransition) <XLControllerTransitioningDelegate>

-(void)pushViewControllerForUserTransition:(UIViewController *)viewController animated:(BOOL)animated;
-(void)stopUserDefineTransition;
@end

NS_ASSUME_NONNULL_END
