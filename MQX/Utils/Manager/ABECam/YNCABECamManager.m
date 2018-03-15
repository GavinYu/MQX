//
//  YNCABECamManager.m
//  MQX
//
//  Created by yc-sh-vr-pc05 on 2018/3/3.
//  Copyright © 2018年 YunEEC. All rights reserved.
//

#import "YNCABECamManager.h"

#import <ABECam/ABECam.h>
#import "YNCMacros.h"
#import "YNCDeviceInfoDataModel.h"
#import <NSObject+YYModel.h>

#define kPeriod 1.0

@interface YNCABECamManager ()
{
    dispatch_source_t _checkWiFiTimer;
    BOOL _currentWiFiConnected;
}
/*
 * The connection status of the component.
 */
@property (nonatomic, assign, readwrite) BOOL  WiFiConnected;

@end

@implementation YNCABECamManager

YNCSingletonM(ABECamManager)

//MARK: -- setter
- (void)setWiFiConnected:(BOOL)WiFiConnected {
    if (_WiFiConnected != WiFiConnected) {
        _WiFiConnected = WiFiConnected;
    }
}

//MARK: -- 监测WiFi连接的状态
- (void)checkWiFiState {
    WS(weakSelf);

    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), kPeriod * NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        //在这里执行事件
        BOOL tmpValue = [[AbeCamHandle sharedInstance] checkWIFI];
        if (_currentWiFiConnected != tmpValue) {
            weakSelf.WiFiConnected = tmpValue;
            _currentWiFiConnected = tmpValue;
        }
    });
    
    dispatch_resume(_timer);
    
    _checkWiFiTimer = _timer;
}
//MARK: -- 释放监测WiFi连接的状态的定时器
- (void)freeCheckWiFiTimer {
    if (_checkWiFiTimer) {
        dispatch_source_cancel(_checkWiFiTimer);
        _checkWiFiTimer = nil;
    }
}

//MARK: -- 获取飞机设备信息
- (void)getDeviceInfo:(void(^)(YNCDeviceInfoDataModel *deviceInfo))block {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[AbeCamHandle sharedInstance] getDeviceParameterResult:^(BOOL succeeded, NSData *data) {
            if (succeeded) {
                YNCDeviceInfoDataModel *tmpModel = [YNCDeviceInfoDataModel new];
                tmpModel = [YNCDeviceInfoDataModel modelWithJSON:data];
                block(tmpModel);
            }
        }];
    });
}


@end
