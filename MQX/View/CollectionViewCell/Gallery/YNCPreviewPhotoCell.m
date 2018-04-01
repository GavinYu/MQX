//
//  YNCPreviewPhotoCell.m
//  YuneecApp
//
//  Created by vrsh on 07/03/2017.
//  Copyright © 2017 yuneec. All rights reserved.
//

#import "YNCPreviewPhotoCell.h"

#import <Photos/Photos.h>
#import "YNCImageHelper.h"
#import "YNCDronePhotoInfoModel.h"
#import "YNCPhotosDataBase.h"
#import "YNCPhotosDataBaseModel.h"
#import "YNCAVPlayerView.h"
#import "YNCAppConfig.h"

@interface YNCPreviewPhotoCell () <UIScrollViewDelegate>

@property (nonatomic, copy) NSString *urlStr;
@property (nonatomic, assign) CGRect currentImageVFrame;

@end

@implementation YNCPreviewPhotoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

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
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollView.delegate = self;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_scrollView];
    
    self.imageV = [[YYAnimatedImageView alloc] init];
    self.imageV.contentMode = UIViewContentModeScaleAspectFit;
    _imageV.userInteractionEnabled = YES;
    [self.scrollView addSubview:_imageV];    
    
    self.playeBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self addSubview:_playeBtn];
    [_playeBtn setImage:[UIImage imageNamed:@"btn_play_small"] forState:(UIControlStateNormal)];
    [_playeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.height.equalTo(@(100));
    }];
}

- (void)displayCellWithObject:(id)object
{
    __block CGFloat width, height;
    WS(weakSelf);
    if ([object isKindOfClass:[PHAsset class]]) {
        PHAsset *asset = object;
        width = asset.pixelWidth;
        height = asset.pixelHeight;
        if (asset.mediaType == PHAssetMediaTypeVideo) {
            _playeBtn.hidden = NO;
            _scrollView.userInteractionEnabled = NO;
            [YNCImageHelper getImageDataWithAsset:asset complete:^(UIImage *HDImage) {
                weakSelf.imageV.image = HDImage;
            }];
        } else if (asset.mediaType == PHAssetMediaTypeImage) {
            _playeBtn.hidden = YES;
            [self addTwiceTapGesture];
            [YNCImageHelper getImageDataWithAsset:(PHAsset *)object complete:^(UIImage *HDImage) {
                self.imageV.image = HDImage;
            }];
        }
        [self configureFrameWithWidth:width height:height];
    } else if ([object isKindOfClass:[YNCDronePhotoInfoModel class]]) {
        YNCDronePhotoInfoModel *photoInfo = object;
        width = SCREENWIDTH;
        height = SCREENHEIGHT;
        switch (photoInfo.mediaType) {
            case YNCMediaTypeDronePhoto:
            {
                _playeBtn.hidden = YES;
                [self addTwiceTapGesture];
                NSURL *pathUrl = [NSURL fileURLWithPath:photoInfo.filePath];
                [_imageV setImageURL:pathUrl];
            }
                break;
            case YNCMediaTypeDroneVideo:
            {
                _playeBtn.hidden = NO;
                _scrollView.userInteractionEnabled = NO;
                NSURL *videoImageURL = [NSURL fileURLWithPath:photoInfo.filePath];
                [_imageV setImageURL:videoImageURL];
            }
                break;
            case YNCMediaTypeEditedPhoto:
            {
                _playeBtn.hidden = YES;
                [self addTwiceTapGesture];
                NSString *path = [Document_ImageEdit stringByAppendingPathComponent:photoInfo.title];
                path = [path stringByAppendingPathExtension:@"JPG"];
                NSURL *pathUrl = [NSURL fileURLWithPath:path];
                [_imageV setImageURL:pathUrl];
            }
                break;
            case YNCMediaTypeEditedVideo:
            {
                _playeBtn.hidden = NO;
                _scrollView.userInteractionEnabled = NO;
                NSString *videoImagePath = [Document_ImageEdit stringByAppendingPathComponent:photoInfo.title];
                videoImagePath = [videoImagePath stringByAppendingPathExtension:@"JPG"];
                NSURL *videoImageURL = [NSURL fileURLWithPath:videoImagePath];
                [_imageV setImageURL:videoImageURL];
            }
                break;
            default:
                break;
        }
        [self configureFrameWithWidth:width height:height];
    } else {
//        YuneecMedia *media = object;
//
//        NSString *createDate = media.thumbnailMedia.createDate;
//        NSString *fileName = media.thumbnailMedia.fileName;
//        YNCMediaType mediaType = YNCMediaTypeDronePhoto;
//        fileName = [NSString stringWithFormat:@"%@_%@", createDate, fileName];
//        fileName = [fileName stringByDeletingPathExtension];
//        NSString *filePath = nil;
//
//        __block UIImage *image = nil;
//        if (media.mediaType == YuneecMediaTypeMP4) {
//            mediaType = YNCMediaTypeDroneVideo;
//            _playeBtn.hidden = NO;
//            _scrollView.userInteractionEnabled = NO;
//        } else if (media.mediaType == YuneecMediaTypeJPEG) {
//            _playeBtn.hidden = YES;
//            [self addTwiceTapGesture];
//        }
//        YNCPhotosDataBaseModel *model = [[YNCPhotosDataBase shareDataBase] selectOnePhotoDataBaseModelBySingleKey:fileName type:mediaType];
//        if (model.singleKey.length > 0) {
//            filePath = [YNCImageHelper convertFileNameToDownloadLocationPath:[fileName stringByAppendingPathExtension:@"JPG"]];
//        } else {
//            filePath = [YNCImageHelper convertFileNameToDownloadLocationPath:[fileName stringByAppendingPathExtension:@"png"]];
//        }
//
//        if (fileExistsAtPath(filePath)) {
//            image = [UIImage imageWithData:[NSData dataWithContentsOfFile:filePath]];
//            width = image.size.width;
//            height = image.size.height;
//            [_imageV setImageURL:[NSURL fileURLWithPath:filePath]];
//            [self configureFrameWithWidth:width height:height];
//        } else {
//            [media fetchThumbnailWithFilePath:filePath block:^(NSError * _Nullable error) {
//                if (error == nil) {
//                    image = [UIImage imageWithData:[NSData dataWithContentsOfFile:filePath]];
//                    width = image.size.width;
//                    height = image.size.height;
//                    [weakSelf.imageV setImageURL:[NSURL fileURLWithPath:filePath]];
//                    [weakSelf configureFrameWithWidth:width height:height];
//                } else {
//                    kLOG_ERROR;
//                }
//            }];
//        }
    }
}

- (void)configureFrameWithWidth:(CGFloat)width height:(CGFloat)height
{
    CGFloat min = MIN(_scrollView.frame.size.height / height, _scrollView.frame.size.width / width);
    _scrollView.minimumZoomScale = min;
    _scrollView.maximumZoomScale = 1.0;
    _scrollView.zoomScale = _scrollView.minimumZoomScale;
    _imageV.frame = CGRectMake(0, 0, width * _scrollView.minimumZoomScale, height * _scrollView.minimumZoomScale);
    _scrollView.contentSize = CGSizeMake(width * _scrollView.minimumZoomScale, height * _scrollView.minimumZoomScale);
    _imageV.frame = [self centerFrameSubview:_imageV inSuperview:_scrollView];
    self.currentImageVFrame = _imageV.frame;
}

- (void)addTwiceTapGesture
{
    self.tapGesutreTwice = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureTwiceAction:)];
    _tapGesutreTwice.numberOfTapsRequired = 2;
    [_imageV addGestureRecognizer:_tapGesutreTwice];
    _scrollView.userInteractionEnabled = YES;
}

- (void)tapGestureTwiceAction:(UITapGestureRecognizer *)sender
{
    CGPoint location = [sender locationInView:_imageV];
    if (_scrollView.zoomScale == _scrollView.minimumZoomScale) {
        CGSize scrollViewSize = _scrollView.bounds.size;
        CGFloat width = scrollViewSize.width / _scrollView.maximumZoomScale;
        CGFloat height = scrollViewSize.height / _scrollView.maximumZoomScale;
        CGFloat x = location.x - (width / 2.0f);
        CGFloat y = location.y - (height / 2.0f);
        CGRect rectToZoomTo = CGRectMake(x, y, width, height);
        [_scrollView zoomToRect:rectToZoomTo animated:YES];
        if ([_delegate respondsToSelector:@selector(hiddenViews)]) {
            [_delegate hiddenViews];
        }
    }else if ((_scrollView.zoomScale > _scrollView.minimumZoomScale) && (_scrollView.zoomScale <= _scrollView.maximumZoomScale)){
        [_scrollView setZoomScale:_scrollView.minimumZoomScale animated:YES];
    }
}


// 恢复原来状态
- (void)recoveryOriginFrame
{
    [_scrollView setZoomScale:_scrollView.minimumZoomScale animated:NO];
    _imageV.frame = _currentImageVFrame;
}

- (CGRect)centerFrameSubview:(UIView *)subview inSuperview:(UIView *)superview
{
    CGSize boundsSize = superview.bounds.size;
    CGRect frameToCenter = subview.frame;
    
    // center horizontally
    if (frameToCenter.size.width < boundsSize.width) {
        frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
    }
    else {
        frameToCenter.origin.x = 0;
    }
    
    // center vertically
    if (frameToCenter.size.height < boundsSize.height) {
        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2;
    }
    else {
        frameToCenter.origin.y = 0;
    }
    
    return frameToCenter;
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageV;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    _imageV.frame = [self centerFrameSubview:_imageV inSuperview:_scrollView];
}

@end
