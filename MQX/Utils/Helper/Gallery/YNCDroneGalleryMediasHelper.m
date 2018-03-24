//
//  YNCDroneGalleryMediasHelper.m
//  MQX
//
//  Created by yc-sh-vr-pc05 on 2018/3/17.
//  Copyright © 2018年 YunEEC. All rights reserved.
//

#import "YNCDroneGalleryMediasHelper.h"

#import <ABECam/ABECam.h>
#import "YNCAppConfig.h"
#import "WTMediaModel.h"

@implementation YNCDroneGalleryMediasHelper
#pragma mark - 获取飞机的图库数据
+ (void)requestDroneInfoDataComplete:(void(^)(NSDictionary *dataDictionary,
                                              NSArray *dateArray,
                                              NSArray<WTMediaModel *> *mediaArray,
                                              NSInteger videoAmount,
                                              NSInteger photoAmount,
                                              NSError * error))complete
{
    __block NSMutableArray *dateArray = [NSMutableArray array];
    __block NSMutableDictionary *dataDictionary = [NSMutableDictionary dictionary];
    __block NSMutableArray *mediaArray = [NSMutableArray array];
    __block NSArray *photoList;
    __block NSArray *videoList;

    WS(weakSelf);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //获取图片列表
        [[AbeCamHandle sharedInstance] getGetIndexFileWithList:@1 result:^(BOOL succeeded, NSData *data) {
            if (succeeded) {
                NSString *fileStr = [[NSString alloc] initWithBytes:[data bytes] length:data.length encoding:NSUTF8StringEncoding];
                DLog(@"获取的图片列表：%@", fileStr);
                if (fileStr.length > 0) {
                    photoList = [weakSelf  parseStringInfoToArray:fileStr];
                    [mediaArray addObjectsFromArray:photoList];
                }
            }
            
            //获取视频列表
            [[AbeCamHandle sharedInstance] getVideoListResult:^(BOOL succeeded, NSData *data) {
                if (succeeded) {
                    NSString *fileStr = [[NSString alloc] initWithBytes:[data bytes] length:data.length encoding:NSUTF8StringEncoding];
                    DLog(@"获取的视频列表：%@", fileStr);
                    if (fileStr.length > 0) {
                        videoList = [weakSelf parseStringInfoToArray:fileStr];
                        [mediaArray addObjectsFromArray:videoList];
                    }
                    
                    complete(dataDictionary,dateArray,mediaArray,photoList.count,videoList.count,nil);
                } else {
                    complete(nil,nil,nil,0,0,[NSError errorWithDomain:@"error" code:404 userInfo:nil]);
                }
            }];
        }];
    });
}

//MARK: -- 解析得到的列表字符串
+ (NSMutableArray *)parseStringInfoToArray:(NSString *)stringInfo {
    NSMutableArray *resultArr = [[NSMutableArray alloc] initWithCapacity:0];
    
    NSArray *tmpItemArr = [stringInfo componentsSeparatedByString:@"\n"];
    for (int i = 0; i < tmpItemArr.count; ++i) {
        NSArray *tmpArr = [tmpItemArr[i] componentsSeparatedByString:@","];
        NSString *tmpStr = [tmpArr firstObject];
        if (tmpStr.length > 0) {
            WTMediaModel *itemModel = [WTMediaModel new];
            itemModel.fileName = tmpStr;
            if ([[tmpStr pathExtension] isEqualToString:@"jpg"]) {
                itemModel.mediaType = WTMediaTypeJPEG;
            } else if ([[tmpStr pathExtension] isEqualToString:@"mp4"]) {
                itemModel.mediaType = WTMediaTypeMP4;
            }
            [resultArr addObject:itemModel];
        }
    }
    
    return resultArr;
}

@end
