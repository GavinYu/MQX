//
//  YNCABECamManager.h
//  MQX
//
//  Created by yc-sh-vr-pc05 on 2018/3/3.
//  Copyright © 2018年 YunEEC. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YNCSingleton.h"

@interface YNCABECamManager : NSObject

YNCSingletonH(ABECamManager)

/*
 * The connection status of the component.
 */
@property (nonatomic, readonly) BOOL  WiFiConnected;

//监测WiFi连接的状态
- (void)checkWiFiState;
//释放监测WiFi连接的状态的定时器
- (void)freeCheckWiFiTimer;

@end
