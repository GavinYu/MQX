//
//  YNCCircleProgressModel.h
//  MQX
//
//  Created by yc-sh-vr-pc05 on 2018/3/17.
//  Copyright © 2018年 YunEEC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YNCCircleProgressModel : NSObject
@property (nonatomic, assign) NSInteger currentDownloadNum;
@property (nonatomic, assign) NSInteger totalDownloadNum;
@property (nonatomic, copy) NSString *fileSize;
@end
