//
//  CircularProgressView.m
//  SellMyiPhone
//
//  Created by Vincent on 1/12/17.
//  Copyright © 2017 Huishoubao Tech. All rights reserved.
//

#import "CircularProgressView.h"
//#import "Macros.h"
//#import "DesignStandards.h"

#define LineWidth 10.f
#define Space 10.f


@implementation CircularProgressView
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}




- (void)setProgress:(float)progress {
    if (progress >= 100.f) {
        _progress = 100.f;
    }
    _progress = progress;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    [self drawBackground];
    [self drawProgressLine];
}

- (void)drawProgressLine {
    [self drawCircleDashed:NO];
}

- (void)drawBackground {
    CGRect rect = self.bounds;
    CGPoint center = CGPointMake(CGRectGetWidth(rect) / 2.f, CGRectGetHeight(rect) / 2.f);
    CGFloat radius = MIN(CGRectGetHeight(rect), CGRectGetWidth(rect)) / 2 - Space - LineWidth;
    // draw pie
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    [[UIColor orangeColor] setFill];
    [path fill];
    // draw dash circle
    [self drawCircleDashed:YES];
}

- (void)drawCircleDashed:(BOOL)dash {
    CGRect rect = self.bounds;
    CGPoint center = CGPointMake(CGRectGetWidth(rect) / 2.f, CGRectGetHeight(rect) / 2.f);
    CGFloat radius = MIN(CGRectGetHeight(rect), CGRectGetWidth(rect)) / 2 - LineWidth / 2;

     CGFloat startAngle = -M_PI_2;
     CGFloat endAngle = 3 / 2.0 * M_PI;
     if (!dash) {
         endAngle = M_PI * 2.0 * self.progress / 100.f - M_PI_2;
     }
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
    if (dash) {
        CGFloat lengths[] = {3, 6};
        [path setLineDash:lengths count:2 phase:0];
    }
    [path setLineWidth:LineWidth];
    [[UIColor orangeColor] setStroke];
    [path stroke];
}

@end
