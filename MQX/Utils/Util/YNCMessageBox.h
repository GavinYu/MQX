//
//  YNMessageBox.h
//  SkyViewS
//
//  Created by kenny on 16/8/1.
//  Copyright © 2016年 Gavin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>


typedef enum : NSUInteger {
    YNMessageBoxStyleClear,
    YNMessageBoxStyleGray,
    YNMessageBoxStyleRed,
    YNMessageBoxStyleBlue,
} YNMessageBoxStyle;

//视频流显示模式：单屏、双屏
typedef NS_ENUM(int, YCModeDisplay)  {
    YCModeDisplayNormal = 0,
    YCModeDisplayGlass,
};

typedef void(^YNMessageBoxCallback)(void);

@class UILabel;
@class UIView;
@interface YNCMessageBox : NSObject

+ (YNCMessageBox *)instance;
/**
 *  在屏幕中间显示提示消息， 默认1秒钟后消息自动消失
 *
 *  @param text 文本
 */
-(void)show:(NSString *)text;
//-(void)show:(NSString *)text withDisplayModel:(YCModeDisplay)displayModel;

/**
 * 移除警告
 */
- (void)removeFPVWarningView;

//- (void)showFPVWarningView;

@property (nonatomic, strong) YNMessageBoxCallback onClick;

@property (nonatomic, assign) YCModeDisplay currentDisplayModel;         //当前的显示模式（单屏or双屏）

@property (nonatomic, strong) UIView *warningView;
@property (nonatomic, strong) UIView *rightWarningView;
@property (nonatomic, assign) CGFloat animateDuration;

@end
