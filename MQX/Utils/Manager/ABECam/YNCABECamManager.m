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
#import "YNCDeviceInfoModel.h"
#import "YNCSDCardInfoModel.h"

#import <NSObject+YYModel.h>

@interface YNCABECamManager () <AbeCamHandleDelegate>
{
    dispatch_source_t _checkWiFiTimer;
}
/*
 * The connection status of the component.
 */
@property (nonatomic, assign, readwrite) BOOL  WiFiConnected;
//SD卡总容量
@property (nonatomic, copy) NSString *totalStorage;
//SD卡可用容量
@property (nonatomic, copy) NSString *freeStorage;
@property (nonatomic, assign) BOOL currentWiFiConnected;
//设备信息
@property (nonatomic, strong) YNCDeviceInfoModel *deviceInfo;

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
        if (weakSelf.currentWiFiConnected != tmpValue) {
            [AbeCamHandle sharedInstance].delegate = self;//最先设置好 first set delegate
            [[AbeCamHandle sharedInstance] connectedTalkSession];
            if ([[AbeCamHandle sharedInstance]checkTalkSeesion]) {
                [[AbeCamHandle sharedInstance] getDeviceParameterResult:^(BOOL succeeded, NSData *data) {
                    if (succeeded) {
                        YNCDeviceInfoModel *tmpModel = [YNCDeviceInfoModel new];
                        tmpModel = [YNCDeviceInfoModel modelWithJSON:data];
                        if (tmpModel.ssid.length > 0) {
                            weakSelf.deviceInfo = tmpModel;
                            weakSelf.WiFiConnected = tmpValue;
                            weakSelf.currentWiFiConnected = tmpValue;
                        }
                    }
                }];
            }
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

//MARK: -- 获取SD卡信息
- (void)getSDCardInfo:(void(^)(YNCSDCardInfoModel *SDCardInfo))block {
    WS(weakSelf);
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[AbeCamHandle sharedInstance] getSDSpaceResult:^(BOOL succeeded, NSData *data) {
            if (succeeded) {
                YNCSDCardInfoModel *tmpModel = [YNCSDCardInfoModel new];
                tmpModel = [YNCSDCardInfoModel modelWithJSON:data];
                weakSelf.totalStorage = [NSString stringWithFormat:@"%liG", (long)tmpModel.totalspace];
                CGFloat tmpFree = tmpModel.totalspace * (tmpModel.sdspace + [tmpModel.sdspace_decimals floatValue]) / 100.0;
                weakSelf.freeStorage = [NSString stringWithFormat:@"%.1fG", tmpFree];
                block(tmpModel);
            }
        }];
    });
    
}

//MARK: -- AbeCamHandleDelegate methods
//MARK: -- 检查WiFi错误
-(void)checkWifiError {
//    DLog(@"[%s  %d], thread: %@", __func__, __LINE__, [NSThread currentThread]);
}

-(void)liveStreamDidConnected {
//    DLog(@"[%d %s], %@ ", __LINE__, __func__, [NSThread currentThread]);
}

-(void)liveStreamDidDisconnected {
//    DLog(@"[%d %s], %@ ", __LINE__, __func__, [NSThread currentThread]);
    
}

//-(void)liveStreamConnectedFailed;
-(void)liveStreamDidRcvFrm {
    //        DLog(@"[%d %s], %@ ", __LINE__, __func__, [NSThread currentThread]);
}

-(void)liveStreamRcvErrData {
//    DLog(@"[%s  %d], thread: %@", __func__, __LINE__, [NSThread currentThread]);
}

-(void)talkSessonDidConnected {
//    DLog(@"[%d %s], %@ ", __LINE__, __func__, [NSThread currentThread]);
    
    [[AbeCamHandle sharedInstance] syncTime:[NSDate date] result:^(BOOL succeeded) {
        if (succeeded) {
            DLog(@"sync time success");
            
        }else{
            DLog(@"sync time failed");
        }
    }];
}

-(void)talkSessonDidDisconnected {
    //    DLog(@"[%d %s], %@ ", __LINE__, __func__, [NSThread currentThread]);
}

-(void)recordStart {
    //    DLog(@"[%d %s], %@ ", __LINE__, __func__, [NSThread currentThread]);
}

-(void)recordWriteFrame {
    //    DLog(@"[%d %s], %@ ", __LINE__, __func__, [NSThread currentThread]);
    
}

-(void)recordStop {
//    DLog(@"[%d %s], %@ ", __LINE__, __func__, [NSThread currentThread]);
}
//MARK: -- 当前视频转换为图像格式 current video to uiimage
-(void)getCurrentVideoToImg:(UIImage *)img
{
//    DLog(@"[%s  %d], thread: %@", __func__, __LINE__, [NSThread currentThread]);
    //    imgView.image = img;
}

@end
