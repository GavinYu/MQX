//
//  YNCBlock.h
//  MQX
//
//  Created by yc-sh-vr-pc05 on 2018/3/3.
//  Copyright © 2018年 YunEEC. All rights reserved.
//

#import "YNCEnum.h"

#import <CoreGraphics/CoreGraphics.h>

@class UIView;

#ifndef YNCBlock_h
#define YNCBlock_h

NS_ASSUME_NONNULL_BEGIN

typedef void(^YNCEventBlock)(YNCEventAction eventAction);
typedef void(^YNCBackSendValueBlock)(id _Nullable sendData);
typedef void(^YNCUpdateSubViewBlock)(UIView *subView);
typedef void(^YNCStartHeadingCompletion)(CGFloat angle);
typedef void(^YNCErrorBlock)(NSError *_Nullable error);
typedef void(^YNCABECamCompletion)(id _Nullable object);

NS_ASSUME_NONNULL_END

#endif /* YNCBlock_h */
