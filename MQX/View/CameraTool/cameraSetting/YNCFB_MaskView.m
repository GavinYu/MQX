//
//  YNCFB_MaskView.m
//  YuneecApp
//
//  Created by hank on 10/05/2017.
//  Copyright © 2017 yuneec. All rights reserved.
//

#import "YNCFB_MaskView.h"

@interface YNCFB_MaskView ()

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) CAShapeLayer *shapeLayer;

@end

@implementation YNCFB_MaskView

- (void)setValue:(CGFloat)value
{
    _value = value;
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGFloat width = self.frame.size.width;
    CGFloat space = 14.0f;
    CGFloat origin_x;
    CGFloat origin_y = 7;
    if (value > 0) {
        origin_x = width / 2.0 - 2;
        [path moveToPoint:CGPointMake(origin_x, origin_y)];
        [path addLineToPoint:CGPointMake(origin_x + value * space + 4 , origin_y)];
    } else if (value < 0) {
        origin_x = width / 2.0 + 2;
        [path moveToPoint:CGPointMake(origin_x, origin_y)];
        [path addLineToPoint:CGPointMake(origin_x + value * space - 4 , origin_y)];
    } else {
        origin_x = width / 2.0 - 2;
        [path moveToPoint:CGPointMake(origin_x, origin_y)];
        [path addLineToPoint:CGPointMake(origin_x + 4, origin_y)];
    }
    _shapeLayer.path = path.CGPath;
    [self setNeedsDisplay];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    [self addSubview:_contentView];
    _contentView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    //    _value = 0.0;
    self.maskLayer = [CALayer layer];
    _maskLayer.frame = self.bounds;
    [self.layer addSublayer:_maskLayer];
    UIImage *image = [UIImage imageNamed:@"icon_ExposureShow"];
    _maskLayer.contents = (__bridge id _Nullable)(image.CGImage);
    
    self.shapeLayer = [CAShapeLayer layer];
    _shapeLayer.frame = self.bounds;
    _shapeLayer.lineWidth = self.bounds.size.height;
    _shapeLayer.strokeColor = [UIColor yellowColor].CGColor;
    //    _shapeLayer.fillColor = nil;
    [self.layer addSublayer:_shapeLayer];
    
    _maskLayer.mask = _shapeLayer;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
