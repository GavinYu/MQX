//
//  YNCDroneNavigationModel.h
//  MQX
//
//  Created by yc-sh-vr-pc05 on 2018/3/17.
//  Copyright © 2018年 YunEEC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YNCDroneNavigationModel : NSObject

@property (nonatomic, assign) NSInteger videosAmount;
@property (nonatomic, assign) NSInteger photosAmount;
@property (nonatomic, assign) NSUInteger currentIndex;
@property (nonatomic, assign) NSUInteger totalMediasAmount;

@end
