//
//  UIColor+Y_StockChart.h
//  BTC-Kline
//
//  Created by yate1996 on 16/4/30.
//  Copyright © 2016年 yate1996. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Y_StockChart)

/**
 *  根据十六进制转换成UIColor
 *
 *  @param hex UIColor的十六进制
 *
 *  @return 转换后的结果
 */
+(UIColor *)colorWithRGBHex:(UInt32)hex;

/** 主背景色 */
+(UIColor *)backgroundColor;
/** 子背景色 */
+(UIColor *)subBackgroundColor;
/** 主文字颜色 */
+(UIColor *)mainTextColor;
/** 辅助文字颜色 */
+(UIColor *)assistTextColor;

/** 分时图颜色 */
+ (UIColor *)timeLineColor;

/** 涨的颜色 */
+(UIColor *)increaseColor;
/** 跌的颜色 */
+(UIColor *)decreaseColor;

/** 长按时线的颜色 */
+(UIColor *)longPressLineColor;
/** ma5的颜色 */
+(UIColor *)ma5Color;
/** ma10的颜色 */
+(UIColor *)ma10Color;
/** ma30颜色 */
+(UIColor *)ma30Color;

/** BOLL_MB颜色 */
+(UIColor *)BOLL_MBColor;
/** BOLL_UP颜色 */
+(UIColor *)BOLL_UPColor;
/** BOLL_DN颜色 */
+(UIColor *)BOLL_DNColor;

/** KDJ_K颜色 */
+ (UIColor *)KDJ_KColor;

/** DIF颜色 */
+(UIColor *)MACD_DIFColor;
/** DEA颜色 */
+(UIColor *)MACD_DEAColor;


@end
