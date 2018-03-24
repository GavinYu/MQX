//
//  YNCDroneGalleryMediasHelper.h
//  MQX
//
//  Created by yc-sh-vr-pc05 on 2018/3/17.
//  Copyright © 2018年 YunEEC. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WTMediaModel;

@interface YNCDroneGalleryMediasHelper : NSObject

/**
 获取飞机的图库数据信息
 
 @param complete 完成回调
 */
+ (void)requestDroneInfoDataComplete:(void(^)(NSDictionary *dataDictionary,
                                                      NSArray *dateArray,
                                                      NSArray<WTMediaModel *> *mediaArray,
                                                      NSInteger videoAmount,
                                                      NSInteger photoAmount,
                                                      NSError * error))complete;

@end
