//
//  YNCDroneStateView.h
//  YuneecApp
//
//  Created by yc-sh-vr-pc05 on 2017/3/31.
//  Copyright © 2017年 yuneec. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YNCEnum.h"

@interface YNCDroneStateView : UIView

//低电压报警
@property (assign, nonatomic) BOOL isLowPower;

//HD Racer WiFi 的连接状态
@property (assign, nonatomic) BOOL HDRacerWiFiConnected;

- (void)initSubView:(YNCModeDisplay)display;
- (void)updateHDSignal:(int)signal;
- (void)updateShowWithHDRacerTelemetry;

@end
