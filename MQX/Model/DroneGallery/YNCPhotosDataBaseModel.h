//
//  YNCPhotosDataBaseModel.h
//  MediaEditor
//
//  Created by vrsh on 21/02/2017.
//  Copyright © 2017 Yuneec. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YNCDronePhotoInfoModel.h"

@interface YNCPhotosDataBaseModel : NSObject

@property (nonatomic, copy) NSString *singleKey;
@property (nonatomic, copy) NSString *createDate;
@property (nonatomic, copy) NSString *author;
@property (nonatomic, copy) NSString *location;
@property (nonatomic, copy) NSString *device;
@property (nonatomic, assign) int width;
@property (nonatomic, assign) int height;
@property (nonatomic, assign) YNCMediaType mediaType;
@property (nonatomic, copy) NSString *mermory;

+ (id)photoDataBaseModelWithSingleKey:(NSString *)singleKey
                           createDate:(NSString *)createDate
                               author:(NSString *)author
                             location:(NSString *)location
                               device:(NSString *)device
                              mermory:(NSString *)mermory
                                width:(int)width
                               height:(int)height
                                 type:(YNCMediaType)type;

@end
