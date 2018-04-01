//
//  YNCDronePhotoInfoModel.h
//  MQX
//
//  Created by yc-sh-vr-pc05 on 2018/3/17.
//  Copyright © 2018年 YunEEC. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CoreGraphics/CoreGraphics.h>

typedef NS_ENUM(NSInteger, YNCMediaType)
{
    YNCMediaTypeSystemPhoto = 1,
    YNCMediaTypeSystemVideo,
    YNCMediaTypeDronePhoto,
    YNCMediaTypeDroneVideo,
    YNCMediaTypeEditedPhoto,
    YNCMediaTypeEditedVideo
};

@interface YNCDronePhotoInfoModel : NSObject

@property (nonatomic, copy) NSString *createDate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *tubImageDataSize;
@property (nonatomic, copy) NSString *originImageDataSize;
@property (nonatomic, copy) NSString *tubVideoDataSize;
@property (nonatomic, copy) NSString *originVideoDataSize;
@property (nonatomic, assign) CGFloat pixelWidth;
@property (nonatomic, assign) CGFloat pixelHeight;

@property (nonatomic, assign) YNCMediaType mediaType;
@property (nonatomic, copy) NSString *filePath;
@end
