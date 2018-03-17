//
//  UIImage+Clip.h
//  PhotoKit
//
//  Created by 田向阳 on 2016/12/6.
//  Copyright © 2016年 田向阳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Clip)
//  压缩图片
-(UIImage *) imageCompressForTargetSize:(CGSize)size;
// 压缩到指定大小
//+ (UIImage *)clipImage:(UIImage*)image;

/**
 *将图片缩放到指定的CGSize大小
 * UIImage image 原始的图片
 * CGSize size 要缩放到的大小
 */
+ (UIImage*)image:(UIImage *)image scaleToSize:(CGSize)size;

/**
 *从图片中按指定的位置大小截取图片的一部分
 * UIImage image 原始的图片
 * CGRect rect 要截取的区域
 */
+(UIImage *)imageFromImage:(UIImage *)image inRect:(CGRect)rect;

/**
 *根据给定的size的宽高比自动缩放原图片、自动判断截取位置,进行图片截取
 * UIImage image 原始的图片
 * CGSize size 截取图片的size
 */
- (UIImage *)clipImage:(UIImage *)image toRect:(CGSize)size;


- (UIImage *)croppedImageWithFrame:(CGRect)frame angle:(NSInteger)angle circularClip:(BOOL)circular;


@end
