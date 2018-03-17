//
//  YNCSessionModel.h
//  MediaEditor
//
//  Created by vrsh on 28/02/2017.
//  Copyright © 2017 Yuneec. All rights reserved.
//



#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

typedef NS_ENUM(NSInteger, DownloadState){
    DownloadStateStart = 0, // 下载中
    DownloadStateSupended, // 下载暂停
    DownloadStateCompleted, // 下载完成
    DownloadStateFailed // 下载失败
};

@interface YNCSessionModel : NSObject

/** 流 **/
@property (nonatomic, strong) NSOutputStream *stream;
/** 下载地址 **/
@property (nonatomic, copy) NSString *url;
/** 获取服务器这次请求 返回数据的总长度 **/
@property (nonatomic, assign) NSInteger totalLength;
/** 下载任务的拍摄日期 **/
@property (nonatomic, copy) NSString *date;
/** 下载进度  **/
@property (nonatomic, copy) void(^progressBlock)(NSInteger receivedSize, NSInteger expectedSize, CGFloat progress);
/** 下载状态 **/
@property (nonatomic, copy) void(^stateBlock)(DownloadState state);

@end
