//
//  YNCABECamManager.h
//  MQX
//
//  Created by yc-sh-vr-pc05 on 2018/3/3.
//  Copyright © 2018年 YunEEC. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YNCSingleton.h"
#import "YNCBlock.h"

@class YNCDeviceInfoModel;
@class YNCSDCardInfoModel;

@interface YNCABECamManager : NSObject

YNCSingletonH(ABECamManager)
/*
 * The connection status of the component.
 */
@property (nonatomic, readonly) BOOL  WiFiConnected;
//SD卡总容量
@property (nonatomic, readonly) NSString *totalStorage;
//SD卡可用容量
@property (nonatomic, copy) NSString *freeStorage;
//设备信息
@property (nonatomic, readonly) YNCDeviceInfoModel *deviceInfo;

//监测WiFi连接的状态
- (void)checkWiFiState;
//释放监测WiFi连接的状态的定时器
- (void)freeCheckWiFiTimer;
//获取SD卡信息
- (void)getSDCardInfo:(void(^)(YNCSDCardInfoModel *SDCardInfo))block;
@end
