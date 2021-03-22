//
//  TXUploadingProgressView.m
//  JhDownProgressView
//
//  Created by fst on 2019/5/20.
//  Copyright © 2019 Jh. All rights reserved.
//

#import "TXUploadingProgressView.h"
#import <QMUIKit/QMUIKit.h>
/** 外环与圆的间距 */
#define KMargin 20

@interface TXUploadingProgressView ()
/** 百分百文字 */
@property (nonatomic, strong) UILabel *percentTextLabel;
@property(nonatomic,weak)CALayer *clayer;
@property(nonatomic,weak)UIView *containerView;
@property(nonatomic,weak)UIView *bgView;
@end

@implementation TXUploadingProgressView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        //设置初始值
        _progress = 0.01;
        self.progressBarColor = UIColorWhite;
        _percentTextFont = [UIFont systemFontOfSize:13];
        _percentTextColor = [UIColor colorWithRed:154/255.0 green:213/255.0 blue:251/255.0 alpha:1];
        [self addNotificationObserver];
    }
    return self;
}

-(UILabel *)percentTextLabel{
    if (!_percentTextLabel) {
        UILabel *textLable = [[UILabel alloc]init];
        textLable.hidden = YES;
        textLable.text = @"2%";
        textLable.textColor = _percentTextColor;
        textLable.font = _percentTextFont;
        textLable.textAlignment = NSTextAlignmentCenter;
        _percentTextLabel = textLable;
        [self addSubview:self.percentTextLabel];
    }
    return _percentTextLabel;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.percentTextLabel.frame = CGRectMake(0, self.frame.size.height * 0.5 - 15, self.frame.size.width, 30);
    [self createCircularRingWithFrame:self.frame];
}

- (void)createCircularRingWithFrame:(CGRect)frame
{
    [self.containerView removeFromSuperview];
    [self.clayer removeFromSuperlayer];
    
    CGFloat w = frame.size.width;
    CGFloat h = frame.size.height;
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, w, h)];
    containerView.backgroundColor = [UIColor clearColor];
    self.containerView = containerView;
    [self addSubview:containerView];
    
    CALayer *layer = [CALayer layer];
    self.clayer = layer;
    layer.frame = CGRectMake(0, 0, w, h);
    layer.backgroundColor = [UIColor clearColor].CGColor;
    [containerView.layer addSublayer:layer];
    //创建圆环
    CGFloat ringLineWidth = 2;
    CGFloat radius = MIN(w, h) / 2 - ringLineWidth;
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(w * 0.5, h * 0.5) radius:radius startAngle:7 * M_PI / 4 endAngle:M_PI / 4 clockwise:YES];
    //圆环遮罩
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.strokeColor = [UIColor whiteColor].CGColor;
    shapeLayer.lineWidth = ringLineWidth;
    shapeLayer.strokeStart = 0;
    shapeLayer.strokeEnd = 1;
    shapeLayer.lineCap = kCALineCapSquare;
    shapeLayer.lineDashPhase = 0.8;
    shapeLayer.path = bezierPath.CGPath;
    [layer setMask:shapeLayer];
    
    //颜色渐变
    CGColorRef color1 = [self.progressBarColor colorWithAlphaComponent:0.01].CGColor;
    CGColorRef color2 = [self.progressBarColor colorWithAlphaComponent:0.9].CGColor;
    NSMutableArray *colors = [NSMutableArray arrayWithObjects:(__bridge id)color1,(__bridge id)color2, nil];
    CGFloat topPadding = 14;
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.shadowPath = bezierPath.CGPath;
    gradientLayer.frame = CGRectMake(0, topPadding, w, h * 0.5 - topPadding);
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1);
    [gradientLayer setColors:[NSArray arrayWithArray:colors]];
    
    NSMutableArray *colors1 = [NSMutableArray arrayWithObjects:(__bridge id)color2,(__bridge id)(color1), nil];
    CAGradientLayer *gradientLayer1 = [CAGradientLayer layer];
    gradientLayer1.shadowPath = bezierPath.CGPath;
    gradientLayer1.frame = CGRectMake(0, h * 0.5, w, h * 0.5 - topPadding);
    gradientLayer1.startPoint = CGPointMake(0,0);
    gradientLayer1.endPoint = CGPointMake(0, 1);
    [gradientLayer1 setColors:[NSArray arrayWithArray:colors1]];
    [layer addSublayer:gradientLayer];
    [layer addSublayer:gradientLayer1];
    [self addAnimation];
}

- (void)addAnimation
{
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.fromValue = [NSNumber numberWithFloat:0];
    rotationAnimation.toValue = [NSNumber numberWithFloat:2.0 * M_PI];
    rotationAnimation.repeatCount = MAXFLOAT;
    rotationAnimation.duration = 0.6;
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [self.clayer addAnimation:rotationAnimation forKey:@"rotationAnnimation"];
}

- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    _progress = progress <= 0.02?0.02:progress;
    self.percentTextLabel.text = [NSString stringWithFormat:@"%d%%", (int)floor(progress * 100)];
    if (progress >= 1.0) {
//        [self removeFromSuperview];
//        [self.bgView removeFromSuperview];
    } else {
        [self setNeedsDisplay];
    }
}

- (void)setPercentTextColor:(UIColor *)percentTextColor
{
    _percentTextColor = percentTextColor;
    self.percentTextLabel.textColor = percentTextColor;
}

-(void)setProgressBarColor:(UIColor *)progressBarColor
{
    _progressBarColor = progressBarColor;
    [self setNeedsDisplay];
}

#pragma mark -- 进入前台或活跃状态
- (void)addNotificationObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addAnimation) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
