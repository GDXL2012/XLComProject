//
//  UIViewController+XLPresent.m
//  FLAnimatedImage
//
//  Created by GDXL2012 on 2020/7/20.
//

#import "UIViewController+XLPresent.h"
#import "XLDeviceMacro.h"
#import <objc/runtime.h>

/// 显示动画
@interface XLPresentAnimation : NSObject <UIViewControllerAnimatedTransitioning>
@end
/// 消失动画
@interface XLPresentDismissAnimation : NSObject <UIViewControllerAnimatedTransitioning>
@end

@interface XLViewControllerTransition : UIPercentDrivenInteractiveTransition <UIViewControllerTransitioningDelegate>
@property (nonatomic, weak) UIViewController *viewController;
@property (nonatomic, assign) BOOL isInteracting;
@property (nonatomic, assign) BOOL shouldComplete;

- (instancetype)initWithController:(UIViewController *)controller;
@end

@implementation UIViewController (XLPresent)

-(XLViewControllerTransition *)presentTransition{
    XLViewControllerTransition *transition = objc_getAssociatedObject(self, @selector(presentTransition));
    return transition;
}

-(void)configCustomPresentTransition{
    XLViewControllerTransition *transition = [[XLViewControllerTransition alloc] initWithController:self];
    objc_setAssociatedObject(self, @selector(presentTransition), transition, OBJC_ASSOCIATION_RETAIN);
    self.transitioningDelegate = transition;
    self.modalPresentationStyle = UIModalPresentationCustom;
}

@end

/// 显示动画
@implementation XLPresentAnimation
-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.35f;
}

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    CGRect finalFrameForVC = [transitionContext finalFrameForViewController:toVC];
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:toVC.view];
    
    toVC.view.frame = CGRectOffset(finalFrameForVC, XLScreenWidth, 0);
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        fromVC.view.alpha = 0.5f;
        toVC.view.frame = finalFrameForVC;
        fromVC.view.frame = CGRectOffset(fromVC.view.frame, -XLScreenWidth / 2.0f, 0);
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
}

-(void)animationEnded:(BOOL)transitionCompleted {
}

@end
/// 消失动画
@implementation XLPresentDismissAnimation

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.35f;
}

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    CGRect initFrame = [transitionContext initialFrameForViewController:fromVC];
    UIView *containerView = [transitionContext containerView];
    if (fromVC.modalPresentationStyle == UIModalPresentationFullScreen) {
        [containerView addSubview:toVC.view];
    }
    [containerView sendSubviewToBack:toVC.view];
    if (fromVC.modalPresentationStyle == UIModalPresentationCustom) {
        [toVC beginAppearanceTransition:YES animated:YES];
    }
    
    CGRect finalFrame = CGRectOffset(initFrame, XLScreenWidth, 0);
    CGRect toVCFrame = toVC.view.frame;
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        fromVC.view.frame = finalFrame;
        toVC.view.alpha = 1.0f;
        toVC.view.frame = CGRectOffset(toVCFrame, XLScreenWidth / 2.0f, 0);
    } completion:^(BOOL finished) {
        if (fromVC.modalPresentationStyle == UIModalPresentationCustom) {
            [toVC endAppearanceTransition];
        }
        BOOL cancelled = [transitionContext transitionWasCancelled];
        if (cancelled) {
            /// 取消转场需要恢复View状态
            fromVC.view.frame = initFrame;
            toVC.view.alpha = 0.5f;
            toVC.view.frame = toVCFrame;
        }
        [transitionContext completeTransition:(!cancelled)];
    }];
}

-(void)animationEnded:(BOOL)transitionCompleted {
}
@end

#pragma mark - 转场动画
@implementation XLViewControllerTransition

- (instancetype)initWithController:(UIViewController *)controller{
    self = [super init];
    if (self) {
        UIScreenEdgePanGestureRecognizer *panGesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureHander:)];
        panGesture.edges = UIRectEdgeLeft;
        [controller.view addGestureRecognizer:panGesture];
        self.viewController = controller;
    }
    return self;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    /// 非交互式动画
    return [[XLPresentAnimation alloc] init];
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    /// 非交互式动画
    return [[XLPresentDismissAnimation alloc] init];
}

-(id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator{
    /// 交互动画
    return (self.isInteracting ? self : nil);
}

#pragma mark - CMPercentDrivenInteractiveTransition
- (void)panGestureHander:(UIScreenEdgePanGestureRecognizer *)gesture{
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan: {
            _isInteracting = YES;
            [self.viewController dismissViewControllerAnimated:YES completion:nil];
            break;
        }
        case UIGestureRecognizerStateChanged: {
            CGFloat fraction;
            CGFloat pointX = XLScreenWidth + [gesture locationInView:self.viewController.view].x;
            fraction = (pointX / XLScreenWidth);
            fraction = fmin(fmaxf(fraction, 0.0), 1.0);
            _shouldComplete = fraction > 0.5;
            [self updateInteractiveTransition:fraction];
            break;
        }
        case UIGestureRecognizerStateEnded: {
            _isInteracting = NO;
            if (!_shouldComplete) {
                [self cancelInteractiveTransition];
            }else {
                [self finishInteractiveTransition];
            }
            break;
        }
        case UIGestureRecognizerStateCancelled: {
            _isInteracting = NO;
            [self cancelInteractiveTransition];
            break;
        }
        default:
            break;
    }
}

@end
