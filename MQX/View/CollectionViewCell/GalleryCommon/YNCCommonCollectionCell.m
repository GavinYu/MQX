//
//  CHGalleryDownloadCell.m
//  SkyViewS
//
//  Created by vrsh on 16/7/1.
//  Copyright © 2016年 Gavin. All rights reserved.
//

#import "YNCCommonCollectionCell.h"

#import <Photos/Photos.h>
#import "YNCImageHelper.h"
#import "YNCDronePhotoInfoModel.h"
#import "YNCPhotosDataBaseModel.h"
#import "YNCPhotosDataBase.h"
#import "YNCAppConfig.h"

#define kItemWidth 2 * (SCREENWIDTH - 1.0 * 2.0) / 3.0

@interface YNCCommonCollectionCell ()


@end

@implementation YNCCommonCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    self.imageView = [[YYAnimatedImageView alloc] init];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    self.selectBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.selectBtn setImage:[UIImage imageNamed:@"icon_normal"] forState:UIControlStateNormal];
    [self.imageView addSubview:_selectBtn];
    [_selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(5);
        make.left.equalTo(self).offset(5);
        make.width.height.equalTo(@27);
    }];
    
    self.tagImageView = [[UIImageView alloc] init];
    self.tagImageView.image = [UIImage imageNamed:@"icon_down_finishedwenjan"];
    self.tagImageView.hidden = YES;
    [self.imageView addSubview:_tagImageView];
    [_tagImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(5);
        make.right.equalTo(self).offset(-5);
        make.width.height.equalTo(@(20));
    }];
    
    self.playImageView = [[UIImageView alloc] init];
    [self.imageView addSubview:_playImageView];
    _playImageView.image = [UIImage imageNamed:@"btn_play_small"];
    _playImageView.hidden = YES;
    [_playImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_imageView);
        make.width.height.equalTo(@44);
    }];
}

// 配置数据
- (void)displayCellWithAsset:(PHAsset *)asset
{
    if (asset.mediaType == PHAssetMediaTypeVideo) {
        _playImageView.hidden = NO;
    } else if (asset.mediaType == PHAssetMediaTypeImage) {
        _playImageView.hidden = YES;
    }
    [YNCImageHelper getImageWithAsset:asset targetSize:CGSizeMake(kItemWidth, kItemWidth) complete:^(UIImage *image) {
        self.imageView.image = image;
    }];
}

#pragma mark - 显示Breeze图片
- (void)displayCellWithModel:(YNCDronePhotoInfoModel *)photoInfo
{
    if (photoInfo.mediaType == YNCMediaTypeDronePhoto) {
        NSString *path = [Document_Download stringByAppendingPathComponent:photoInfo.title];
        path = [path stringByAppendingPathExtension:@"png"];
        _playImageView.hidden = YES;
        NSURL *pathUrl = [NSURL fileURLWithPath:path];
        [_imageView setImageURL:pathUrl];
    } else if (photoInfo.mediaType == YNCMediaTypeDroneVideo) {
        NSString *path = [Document_Download stringByAppendingPathComponent:photoInfo.title];
        path = [path stringByAppendingPathExtension:@"png"];
        _playImageView.hidden = NO;
        NSURL *pathUrl = [NSURL fileURLWithPath:path];
        [_imageView setImageURL:pathUrl];
    } else if (photoInfo.mediaType == YNCMediaTypeEditedPhoto) {
        NSString *path = [Document_ImageEdit stringByAppendingPathComponent:photoInfo.title];
        path = [path stringByAppendingPathExtension:@"png"];
        _playImageView.hidden = YES;
        NSURL *pathUrl = [NSURL fileURLWithPath:path];
        [_imageView setImageURL:pathUrl];
    } else if (photoInfo.mediaType == YNCMediaTypeEditedVideo) {
        NSString *path = [Document_ImageEdit stringByAppendingPathComponent:photoInfo.title];
        path = [path stringByAppendingPathExtension:@"png"];
        _playImageView.hidden = NO;
        NSURL *pathUrl = [NSURL fileURLWithPath:path];
        [_imageView setImageURL:pathUrl];
    }
}

- (void)displayCellWithMedia:(YNCDronePhotoInfoModel *)media
{
    YNCMediaType mediaType = YNCMediaTypeDronePhoto;
    if (media.mediaType == YNCMediaTypeDroneVideo) {
        mediaType = YNCMediaTypeDroneVideo;
        _playImageView.hidden = NO;
        if ([[NSFileManager defaultManager] fileExistsAtPath:media.videoThumbPath]) {
            [_imageView setImageURL:[NSURL fileURLWithPath:media.videoThumbPath]];
        }
    } else {
        _playImageView.hidden = YES;
        if ([[NSFileManager defaultManager] fileExistsAtPath:media.filePath]) {
            [_imageView setImageURL:[NSURL fileURLWithPath:media.filePath]];
        }
    }
}


@end
