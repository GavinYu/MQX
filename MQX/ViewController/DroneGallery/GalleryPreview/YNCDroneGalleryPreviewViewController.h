//
//  YNCDroneGalleryPreviewViewController.h
//  MQX
//
//  Created by yc-sh-vr-pc05 on 2018/3/17.
//  Copyright © 2018年 YunEEC. All rights reserved.
//

#import "YNCDroneGalleryBaseViewController.h"

@interface YNCDroneGalleryPreviewViewController : YNCDroneGalleryBaseViewController

@property (nonatomic, assign) NSInteger number;
@property (nonatomic, strong) NSMutableDictionary *dataDictionary;
@property (nonatomic, strong) NSMutableArray *dateArray;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, assign) NSInteger videoAmount;
@property (nonatomic, assign) NSInteger photoAmount;

- (void)scrollToItemAtNumber:(NSInteger)number;
- (void)configureSubViews;
- (void)configureData;

@end
