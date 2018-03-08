//
//  YNCScrollLabelView.h
//  YuneecApp
//
//  Created by yc-sh-vr-pc05 on 2017/12/12.
//  Copyright © 2017年 yuneec. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YNCEnum.h"

@interface YNCScrollLabelView : UIView

@property (nonatomic, strong) NSString *text; /**< 文字*/
@property (nonatomic, strong) UIColor *textColor; /**< 字体颜色 默认白色*/
@property (nonatomic, strong) UIFont *textFont; /**< 字体大小 默认18*/
@property (nonatomic, assign) NSTextAlignment textAlignment; /**< 字体位置，默认居中*/

@property (nonatomic, assign) CGFloat space; /**< 首尾间隔 默认15*/
@property (nonatomic, assign) CGFloat velocity; /**< 滚动速度 pixels/second,默认5*/
@property (nonatomic, assign) NSTimeInterval pauseTimeIntervalBeforeScroll; /**< 每次开始滚动前暂停的间隔 默认0s*/

@property (nonatomic, assign) YNCModeDisplay currentDisplayMode;
/**
 *  重新进入前台，还能滚动
 */
- (void)addObaserverNotification;

@end
