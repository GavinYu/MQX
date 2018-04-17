//
//  YNCDroneMediasDownloadManager.m
//  MQX
//
//  Created by yc-sh-vr-pc05 on 2018/3/17.
//  Copyright © 2018年 YunEEC. All rights reserved.
//

#import "YNCDroneMediasDownloadManager.h"

#import "YNCImageHelper.h"
#import "YNCPhotosDataBaseModel.h"
#import "YNCPhotosDataBase.h"
#import "YNCMacros.h"
#import "WTMediaModel.h"
#import <ABECam/ABECam.h>

#import "YNCDronePhotoInfoModel.h"

@interface YNCDroneMediasDownloadManager ()
@property (nonatomic, strong) NSMutableArray<id> *mediasArray;
@property (nonatomic, copy) void (^progressBlock)(NSInteger currentNum, NSString *fileSize, CGFloat progress);
@property (nonatomic, copy) void (^completeBlock)(BOOL completed, NSArray *photoArray, NSArray *videoArray);
@property (nonatomic, copy) void (^downloadCompleteBlock)(BOOL complete);
//存储图片的数据
@property (nonatomic, strong) NSMutableArray *photoFileAarry;
//存储图片的数据
@property (nonatomic, strong) NSMutableArray *videoFileAarry;

@end
#warning TODO: --- Need coding
@implementation YNCDroneMediasDownloadManager

//MARK: -- lazyload photoFileAarry
- (NSMutableArray *)photoFileAarry {
    if (!_photoFileAarry) {
        _photoFileAarry = [NSMutableArray new];
    }
    
    return _photoFileAarry;
}

//MARK: -- lazyload videoFileAarry
- (NSMutableArray *)videoFileAarry {
    if (!_videoFileAarry) {
        _videoFileAarry = [NSMutableArray new];
    }
    
    return _videoFileAarry;
}

// MARK: 下载缩略图
- (void)downloadMediaThumbnailWithMediaArray:(NSArray *)mediaArray
                              CompletedBlock:(void(^)(BOOL completed))completed;
{
    self.downloadCompleteBlock = completed;
    self.isDownloadingThumbs = YES;
    [self downloadThumbnailsWithMediasArray:mediaArray];
}

- (void)downloadThumbnailsWithMediasArray:(NSArray *)mediasArray
{
    WS(weakSelf);
    __block NSInteger i = 0;
    dispatch_queue_t downloadQueue_t = dispatch_queue_create("com.WT.download", DISPATCH_QUEUE_SERIAL);
    WTMediaModel *media = mediasArray[i];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString *fileName = media.fileName;
        NSString *filePath;
        NSNumber *fileType;
        if (media.mediaType == WTMediaTypeJPEG) {
            filePath = [Document_Download stringByAppendingPathComponent:fileName];
            fileType = @(kPicture);
        } else {
            filePath = [Document_Download_Video stringByAppendingPathComponent:fileName];
            fileType = @(kRecord);
        }
        
        [[AbeCamHandle sharedInstance] downloadFileToPath:filePath fileName:fileName FileType:fileType pos:@(0) progressBlock:^(float percentDone) {
            DLog(@"下载进度%.1f%%", percentDone*100);
        } resultblock:^(BOOL succeeded, NSString *path) {
            if (succeeded) {
                DLog(@"保存的路径：%@", path);
                [[AbeCamHandle sharedInstance] downloadFinishWithFileName:fileName FileType:fileType result:^(BOOL succeeded) {
                    if (succeeded) {
                        DLog(@"下载成功 Yea!");
                    }
                }];
            }
        }];
    });

    self.isDownloadingThumbs = NO;
    self.downloadCompleteBlock(YES);
}

//MARK: -- 下载某个文件
- (void)downloadMedia:(WTMediaModel *)media withCompletion:(void(^)(BOOL succeed))completionBlock {
    
}

//MARK 下载原图 / 视频
- (void)downloadDroneMediasWithMediasArray:(NSArray<id> *)mediasArray
                             progressBlock:(void (^)(NSInteger currentNum,
                                                     NSString *fileSize,
                                                     CGFloat progress))progressBlock
                             completeBlock:(void (^)(BOOL completed, NSArray *photoArray, NSArray *videoArray))completeBlock
{
    NSFileManager *tmpFileManager = [NSFileManager defaultManager];
    if (![tmpFileManager fileExistsAtPath:Document_Download_Photo]) {
        BOOL tmpPhoto = [tmpFileManager createDirectoryAtPath:Document_Download_Photo withIntermediateDirectories:YES attributes:nil error:NULL];
        if (tmpPhoto) {
            DLog(@"create photo 路径成功");
        }
    }
    if (![tmpFileManager fileExistsAtPath:Document_Download_Video]) {
        BOOL tmpVideo = [tmpFileManager createDirectoryAtPath:Document_Download_Video withIntermediateDirectories:YES attributes:nil error:NULL];
        if (tmpVideo) {
            DLog(@"create video 路径成功");
        }
    }
    
    if (mediasArray.count > 0) {
        if (self.mediasArray.count > 0) {
            [self.mediasArray removeAllObjects];
        }
        [self.mediasArray addObjectsFromArray:mediasArray];
        self.progressBlock = progressBlock;
        self.completeBlock = completeBlock;
        [self downloadThumbImageWithNumber:0];
    }
}

- (void)downloadThumbImageWithNumber:(NSInteger)number
{
    WTMediaModel *media = self.mediasArray[number];
    NSString *fileName = media.fileName;
    NSString *filePath;
    NSNumber *fileType;
    if (media.mediaType == WTMediaTypeJPEG) {
        filePath = [Document_Download_Photo stringByAppendingPathComponent:fileName];
        fileType = @(kPicture);
    } else {
        filePath = [Document_Download_Video stringByAppendingPathComponent:fileName];
        fileType = @(kRecord);
    }
    
    DLog(@"保存的路径：%@", filePath);
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        
        YNCDronePhotoInfoModel *itemPhotoModel = [YNCDronePhotoInfoModel new];
        itemPhotoModel.filePath = filePath;
        itemPhotoModel.title = fileName;
        itemPhotoModel.pixelWidth = SCREENWIDTH;
        itemPhotoModel.pixelHeight = SCREENHEIGHT;
        
        if ([fileType integerValue] == kPicture) {
            itemPhotoModel.mediaType = YNCMediaTypeDronePhoto;
            
            UIImage *tmpImg = [UIImage imageWithContentsOfFile:filePath];
            itemPhotoModel.pixelWidth = tmpImg.size.width;
            itemPhotoModel.pixelHeight = tmpImg.size.height;
            
            [self.photoFileAarry addObject:itemPhotoModel];
        } else {
            itemPhotoModel.mediaType = YNCMediaTypeDroneVideo;
            NSString *tmpStr = [filePath stringByDeletingPathExtension];
            NSString *videoThumbImagePath = [tmpStr stringByAppendingPathExtension:@"JPG"];
            if ([[NSFileManager defaultManager] fileExistsAtPath:videoThumbImagePath]) {
                UIImage *tmpImg = [UIImage imageWithContentsOfFile:videoThumbImagePath];
                itemPhotoModel.pixelWidth = tmpImg.size.width;
                itemPhotoModel.pixelHeight = tmpImg.size.height;
                itemPhotoModel.videoThumbPath = videoThumbImagePath;
            }
            [self.videoFileAarry addObject:itemPhotoModel];
        }
        ++number;
        
        if (number < self.mediasArray.count) {
            [self downloadThumbImageWithNumber:number];
        } else {
            self.completeBlock(YES, self.photoFileAarry, self.videoFileAarry);
        }
    } else {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            WS(weakSelf);
            __block NSInteger blockNumber = number;
            
            [[AbeCamHandle sharedInstance] downloadFileToPath:filePath fileName:fileName FileType:fileType pos:@(0) progressBlock:^(float percentDone) {
                DLog(@"下载进度%.1f%%", percentDone*100);
            } resultblock:^(BOOL succeeded, NSString *path) {
                if (succeeded) {
                    DLog(@"保存的路径：%@", path);
                    YNCDronePhotoInfoModel *itemPhotoModel = [YNCDronePhotoInfoModel new];
                    itemPhotoModel.filePath = path;
                    itemPhotoModel.title = fileName;
                    
                    if ([fileType integerValue] == kPicture) {
                        UIImage *tmpImg = [UIImage imageWithContentsOfFile:filePath];
                        itemPhotoModel.pixelWidth = tmpImg.size.width;
                        itemPhotoModel.pixelHeight = tmpImg.size.height;
                        itemPhotoModel.mediaType = YNCMediaTypeDronePhoto;
                        [weakSelf.photoFileAarry addObject:itemPhotoModel];
                    } else {
                        itemPhotoModel.mediaType = YNCMediaTypeDroneVideo;
                        //截取视频的第一帧图像作为视频的缩略图
                        itemPhotoModel = [self interceptVideoFirstImage:path withPhotoInfoModel:itemPhotoModel];
                        [weakSelf.videoFileAarry addObject:itemPhotoModel];
                    }
                    ++blockNumber;
                    
                    if (blockNumber < self.mediasArray.count) {
                        [self downloadThumbImageWithNumber:blockNumber];
                    } else {
                        self.completeBlock(YES, weakSelf.photoFileAarry, weakSelf.videoFileAarry);
                    }
                    
                    [[AbeCamHandle sharedInstance] downloadFinishWithFileName:fileName FileType:fileType result:^(BOOL succeeded) {
                        if (succeeded) {
                            DLog(@"下载成功 Yea!");
                        }
                    }];
                }
            }];
            
        });
    }
}

static int xxxx = 0;
- (void)downloadDroneMedia:(id)media singleKey:(NSString *)singleKey number:(NSInteger)number
{
    __block NSInteger newNumber = number;
    NSString *string = singleKey;
    YNCPhotosDataBaseModel *model = [YNCPhotosDataBaseModel new];
    model.singleKey = singleKey;
    model.createDate = @"201811";
    
}

- (void)insertDataBaseWithModel:(YNCPhotosDataBaseModel *)model
{
    if (model.mediaType == YNCMediaTypeDroneVideo) {
        NSString *path = [YNCImageHelper convertFileNameToDownloadLocationPath:[model.singleKey stringByAppendingPathExtension:@"mp4"]];
        UIImage *originImage = [YNCImageHelper getVideoFirstImageWithVideoPath:path];
        model.width = originImage.size.width;
        model.height = originImage.size.height;
        NSString *originImagePath = [model.singleKey stringByAppendingPathExtension:@"JPG"];
        originImagePath = [YNCImageHelper convertFileNameToDownloadLocationPath:originImagePath];
        [YNCImageHelper writeImage:originImage
                            toPath:originImagePath
                compressionQuality:1.0];
        [YNCImageHelper savePhotosAndVideosToAlbumWithIsPhoto:NO mediaPath:path];
    } else if (model.mediaType == YNCMediaTypeDronePhoto) {
        NSString *path = [YNCImageHelper convertFileNameToDownloadLocationPath:[model.singleKey stringByAppendingPathExtension:@"JPG"]];
        NSURL *url = [NSURL fileURLWithPath:path];
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
        model.width = image.size.width;
        model.height = image.size.height;
        [YNCImageHelper savePhotosAndVideosToAlbumWithIsPhoto:YES mediaPath:path];
    }
    model.singleKey = [[model.singleKey lastPathComponent] stringByDeletingPathExtension];
    NSString *createDate = [model.createDate substringToIndex:10];
    NSArray *strArray = [createDate componentsSeparatedByString:@":"];
    if (strArray.count >= 3) {
        model.createDate = [NSString stringWithFormat:@"%@-%@-%@",strArray[0], strArray[1], strArray[2]];
    }
    [[YNCPhotosDataBase shareDataBase] insertOnePhotoDataBase:model];
}

//MARK: -- 截取视频第一帧图像
- (YNCDronePhotoInfoModel *)interceptVideoFirstImage:(NSString *)videoPath withPhotoInfoModel:(YNCDronePhotoInfoModel *)photoInfoModel {
    //截取视频的第一帧图像作为视频的缩略图
    UIImage *originImage = [YNCImageHelper getVideoFirstImageWithVideoPath:videoPath];
    photoInfoModel.pixelWidth = originImage.size.width;
    photoInfoModel.pixelHeight = originImage.size.height;
    NSString *tmpStr = [videoPath stringByDeletingPathExtension];
    NSString *videoThumbImagePath = [tmpStr stringByAppendingPathExtension:@"JPG"];
    
    [YNCImageHelper writeImage:originImage
                        toPath:videoThumbImagePath
            compressionQuality:1.0];
    if ([[NSFileManager defaultManager] fileExistsAtPath:videoThumbImagePath]) {
        photoInfoModel.videoThumbPath = videoThumbImagePath;
    }
    
    return photoInfoModel;
}

#pragma mark ----------------------------------- getters & setters

- (NSMutableArray<id> *)mediasArray
{
    if (!_mediasArray) {
        _mediasArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _mediasArray;
}

- (void)setIsDownloadingThumbs:(BOOL)isDownloadingThumbs
{
    _isDownloadingThumbs = isDownloadingThumbs;
}



@end
