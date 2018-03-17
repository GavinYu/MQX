//
//  YNCCircleProgress.m
//  MQX
//
//  Created by yc-sh-vr-pc05 on 2018/3/17.
//  Copyright © 2018年 YunEEC. All rights reserved.
//

#import "YNCCircleProgress.h"

#import "YNCMacros.h"

#define kDegreeConvertRadian(x) (M_PI * (x) / 180.0) // 将度数转弧度
#define kLineWidth 6.0f
#define kSelfWidth self.frame.size.width
#define kSelfHeight self.frame.size.height

@interface YNCCircleProgress ()

@property (nonatomic, strong) CAShapeLayer *colorMaskLayer;
@property (nonatomic, strong) CAShapeLayer *colorLayer;
@property (nonatomic, strong) CAShapeLayer *garyMasklayer;

@end

@implementation YNCCircleProgress

- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    self.colorMaskLayer.strokeEnd = progress;
}

- (void)createLayer
{
    self.backgroundColor =[UIColor colorWithRed:52/255.0 green:58/255. blue:60/255.0 alpha:1.0];
    [self setUpColorLayer];
    [self setUpColorMaskLayer];
    [self setUpGaryMaskLayer];
    self.progress = 0.0;
}

- (void)setUpColorLayer
{
    self.colorLayer = [CAShapeLayer layer];
    self.colorLayer.frame = CGRectMake(0, 0, kSelfWidth, kSelfHeight);
    self.colorLayer.backgroundColor = UICOLOR_FROM_HEXRGB(0xF75F23).CGColor;
    [self.layer addSublayer:self.colorLayer];
}

- (void)setUpColorMaskLayer
{
    CAShapeLayer *layer = [self generateMaskLayer];
    layer.lineWidth = kLineWidth + 0.5;
    self.colorLayer.mask = layer;
    self.colorMaskLayer = layer;
}

- (void)setUpGaryMaskLayer
{
    CAShapeLayer *layer = [self generateMaskLayer];
    self.layer.mask = layer;
    self.garyMasklayer = layer;
}

- (CAShapeLayer *)generateMaskLayer
{
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.frame = CGRectMake(0, 0, kSelfWidth, kSelfHeight);
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(kSelfWidth / 2.0, kSelfHeight / 2.0) radius:(kSelfWidth - 10.0)/ 2.0 startAngle:kDegreeConvertRadian(-90) endAngle:kDegreeConvertRadian(270) clockwise:YES];
    layer.lineWidth = kLineWidth;
    layer.path = path.CGPath;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.strokeColor = [UIColor redColor].CGColor;
    return layer;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
