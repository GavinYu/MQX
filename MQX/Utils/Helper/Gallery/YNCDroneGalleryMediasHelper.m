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

@implementation YNCDroneGalleryMediasHelper
#pragma mark - 获取火鸟飞机的数据
+ (void)requestFireBirdDroneInfoDataComplete:(void(^)(NSDictionary *dataDictionary,
                                                      NSArray *dateArray,
                                                      NSArray *mediaArray,
                                                      NSInteger videoAmount,
                                                      NSInteger photoAmount,
                                                      NSError * error))complete
{
    __block NSMutableArray *dateArray = [NSMutableArray array];
    __block NSMutableDictionary *dataDictionary = [NSMutableDictionary dictionary];
#ifdef OPENTOAST_HANK
    [[YNCMessageBox instance] show:@"start get media"];
#endif
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[AbeCamHandle sharedInstance] getGetIndexFileWithList:@1 result:^(BOOL succeeded, NSData *data) {
            NSDictionary *dic = [NSDictionary modelDictionaryWithClass:[NSData class] json:data];
            DLog(@"获取的图片列表：%@", dic);
        }];
    });
}
@end
