//
//  YNCDroneMediasDownloadManager.h
//  MQX
//
//  Created by yc-sh-vr-pc05 on 2018/3/17.
//  Copyright © 2018年 YunEEC. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CoreGraphics/CoreGraphics.h>
#import "YNCSingleton.h"

@interface YNCDroneMediasDownloadManager : NSObject

@property (nonatomic, assign) BOOL isCancel;
@property (nonatomic, assign) BOOL isDownloadingThumbs;

/**
 下载飞机缩略图
 @param completed 完成回调
 */
- (void)downloadMediaThumbnailWithMediaArray:(NSArray *)mediaArray
                              CompletedBlock:(void(^)(BOOL completed))completed;


/**
 下载多张原图
 
 @param mediasArray 要下载的资源
 @param progressBlock 进度回调
 @param completeBlock 完成回调
 */
- (void)downloadDroneMediasWithMediasArray:(NSArray<id> *)mediasArray
                             progressBlock:(void (^)(NSInteger currentNum,
                                                     NSString *fileSize,
                                                     CGFloat progress))progressBlock
                             completeBlock:(void (^)(BOOL))completeBlock;

@end
