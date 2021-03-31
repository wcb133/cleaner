//
//  UIBezierPath+CRExtension.m
//  CoinRise
//
//  Created by fst on 2019/5/30.
//  Copyright © 2019 leon. All rights reserved.
//

#import "UIBezierPath+CRExtension.h"
#define IsArrayNull(array) ((nil == array || ![array isKindOfClass:[NSArray class]]\
|| [array isKindOfClass:[NSNull class]] || array.count <= 0))
#define IsStringNull(string) (nil == string || [string isKindOfClass:[NSNull class]] \
|| string.length <= 0)
#define IsObjectNull(object) (nil == object || [object isKindOfClass:[NSNull class]])
@implementation UIBezierPath (CRExtension)

+ (UIBezierPath *)drawCircleWithCenter:(CGPoint)circleCenter
{
    CGFloat radius = 2.5;
    UIBezierPath * path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(circleCenter.x - radius, circleCenter.y - radius, 2 * radius, 2 * radius)];
    return path;
}

+(UIBezierPath *)drawWireLine:(NSArray *)linesArray
{
    UIBezierPath * path = [UIBezierPath bezierPath];
    [linesArray enumerateObjectsUsingBlock:^(NSValue * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGPoint point;
        point.x = [obj CGPointValue].x;
        point.y = [obj CGPointValue].y;
        if (idx == 0)
            [path moveToPoint:CGPointMake(point.x, point.y)];
        else
            [path addLineToPoint:CGPointMake(point.x, point.y)];
    }];
    return path;
}

+ (NSMutableArray<UIBezierPath *> *)drawLines:(NSMutableArray<NSMutableArray *> *)linesArray
{
    if (IsArrayNull(linesArray))
        return nil;
    NSMutableArray * result = [NSMutableArray array];
    
    for (NSMutableArray * lineArray in linesArray) {
        UIBezierPath * path = [UIBezierPath drawWireLine:lineArray];
        [result addObject:path];
    }
    return result;
}

+ (UIBezierPath *)drawKLine:(CGFloat)open close:(CGFloat)close high:(CGFloat)high low:(CGFloat)low kLineWidth:(CGFloat)kLineWidth  xPostion:(CGFloat)xPostion lineWidth:(CGFloat)lineWidth
{
    UIBezierPath * candlePath = [UIBezierPath bezierPath];

    CGFloat y = open > close ? close : open;//这里是Y轴坐标
    CGFloat height = fabs(close - open);
    CGFloat halfKlineWidth = kLineWidth * 0.5;
    [candlePath moveToPoint:CGPointMake(xPostion, y)];
    [candlePath addLineToPoint:CGPointMake(xPostion + halfKlineWidth, y)];
    if (y > high) {
        [candlePath addLineToPoint:CGPointMake(xPostion + halfKlineWidth, high)];
        [candlePath addLineToPoint:CGPointMake(xPostion + halfKlineWidth, y)];
    }
    
    [candlePath addLineToPoint:CGPointMake(xPostion + kLineWidth - lineWidth, y)];
    [candlePath addLineToPoint:CGPointMake(xPostion + kLineWidth - lineWidth, y + height)];
    [candlePath addLineToPoint:CGPointMake(xPostion + halfKlineWidth, y + height)];
    if ((y + height) < low)
    {
        [candlePath addLineToPoint:CGPointMake(xPostion + halfKlineWidth, low)];
        [candlePath addLineToPoint:CGPointMake(xPostion + halfKlineWidth, y + height)];
    }
    [candlePath addLineToPoint:CGPointMake(xPostion, y + height)];
    [candlePath addLineToPoint:CGPointMake(xPostion, y)];
    [candlePath closePath];
    return candlePath;
}

@end
