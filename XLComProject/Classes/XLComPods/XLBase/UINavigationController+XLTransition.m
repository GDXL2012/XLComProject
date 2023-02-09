//
//  UINavigationController+XLTransition.m
//  AFNetworking
//
//  Created by GDXL2012 on 2020/8/1.
//

#import "UINavigationController+XLTransition.h"
#import "XLDeviceMacro.h"
#import <objc/runtime.h>

/// 显示动画
@interface XLPushAnimation : NSObject <UIViewControllerAnimatedTransitioning>
@property (nonatomic, weak) id<XLControllerTransitioningDelegate> transitionDelegate;
@end
/// 消失动画
@interface XLPopDismissAnimation : NSObject <UIViewControllerAnimatedTransitioning>
@property (nonatomic, weak) id<XLControllerTransitioningDelegate> transitionDelegate;
@end

@interface XLNavigationControllerTransition : UIPercentDrivenInteractiveTransition <UINavigationControllerDelegate, XLControllerTransitioningDelegate>
@property (nonatomic, strong) XLPushAnimation *pushAnimation;
@property (nonatomic, strong) XLPopDismissAnimation *popAnimation;

@property (nonatomic, weak) id<XLControllerTransitioningDelegate> transitionDelegate;
@property (nonatomic, weak) UINavigationController *nvController;
@property (nonatomic, assign) BOOL isInteracting;
@property (nonatomic, assign) BOOL shouldComplete;

- (instancetype)initWithController:(UIViewController *)controller;
@end

@implementation UINavigationController (XLTransition)

-(id<UINavigationControllerDelegate>)xlNavigationDelegate{
    id<UINavigationControllerDelegate> delegate = objc_getAssociatedObject(self, @selector(xlNavigationDelegate));
    return delegate;
}

-(XLNavigationControllerTransition *)xlTransition{
    XLNavigationControllerTransition *transition = objc_getAssociatedObject(self, @selector(xlTransition));
    return transition;
}

-(void)pushViewControllerForUserTransition:(UIViewController *)viewController animated:(BOOL)animated{
    viewController.hidesBottomBarWhenPushed = YES;
    
    UIScreenEdgePanGestureRecognizer *panGesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureHander:)];
    panGesture.edges = UIRectEdgeLeft;
    [viewController.view addGestureRecognizer:panGesture];
    
    [self pushViewController:viewController animated:animated];
}

-(void)stopUserDefineTransition{
    if ([self xlNavigationDelegate]) {
        self.delegate = [self xlNavigationDelegate];
    }
}

#pragma mark - CMPercentDrivenInteractiveTransition
- (void)panGestureHander:(UIScreenEdgePanGestureRecognizer *)gesture{
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan: {
            if (self.delegate) {
                objc_setAssociatedObject(self, @selector(xlNavigationDelegate), self.delegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
            XLNavigationControllerTransition *transition = [[XLNavigationControllerTransition alloc] initWithController:self];
            objc_setAssociatedObject(self, @selector(xlTransition), transition, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            self.delegate = transition;
            transition.isInteracting = YES;
            [self popViewControllerAnimated:YES];
            break;
        }
        case UIGestureRecognizerStateChanged: {
            CGFloat fraction;
            CGFloat locationX = XLScreenWidth() + [gesture locationInView:gesture.view].x;
            fraction = (locationX / XLScreenWidth());
            fraction = fmin(fmaxf(fraction, 0.0), 1.0);
            self.xlTransition.shouldComplete = fraction > 0.5;
            [self.xlTransition updateInteractiveTransition:fraction];
            break;
        }
        case UIGestureRecognizerStateEnded: {
            self.xlTransition.isInteracting = NO;
            if (!self.xlTransition.shouldComplete) {
                [self.xlTransition cancelInteractiveTransition];
            }else {
                [self.xlTransition finishInteractiveTransition];
            }
            self.delegate = self.xlNavigationDelegate;
            break;
        }
        case UIGestureRecognizerStateCancelled: {
            self.xlTransition.isInteracting = NO;
            [self.xlTransition cancelInteractiveTransition];
            self.delegate = self.xlNavigationDelegate;
            break;
        }
        default:
            break;
    }
}

-(void)xlPopAnimationEnded{
    [self stopUserDefineTransition];
}

-(void)xlPushAnimationEnded{
    
}

@end

#pragma mark - 转场动画
@implementation XLNavigationControllerTransition

- (instancetype)initWithController:(UINavigationController *)controller{
    self = [super init];
    if (self) {
        self.nvController = controller;
    }
    return self;
}

- (id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                          interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController{
    /// 交互动画
    if (self.isInteracting) {
        return self;
    } else {
        return nil;
    }
}

- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC{
    if (operation == UINavigationControllerOperationPush) {
        /// 非交互式动画
        if (!_pushAnimation) {
            _pushAnimation = [[XLPushAnimation alloc] init];
            _pushAnimation.transitionDelegate = self;
        }
        return _pushAnimation;
    } else if (operation == UINavigationControllerOperationPop) {
        if (!_popAnimation) {
            _popAnimation = [[XLPopDismissAnimation alloc] init];
            _popAnimation.transitionDelegate = self;
        }
        return _popAnimation;
    } else {
        return nil;
    }
}

- (void)xlPopAnimationEnded {
    if (self.transitionDelegate &&
        [self.transitionDelegate respondsToSelector:@selector(xlPopAnimationEnded)]) {
        [self.transitionDelegate xlPopAnimationEnded];
    }
}

- (void)xlPushAnimationEnded {
    if (self.transitionDelegate &&
        [self.transitionDelegate respondsToSelector:@selector(xlPushAnimationEnded)]) {
        [self.transitionDelegate xlPushAnimationEnded];
    }
}

@end

/// 显示动画
@implementation XLPushAnimation
-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.35f;
}

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    /// 此处方法不会执行
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    CGRect finalFrameForVC = [transitionContext finalFrameForViewController:toVC];
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:toVC.view];
    
    UINavigationBar *tureBar = toVC.navigationController.navigationBar;
    /// 修改view的偏移位置，解决动画结束后view位置跳动
    CGFloat barBottom = CGRectGetMaxY(tureBar.frame);
    CGRect oldNvBarFrame = tureBar.frame;
    if (tureBar.hidden) {
        /// 导航栏隐藏状态，不需要偏移
        CGRect nvBarFrame = tureBar.frame;
        tureBar.frame = nvBarFrame;
        [containerView addSubview:tureBar];
    }
    
    toVC.view.frame = CGRectOffset(finalFrameForVC, XLScreenWidth(), 0);
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        toVC.view.frame = finalFrameForVC;
        fromVC.view.frame = CGRectOffset(fromVC.view.frame, -XLScreenWidth() / 3.0f, 0);
        if (tureBar.hidden) {
            /// 导航栏隐藏状态，偏移
            tureBar.frame = CGRectOffset(oldNvBarFrame, -XLScreenWidth(), 0);
        }
    } completion:^(BOOL finished) {
        if (tureBar.hidden) {
            /// 导航栏隐藏状态，偏移
            tureBar.frame = CGRectOffset(oldNvBarFrame, -XLScreenWidth(), 0);
        }
        if (tureBar.hidden) {
            /// 导航栏隐藏状态，偏移
            [toVC.navigationController.view addSubview:tureBar];
        }
        [transitionContext completeTransition:YES];
    }];
}

-(void)animationEnded:(BOOL)transitionCompleted {
    if (self.transitionDelegate &&
        [self.transitionDelegate respondsToSelector:@selector(xlPushAnimationEnded)]) {
        [self.transitionDelegate xlPushAnimationEnded];
    }
}

@end
/// 消失动画
@implementation XLPopDismissAnimation

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.35f;
}

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];

    UIView *containerView = [transitionContext containerView];

    UINavigationBar *tureBar = toVC.navigationController.navigationBar;
    /// 修改view的偏移位置，解决动画结束后view位置跳动
    CGFloat barBottom = CGRectGetMaxY(tureBar.frame);
    CGRect oldNvBarFrame = tureBar.frame;
    if (tureBar.hidden) {
        /// 导航栏隐藏状态，不需要偏移
        barBottom = 0;
    } else {
        CGRect nvBarFrame = tureBar.frame;
        tureBar.frame = nvBarFrame;
        [containerView addSubview:tureBar];
        [containerView sendSubviewToBack:tureBar];
    }
    
    /// 设置底部标签栏
    BOOL hidesBottomBar = toVC.hidesBottomBarWhenPushed && toVC.navigationController.viewControllers.firstObject != toVC;
    UIViewController *mainVC = [UIApplication sharedApplication].delegate.window.rootViewController;
    UITabBar *tabBar = nil;
    if (!hidesBottomBar && toVC.tabBarController) {
        tabBar = toVC.tabBarController.tabBar;
        CGRect tabBarFrame = tabBar.frame;
        tabBarFrame.origin.x = -XLScreenWidth();
        tabBar.frame = tabBarFrame;
    }
    
    CGRect oldToFrame = toVC.view.frame;
    CGRect toframe = toVC.view.frame;
    toframe.origin.y = barBottom < 0 ? 0 : barBottom;
    toframe.origin.x = -XLScreenWidth() / 3.0f;
    toframe.size.height = toframe.size.height - barBottom;
    toVC.view.frame = toframe;
    [containerView addSubview:toVC.view];
    [containerView sendSubviewToBack:toVC.view];

    CGRect oldFromeFrame = [transitionContext initialFrameForViewController:fromVC];
    CGRect finalFrame = CGRectOffset(oldFromeFrame, XLScreenWidth(), 0);
    NSTimeInterval interval = [self transitionDuration:transitionContext];
    fromVC.view.layer.zPosition = 1000;
    [UIView animateWithDuration:interval animations:^{
        if (tureBar.hidden) {
            /// 导航栏隐藏状态，不需要偏移
            tureBar.frame = oldNvBarFrame;
        }
        fromVC.view.frame = finalFrame;
        toVC.view.frame = CGRectOffset(toframe, XLScreenWidth() / 3.0f, 0);
        if (tabBar) {
            CGRect tabBarFrame = tabBar.frame;
            tabBar.frame = CGRectOffset(tabBarFrame, XLScreenWidth(), 0);
        }
    } completion:^(BOOL finished) {
        BOOL cancelled = [transitionContext transitionWasCancelled];
        if (cancelled) {
            /// 取消转场需要恢复View状态
            fromVC.view.frame = oldFromeFrame;
            toVC.view.frame = oldToFrame;
            tureBar.frame = oldNvBarFrame;
        }
        [transitionContext completeTransition:(!cancelled)];
        [toVC.navigationController.view addSubview:tureBar];
    }];
}

-(void)animationEnded:(BOOL)transitionCompleted {
    if (self.transitionDelegate &&
        [self.transitionDelegate respondsToSelector:@selector(xlPopAnimationEnded)]) {
        [self.transitionDelegate xlPopAnimationEnded];
    }
}
@end
