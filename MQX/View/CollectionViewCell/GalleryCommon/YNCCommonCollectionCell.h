//
//  CHGalleryDownloadCell.h
//  SkyViewS
//
//  Created by vrsh on 16/7/1.
//  Copyright © 2016年 Gavin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YYKit/YYKit.h>

@class AVAsset;

@class PHAsset;
@class YNCDronePhotoInfoModel;

@interface YNCCommonCollectionCell : UICollectionViewCell

/** 播放的按钮 **/
@property (nonatomic, strong) UIImageView *playImageView;
/** 选择按钮 **/
@property (nonatomic, strong) UIButton *selectBtn;
/** 标记cell是否被选中删除 **/
@property (nonatomic, assign) BOOL isSelectedDelete;
/** 底部图片 **/
@property (nonatomic, strong) YYAnimatedImageView *imageView;
/** 标记cell是否已下载 **/
@property (nonatomic, strong) UIImageView *tagImageView;

/** 视频时长 **/
@property (nonatomic ,strong) UILabel *timeLabel;
@property (nonatomic, strong) AVAsset *asset;

// 配置数据
- (void)displayCellWithAsset:(PHAsset *)asset;

- (void)displayCellWithModel:(YNCDronePhotoInfoModel *)photoInfo;

- (void)displayCellWithMedia:(YNCDronePhotoInfoModel *)media;

@end
