//
//  YNCVideoTimeView.m
//  MQX
//
//  Created by yc-sh-vr-pc05 on 2018/3/3.
//  Copyright © 2018年 YunEEC. All rights reserved.
//

#import "YNCVideoTimeView.h"

#import "YNCAppConfig.h"

@interface YNCVideoTimeView ()
{
    CGFloat _sizeMultiple;
}

@property (weak, nonatomic) IBOutlet UILabel *pointLabel;
@property (weak, nonatomic) IBOutlet UILabel *videoTimeLabel;
@property (nonatomic, assign) BOOL isCancel;

@end

@implementation YNCVideoTimeView

//MARK: -- 初始化VideoTimeView
+ (YNCVideoTimeView *)instanceVideoTimeView {
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"YNCVideoTimeView" owner:nil options:nil];
    return [nibView objectAtIndex:0];
}
//MARK: -- 初始化子视图
- (void)initSubView:(YNCModeDisplay)display {
    _sizeMultiple = display == YNCModeDisplayGlass?0.5:1.0;
    
    self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
    self.layer.cornerRadius = 8*_sizeMultiple;
    self.layer.masksToBounds = YES;
    _isCancel = NO;
    
    [_pointLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(3*_sizeMultiple);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(5*_sizeMultiple, 5*_sizeMultiple));
    }];
    [_videoTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(50*_sizeMultiple, 12*_sizeMultiple));
    }];
    _videoTimeLabel.font = [UIFont systemFontOfSize:9*_sizeMultiple];
    
    _pointLabel.layer.cornerRadius = self.pointLabel.bounds.size.width * 0.5;
    _pointLabel.layer.masksToBounds = YES;
}
//MARK: -- 是否显示录像时间
- (void)setShowTimeLabel:(BOOL)showTimeLabel
{
    _showTimeLabel = showTimeLabel;
    if (showTimeLabel) {
        _isCancel = NO;
        [self animationTwinkle:_pointLabel];
    } else {
        _isCancel = YES;
    }
    _pointLabel.hidden = !showTimeLabel;
    _videoTimeLabel.hidden = !showTimeLabel;
    self.hidden = !showTimeLabel;
}
//MARK: -- 显示录像时间的动画
- (void)animationTwinkle:(UIView *)twinkleView;
{
    [UIView animateKeyframesWithDuration:1.0 delay:0.5f options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        [UIView addKeyframeWithRelativeStartTime:0.f relativeDuration:1.0 / 2 animations:^{
            twinkleView.alpha = 0.0;
        }];
        [UIView addKeyframeWithRelativeStartTime:1.0 / 2 relativeDuration:1.0 / 2 animations:^{
            twinkleView.alpha = 1.0;
        }];
        
    } completion:^(BOOL finished) {
        if (!_isCancel) {
            [self animationTwinkle:twinkleView];
        }
    }];
}

- (void)setRecordTimeInSecond:(NSString *)recordTimeInSecond
{
    _recordTimeInSecond = recordTimeInSecond;
    _videoTimeLabel.text = recordTimeInSecond;
}

- (void)dealloc {
    DLog(@"dealloc: %@", NSStringFromClass([self class]));
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
