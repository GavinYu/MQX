//
//  YNCVideoTimeView.h
//  MQX
//
//  Created by yc-sh-vr-pc05 on 2018/3/3.
//  Copyright © 2018年 YunEEC. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YNCEnum.h"

@interface YNCVideoTimeView : UIView

@property (nonatomic, assign) BOOL showTimeLabel;
@property (nonatomic, copy) NSString *recordTimeInSecond;

+ (YNCVideoTimeView *)instanceVideoTimeView;
- (void)initSubView:(YNCModeDisplay)display;

@end
