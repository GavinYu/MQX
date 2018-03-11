//
//  UIImage+YNCImage.h
//  YuneecApp
//
//  Created by yc-sh-vr-pc05 on 2017/6/10.
//  Copyright © 2017年 yuneec. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface UIImage (YNCImage)

#pragma mark 根据自定义的宽度等比例压缩图片
+ (UIImage *)imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth;
#pragma mark 根据自定义的大小等比例压缩图片
+ (UIImage *)imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size;
#pragma mark 根据自定义的大小等比例压缩图片
+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size;
#pragma mark 将图片转换成NSData
+ (NSData *)imageToData:(UIImage *)image;
+ (UIImage *)cutImage:(UIImage*)image withSize:(CGSize)size;
#pragma mark 从bundle资料包里获取图片
+ (UIImage *)imageWithContentsOfBundleResourceImageName:(NSString *)imageName;

@end

NS_ASSUME_NONNULL_END
