//
//  YNCVideoHomepageView.m
//  MQX
//
//  Created by yc-sh-vr-pc05 on 2018/3/11.
//  Copyright © 2018年 YunEEC. All rights reserved.
//

#import "YNCVideoHomepageView.h"

#import "YNCFlightStatusView_Firebird.h"
#import "YNCAppConfig.h"

@interface YNCVideoHomepageView ()
{
    CGFloat _sizeMultiple;
}

@property (weak, nonatomic) IBOutlet UIButton *wifiNameButton;

@property (nonatomic, assign) int currentPitch;
@property (nonatomic, assign) int currentRoll;


- (IBAction)clickWifiNameButton:(UIButton *)sender;
@property (nonatomic, strong) dispatch_source_t dispatch_displayTimer;
@end

@implementation YNCVideoHomepageView

//MARK: -- lazyload videoTimeView
- (YNCVideoTimeView *)videoTimeView {
    if (!_videoTimeView) {
        _videoTimeView = [YNCVideoTimeView instanceVideoTimeView];
    }
    
    return _videoTimeView;
}

- (dispatch_source_t)dispatch_displayTimer
{
    if (!_dispatch_displayTimer) {
        dispatch_queue_t global = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        self.dispatch_displayTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, global);
        dispatch_source_set_timer(_dispatch_displayTimer, DISPATCH_TIME_NOW, 0.018 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
        WS(weakSelf);
        dispatch_source_set_event_handler(_dispatch_displayTimer, ^{
            [weakSelf animationPitch];
            [weakSelf animationRoll];
        });
    }
    return _dispatch_displayTimer;
}

- (void)animationPitch
{
    if (_currentPitch == _pitch) {
        return;
    }
    if (_currentPitch < _pitch) {
        _currentPitch = _currentPitch + 2;
        if (_currentPitch >= _pitch) {
            _currentPitch = _pitch;
        }
        WS(weakSelf);
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.flightStatusView_fireBird.statusView_pitch = _currentPitch;
        });
    } else {
        _currentPitch = _currentPitch - 2;
        if (_currentPitch <= _pitch) {
            _currentPitch = _pitch;
        }
        WS(weakSelf);
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.flightStatusView_fireBird.statusView_pitch = _currentPitch;
        });
    }
}

- (void)animationRoll
{
    if (_currentRoll == _roll) {
        return;
    }
    if (_currentRoll < _roll ) {
        _currentRoll = _currentRoll + 3;
        if (_currentRoll >= _roll || _roll - _currentRoll > 200) {
            _currentRoll = _roll;
        }
        WS(weakSelf);
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.flightStatusView_fireBird.statusView_roll = _currentRoll;
        });
    } else {
        _currentRoll = _currentRoll - 3;
        if (_currentRoll <= _roll || _currentRoll - _roll > 200) {
            _currentRoll = _roll;
        }
        WS(weakSelf);
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.flightStatusView_fireBird.statusView_roll = _currentRoll;
        });
    }
}

- (void)setPitch:(int)pitch
{
    _pitch = pitch;
}

- (void)setRoll:(int)roll
{
    _roll = -roll;
}


+ (YNCVideoHomepageView *)instanceVideoHomepageView {
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"YNCVideoHomepageView" owner:nil options:nil];
    return [nibView objectAtIndex:0];
}

//MARK: -- 初始化子视图
- (void)initSubView:(YNCModeDisplay)modeDisplay {
    _sizeMultiple = modeDisplay==YNCModeDisplayNormal ? 1.0:0.5;
    
    self.wifiNameButton.titleLabel.font = [UIFont systemFontOfSize:14*_sizeMultiple];
    
    [self.wifiNameButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(40*_sizeMultiple);
        make.right.equalTo(self).offset(-10*_sizeMultiple);
        make.size.mas_equalTo(CGSizeMake(160*_sizeMultiple, 30*_sizeMultiple));
    }];

    self.flightStatusView_fireBird = [YNCFlightStatusView_Firebird statusView_Firebird];
    self.flightStatusView_fireBird.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);

    [self layoutIfNeeded];
    
    [_flightStatusView_fireBird initSubViewsWithSizeMultiple:_sizeMultiple];
    self.flightStatusView_fireBird.backgroundColor = [UIColor clearColor];

    [self addSubview:self.videoTimeView];
    [self.videoTimeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(60*_sizeMultiple);
        make.top.equalTo(self).offset(125*_sizeMultiple);
        make.size.mas_equalTo(CGSizeMake(60*_sizeMultiple, 14*_sizeMultiple));
    }];
    [self.videoTimeView initSubView:modeDisplay];
    
#pragma mark TODO:测试使用
#ifdef YNCTEST
    [self addSliders];
#endif
    
    self.currentPitch = 0;
    self.currentRoll = 0;
    dispatch_resume(self.dispatch_displayTimer);
}

#ifdef YNCTEST
- (void)addSliders {
    WS(weakSelf);
    
    UISlider *speedSlider = [UISlider new];
    speedSlider.minimumValue = 0;
    speedSlider.maximumValue = 800;
    speedSlider.value = 0;
    speedSlider.tag = 101;
    [speedSlider addTarget:self action:@selector(dragSlider:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:speedSlider];
    [speedSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf);
        make.centerX.equalTo(weakSelf);
        make.size.mas_equalTo(CGSizeMake(273, 31));
    }];
    
    UISlider *altSlider = [UISlider new];
    altSlider.minimumValue = -60;
    altSlider.maximumValue = 90;
    altSlider.value = 0;
    altSlider.tag = 102;
    [altSlider addTarget:self action:@selector(dragSlider:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:altSlider];
    [altSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(speedSlider.mas_top);
        make.centerX.equalTo(weakSelf);
        make.size.mas_equalTo(CGSizeMake(273, 31));
    }];
}

- (void)dragSlider:(UISlider *)sender {
    if (sender.tag == 101) {
        //                [self.speedStaffSliderView updateStaffSliderView:round(sender.value)];
        [self.distanceView updateSubView:sender.value];
    } else {
        [self.altStaffSliderView updateStaffSliderView:round(sender.value)];
    }
    
}
#endif

- (void)hiddenSubView:(BOOL)isHidden withDoubleClickCount:(NSInteger)count {
    WS(weakSelf);
    
    CGFloat tmpAlpha = isHidden==YES?0:1.0;
    
    if (count == 1) {
        [UIView animateWithDuration:0.3 animations:^{
            weakSelf.wifiNameButton.alpha = tmpAlpha;
        }];
        [self.flightStatusView_fireBird hiddenSubView:isHidden withDoubleClickCount:count];
    } else if (count == 2) {
        [self.flightStatusView_fireBird hiddenSubView:isHidden withDoubleClickCount:count];
        
        
    } else if (count == 3) {
        [UIView animateWithDuration:0.3 animations:^{
            weakSelf.wifiNameButton.alpha = tmpAlpha;
        }];
        
        [self.flightStatusView_fireBird hiddenSubView:isHidden withDoubleClickCount:count];
    }
    
}

- (void)updateWifiName:(NSString *)wifName {
    if (wifName == nil) {
        [self.wifiNameButton setTitle:@"--" forState:UIControlStateNormal];
        self.wifiNameButton.enabled = NO;
        [self.wifiNameButton setTitleColor:[UIColor lightGrayishColor] forState:UIControlStateNormal];
    } else {
        [self.wifiNameButton setTitle:wifName forState:UIControlStateNormal];
        self.wifiNameButton.enabled = YES;
        [self.wifiNameButton setTitleColor:[UIColor yncFirebirdLightGreenColor] forState:UIControlStateNormal];
    }
}

- (void)dealloc {
    DLog(@"dealloc: %@", NSStringFromClass([self class]));
    if (_dispatch_displayTimer) {
        dispatch_source_cancel(_dispatch_displayTimer);
        _dispatch_displayTimer = nil;
        NSLog(@"dealloc display timer");
    }
}

- (IBAction)clickWifiNameButton:(UIButton *)sender {
    if (_wifiNameBlock) {
        _wifiNameBlock(YNCEventActionFirebirdHomepageWifiName);
    }
}

//MARK: -- 设置是否显示录像时间
- (void)setIsShowVideoTimeView:(BOOL)isShowVideoTimeView {
    _isShowVideoTimeView = isShowVideoTimeView;
    self.videoTimeView.showTimeLabel = isShowVideoTimeView;
    
    if (_isShowVideoTimeView) {
        [UIView animateWithDuration:.3 animations:^{
            [self.videoTimeView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self).offset(-3*_sizeMultiple);
            }];
        }];
    } else {
        self.videoTimeView.recordTimeInSecond = @"00:00:00";
        
        [UIView animateWithDuration:.3 animations:^{
            [self.videoTimeView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self).offset(60*_sizeMultiple);
            }];
        }];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
