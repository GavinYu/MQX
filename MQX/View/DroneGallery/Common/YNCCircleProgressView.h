//
//  YNCCircleProgressView.h
//  MQX
//
//  Created by yc-sh-vr-pc05 on 2018/3/17.
//  Copyright © 2018年 YunEEC. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YNCEnum.h"

@class YNCCircleProgressModel;
@protocol YNCCircleProgressDelegate <NSObject>

@optional
- (void)cancelDownload;

@end

@interface YNCCircleProgressView : UIView
@property (nonatomic, assign) CGFloat progress; // 0.0 ~ 1.0;
@property (nonatomic, assign) YNCFB_ProgressViewType type;
@property (nonatomic, weak) id <YNCCircleProgressDelegate> delegate;

+ (instancetype)circleProgress;
- (void)createSubViews;
- (void)configureSubviewWithModel:(YNCCircleProgressModel *)model;
@end
