//
//  YNCNavigationBar.h
//  YuneecApp
//
//  Created by yc-sh-vr-pc05 on 2017/3/20.
//  Copyright © 2017年 yuneec. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YNCBlock.h"


@interface YNCNavigationBar : UIView

@property (copy, nonatomic) YNCEventBlock navigationBarButtonEventBlock;
//低电压报警
@property (assign, nonatomic) BOOL isLowPower;

//HD Racer WiFi 的连接状态
@property (assign, nonatomic) BOOL HDRacerWiFiConnected;

+ (YNCNavigationBar *)instanceNavigationBar;

- (IBAction)clickHomeButton:(UIButton *)sender;

- (void)initSubView:(YNCModeDisplay)display;
- (void)updateRemoteControlSignal:(int)signal;
- (void)hiddenNavigationBarSubView:(BOOL)hidden withModeDisplay:(YNCModeDisplay)display;
//MARK: 更新导航栏的状态栏的信息显示
- (void)updateStateView:(id)warningData;

- (void)updateShowWithHDRacerTelemetry;

@end
