//
//  WTMediaModel.h
//  MQX
//
//  Created by yc-sh-vr-pc05 on 2018/3/24.
//  Copyright © 2018年 YunEEC. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YNCEnum.h"

@interface WTMediaModel : NSObject

/**
 *  Returns the type of media file.
 */
@property (nonatomic, assign) WTMediaType mediaType;

/**
 *  Returns the name of the media file.
 */
@property (nonatomic, copy) NSString *_Nonnull fileName;

/**
 *  Returns the time when the media file was created as a string in
 *  the format "YYYY-MMM-dd HH:mm:ss".
 */
@property (nonatomic, copy) NSString *_Nonnull createDate;

/**
 *  Returns the size (bytes) of the media file
 */
@property (nonatomic, copy) NSString *_Nonnull fileSize;

/**
 Returns MD5 of the media file
 */
@property (nonatomic, copy) NSString *_Nullable fileMD5;

/**
 *  If the media file is a video, this property returns the duration
 *  of the video in seconds.
 */
@property (nonatomic, assign) float videoDuration;

/**
 Returns thumbnail of the media file
 */
@property (nonatomic, strong) WTMediaModel *_Nullable thumbnailMedia;

/**
 Returns preview video of the media file
 */
@property (nonatomic, strong) WTMediaModel *_Nullable previewMedia;

@end
