//
//  YNCDeviceInfoDataModel.h
//  MQX
//
//  Created by yc-sh-vr-pc05 on 2018/3/11.
//  Copyright © 2018年 YunEEC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YNCDeviceInfoDataModel : NSObject

@property (assign, nonatomic) NSInteger batterylevel;
@property (assign, nonatomic) NSInteger day;
@property (copy, nonatomic) NSString *fwversion;
@property (assign, nonatomic) NSInteger gsensor_sensitivity;
@property (assign, nonatomic) NSInteger hour;
@property (copy, nonatomic) NSString *iqversion;
@property (assign, nonatomic) NSInteger min;
@property (assign, nonatomic) NSInteger month;
@property (assign, nonatomic) NSInteger powerfrequency;
@property (copy, nonatomic) NSString *pwd;
@property (assign, nonatomic) NSInteger sec;
@property (copy, nonatomic) NSString *ssid;
@property (copy, nonatomic) NSString *timezone;
@property (copy, nonatomic) NSString *type;
@property (assign, nonatomic) NSInteger wifichannel;
@property (assign, nonatomic) NSInteger year;

@end
