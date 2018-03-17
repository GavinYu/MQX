//
//  YNCImageHelper.m
//  MediaEditor
//
//  Created by vrsh on 2017/1/5.
//  Copyright © 2017年 Yuneec. All rights reserved.
//

#import "YNCImageHelper.h"

#import "YNCDronePhotoInfoModel.h"
#import "YNCPhotosDataBase.h"
#import <Photos/Photos.h>
#import <ImageIO/ImageIO.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <CoreImage/CoreImage.h>
#import "YNCMacros.h"

@implementation YNCImageHelper

#pragma mark - 处理系统图册
+ (void)getAlbumListWithAscend:(BOOL)isAscend type:(YNCDisplayType)type complete:(void(^)(NSArray<PHFetchResult *> *albumList))complete
{
    PHFetchOptions * allPhotosOptions = [[PHFetchOptions alloc]init];
    allPhotosOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:isAscend]];
    //所有图片的集合
    PHFetchResult *allPhotos = nil;
    switch (type) {
        case YNCDisplayTypeSystemVideo:
        case YNCDisplayTypeVideoMake:
        {
            allPhotos = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeVideo options:allPhotosOptions];
        }
            break;
        case YNCDisplayTypeSystemPhoto:
        {
            allPhotos = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:allPhotosOptions];
        }
            break;
            
        default:
            break;
    }
    //自定义的
//    PHFetchOptions *option = [[PHFetchOptions alloc] init];
//    option.predicate = [NSPredicate predicateWithFormat:@"estimatedAssetCount > 0"];
////    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"selected" ascending:YES];
//    option.sortDescriptors = @[sortDescriptor];
//    
//    PHFetchResult *result = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:option];
//    
//    NSArray *list = @[allPhotos,result];
    
    if (allPhotos!=nil) {
        NSArray *list = @[allPhotos];
        complete?complete(list):nil;
    }
}

+ (void)getImageDataWithAsset:(PHAsset *)asset complete:(void (^)(UIImage*))complete
{
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    option.synchronous = YES;
//    option.networkAccessAllowed = YES;
//    NSLog(@"++++++++++++++%ld", asset.sourceType);
    @autoreleasepool {
        [[PHImageManager defaultManager] requestImageDataForAsset:asset options:option resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
            UIImage *HDImage = [UIImage imageWithData:imageData];
            complete?complete(HDImage):nil;
        }];
    }
}

+ (void)getImageWithAsset:(PHAsset*)asset targetSize:(CGSize)size complete:(void (^)(UIImage *))complete
{
    PHImageManager *imageManager = [PHImageManager defaultManager];
    [imageManager requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                complete?complete(result):nil;
            });
        });
    }];
}

+ (BOOL)isOpenAuthority
{
//    switch ([PHPhotoLibrary authorizationStatus]) {
//        case PHAuthorizationStatusNotDetermined:
//            NSLog(@"PHAuthorizationStatusNotDetermined");
//            break;
//        case PHAuthorizationStatusRestricted:
//            NSLog(@"PHAuthorizationStatusRestricted");
//            break;
//        case PHAuthorizationStatusAuthorized:
//            NSLog(@"PHAuthorizationStatusAuthorized");
//            break;
//        case PHAuthorizationStatusDenied:
//            NSLog(@"PHAuthorizationStatusDenied");
//            break;
//            
//        default:
//            break;
//    }
    return [PHPhotoLibrary authorizationStatus] != PHAuthorizationStatusDenied;
}

+ (void)jumpToSetting
{
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:^(BOOL success) {
            
        }];
    }
}

+ (void)showAlertWithTittle:(NSString *)title
                    message:(NSString *)message
             showController:(UIViewController *)controller
             isSingleAction:(BOOL)isSingle
               leftBtnTitle:(NSString *)leftBtnTitle
              rightBtnTitle:(NSString *)rightBtnTitle
                   complete:(void (^)(NSInteger))complete
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:leftBtnTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        complete?complete(0):nil;
    }];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:rightBtnTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        complete?complete(1):nil;
    }];
    if (!isSingle) {
        [alertController addAction:cancleAction];
    }
    [alertController addAction:confirmAction];
    [controller presentViewController:alertController animated:YES completion:nil];
}

//#pragma mark - 处理飞机图库
//+ (void)requestBreezeDroneInfoDataWithURL:(NSURL *)url complete:(void(^)(NSDictionary*, NSArray*))complete
//{
//    NSMutableArray *dateArray = [NSMutableArray array];
//    NSMutableDictionary *dataDictionary = [NSMutableDictionary dictionary];
//    OGNode *node = [ObjectiveGumbo parseDocumentWithUrl:url];
//    // n:标题, m:日期, s:数据大小
//    NSArray *titleArray = [node elementsWithClass:@"n"];
//    NSArray *sizeArray = [node elementsWithClass:@"s"];
//    for (int i = 0; i < titleArray.count; i++) {
//        OGElement *titleElement = titleArray[i];
//        OGText *titleText = titleElement.children.firstObject;
//        if ([titleText.text hasPrefix:@"Breeze"]) {
//            YNCDronePhotoInfoModel *dronePhotoInfo = [[YNCDronePhotoInfoModel alloc] init];
//            if ([titleText.text hasSuffix:@"2nd"]) {
//                dronePhotoInfo.title = [titleText.text substringToIndex:titleText.text.length - 4];
//                dronePhotoInfo.mediaType = YNCMediaTypeDroneVideo;
//                dronePhotoInfo.tubVideoDataSize = [self getDataSizeWithIndex:i sizeArray:sizeArray];
//                dronePhotoInfo.originVideoDataSize = [self getDataSizeWithIndex:i + 1 sizeArray:sizeArray];
//                dronePhotoInfo.tubImageDataSize = [self getDataSizeWithIndex:i + 2 sizeArray:sizeArray];
//                i = i + 2;
//            }
//            if ([titleText.text hasSuffix:@"JPG"]) {
//                dronePhotoInfo.title = [titleText.text substringToIndex:titleText.text.length - 4];
//                dronePhotoInfo.mediaType = YNCMediaTypeDronePhoto;
//                dronePhotoInfo.originImageDataSize = [self getDataSizeWithIndex:i sizeArray:sizeArray];
//                dronePhotoInfo.tubImageDataSize = [self getDataSizeWithIndex:i + 1 sizeArray:sizeArray];
//                i = i + 1;
//            }
//            NSString *date = [titleText.text substringWithRange:NSMakeRange(7, 6)];
//            date = [NSString stringWithFormat:@"20%@-%@-%@", [date substringWithRange:NSMakeRange(0, 2)], [date substringWithRange:NSMakeRange(2, 2)], [date substringWithRange:NSMakeRange(4, 2)]];
//            dronePhotoInfo.createDate = date;
//            NSMutableArray *array = [NSMutableArray array];
//            if (![dateArray containsObject:date]) {
//                [dateArray addObject:date];
//                [array addObject:dronePhotoInfo];
//            } else {
//                [array addObjectsFromArray:dataDictionary[date]];
//                [array addObject:dronePhotoInfo];
//            }
//
//            dataDictionary[date] = array;
//        }
//    }
//    complete?complete(dataDictionary, dateArray):nil;
//}

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
//    YuneecMediaManager *manager = [[YuneecMediaManager alloc] initWithCameraType:YuneecCameraTypeHDRacer];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        [manager fetchMediaWithCompletion:^(NSArray<YuneecMedia *> * _Nullable mediaArray, NSError * _Nullable error) {
//            if (error == nil) {
//                NSInteger videoAmount = 0;
//                NSInteger photoAmount = 0;
//                if (mediaArray.count > 0) {
////                    for (YuneecMedia *media in mediaArray) { // createDate格式year:month:day hour:minute:second
////                        NSString *createTime = [media.createDate componentsSeparatedByString:@" "].firstObject;
////                        NSArray *separatedDateArray = [createTime componentsSeparatedByString:@":"];
////                        createTime = [NSString stringWithFormat:@"%@-%@-%@", separatedDateArray[0], separatedDateArray[1], separatedDateArray[2]];
////                        if (media.mediaType == YuneecMediaTypeMP4) {
////                            ++videoAmount;
////                        } else if (media.mediaType == YuneecMediaTypeJPEG) {
////                            ++photoAmount;
////                        }
////                        NSMutableArray *array = [NSMutableArray array];
////                        if (![dateArray containsObject:createTime]) {
////                            [dateArray addObject:createTime];
////                            [array addObject:media];
////                        } else {
////                            [array addObjectsFromArray:dataDictionary[createTime]];
////                            [array addObject:media];
////                        }
////                        dataDictionary[createTime] = array;
////                    }
//
//                    NSArray *sortArray = [mediaArray sortedArrayUsingComparator:^NSComparisonResult(YuneecMedia *obj1, YuneecMedia *obj2) {
//                        return [obj2.createDate compare:obj1.createDate];
//                    }];
//
//                    for (YuneecMedia *media in sortArray) {
//                        // createDate格式year:month:day hour:minute:second
//                        NSString *createTime = [media.createDate componentsSeparatedByString:@" "].firstObject;
//                        NSArray *separatedDateArray = [createTime componentsSeparatedByString:@":"];
//                        createTime = [NSString stringWithFormat:@"%@-%@-%@", separatedDateArray[0], separatedDateArray[1], separatedDateArray[2]];
//                        if (media.mediaType == YuneecMediaTypeMP4) {
//                            ++videoAmount;
//                        } else if (media.mediaType == YuneecMediaTypeJPEG) {
//                            ++photoAmount;
//                        }
//                        NSMutableArray *array = [NSMutableArray array];
//                        if (![dateArray containsObject:createTime]) {
//                            [dateArray addObject:createTime];
//                            [array addObject:media];
//                        } else {
//                            [array addObjectsFromArray:dataDictionary[createTime]];
//                            [array addObject:media];
//                        }
//                        dataDictionary[createTime] = array;
//                    }
//
//
////                    for (NSString *date in dateArray) {
////                        NSArray *sortedArray = dataDictionary[date];
////                        NSArray *newArray = [sortedArray sortedArrayUsingComparator:^NSComparisonResult(YuneecMedia *obj1, YuneecMedia *obj2) {
////                            return [obj2.createDate compare:obj1.createDate];
////                        }];
////                        dataDictionary[date] = newArray;
////                    }
//                    [dateArray sortUsingSelector:@selector(compare:)];
//                    //通过倒序的方法进行降序排列
//                    NSEnumerator *enumerator = [dateArray reverseObjectEnumerator];
//                    dateArray =[[NSMutableArray alloc] initWithArray: [enumerator allObjects]];
//
//                    complete?complete(dataDictionary,
//                                      dateArray,
//                                      sortArray,
//                                      videoAmount,
//                                      photoAmount,
//                                      error):nil;
//                }
//            } else {
//                complete(nil, nil, nil, 0, 0, error);
//            }
//        }];
//    });
}

+ (NSURL *)getDronePhotoUrlWithTitle:(NSString *)title droneType:(YNCDroneMediaType)droneType
{
    NSString *urlStr = nil;
    switch (droneType) {
        case YNCDroneMediaTypeTubImage:
            urlStr = [Document_Download stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.thm", title]];
            break;
        case YNCDroneMediaTypeVideo:
            urlStr = [Document_Download stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.2nd", title]];
            break;
        case YNCDroneMediaTypeOriginImage:
            urlStr = [Document_Download stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.JPG", title]];
            break;
    }
    NSURL *url = [NSURL URLWithString:urlStr];
    return url;
}

+ (NSURL *)getKeyOfYYCacheWithTitle:(NSString *)title droneType:(YNCDroneMediaType)droneType
{
    NSString *key = nil;
    if (droneType == YNCDroneMediaTypeTubImage) {
        key = [kURL_Breeze_2DCIM stringByAppendingString:[NSString stringWithFormat:@"%@.thm", title]];
    } else if (droneType == YNCDroneMediaTypeOriginImage) {
        key = [kURL_Breeze_2DCIM stringByAppendingString:[NSString stringWithFormat:@"%@.JPG", title]];
    }
    
    if (key!=nil) {
        NSURL *keyUrl = [NSURL URLWithString:key];
        return keyUrl;
    } else {
        return nil;
    }
}

+ (void)getDataSourceWithMediaType:(YNCMediaType)mediaType
                          complete:(void(^)(NSDictionary *dataDictionary,
                                            NSArray *dateArray))complete
{
    NSArray *array = [[YNCPhotosDataBase shareDataBase] selectAllPhotosDataBaseModelWithType:mediaType];
    NSMutableArray *dateArray = [NSMutableArray arrayWithCapacity:0];
    NSMutableDictionary *dataDictionary = [NSMutableDictionary dictionaryWithCapacity:0];
    for (YNCPhotosDataBaseModel *model in array) {
        if (![dateArray containsObject:model.createDate]) {
            if (model.createDate) {
                [dateArray addObject:model.createDate];
            }
        }
        NSMutableArray *modelArray = [NSMutableArray arrayWithCapacity:0];
        if ([dataDictionary.allKeys containsObject:model.createDate]) {
            [modelArray addObjectsFromArray:dataDictionary[model.createDate]];
        }
        switch (model.mediaType) {
            case YNCMediaTypeDronePhoto:
            {
                YNCDronePhotoInfoModel *photoInfo = [[YNCDronePhotoInfoModel alloc] init];
                photoInfo.createDate = model.createDate;
                photoInfo.title = model.singleKey;
                photoInfo.originImageDataSize = model.mermory;
                photoInfo.mediaType = YNCMediaTypeDronePhoto;
                photoInfo.pixelWidth = model.width;
                photoInfo.pixelHeight = model.height;
                [modelArray insertObject:photoInfo atIndex:0];
            }
                break;
            case YNCMediaTypeDroneVideo:
            {
                YNCDronePhotoInfoModel *photoInfo = [[YNCDronePhotoInfoModel alloc] init];
                photoInfo.createDate = model.createDate;
                photoInfo.title = model.singleKey;
                photoInfo.originImageDataSize = model.mermory;
                photoInfo.mediaType = YNCMediaTypeDroneVideo;
                photoInfo.pixelWidth = model.width;
                photoInfo.pixelHeight = model.height;
                [modelArray insertObject:photoInfo atIndex:0];
            }
                break;
            case YNCMediaTypeSystemVideo:
            case YNCMediaTypeSystemPhoto:
            {
                PHAsset *asset = nil;
                PHFetchResult *fetchResult = [PHAsset fetchAssetsWithLocalIdentifiers:@[model.singleKey] options:nil];
                if (fetchResult.count > 0) {
                    asset = fetchResult[0];
                    [modelArray insertObject:asset atIndex:0];
                } else {
                    [[YNCPhotosDataBase shareDataBase] deleteOnePhotoDataBaseModelBySingleKey:model.singleKey type:model.mediaType];
                }
            }
                break;
            case YNCMediaTypeEditedPhoto:
            case YNCMediaTypeEditedVideo:
            {
                YNCDronePhotoInfoModel *photoInfo = [[YNCDronePhotoInfoModel alloc] init];
                photoInfo.createDate = model.createDate;
                photoInfo.title = model.singleKey;
                photoInfo.mediaType = model.mediaType;
                photoInfo.pixelWidth = model.width;
                photoInfo.pixelHeight = model.height;
                [modelArray insertObject:photoInfo atIndex:0];
            }
                break;
            default:
                break;
        }
        if (modelArray.count > 0) {
            if (model.createDate) {
                dataDictionary[model.createDate] = modelArray;
            }
        } else {
            [dateArray removeObject:model.createDate];
        }
    }
    dateArray = [dateArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj2 compare:obj1];
    }].mutableCopy;
    
    complete?complete(dataDictionary, dateArray):nil;
}

/**
 * 修复系统图库导入图片的orientation值不为0的情况
 */
+ (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

+ (void)createCacheDirectoryWithPath:(NSString *)path
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:path]) {
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:NULL];
    }
}

#pragma mark - 获取当前的时间
+ (NSString*)getCurrentTime
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyMMddHHmmss"];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    return dateTime;
}

#pragma mark - 将图片写入本地
+ (void)writeImage:(UIImage *)image
            toPath:(NSString *)path
compressionQuality:(CGFloat)compressionQuality
{
    NSData *data = UIImageJPEGRepresentation(image, compressionQuality);
    [data writeToFile:path atomically:YES];
}

#pragma mark - 将图片压缩到指定大小
+ (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize withSourceImage:(UIImage *)sourceImage
{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth= width * scaleFactor;
        scaledHeight = height * scaleFactor;
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else if (widthFactor < heightFactor)
        {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width= scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil)
        NSLog(@"could not scale image");
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}



#pragma mark - 将图片保存到系统相册
+ (void)saveImageToSystemPhotoWithImage:(UIImage *)image
{
    UIImageWriteToSavedPhotosAlbum(image, NULL, NULL, NULL);
//    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
//    [library writeImageToSavedPhotosAlbum:image.CGImage metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) {
//        if (!error) {
//
//        }
//    }];
}

#pragma mark - 删除本地资源
+ (void)deleteDataWithPath:(NSString *)path
{
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
}

#pragma mark - 获取视频第一帧
+ (UIImage *)getVideoFirstImageWithVideoPath:(NSString *)videoPath
{
    NSURL *videoURL = [NSURL fileURLWithPath:videoPath];
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *img = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return img;
}

+ (NSString *)convertFileNameToDownloadLocationPath:(NSString *)fileName
{
    NSFileManager *tmpManager = [NSFileManager defaultManager];
    if (![tmpManager fileExistsAtPath:Document_Download]) {
        [tmpManager createDirectoryAtPath:Document_Download withIntermediateDirectories:YES attributes:@{} error:nil];
    }

    NSString *path = [Document_Download stringByAppendingPathComponent:fileName];
    return path;
}

+ (void)writeData:(NSData *)data
     LocationPath:(NSString *)locationPath
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:locationPath]) {
        NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:locationPath];
        [fileHandle seekToEndOfFile];
        [fileHandle writeData:data];
        [fileHandle closeFile];
    } else {
        [data writeToFile:locationPath atomically:YES];
    }
}


/**
 *  保存图片或者视频到系统相册
 *
 *  @param isPhoto Yes: 代表图片; No: 代表视频
 */
+ (void)savePhotosAndVideosToAlbumWithIsPhoto:(BOOL)isPhoto
                                   mediaPath:(NSString *)mediaPath
{
    ALAuthorizationStatus authStatus = [ALAssetsLibrary authorizationStatus];
    if (authStatus == ALAuthorizationStatusDenied || authStatus == ALAuthorizationStatusRestricted) {
        // 没有权限
//        [self showAlertInViewController:viewController
//                                  title:@""
//                                message:@""
//                           leftBtnTitle:@""
//                          rightBtnTitle:@""];
    }else{
        // 已经获取权限
        if (isPhoto) {
            [self saveToPhotosAlbum:mediaPath];
        } else {
            [self saveVideoToPhotos:mediaPath];
        }
    }
}


+ (void)showAlertInViewController:(UIViewController *)viewController
                            title:(NSString *)title
                          message:(NSString *)message
                     leftBtnTitle:(NSString *)leftBtnTitle
                    rightBtnTitle:(NSString *)rightBtnTitle
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:message
                                                                      preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:leftBtnTitle
                                                          style:(UIAlertActionStyleDefault)
                                                        handler:^(UIAlertAction * _Nonnull action) {
        //跳入当前App设置界面,
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }];
    UIAlertAction *alertAction_1 = [UIAlertAction actionWithTitle:rightBtnTitle
                                                            style:(UIAlertActionStyleCancel)
                                                          handler:^(UIAlertAction * _Nonnull action) {
        [viewController dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alertController addAction:alertAction];
    [alertController addAction:alertAction_1];
    [viewController presentViewController:alertController animated:YES completion:nil];
    
}


#pragma mark - 将图片保存到系统相册
+ (void)saveToPhotosAlbum:(NSString *)filePath {
    [self createdCollection];
    [self saveImageIntoAlbumWithUrl:[NSURL fileURLWithPath:filePath]];
}
#pragma mark - 将视频保存到系统相册
+ (void)saveVideoToPhotos:(NSString *)filePath {
    [self createdCollection];
    [self saveVideoIntoAlbumWithUrl:[NSURL fileURLWithPath:filePath]];
}

#pragma mark - 在系统相册自定义文件夹
/**
 *  获得自定义相册
 *
 *  @return 自定义相册
 */
+ (PHAssetCollection *)createdCollection
{
    // 获取软件的名字作为相册的标题
    NSString *title = [NSBundle mainBundle].infoDictionary[(NSString *)kCFBundleNameKey];
    // 获得所有的自定义相册
    PHFetchResult<PHAssetCollection *> *collections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    for (PHAssetCollection *collection in collections) {
        if ([collection.localizedTitle isEqualToString:title]) {
            return collection;
        }
    }
    // 代码执行到这里，说明还没有自定义相册
    __block NSString *createdCollectionId = nil;
    // 创建一个新的相册
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        createdCollectionId = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:title].placeholderForCreatedAssetCollection.localIdentifier;
    } error:nil];
    if (createdCollectionId == nil) return nil;
    // 创建完毕后再取出相册
    return [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[createdCollectionId] options:nil].firstObject;
}

/**
 *  获得刚才添加到相机胶卷的照片
 *
 *  @param url 要加入相机胶卷的照片
 *
 *  @return 添加到相机胶卷的照片
 */
+ (PHFetchResult<PHAsset *> *)createdImageAssetsWithUrl:(NSURL *)url
{
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *image = [UIImage imageWithData:data];
    __block NSString *createdAssetId = nil;
    
    // 添加图片到相机胶卷
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        createdAssetId = [PHAssetChangeRequest creationRequestForAssetFromImage:image].placeholderForCreatedAsset.localIdentifier;
    } error:nil];
    
    if (createdAssetId == nil) return nil;
    
    // 在保存完毕后取出图片
    return [PHAsset fetchAssetsWithLocalIdentifiers:@[createdAssetId] options:nil];
}

/**
 *  获得刚才添加到相机胶卷的视频
 *
 *  @param url 要加入相机胶卷的视频
 *
 *  @return 添加到相机胶卷的视频
 */
+ (PHFetchResult<PHAsset *> *)createdVideoAssetsWithUrl:(NSURL *)url
{
    __block NSString *createdAssetId = nil;
    // 添加视频到相机胶卷
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        createdAssetId = [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:url].placeholderForCreatedAsset.localIdentifier;
    } error:nil];
    if (createdAssetId == nil) {
        return nil;
    }
    // 保存完毕后取出视频
    return [PHAsset fetchAssetsWithLocalIdentifiers:@[createdAssetId] options:nil];
}

/**
 *  保存图片到相册
 *
 *  @param url 本地图片路径
 */
+ (void)saveImageIntoAlbumWithUrl:(NSURL *)url
{
    // 获得相片
    PHFetchResult<PHAsset *> *createdAssets = [self createdImageAssetsWithUrl:url];
    // 获得相册
    PHAssetCollection *createdCollection = [self createdCollection];
    if (createdAssets == nil || createdCollection == nil) {
        //        [SVProgressHUD showErrorWithStatus:@"保存失败！"];
        return;
    }
    // 将相片添加到相册
    NSError *error = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        PHAssetCollectionChangeRequest *request = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:createdCollection];
        [request insertAssets:createdAssets atIndexes:[NSIndexSet indexSetWithIndex:0]];
    } error:&error];
    // 保存结果
    if (error) {
        //        [SVProgressHUD showErrorWithStatus:@"保存失败！"];
    } else {
        //        [SVProgressHUD showSuccessWithStatus:@"保存成功！"];
    }
}

/**
 *  保存视频到相册
 *
 *  @param url 本地视频路径
 */
+ (void)saveVideoIntoAlbumWithUrl:(NSURL *)url
{
    // 获得相片
    PHFetchResult<PHAsset *> *createdAssets = [self createdVideoAssetsWithUrl:url];
    // 获得相册
    PHAssetCollection *createdCollection = [self createdCollection];
    if (createdAssets == nil || createdCollection == nil) {
        //        [SVProgressHUD showErrorWithStatus:@"保存失败！"];
        return;
    }
    // 将相片添加到相册
    NSError *error = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        PHAssetCollectionChangeRequest *request = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:createdCollection];
        [request insertAssets:createdAssets atIndexes:[NSIndexSet indexSetWithIndex:0]];
    } error:&error];
    // 保存结果
    if (error) {
        //        [SVProgressHUD showErrorWithStatus:@"保存失败！"];
    } else {
        //        [SVProgressHUD showSuccessWithStatus:@"保存成功！"];
    }
}





@end


