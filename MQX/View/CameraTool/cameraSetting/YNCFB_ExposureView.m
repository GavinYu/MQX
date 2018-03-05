//
//  YNCFB_ExposureView.m
//  YuneecApp
//
//  Created by hank on 08/05/2017.
//  Copyright © 2017 yuneec. All rights reserved.
//

#import "YNCFB_ExposureView.h"

#import "YNCFB_MaskView.h"
#import "YNCAppConfig.h"

@interface YNCFB_ExposureView ()

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (nonatomic, strong) CAShapeLayer *shapeLayer;

@end

@implementation YNCFB_ExposureView


- (void)setValue:(CGFloat)value
{
    _value = value;
    if (value > 0) {
        _valueLabel.text = [NSString stringWithFormat:@"+%.1f", value];
    } else {
        _valueLabel.text = [NSString stringWithFormat:@"%.1f", value];
    }
    _customMaskView.value = value;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    [self addSubview:_contentView];
    _contentView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    _valueLabel.text = @"0.0";
    _valueLabel.textColor = [UIColor yncGreenColor];
    _valueLabel.font = [UIFont thirteenFontSize];
    _customMaskView.value = 0.0;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
