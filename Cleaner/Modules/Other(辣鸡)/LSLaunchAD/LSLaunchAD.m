

//
//  LSLaunchAD.m
//  LSLaunchAD
//
//  Created by 刘松 on 16/8/26.
//  Copyright © 2016年 liusong. All rights reserved.
//

#import "LSLaunchAD.h"
//#import "UIImageView+WebCache.h"

@interface LSLaunchAD ()

@property(nonatomic, strong) UIImageView *adImgView;
//倒计时总时长
@property(nonatomic, assign) int adTime;

@property(nonatomic, strong) UIButton *skipBtn;

@property(nonatomic, strong) NSTimer *timer;

@property(nonatomic, copy) LSLaunchADBlock block;

@end

@implementation LSLaunchAD

+ (void)showWithCountTime:(int)countTime
                        adImageUrl:(NSString *)adImageUrl
                          aDBlock:(LSLaunchADBlock)aDBlock

{
    //本地缓存中的图片
//    UIImage *adImage = [[SDImageCache sharedImageCache] imageFromCacheForKey:adImageUrl];
//    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    //是否显示广告
//    BOOL isShowAd = [userdefault boolForKey:isShowAdKey];
    //是否已过期
//    NSDateFormatter *formatter= [[NSDateFormatter alloc] init];
//    [formatter setLocale:[NSLocale currentLocale]];
//    [formatter setDateFormat:@"yyyyMMdd"];
//    NSString *currentDateString= [formatter stringFromDate:[NSDate date]];
//    NSString *deadlineDateString = [userdefault stringForKey:deadlineKey];
//    BOOL isDidDeadline = currentDateString.longLongValue > deadlineDateString.longLongValue;
//    //若没有图片、广告过期或设置了不展示，则不需要显示广告
//    if (adImage == nil || !isShowAd || isDidDeadline) return;
//
//    LSLaunchAD *ad = [[LSLaunchAD alloc] init];
//    ad.adTime = countTime + 1;
//    ad.block = aDBlock;
//    ad.adImgView.image = adImage;
//
//    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1
//                                                      target:ad
//                                                    selector:@selector(autoCount)
//                                                    userInfo:nil
//                                                     repeats:YES];
//    ad.timer = timer;
//    [timer fire];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIWindow *win = nil;
        self.frame = win.bounds;
        [win addSubview:self];
        
        _adImgView = [[UIImageView alloc] init];
        _adImgView.contentMode = UIViewContentModeScaleAspectFill;
        _adImgView.clipsToBounds = YES;
        
        _adImgView.frame = self.bounds;
        _adImgView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
        [_adImgView addGestureRecognizer:tap];
        [self addSubview:_adImgView];
        
        _skipBtn = [[UIButton alloc] init];
        _skipBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _skipBtn.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.377];
        CGFloat size = 45;
//        _skipBtn.frame = CGRectMake(win.bounds.size.width - 30 - size, KStatusBarHeight + 10, size, size);
        _skipBtn.layer.cornerRadius = size * 0.5;
        _skipBtn.clipsToBounds = YES;
        [self addSubview:_skipBtn];

    }
    return self;
}

- (void)autoCount {
    if (self.adTime == 0) {
        [self hide];
        return;
    }
    if (self.skipBtn) {
        if (self.adTime == 1) {
            [self.skipBtn
             setTitle:[NSString stringWithFormat:@"%ds", self.adTime]
             forState:UIControlStateNormal];
        } else {
            [self.skipBtn
             setTitle:[NSString stringWithFormat:@"%ds", self.adTime]
             forState:UIControlStateNormal];
        }
    }
    self.adTime--;
}

- (void)hide {
    [self.timer invalidate];
    self.timer = nil;
    [UIView animateWithDuration:0.3
                     animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        if (self.block) {
            self.block(NO);
        }
        [self removeFromSuperview];
    }];
}

- (void)skip {
    [self hide];
}

- (void)tapClick {
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
//    NSString *adUrl = [userdefault stringForKey:adUrlKey];
//    if (adUrl.length == 0) { return; }
//    if (self.block) {
//        [self hide];
//        self.block(YES);
//    }
}

@end
