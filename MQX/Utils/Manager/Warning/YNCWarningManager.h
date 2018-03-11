//
//  YNCWarningManager.h
//  YuneecApp
//
//  Created by yc-sh-vr-pc05 on 2017/5/20.
//  Copyright © 2017年 yuneec. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YNCSingleton.h"
#import "YNCWarningConstMacro.h"
#import "YNCEnum.h"
#import <UIKit/UIKit.h>

@interface YNCWarningManager : NSObject

@property (strong, nonatomic) NSMutableArray *thirdWarningArray;
@property (strong, nonatomic) NSMutableDictionary *secondWarningMsgDictionary;

@property (strong, nonatomic) NSMutableArray *secondWarningViewArray;
@property (strong, nonatomic) NSMutableArray *leftSecondWarningViewArray;
@property (strong, nonatomic) NSMutableArray *rightSecondWarningViewArray;

@property (strong, nonatomic) NSMutableArray *thirdWarningViewArray;
@property (strong, nonatomic) NSMutableArray *leftThirdWarningViewArray;
@property (strong, nonatomic) NSMutableArray *rightThirdWarningViewArray;

@property (strong, nonatomic) UIView *containerView;


YNCSingletonH(WarningManager)

//显示警告
- (void)showWarningViewInViewWithObject:(id)object withModeDisplay:(YNCModeDisplay)display withDirectCode:(NSInteger)directCode;
- (NSMutableDictionary *)getSecondWarningMsg;
// 根据警告通知，得知警告等级类型
- (YNCWarningLevel)getWarningType:(NSInteger)type;
- (void)removeSecondWarningView:(id)object;
- (void)removeAllSecondWarningMsgAndWarningView;
//HD Racer 根据警告errorFlag转换成 "警告系统"对应的WarningCode
+ (int)HDRacerErrorFlagConvertWarningCode:(int)errorFlag;
@end
