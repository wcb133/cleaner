//
//  UIColor+Y_StockChart.m
//  BTC-Kline
//
//  Created by yate1996 on 16/4/30.
//  Copyright © 2016年 yate1996. All rights reserved.
//

#import "UIColor+Y_StockChart.h"

@implementation UIColor (Y_StockChart)

+ (UIColor *)colorWithRGBHex:(UInt32)hex {
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    
    return [UIColor colorWithRed:r / 255.0f
                           green:g / 255.0f
                            blue:b / 255.0f
                           alpha:1.0f];
}

+ (UIColor *)backgroundColor
{
    return [UIColor colorWithRGBHex:0x092039];
}

+ (UIColor *)subBackgroundColor
{
    return [UIColor colorWithRGBHex:0x092039];
}

+ (UIColor *)mainTextColor
{
    return [UIColor colorWithRGBHex:0x6A8296];
}

+ (UIColor *)assistTextColor
{
    return [UIColor colorWithRGBHex:0x0FA8F5];
}

+ (UIColor *)timeLineColor
{
    return [UIColor colorWithRGBHex:0x1482D6];
}

+ (UIColor *)increaseColor
{
    return [UIColor colorWithRGBHex:0xFF4349];
}

+ (UIColor *)decreaseColor
{
    return [UIColor colorWithRGBHex:0x00B99F];
}

+ (UIColor *)longPressLineColor
{
    return [[UIColor whiteColor] colorWithAlphaComponent:0.3];
}

+ (UIColor *)ma5Color
{
    return [UIColor colorWithRGBHex:0xFEF284];
}

+ (UIColor *)ma10Color
{
    return [UIColor colorWithRGBHex:0xA980F5];
}

+ (UIColor *)ma30Color
{
    return [UIColor colorWithRGBHex:0xFF8686];
}

+ (UIColor *)BOLL_MBColor
{
    return [UIColor ma5Color];
}

+ (UIColor *)BOLL_UPColor
{
    return [UIColor ma10Color];
}

+ (UIColor *)BOLL_DNColor
{
    return [UIColor ma30Color];
}

+ (UIColor *)KDJ_KColor
{
   return [UIColor colorWithRGBHex:0x84FEE0];
}

+ (UIColor *)MACD_DIFColor
{
    return [UIColor colorWithRGBHex:0xFEF284];
}

+ (UIColor *)MACD_DEAColor
{
    return [UIColor colorWithRGBHex:0xA980F5];
}


@end
