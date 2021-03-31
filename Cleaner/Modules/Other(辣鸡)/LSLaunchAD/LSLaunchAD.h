//
//  LSLaunchAD.h
//  LSLaunchAD
//
//  Created by 刘松 on 16/8/26.
//  Copyright © 2016年 liusong. All rights reserved.
//

#import <UIKit/UIKit.h>

// clickAD YES为点击了广告 NO为倒计时完成倒计时或点击了跳过按钮
typedef void (^LSLaunchADBlock)(BOOL clickAD);

@interface LSLaunchAD : UIView

/**
*  根据需要显示
*
*  @param countTime 倒计时时间
*  @param adImageUrl 广告图片
*  @param aDBlock              回调block
*
*/
+ (void)showWithCountTime:(int)countTime
               adImageUrl:(NSString *)adImageUrl
                  aDBlock:(LSLaunchADBlock)aDBlock;

@end
