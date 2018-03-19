//
//  YNCFlightStatusView_Firebird.m
//  Demo_hireBird
//
//  Created by vrsh on 20/04/2017.
//  Copyright © 2017 yuneec. All rights reserved.
//

#import "YNCFlightStatusView_Firebird.h"

#import "YNCStatusView_Firebird.h"
#import "YNCAppConfig.h"

#define kStatusView_fireBirdWidth 250.0
#define kStatusView_fireBirdHeight 220.0
#define kStatusView_HiddenHeight 280.0
#define kAnimationTime 0.05

#define kPitchRulerScrollerViewWidth 250.0
#define kPitchRulerScrollerViewHeight 200.0
#define kPitchRulerScrollerViewHiddenHeight 270.0

@interface YNCFlightStatusView_Firebird ()

@property (nonatomic, strong) YNCStatusView_Firebird *statusView_fireBird;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, strong) UIImageView *centerImageView;
@property (nonatomic, assign) CGFloat sizeMutiple;

@end

@implementation YNCFlightStatusView_Firebird

// 刻度旋转(正负180)
- (void)setStatusView_roll:(int)statusView_roll
{
    _statusView_roll = statusView_roll;

    _statusView_fireBird.transform = CGAffineTransformMakeRotation(statusView_roll / 180.0 * M_PI);

}

// 绘制刻度值(正负90)
//static int pitchValue = 0;
- (void)setStatusView_pitch:(int)statusView_pitch
{
    _statusView_pitch = statusView_pitch;
    _statusView_fireBird.value = statusView_pitch;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
}

+ (instancetype)statusView_Firebird
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}


- (void)initSubViewsWithSizeMultiple:(CGFloat)sizeMutiple
{
    self.sizeMutiple = sizeMutiple;
    self.width = self.frame.size.width;
    self.height = self.frame.size.height;

    self.statusView_fireBird = [[YNCStatusView_Firebird alloc] init];
    _statusView_fireBird.backgroundColor = [UIColor clearColor];
    [self addSubview:_statusView_fireBird];

    _statusView_fireBird.centerMode = YES;
    [_statusView_fireBird mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset((_width - kStatusView_fireBirdWidth*_sizeMutiple) / 2.0 );
        make.top.equalTo(self).offset((_height - kStatusView_HiddenHeight* _sizeMutiple) / 2.0 );
        make.width.equalTo(@(kStatusView_fireBirdWidth * _sizeMutiple));
        make.height.equalTo(@(kStatusView_HiddenHeight * _sizeMutiple));
    }];

    [_statusView_fireBird layoutIfNeeded];
    _statusView_fireBird.sizeMutiple = sizeMutiple;
    [_statusView_fireBird createUI];
    [_statusView_fireBird setClearsContextBeforeDrawing:NO];
    _statusView_fireBird.value = 0;

    self.centerImageView = [[UIImageView alloc] init];
    _centerImageView.image = [UIImage imageNamed:@"icon_center"];
    [self addSubview:_centerImageView];
    [_centerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_statusView_fireBird);
        make.width.equalTo(@(15*sizeMutiple));
        make.height.equalTo(@(15*sizeMutiple));
    }];
}

- (void)hiddenSubView:(BOOL)isHidden withDoubleClickCount:(NSInteger)count {
    CGFloat tmpAlpha = isHidden==YES?0:1.0;
    
    if (count == 1) {

        [UIView animateWithDuration:0.3 animations:^{
            self.statusView_fireBird.alpha = tmpAlpha;
            self.centerImageView.alpha = tmpAlpha;
        }];
    } else if (count == 2) {

    } else if (count == 3) {
        [UIView animateWithDuration:0.3 animations:^{
            self.statusView_fireBird.alpha = tmpAlpha;
            self.centerImageView.alpha = tmpAlpha;
        }];
    }
}

- (void)hiddenPlateView
{
    [_statusView_fireBird mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset((_width - kStatusView_fireBirdWidth) / 2.0 * _sizeMutiple);
        make.top.equalTo(self.mas_bottom).offset(-kStatusView_HiddenHeight / 2.0 * _sizeMutiple);
        make.width.equalTo(@(kStatusView_fireBirdWidth * _sizeMutiple));
        make.height.equalTo(@(kStatusView_HiddenHeight * _sizeMutiple));
    }];

    _statusView_fireBird.alpha = 0.0;
    _centerImageView.alpha = 0.0;
    [UIView animateWithDuration:0.05 animations:^{

    } completion:^(BOOL finished) {
        if (finished) {
            [_statusView_fireBird layoutIfNeeded];
            _statusView_fireBird.centerMode = YES;
            _statusView_fireBird.alpha = 1.0;
            _centerImageView.alpha = 1.0;
        }
    }];

}

- (void)showPlateView
{
    [_statusView_fireBird mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset((_width - kStatusView_fireBirdWidth) / 2.0 *_sizeMutiple);
        make.top.equalTo(self.mas_bottom).offset(-kStatusView_fireBirdHeight / 2.0*_sizeMutiple);
        make.width.equalTo(@(kStatusView_fireBirdWidth*_sizeMutiple));
        make.height.equalTo(@(kStatusView_fireBirdHeight*_sizeMutiple));
    }];

    _statusView_fireBird.alpha = 0.0;
    _centerImageView.alpha = 0.0;
    [UIView animateWithDuration:0.05 animations:^{
    } completion:^(BOOL finished) {
        if (finished) {
            [_statusView_fireBird layoutIfNeeded];
            _statusView_fireBird.centerMode = NO;
            _statusView_fireBird.alpha = 1.0;
            _centerImageView.alpha = 1.0;
        }
    }];

}

- (void)dealloc
{
    NSLog(@"flightStatusViewDealloc");
}

@end
