//
//  testView.m
//  Demo_hireBird
//
//  Created by vrsh on 06/04/2017.
//  Copyright © 2017 yuneec. All rights reserved.
//

#import "YNCStatusView_Firebird.h"

#define kLineWidth (1.5 * _sizeMutiple) // 线高
#import "YNCAppConfig.h"


@interface YNCStatusView_Firebird ()

@property (nonatomic, weak) CAShapeLayer *shapeLayer;
@property (nonatomic, strong) NSMutableArray *leftTextLayerArray;
@property (nonatomic, strong) NSMutableArray *rightTextLayerArray;

@end

@implementation YNCStatusView_Firebird

- (NSMutableArray *)leftTextLayerArray
{
    if (!_leftTextLayerArray) {
        self.leftTextLayerArray = [NSMutableArray arrayWithCapacity:0];
        for (int i = 0; i < 6; i++) {
            CATextLayer *textLayer_left = [CATextLayer layer];
            [self.layer addSublayer:textLayer_left];
            
            //set text attributes
            textLayer_left.foregroundColor = [UIColor yncFirebirdLightGreenColor].CGColor;
            textLayer_left.alignmentMode = kCAAlignmentLeft;
            textLayer_left.wrapped = YES;
            textLayer_left.contentsScale = [UIScreen mainScreen].scale;
            [self.leftTextLayerArray addObject:textLayer_left];
        }
    }
    return _leftTextLayerArray;
}

- (NSMutableArray *)rightTextLayerArray
{
    if (!_rightTextLayerArray) {
        self.rightTextLayerArray = [NSMutableArray arrayWithCapacity:0];
        for (int i = 0; i < 6; i++) {
            CATextLayer *textLayer_right = [CATextLayer layer];
            [self.layer addSublayer:textLayer_right];
            //set text attributes
            textLayer_right.foregroundColor = [UIColor yncFirebirdLightGreenColor].CGColor;
            textLayer_right.alignmentMode = kCAAlignmentRight;
            textLayer_right.wrapped = YES;
            textLayer_right.contentsScale = [UIScreen mainScreen].scale;
            [self.rightTextLayerArray addObject:textLayer_right];
        }
    }
    return _rightTextLayerArray;
}

- (void)setCenterMode:(BOOL)centerMode
{
    _centerMode = centerMode;
    
    _shapeLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);

    [self setNeedsDisplay];

    self.shapeLayer.path = [self classOneBezierPathWithValue:_value].CGPath;
}

- (void)setValue:(int)value
{
    _value = value;

    [self setNeedsDisplay];

    self.shapeLayer.path = [self classOneBezierPathWithValue:_value].CGPath;
}

- (void)createUI
{
    _value = 0;
    [self createCAShapeLayer];
}

- (void)createCAShapeLayer
{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.strokeColor = [UIColor yncFirebirdLightGreenColor].CGColor;
    shapeLayer.lineCap = kCALineCapRound;
    shapeLayer.lineJoin = kCALineJoinRound;
    shapeLayer.lineWidth = kLineWidth;

    shapeLayer.frame = self.bounds;

    [self.layer addSublayer:shapeLayer];
    shapeLayer.path = [self classOneBezierPathWithValue:_value].CGPath;
    self.shapeLayer = shapeLayer;
}

- (UIBezierPath *)classOneBezierPathWithValue:(int)value
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGFloat width = self.bounds.size.width; // 视图的宽
    CGFloat height = self.bounds.size.height; // 视图的高
    
    // 纵向每个刻度的间隔值
    CGFloat space_vertical = 5.0 * _sizeMutiple;
    CGFloat lineWidth = 40 * _sizeMutiple; // 线长度
    int centerValue = value; // 当前显示值
    int maxValue, minValue;
    if (_centerMode) {
        maxValue = 55;
        minValue = 3;
    } else {
        maxValue = 44;
        minValue = 7;
    }
    
    for (int i = minValue; i < maxValue; i++) {
        int value;
        if (_centerMode) {
            value = centerValue - 25 + i - minValue;
        } else {
            value = centerValue - 15 + i - minValue;
        }
        if (value % 5 == 0) {
            if (value % 10 == 0) {
                if (value == 0) {
                    // 绘制中心线
                    // 2.画圆
                    [path moveToPoint:CGPointMake(width / 2.0, height - i * space_vertical)];
                    [path addArcWithCenter:CGPointMake(width / 2.0, height - i * space_vertical) radius:1 * _sizeMutiple startAngle:0 endAngle:M_PI * 2 clockwise:YES];
                    [path moveToPoint:CGPointMake(width / 2.0 - 12 * _sizeMutiple, height - i * space_vertical)];
                    [path addLineToPoint:CGPointMake(width / 2.0 - 117 * _sizeMutiple, height - i * space_vertical)];
                    
                    [path moveToPoint:CGPointMake(width / 2.0 + 12 * _sizeMutiple, height - i * space_vertical)];
                    [path addLineToPoint:CGPointMake(width / 2.0 + 117 * _sizeMutiple, height - i * space_vertical)];
                } else {
                    // 有数值的刻度
                    [path moveToPoint:CGPointMake((width - lineWidth) / 2.0, height - i * space_vertical)];
                    [path addLineToPoint:CGPointMake((width + lineWidth) / 2.0, height - i * space_vertical)];
                    
                }
            } else {
                // 没有刻度的线
                [path moveToPoint:CGPointMake((width / 2.0 - lineWidth / 4.0), height - i * space_vertical)];
                [path addLineToPoint:CGPointMake((width / 2.0 + lineWidth / 4.0), height - i * space_vertical)];
            }
        }
    }
    return path;
}

// 上下偏移25度, 上下各有五个刻度
- (void)drawRect:(CGRect)rect {
    // Drawing code
    // 1.获取上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();

    CGFloat width = rect.size.width; // 视图的宽
    CGFloat height = rect.size.height; // 视图的高
    
    // 纵向每个刻度的间隔值
    CGFloat space_vertical = 5.0 * _sizeMutiple;
    CGFloat lineWidth = 40 * _sizeMutiple; // 线长度
    int centerValue = _value; // 当前显示值
    int maxValue, minValue;
    if (_centerMode) {
        maxValue = 59;
        minValue = 3;
    } else {
        maxValue = 44;
        minValue = 7;
    }

    for (int i = minValue; i < maxValue; i++) {
        int value;
        if (_centerMode) {
            value = centerValue - 25 + i - minValue;
        } else {
            value = centerValue - 15 + i - minValue;
        }
        if (value % 5 == 0) {
            if (value % 10 == 0) {
                if (value == 0) {
                    // 绘制中心线
                    // 2.画圆
//                    CGContextAddEllipseInRect(ctx, CGRectMake(width / 2.0 - 1 * _sizeMutiple, height - i * space_vertical - 1, 2 * _sizeMutiple, 2 * _sizeMutiple));
//                    CGContextMoveToPoint(ctx, width / 2.0 - 12 * _sizeMutiple, height - i * space_vertical); // 起点
//                    CGContextAddLineToPoint(ctx, width / 2.0 - 117 * _sizeMutiple, height - i * space_vertical); //终点
//                    CGContextMoveToPoint(ctx, width / 2.0 + 12 * _sizeMutiple, height - i * space_vertical); // 起点
//                    CGContextAddLineToPoint(ctx, width / 2.0 + 117 * _sizeMutiple, height - i * space_vertical); //终点
//                    CGContextSetLineWidth(ctx, kLineWidth); // 线的宽度
                } else {
                    // 有数值的刻度
//                    CGContextMoveToPoint(ctx, (width - lineWidth) / 2.0, height - i * space_vertical); // 起点
//                    CGContextAddLineToPoint(ctx, (width + lineWidth) / 2.0, height - i * space_vertical); //终点
                    // 文字
                    NSString *str = [NSString stringWithFormat:@"%d", value];
                    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                    dict[NSForegroundColorAttributeName] = [UIColor yncFirebirdLightGreenColor]; // 文字颜色
                    dict[NSFontAttributeName] = [UIFont systemFontOfSize:12 * _sizeMutiple]; // 字体
                    [str drawInRect:CGRectMake((width - lineWidth) / 2.0 - 30 * _sizeMutiple, height - i * space_vertical - 8 * _sizeMutiple, 30 * _sizeMutiple, 30 * _sizeMutiple) withAttributes:dict];
                    [str drawInRect:CGRectMake((width + lineWidth) / 2.0 + 15 * _sizeMutiple, height - i * space_vertical - 8 * _sizeMutiple, 30 * _sizeMutiple, 30 * _sizeMutiple) withAttributes:dict];
                    CGContextSetLineWidth(ctx, kLineWidth); // 线的宽度
                }
            } else {
                // 没有刻度的线
//                CGContextMoveToPoint(ctx, (width / 2.0 - lineWidth / 4.0), height - i * space_vertical); // 起点
//                CGContextAddLineToPoint(ctx, (width / 2.0 + lineWidth / 4.0), height - i * space_vertical); //终点
//                CGContextSetLineWidth(ctx, kLineWidth); // 线的宽度
            }
//            [[UIColor yncFirebirdLightGreenColor] set]; // 两种设置颜色的方式都可以
//            CGContextSetLineCap(ctx, kCGLineCapRound); // 起点和重点圆角
//            CGContextSetLineJoin(ctx, kCGLineJoinRound); // 转角圆角
//            CGContextStrokePath(ctx); // 渲染（直线只能绘制空心的，不能调用
        }
    }
}

- (void)dealloc
{
    DLog(@"statusViewDealloc");
}

@end
