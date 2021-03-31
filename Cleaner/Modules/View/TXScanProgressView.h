//
//  TXUploadingProgressView.h
//  JhDownProgressView
//
//  Created by fst on 2019/5/20.
//  Copyright © 2019 Jh. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TXScanProgressView : UIView
/**
 下载进度,内部按1.0计算
 */
@property (nonatomic, assign) CGFloat progress;
/** 中间文字颜色 */
@property (nonatomic,strong) UIColor *percentTextColor;
/** 中间文字字体 */
@property(nonatomic,strong)UIFont *percentTextFont;

/** 进度条颜色 */
@property(nonatomic,strong) UIColor *progressBarColor;


@end

NS_ASSUME_NONNULL_END
