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

@property (nonatomic, assign) int currentPitch;
@property (nonatomic, assign) int currentRoll;

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
    
    self.flightStatusView_fireBird = [YNCFlightStatusView_Firebird statusView_Firebird];
    [self addSubview:self.flightStatusView_fireBird];
    [self.flightStatusView_fireBird mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self);
        make.size.mas_equalTo(self.bounds.size);
    }];

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
    self.videoTimeView.hidden = YES;
    
    self.currentPitch = 0;
    self.currentRoll = 0;
    dispatch_resume(self.dispatch_displayTimer);
}
//MARK: -- 双击隐藏 视图
- (void)hiddenSubView:(BOOL)isHidden withDoubleClickCount:(NSInteger)count {
    WS(weakSelf);
    
    CGFloat tmpAlpha = isHidden==YES?0:1.0;
    
    if (count == 1) {
        [self.flightStatusView_fireBird hiddenSubView:isHidden withDoubleClickCount:count];
    } else if (count == 2) {
        [self.flightStatusView_fireBird hiddenSubView:isHidden withDoubleClickCount:count];
    } else if (count == 3) {
        [self.flightStatusView_fireBird hiddenSubView:isHidden withDoubleClickCount:count];
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

//MARK: -- 设置是否显示录像时间
- (void)setIsShowVideoTimeView:(BOOL)isShowVideoTimeView {
    self.videoTimeView.hidden = !isShowVideoTimeView;
    
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
