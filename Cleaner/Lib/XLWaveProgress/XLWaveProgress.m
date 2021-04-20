//
//  XLWaveProgress.m
//  XLWaveProgressDemo
//
//  Created by Apple on 2016/11/10.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "XLWaveProgress.h"
#import "XLWave.h"
#import <QMUIKit/QMUIKit.h>

@interface XLWaveProgress ()
{
    XLWave *_wave;
    UILabel *_textLabel;
}



@end

@implementation XLWaveProgress

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self buildLayout];
        
        UILabel *lab = [[UILabel alloc] init];
        lab.text = @"--";
        lab.textAlignment = NSTextAlignmentCenter;
        lab.textColor = [UIColor qmui_colorWithHexString:@"FDCC33"];
        lab.font = [UIFont systemFontOfSize:15];
        [self addSubview:lab];
        lab.qmui_left = _textLabel.qmui_left;
        lab.qmui_width = _textLabel.qmui_width;
        lab.qmui_height = 20;
        lab.qmui_top = _textLabel.qmui_bottom + 6;
        self.memeryLab = lab;
        
        UILabel *tipslab = [[UILabel alloc] init];
        tipslab.text = @"已使用";
        tipslab.textAlignment = NSTextAlignmentCenter;
        tipslab.textColor = [UIColor qmui_colorWithHexString:@"FDCC33"];
        tipslab.font = [UIFont systemFontOfSize:15];
        [self addSubview:tipslab];
        tipslab.qmui_left = self.memeryLab.qmui_left;
        tipslab.qmui_width = self.memeryLab.qmui_width;
        tipslab.qmui_height = 20;
        tipslab.qmui_top = self.memeryLab.qmui_bottom + 6;

    }
    return self;
}

-(void)buildLayout
{
    self.backgroundColor = [UIColor colorWithRed:40/255.0 green:179/255.0 blue:255/255.0 alpha:0.15];
    self.layer.cornerRadius = self.bounds.size.width/2.0f;
    self.layer.masksToBounds = true;
    
    CGFloat waveWidth = self.bounds.size.width * 0.8f;
    _wave = [[XLWave alloc] initWithFrame:CGRectMake(0, 0, waveWidth, waveWidth)];
    _wave.center = CGPointMake(self.bounds.size.width/2.0f, self.bounds.size.width/2.0f);
    [self addSubview:_wave];
    
    _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width - 40, 50)];
    _textLabel.qmui_left = (self.qmui_width - _textLabel.qmui_width) * 0.5;
    _textLabel.qmui_top = self.qmui_height * 0.5 - _textLabel.qmui_height;
    _textLabel.textAlignment = NSTextAlignmentCenter;
    _textLabel.textColor = [UIColor qmui_colorWithHexString:@"FDCC33"];
    _textLabel.font = [UIFont boldSystemFontOfSize:45];
    [self addSubview:_textLabel];
}

-(void)setProgress:(CGFloat)progress
{
    _progress = progress;
    _wave.progress = progress;
    NSString *percentString = [NSString stringWithFormat:@"%.0f%%",progress * 100];
    NSMutableAttributedString *attrPercentString = [[NSMutableAttributedString alloc] initWithString:percentString];
    [attrPercentString addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:48]} range:NSMakeRange(0, percentString.length)];
    [attrPercentString addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:30]} range:NSMakeRange(percentString.length - 1,1)];
    _textLabel.attributedText = attrPercentString;
}

-(void)dealloc
{
    [_wave stop];
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
}

@end
