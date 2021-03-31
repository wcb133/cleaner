//
//  XWCircleSpreadAnimator.m
//  XWTADemo
//
//  Created by wazrx on 16/6/7.
//  Copyright © 2016年 wazrx. All rights reserved.
//

#import "XWCircleSpreadAnimator.h"

@interface XWCircleSpreadAnimator ()<CAAnimationDelegate>
@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, assign) CGFloat startRadius;
@property (nonatomic, strong) UIBezierPath *startPath;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) CAShapeLayer *maskLayer;
@property(nonatomic, strong) UIView *coverView;
@end

@implementation XWCircleSpreadAnimator

+ (instancetype)xw_animatorWithStartCenter:(CGPoint)point radius:(CGFloat)radius {
    return [[self alloc] _initWithStartCenter:point radius:radius];
}

- (instancetype)_initWithStartCenter:(CGPoint)point radius:(CGFloat)radius
{
    self = [super init];
    if (self) {
        _startPoint = point;
        _startRadius = radius == 0 ? 0.01 : radius;
        self.needInteractiveTimer = YES;
    }
    return self;
}

- (void)xw_setToAnimation:(id<UIViewControllerContextTransitioning>)transitionContext{
     UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:fromVC.view];
    [containerView addSubview:toVC.view];
    //添加遮罩视图
    [fromVC.view addSubview:self.coverView];
    UIBezierPath *startCycle = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(self.startPoint.x - self.startRadius, self.startPoint.y - self.startRadius, self.startRadius * 2, self.startRadius * 2) cornerRadius:self.startRadius];

    UIBezierPath *endCycle = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) cornerRadius:35];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = endCycle.CGPath;
    toVC.view.layer.mask = maskLayer;
    self.startPath = startCycle;
    self.maskLayer = maskLayer;
    self.containerView = containerView;
    CABasicAnimation *maskLayerAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    maskLayerAnimation.fromValue = (__bridge id)(startCycle.CGPath);
    maskLayerAnimation.toValue = (__bridge id)((endCycle.CGPath));
    maskLayerAnimation.duration = self.toDuration;
    maskLayerAnimation.delegate = self;
    [maskLayerAnimation setValue:transitionContext forKey:@"transitionContext"];
    [maskLayer addAnimation:maskLayerAnimation forKey:@"xw_path"];
}

- (void)xw_setBackAnimation:(id<UIViewControllerContextTransitioning>)transitionContext{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:toVC.view];
    [containerView addSubview:fromVC.view];
    //添加遮罩视图
    [toVC.view addSubview:self.coverView];
    UIBezierPath *endCycle = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(self.startPoint.x - self.startRadius, self.startPoint.y - self.startRadius, self.startRadius * 2, self.startRadius * 2) cornerRadius:self.startRadius];

    UIBezierPath *startPath =  [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) cornerRadius:35];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = endCycle.CGPath;
    fromVC.view.layer.mask = maskLayer;
    
    self.maskLayer = maskLayer;
    self.startPath = [UIBezierPath bezierPathWithCGPath:startPath.CGPath];
    self.containerView = containerView;
    CABasicAnimation *maskLayerAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    maskLayerAnimation.fromValue = (__bridge id)(startPath.CGPath);
    maskLayerAnimation.toValue = (__bridge id)(endCycle.CGPath);
    maskLayerAnimation.duration = self.backDuration;
    maskLayerAnimation.delegate = self;
    [maskLayerAnimation setValue:transitionContext forKey:@"transitionContext"];
    [maskLayer addAnimation:maskLayerAnimation forKey:@"xw_path"];
    [UIView animateWithDuration:self.backDuration animations:^{
        self.coverView.alpha = 0;
    }];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    id<UIViewControllerContextTransitioning> transitionContext = [anim valueForKey:@"transitionContext"];
    [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view.layer.mask = nil;
    [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view.layer.mask = nil;
     [self.coverView removeFromSuperview];
}

- (void)xw_interactiveTransitionWillBeginTimerAnimation:(XWInteractiveTransition *)interactiveTransition{
    _containerView.userInteractionEnabled = NO;
}

- (void)xw_interactiveTransition:(XWInteractiveTransition *)interactiveTransition willEndWithSuccessFlag:(BOOL)flag percent:(CGFloat)percent{
    if (!flag) {
        //防止失败后的闪烁
        _maskLayer.path = _startPath.CGPath;
    }
    _containerView.userInteractionEnabled = YES;
}

-(UIView *)coverView{
    if (!_coverView) {
        _coverView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _coverView.backgroundColor = [UIColor blackColor];
        _coverView.alpha = 0.4;
    };
    return _coverView;
}

@end
