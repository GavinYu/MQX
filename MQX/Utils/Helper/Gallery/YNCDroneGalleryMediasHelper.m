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
#pragma mark - 获取飞机的数据
+ (void)requestDronePhotoListComplete:(void(^)(NSString *photoListString,
                                               NSArray *dateArray,
                                               NSInteger photoAmount,
                                               NSError * error))complete
{
    __block NSMutableArray *dateArray = [NSMutableArray array];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[AbeCamHandle sharedInstance] getGetIndexFileWithList:@10 result:^(BOOL succeeded, NSData *data) {
            NSString *fileStr = [[NSString alloc] initWithBytes:[data bytes] length:data.length encoding:NSUTF8StringEncoding];
            DLog(@"获取的图片列表：%@", fileStr);
            if (succeeded) {
                complete(fileStr,nil,0,nil);
            } else {
                complete(nil, nil, 0, [NSError errorWithDomain:@"error" code:404 userInfo:nil]);
            }
        }];
    });
}
@end
