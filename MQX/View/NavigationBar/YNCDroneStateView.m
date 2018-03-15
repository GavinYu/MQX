//
//  YNCDroneStateView.m
//  YuneecApp
//
//  Created by yc-sh-vr-pc05 on 2017/3/31.
//  Copyright © 2017年 yuneec. All rights reserved.
//

#import "YNCDroneStateView.h"

#import "YNCAppConfig.h"

@interface YNCDroneStateView ()
{
    CGFloat _sizeMultiple;
    
    int _thirdCount;
    int _secondCount;
    int _firstCount;
    int _result;//电量格数
}

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *remoteControlButton;
@property (weak, nonatomic) IBOutlet UIButton *hdSignalButton;
@property (weak, nonatomic) IBOutlet UIImageView *voltageImageView;
//飞机电池当前电压值
@property (assign, nonatomic) int powerValue;
//飞机电池当前电压值
@property (assign, nonatomic) BOOL isFirstReadPowerValue;

@end

@implementation YNCDroneStateView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (void)awakeFromNib{
    [super awakeFromNib];
    
    [[NSBundle mainBundle] loadNibNamed:@"YNCDroneStateView" owner:self options:nil];
    [self addSubview:self.contentView];
}

- (void)initSubView:(YNCModeDisplay)display {
    _secondCount = 0;
    _thirdCount = 0;
    _firstCount = 0;
    _result = 0;
    _isFirstReadPowerValue = YES;
    
    _sizeMultiple = display == YNCModeDisplayGlass?0.5:1.0;

    [self.voltageImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.top.equalTo(self).offset(11*_sizeMultiple);
        make.size.mas_equalTo(CGSizeMake(30*_sizeMultiple, 14*_sizeMultiple));
    }];
    
    [self.remoteControlButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.voltageImageView.mas_left).offset(-10*_sizeMultiple);
        make.centerY.equalTo(self.voltageImageView);
        make.size.mas_equalTo(CGSizeMake(17*_sizeMultiple, 13*_sizeMultiple));
    }];
    
    [_hdSignalButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_remoteControlButton.mas_left).offset(-10*_sizeMultiple);
        make.centerY.equalTo(_remoteControlButton);
        make.size.mas_equalTo(CGSizeMake(18*_sizeMultiple, 12*_sizeMultiple));
    }];
}

- (void)dealloc {
    DLog(@"dealloc: %@", NSStringFromClass([self class]));
}
//MARK: -- 获取 HD Racer 电压值级别
- (int)getVoltageLevel:(int)voltage {
    if (voltage >= 40) {
        _result = 4;
    } else if (voltage >= 37 && voltage < 40) {
        if (_isFirstReadPowerValue) {
            _isFirstReadPowerValue = NO;
            _result = 3;
        } else {
            ++_thirdCount;
            if (_thirdCount == 5) {
                _result = 3;
            }
        }
    } else if (voltage >= 34 && voltage < 37) {
        if (_isFirstReadPowerValue) {
            _isFirstReadPowerValue = NO;
            _result = 2;
        } else {
            if (_thirdCount > 5) {
                ++_secondCount;
                if (_secondCount == 5) {
                    _result = 2;
                    _thirdCount = 0;
                }
            }
        }
    } else {
        if (_isFirstReadPowerValue) {
            _isFirstReadPowerValue = NO;
            _result = 2;
        } else {
            if (_secondCount > 5) {
                ++_firstCount;
                if (_firstCount == 5) {
                    _result = 2;
                    _firstCount = 0;
                    _secondCount = 0;
                }
            }
        }
    }
    
    return _result;
}

//MARK: -- 根据HD Racer 的 Telemetry 更新界面
#warning TODO: ---------
- (void)updateShowWithHDRacerTelemetry {
    int errorFlag = 0;
    [_remoteControlButton setImage:[UIImage imageNamed:1?@"icon_remoteControl_disconnected":@"icon_remoteControl_connected"] forState:UIControlStateNormal];
    
    if ([YNCABECamManager sharedABECamManager].WiFiConnected) {
        if (_powerValue != 0) {
            _voltageImageView.hidden = NO;
            
            int k = [self getVoltageLevel:40];
            [_voltageImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"icon_voltage%d",k]]];
            _powerValue = 1;
        }
        
        if (errorFlag == 1) {
            [_voltageImageView setImage:[UIImage imageNamed:@"icon_voltage1"]];
        } else if (errorFlag == 3) {
            [_voltageImageView setImage:[UIImage imageNamed:@"icon_voltage0"]];
        }
    }
}
//MARK: -- setter WiFiConnected
- (void)setWiFiConnected:(BOOL)WiFiConnected {
    if (!WiFiConnected) {
        _powerValue = 0;
        [_voltageImageView setImage:[UIImage imageNamed:@"icon_voltage0_disconnectd"]];
        [_remoteControlButton setImage:[UIImage imageNamed:@"icon_remoteControl_disconnected"] forState:UIControlStateNormal];
        [_hdSignalButton setImage:[UIImage imageNamed:@"icon_wifi0"] forState:UIControlStateNormal];
    } else {
        [_voltageImageView setImage:[UIImage imageNamed:@"icon_voltage4"]];
        [_hdSignalButton setImage:[UIImage imageNamed:@"icon_wifi4"] forState:UIControlStateNormal];
    }
}

@end
