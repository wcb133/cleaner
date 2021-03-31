//
//  UIBezierPath+CRExtension.h
//  CoinRise
//
//  Created by fst on 2019/5/30.
//  Copyright © 2019 leon. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIBezierPath (CRExtension)
+ (UIBezierPath *)drawCircleWithCenter:(CGPoint)circleCenter;

+ (UIBezierPath*)drawWireLine:(NSArray *)linesArray;

+ (NSMutableArray *  __nullable)drawLines:(NSMutableArray<NSMutableArray*>*)linesArray;

+ (UIBezierPath *)drawKLine:(CGFloat)open close:(CGFloat)close high:(CGFloat)high low:(CGFloat)low kLineWidth:(CGFloat)kLineWidth xPostion:(CGFloat)xPostion lineWidth:(CGFloat)lineWidth;
@end

NS_ASSUME_NONNULL_END
