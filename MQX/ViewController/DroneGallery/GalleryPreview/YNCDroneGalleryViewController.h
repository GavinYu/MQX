//
//  YNCDroneGalleryViewController.h
//  MQX
//
//  Created by yc-sh-vr-pc05 on 2018/3/17.
//  Copyright © 2018年 YunEEC. All rights reserved.
//

#import "YNCDroneGalleryBaseViewController.h"
#import "YNCMeidasViewController.h"

@class YNCDroneNavigationModel;
@class YNCDronePhotoInfoModel;

typedef void(^YNCChangeDroneGalleryDataBlock)(NSArray <YNCDronePhotoInfoModel *> *deleteDataArray,YNCDroneNavigationModel *droneNavigationModel);

@interface YNCDroneGalleryViewController : YNCMeidasViewController

@property (nonatomic, strong) YNCDroneNavigationModel *droneNavigationModel;

@property (nonatomic, copy) YNCChangeDroneGalleryDataBlock droneGalleryDataChangeBlock;


- (void)configureSubView;
@end
