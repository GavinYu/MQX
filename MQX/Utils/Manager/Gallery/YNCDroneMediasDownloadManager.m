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

@interface YNCDroneMediasDownloadManager ()
@property (nonatomic, strong) NSMutableArray<id> *mediasArray;
@property (nonatomic, copy) void (^progressBlock)(NSInteger currentNum, NSString *fileSize, CGFloat progress);
@property (nonatomic, copy) void (^completeBlock)(BOOL completed);
@property (nonatomic, copy) void (^downloadCompleteBlock)(BOOL complete);
@end
#warning TODO: --- Need coding
@implementation YNCDroneMediasDownloadManager
// MARK: 下载缩略图
- (void)downloadMediaThumbnailWithMediaArray:(NSArray *)mediaArray
                              CompletedBlock:(void(^)(BOOL completed))completed;
{
    self.downloadCompleteBlock = completed;
    self.isDownloadingThumbs = YES;
    dispatch_queue_t queue = dispatch_queue_create("com.download.thumb", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{
        //Mark: 为什么不能用weakself
        [self downloadThumbnailsWithMediasArray:mediaArray];
    });
}

- (void)downloadThumbnailsWithMediasArray:(NSArray *)mediasArray
{
    __block NSInteger i = 0;
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    while (mediasArray.count > i) {
        NSString *createDate = @"2018-03-17";
        NSString *fileName = @"test";
        fileName = [[fileName stringByDeletingPathExtension] stringByAppendingString:@".png"];
        NSString *filePath = [YNCImageHelper convertFileNameToDownloadLocationPath:[NSString stringWithFormat:@"%@_%@", createDate, fileName]];
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
            i++;
        } else {
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            i++;
        }
    }
    self.isDownloadingThumbs = NO;
    self.downloadCompleteBlock(YES);
}

//MARK 下载原图 / 视频
- (void)downloadDroneMediasWithMediasArray:(NSArray<id> *)mediasArray
                             progressBlock:(void (^)(NSInteger currentNum,
                                                     NSString *fileSize,
                                                     CGFloat progress))progressBlock
                             completeBlock:(void (^)(BOOL))completeBlock
{
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
    
    NSString *createDate = @"201801";
    NSString *fileName = @"test";
    fileName = [[fileName stringByDeletingPathExtension] stringByAppendingString:@".png"];
    NSString *filePath = [YNCImageHelper convertFileNameToDownloadLocationPath:[NSString stringWithFormat:@"%@_%@", createDate, fileName]];
    NSString *singleKey = [[filePath lastPathComponent] stringByDeletingPathExtension];
    YNCPhotosDataBase *dataBase = [YNCPhotosDataBase shareDataBase];
    YNCPhotosDataBaseModel *model = [[YNCPhotosDataBaseModel alloc] init];
    if (1) {
        model = [dataBase selectOnePhotoDataBaseModelBySingleKey:singleKey type:YNCMediaTypeDroneVideo];
    } else if (2) {
        model = [dataBase selectOnePhotoDataBaseModelBySingleKey:singleKey type:YNCMediaTypeDronePhoto];
    }
    
    if (model.singleKey.length > 0) {
        ++number;
        self.progressBlock(number + 1, model.mermory, 1.0);
        if (number < self.mediasArray.count) {
            [self downloadThumbImageWithNumber:number];
        } else {
            self.completeBlock(YES);
        }
        return;
    }
    
    if ([[NSFileManager defaultManager]fileExistsAtPath:filePath]) {
//        [self downloadDroneMedia:media singleKey:singleKey number:number];
    } else {
        WS(weakSelf);
        
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
