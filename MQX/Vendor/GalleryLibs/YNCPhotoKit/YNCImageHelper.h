//
//  YNCImageHelper.h
//  MediaEditor
//
//  Created by vrsh on 2017/1/5.
//  Copyright © 2017年 Yuneec. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import "UIImage+Clip.h"
//#import "YNCImportView.h"
#import "YNCPhotosDataBaseModel.h"
#import "YNCEnum.h"

typedef NS_ENUM(NSInteger, AlbumType) {
    AlbumTypeDefault   = 0, // 默认
    AlbumTypeCumstom   = 1  // 自定义
};

typedef NS_ENUM(NSInteger, YNCDroneMediaType) {
    YNCDroneMediaTypeTubImage = 0,
    YNCDroneMediaTypeOriginImage,
    YNCDroneMediaTypeVideo
};

@interface YNCImageHelper : NSObject
/**
 获取相册列表
 
 @param complete callback
 */
+ (void)getAlbumListWithAscend:(BOOL)isAscend type:(YNCDisplayType)type complete:(void(^)(NSArray<PHFetchResult *> *albumList))complete;

/**
 通过 asset  获取 imageData
 
 @param asset asset
 @param complete image 压缩后的图片 / HDImage 高清图 原图
 */
+ (void)getImageDataWithAsset:(PHAsset*)asset complete:(void(^)(UIImage *HDImage))complete;

/**
 获取指定大小的图片
 
 @param asset asset
 @param size size
 @param complete callback
 */
+ (void)getImageWithAsset:(PHAsset*)asset targetSize:(CGSize)size complete:(void (^)(UIImage *))complete;

/**
 是否开启相册权限
 
 @return yes or no
 */
+ (BOOL)isOpenAuthority;


/**
 跳转到设置界面
 */
+ (void)jumpToSetting;

/**
 弹框
 @param title 标题
 @param message 消息
 @param controller 控制器
 @param isSingle 是否是单个选择
 @param leftBtnTitle 控制器
 @param rightBtnTitle 控制器
 */
+ (void)showAlertWithTittle:(NSString *)title
                    message:(NSString *)message
             showController:(UIViewController *)controller
             isSingleAction:(BOOL)isSingle
               leftBtnTitle:(NSString *)leftBtnTitle
              rightBtnTitle:(NSString *)rightBtnTitle
                   complete:(void (^)(NSInteger))complete;


/**
 直连时处理飞机数据

 @param url 地址
 @param complete 返回数据
 */
//+ (void)requestBreezeDroneInfoDataWithURL:(NSURL *)url complete:(void(^)(NSDictionary*, NSArray*))complete;




+ (NSURL *)getDronePhotoUrlWithTitle:(NSString *)title droneType:(YNCDroneMediaType)droneType;


/**
 获取YYImage缓存的key

 @param title 飞机图片名
 @param droneType 图片类型
 @return 返回url地址
 */
+ (NSURL *)getKeyOfYYCacheWithTitle:(NSString *)title droneType:(YNCDroneMediaType)droneType;


/**
 获取本地缓存数据

 @param mediaType 要获取数据的列表类型
 @param complete 返回获取到的数据,字典中存储所有的数据,数组中存储图片或视频的时间
 */
+ (void)getDataSourceWithMediaType:(YNCMediaType)mediaType
                          complete:(void(^)(NSDictionary *dataDictionary,
                                            NSArray *dateArray))complete;


/**
 用于解决从手机图库中导入的图片发生旋转的问题

 @param aImage 手机图库的图片资源
 @return 显示时不会旋转的图片资源
 */
+ (UIImage *)fixOrientation:(UIImage *)aImage;

/**
 创建缓存文件

 @param path 缓存路径
 */
+ (void)createCacheDirectoryWithPath:(NSString *)path;

/**
 获取当前时间

 @return 当前时间
 */
+ (NSString*)getCurrentTime;

/**
 将图片缓存到本地

 @param image 要缓存的图片
 @param path 缓存的路径
 @param compressionQuality 图片质量
 */
+ (void)writeImage:(UIImage *)image
            toPath:(NSString *)path
compressionQuality:(CGFloat)compressionQuality;

/**
 *  图片压缩到指定大小
 *  @param targetSize  目标图片的大小
 *  @param sourceImage 源图片
 *  @return 目标图片
 */
+ (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize withSourceImage:(UIImage *)sourceImage;

/**
 将图片保存到系统相册

 @param image 图片
 */
+ (void)saveImageToSystemPhotoWithImage:(UIImage *)image;

/**
 删除本地文件

 @param path 路径
 */
+ (void)deleteDataWithPath:(NSString *)path;

/**
 获取视频第一帧

 @param videoPath 视频路径
 @return 视频第一帧
 */
+ (UIImage *)getVideoFirstImageWithVideoPath:(NSString *)videoPath;


/**
 获取本地路径

 @param fileName 文件名
 @return 文件路径
 */
+ (NSString *)convertFileNameToDownloadLocationPath:(NSString *)fileName;


 + (void)writeData:(NSData *)data
     LocationPath:(NSString *)locationPath;

/**
 *  保存图片或者视频到系统相册
 *
 *  @param isPhoto Yes: 代表图片; No: 代表视频
 */
+ (void)savePhotosAndVideosToAlbumWithIsPhoto:(BOOL)isPhoto
                                    mediaPath:(NSString *)mediaPath;

@end



