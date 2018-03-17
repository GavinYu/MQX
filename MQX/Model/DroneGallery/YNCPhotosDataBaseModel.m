//
//  YNCPhotosDataBaseModel.m
//  MediaEditor
//
//  Created by vrsh on 21/02/2017.
//  Copyright © 2017 Yuneec. All rights reserved.
//

#import "YNCPhotosDataBaseModel.h"

@implementation YNCPhotosDataBaseModel

- (id)initWithSingleKey:(NSString *)singleKey
             createDate:(NSString *)createDate
                 author:(NSString *)author
               location:(NSString *)location
                 device:(NSString *)device
                mermory:(NSString *)mermory
                  width:(int)width
                 height:(int)height
                   type:(YNCMediaType)type
{
    if (self = [super init]) {
        self.singleKey = singleKey;
        self.createDate = createDate;
        self.author = author;
        self.location = location;
        self.device = device;
        self.mermory = mermory;
        self.width = width;
        self.height = height;
        self.mediaType = type;
    }
    return self;
}

+ (id)photoDataBaseModelWithSingleKey:(NSString *)singleKey
                           createDate:(NSString *)createDate
                               author:(NSString *)author
                             location:(NSString *)location
                               device:(NSString *)device
                              mermory:(NSString *)mermory
                                width:(int)width
                               height:(int)height
                                 type:(YNCMediaType)type
{
    return [[YNCPhotosDataBaseModel alloc] initWithSingleKey:singleKey createDate:createDate author:author location:location device:device mermory:mermory width:width height:height type:type];
}

@end
