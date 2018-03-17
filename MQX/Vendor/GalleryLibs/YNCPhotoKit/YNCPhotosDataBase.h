//
//  YNCPhotosDataBase.h
//  MediaEditor
//
//  Created by vrsh on 21/02/2017.
//  Copyright © 2017 Yuneec. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YNCPhotosDataBaseModel.h"

@interface YNCPhotosDataBase : NSObject

// 创建单例的接口
+ (YNCPhotosDataBase *)shareDataBase;

// 插入新数据
- (void)insertOnePhotoDataBase:(YNCPhotosDataBaseModel *)itemModel;

// 根据标题删除数据的接口
- (void)deleteOnePhotoDataBaseModelBySingleKey:(NSString *)singleKey
                                          type:(YNCMediaType)type;

// 根据标题查找一个下载资源的接口
- (YNCPhotosDataBaseModel *)selectOnePhotoDataBaseModelBySingleKey:(NSString *)singleKey
                                                              type:(YNCMediaType)type;

// 获取全部图片模型的接口
- (NSArray *)selectAllPhotosDataBaseModelWithType:(YNCMediaType)type;

@end
