//
//  YNCNavigationBar.m
//  YuneecApp
//
//  Created by yc-sh-vr-pc05 on 2017/3/20.
//  Copyright © 2017年 yuneec. All rights reserved.
//

#import "YNCNavigationBar.h"

#import "YNCWarningConstMacro.h"
#import "YNCScrollLabelView.h"
#import "YNCDroneStateView.h"
#import "YNCAppConfig.h"

@interface YNCNavigationBar ()
{
    NSString *_stateTextLocalizedKey;
    UIColor *_stateTextColor;
    CGFloat _sizeMultiple;
}

@property (weak, nonatomic) IBOutlet UIButton *homeButton;
@property (weak, nonatomic) IBOutlet UILabel *currentModeLabel;
@property (weak, nonatomic) IBOutlet YNCScrollLabelView *stateView;
@property (strong, nonatomic) IBOutlet YNCDroneStateView *droneStateView;
@property (strong, nonatomic) NSMutableArray *stateMessageArray;
@property (strong, nonatomic) NSMutableArray *warningCodeArray;

//new add
//飞行模式
@property (assign, nonatomic) int flightMode;
//遥控器与相机之间的信号
@property (assign, nonatomic) int remoteControlAndCameraSignal;

@end

@implementation YNCNavigationBar

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
+ (YNCNavigationBar *)instanceNavigationBar {
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"YNCNavigationBar" owner:nil options:nil];
    return [nibView objectAtIndex:0];
}

//MARK: -- 标尺头尾添加虚影效果 frosted glass
-(void)addFrostedGlass:(UIView *)imageView {
    CAGradientLayer *maskLayer = [CAGradientLayer layer];
    maskLayer.frame = imageView.bounds;
    //    maskLayer.frame = CGRectMake(imageView.bounds.origin.x, imageView.bounds.origin.y, imageView.bounds.size.width, imageView.bounds.size.height+self.attributeLabel.bounds.size.height);
    maskLayer.colors = @[(id)[[UIColor blackColor] CGColor],
                         (id)[[UIColor clearColor] CGColor]];
    maskLayer.locations = @[@0.1, @1.0];
    maskLayer.startPoint = CGPointMake(0.0, 0.0);
    maskLayer.endPoint = CGPointMake(0.0, 1.0);
    imageView.layer.mask = maskLayer;
}
//MARK: -- initData
- (void)initData {
    self.flightMode = -1;
}
//MARK: -- initSubView
- (void)initSubView:(YNCModeDisplay)display {
    _sizeMultiple = display == YNCModeDisplayGlass?0.5:1.0;
    
    [self initData];
    
    self.currentModeLabel.font = [UIFont systemFontOfSize:14*_sizeMultiple];
    
    self.backgroundColor = [UIColor clearColor];
    self.stateView.backgroundColor = [UIColor clearColor];
    self.stateView.textAlignment = NSTextAlignmentLeft;
    self.stateView.currentDisplayMode = display;
    self.stateView.textFont = [UIFont systemFontOfSize:18.0*_sizeMultiple];
    self.stateView.textColor = [UIColor middleGrayColor];
    self.stateView.text = NSLocalizedString(@"homepage_device_not_conneted",nil);
    [self.stateView addObaserverNotification];
    
    self.droneStateView.backgroundColor = [UIColor clearColor];
    
    UIImage *homeBtnImage = [UIImage imageNamed:@"btn_firebird_home"];
    [self.homeButton setImage:homeBtnImage forState:UIControlStateNormal];

    
    [self.homeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10*_sizeMultiple);
        make.top.equalTo(self).offset(3*_sizeMultiple);
        make.size.mas_equalTo(CGSizeMake(30*_sizeMultiple, 30*_sizeMultiple));
    }];
    
    [self.stateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.homeButton.mas_right).offset(3*_sizeMultiple);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(210*_sizeMultiple, 30*_sizeMultiple));
    }];

    [self.currentModeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(8*_sizeMultiple);
        make.size.mas_equalTo(CGSizeMake(127*_sizeMultiple, 21*_sizeMultiple));
    }];
    
    [self.droneStateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-20*_sizeMultiple);
        make.top.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(200*_sizeMultiple, 36*_sizeMultiple));
    }];
    
    [self.droneStateView initSubView:display];
}

- (IBAction)clickHomeButton:(UIButton *)sender {
    if (_navigationBarButtonEventBlock) {
        _navigationBarButtonEventBlock(YNCEventActionNavBarHomeBtn);
    }
}

//MARK: -- 更新遥控器与相机之间的信号强弱
- (void)updateRemoteControlSignal:(int)signal {
    if (signal != self.remoteControlAndCameraSignal) {
        [self.droneStateView updateHDSignal:signal];
        self.remoteControlAndCameraSignal = signal;
    }
    
    if (signal == 0) {
        self.remoteControlAndCameraSignal = 0;
    }
}

//MARK: -- stateView methods
//MARK: -- lazyload stateMessageArray
- (NSMutableArray *)stateMessageArray {
    if (!_stateMessageArray) {
        _stateMessageArray = [NSMutableArray new];
    }
    
    return _stateMessageArray;
}

//MARK: -- lazyload warningCodeArray
- (NSMutableArray *)warningCodeArray {
    if (!_warningCodeArray) {
        _warningCodeArray = [NSMutableArray new];
    }
    return _warningCodeArray;
}

//MARK: 更新导航栏的状态栏的信息显示
- (void)updateStateView:(id)warningData {
    int warning = [warningData[@"msgid"] intValue];
    BOOL isHidden = [warningData[@"isHidden"] boolValue];
    
    if (!isHidden) {
        switch (warning) {
            case YNCWARNING_DEVICE_CONNECTED:
            {
                _stateTextColor = [UIColor middleGrayColor];
                _stateTextLocalizedKey = @"homepage_remote_controller_connected";
            }
                break;
                
            case YNCWARNING_DEVICE_DISCONNECTED:
            {
                _stateTextColor = [UIColor middleGrayColor];
                _stateTextLocalizedKey = @"homepage_device_not_conneted";
            }
                break;
                
            case YNCWARNING_DRONE_DISCONNECTED:
            {
                _stateTextColor = [UIColor lightRedColor];
                _stateTextLocalizedKey = @"flight_interface_warning_LOST_DRONE";
            }
                break;
                
            case YNCWARNING_DRONE_CONNECTED:
            {
                _stateTextColor = [UIColor yncGreenColor];

                _stateTextLocalizedKey = @"flight_interface_warning_CONNECTION_STABLE";
            }
                break;
                
            case YNCWARNING_DRONE_WIFI_WEAK:
            {
                _stateTextColor = [UIColor middleGrayColor];
                _stateTextLocalizedKey = @"";
            }
                break;
                
            case YNCWARNING_DRONE_WIFI_DISCONNECTED:
            {
                _stateTextColor = [UIColor lightRedColor];
                _stateTextLocalizedKey = @"flight_interface_warning_WIFI_LOST";
            }
                break;
                
            case YNCWARNING_ZIGBEE_DISCONNECTED:
            {
                _stateTextColor = [UIColor lightRedColor];
                _stateTextLocalizedKey = @"flight_interface_warning_ZIGBEE_LOST";
            }
                break;
                
            case YNCWARNING_VOLTAGE_1:
            {
                _stateTextColor = [UIColor lightRedColor];
                _stateTextLocalizedKey = @"flight_interface_warning_LOW_POWER_STAGE1";
                
            }
                break;
                
            case YNCWARNING_VOLTAGE_2:
            {
                _stateTextColor = [UIColor lightRedColor];
                _stateTextLocalizedKey = @"flight_interface_warning_LOW_POWER_STAGE2";
                
            }
                break;
                
            case YNCWARNING_MOTOR_FAILSAFE:
            {
                _stateTextColor = [UIColor lightRedColor];
                _stateTextLocalizedKey = @"flight_interface_warning_MOTOR_FAILSAFE";
            }
                break;
                
            case YNCWARNING_MOTOR_ESC:
            {
                _stateTextColor = [UIColor lightRedColor];
                _stateTextLocalizedKey = @"flight_interface_warning_MOTOR_ESC";
            }
                break;
                
            case YNCWARNING_HIGH_TEMPERATURE:
            {
                _stateTextColor = [UIColor lightRedColor];
                _stateTextLocalizedKey = @"flight_interface_warning_HIGH_TEMPERATURE";
            }
                break;
                
            case YNCWARNING_COMPASS_CALIBRATION:
            {
                _stateTextColor = [UIColor lightRedColor];
                _stateTextLocalizedKey = @"flight_interface_warning_COMPASS_CALIBRATION";
            }
                break;
                
            case YNCWARNING_FLYAWAY:
            {
                _stateTextColor = [UIColor lightRedColor];
                _stateTextLocalizedKey = @"flight_interface_warning_FLYAWAY";
            }
                break;
                
            case YNCWARNING_NO_FLY_ZONE:
            {
                _stateTextColor = [UIColor lightRedColor];
                _stateTextLocalizedKey = @"flight_interface_warning_NO_FLY_ZONE";
            }
                break;
                
            case YNCWARNING_ACC_ERROR:
            {
                _stateTextColor = [UIColor lightRedColor];
                _stateTextLocalizedKey = @"";
            }
                break;
                
            case YNCWARNING_MEGNETIC_ERROR:
            {
                _stateTextColor = [UIColor lightRedColor];
                _stateTextLocalizedKey = @"";
            }
                break;
                
            case YNCWARNING_GYROSCOPE_ERROR:
            {
                _stateTextColor = [UIColor lightRedColor];
                _stateTextLocalizedKey = @"";
            }
                break;
                
            case YNCWARNING_GPS_LOST_FIRSTCLASS:
            {
                _stateTextColor = [UIColor lightRedColor];
                _stateTextLocalizedKey = @"";
            }
                break;
                
            case YNCWARNING_GPS_ERROR_FIRSTCLASS:
            {
                _stateTextColor = [UIColor lightRedColor];
                _stateTextLocalizedKey = @"";
            }
                break;
                
            case YNCWARNING_FIXING_LOW_POWER_STAGE1:
            {
                _stateTextColor = [UIColor lightRedColor];
                _stateTextLocalizedKey = @"flight_warning_low_voltage";
                self.isLowPower = !isHidden;
            }
                break;
                
            case YNCWARNING_FIXING_LOW_POWER_STAGE2: 
            {
                _stateTextColor = [UIColor lightRedColor];
                _stateTextLocalizedKey = @"flight_warning_Force_Landing";
            }
                break;
                
            case YNCWARNING_FLIGHTCONTROL_GYRO_ERROR:
            {
                _stateTextColor = [UIColor lightRedColor];
                _stateTextLocalizedKey = @"flight_interface_warning_GYRO_ERROR";
            }
                break;
                
            case YNCWARNING_FLIGHTCONTROL_BAROMETER_ERROR:
            {
                _stateTextColor = [UIColor lightRedColor];
                _stateTextLocalizedKey = @"flight_interface_warning_FIXING_LOW_POWER_STAGE2";
            }
                break;
                
            case YNCWARNING_FLIGHTCONTROL_GEOMAGNETISM_ERROR:
            {
                _stateTextColor = [UIColor lightRedColor];
                _stateTextLocalizedKey = @"flight_interface_warning_FIXING_LOW_POWER_STAGE2";
                self.isLowPower = !isHidden;
            }
                break;
                
            case YNCWARNING_FLIGHTCONTROL_GPS_ERROR:
            {
                _stateTextColor = [UIColor lightRedColor];
                _stateTextLocalizedKey = @"flight_interface_warning_GPS_ERROR";
            }
                break;
                
            case YNCWARNING_FLIGHTCONTROL_EEPROM_ERROR:
            {
                _stateTextColor = [UIColor lightRedColor];
                _stateTextLocalizedKey = @"flight_interface_warning_EEPROM_ERROR";
            }
                break;
                
                
            default:
                break;
        }
        
        [self.warningCodeArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj intValue] == warning) {
                [self.warningCodeArray removeObjectAtIndex:idx];
                *stop = YES;
            }
        }];
        
        [self.stateMessageArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSArray *keyArr = [obj allKeys];
            NSString *keyStr = [keyArr firstObject];
            int tmpWarning = [keyStr intValue];
            if (tmpWarning == warning) {
                [self.stateMessageArray removeObjectAtIndex:idx];
                *stop = YES;
            }
        }];
        
        [self.warningCodeArray addObject:[NSNumber numberWithInt:warning]];
        [self.stateMessageArray insertObject:@{[NSString stringWithFormat:@"%d", warning]:_stateTextLocalizedKey} atIndex:0];
        
    } else {
        [self.warningCodeArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj intValue] == warning) {
                [self.warningCodeArray removeObjectAtIndex:idx];
                *stop = YES;
            }
        }];
        
        [self.stateMessageArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([[[obj allKeys] firstObject] integerValue] == warning) {
                [self.stateMessageArray removeObjectAtIndex:idx];
                *stop = YES;
            }
        }];
        
        _stateTextLocalizedKey = [[[self.stateMessageArray firstObject] allValues] firstObject];
    }
    
    if (_stateTextLocalizedKey) {
        self.stateView.textColor = _stateTextColor;
        self.stateView.text = NSLocalizedString(_stateTextLocalizedKey, nil);
    }
}

//MARK: -- 根据单双屏隐藏子视图
- (void)hiddenNavigationBarSubView:(BOOL)hidden withModeDisplay:(YNCModeDisplay)display {
    if (display == YNCModeDisplayGlass) {
        self.homeButton.hidden = hidden;
    } else {
        self.currentModeLabel.hidden = hidden;
        self.stateView.hidden = hidden;
        self.droneStateView.hidden = hidden;
    }
}

- (void)setIsLowPower:(BOOL)isLowPower {
    if (_isLowPower != isLowPower) {
        self.droneStateView.isLowPower = isLowPower;
    }
    
    _isLowPower = isLowPower;
}

- (void)dealloc {
    DLog(@"dealloc: %@", NSStringFromClass([self class]));
}
//MARK: -- 根据HD Racer 的 Telemetry 更新界面
- (void)updateShowWithHDRacerTelemetry {
    if (1) {
        self.currentModeLabel.text = [YNCUtil getHDRacerFlightMode:3] ;
        self.flightMode = 3;
        self.currentModeLabel.textColor =  1?[UIColor yncFirebirdLightGreenColor]:[UIColor lightGrayishColor];
    }
    
    [self.droneStateView updateShowWithHDRacerTelemetry];
}

- (void)setHDRacerWiFiConnected:(BOOL)HDRacerWiFiConnected {
    if (_HDRacerWiFiConnected != HDRacerWiFiConnected) {
        self.droneStateView.HDRacerWiFiConnected = HDRacerWiFiConnected;
    }
    
    if (!HDRacerWiFiConnected) {
        self.currentModeLabel.text = @"--" ;
        self.currentModeLabel.textColor = [UIColor lightGrayishColor];
    } else {
        self.currentModeLabel.text = @"Disarmed" ;
        self.currentModeLabel.textColor = [UIColor yncFirebirdLightGreenColor];
    }
    
    _HDRacerWiFiConnected = HDRacerWiFiConnected;
}

@end
