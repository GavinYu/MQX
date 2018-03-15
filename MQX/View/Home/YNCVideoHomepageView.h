//
//  YNCVideoHomepageView.h
//  MQX
//
//  Created by yc-sh-vr-pc05 on 2018/3/11.
//  Copyright © 2018年 YunEEC. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YNCBlock.h"
#import "YNCVideoTimeView.h"

@class YNCFlightStatusView_Firebird;

@interface YNCVideoHomepageView : UIView

@property (nonatomic, strong) YNCFlightStatusView_Firebird *flightStatusView_fireBird;

@property (nonatomic, assign) int pitch;
@property (nonatomic, assign) int roll;
@property (assign, nonatomic) BOOL isShowVideoTimeView;
@property (strong, nonatomic) YNCVideoTimeView *videoTimeView;

+ (YNCVideoHomepageView *)instanceVideoHomepageView;

- (void)initSubView:(YNCModeDisplay)modeDisplay;
- (void)hiddenSubView:(BOOL)isHidden withDoubleClickCount:(NSInteger)count;

@end
