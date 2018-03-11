//
//  YNCWarningView.h
//  YuneecApp
//
//  Created by yc-sh-vr-pc05 on 2017/3/20.
//  Copyright © 2017年 yuneec. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YNCEnum.h"

#define yAnimationDuration 0.3
#define yAutoDismissDuration 3.0

@class YNCWarningView;

typedef void(^YNCWhichCloseBtnBlock)(YNCWarningView *warningView);

@interface YNCWarningView : UIView

@property (weak, nonatomic) IBOutlet UIButton *closeButton;

@property (copy, nonatomic) YNCWhichCloseBtnBlock closeBtnBlock;
@property (assign, nonatomic, readonly) YNCWarningLevel warningLevel;

@property (strong, nonatomic) UIView *containerView;

+ (YNCWarningView *)instanceWarningView;

- (void)initSubView:(NSString *)message withWarningType:(YNCWarningLevel)warningLevel withModeDisplay:(YNCModeDisplay)display;

- (IBAction)clickCloseButton:(UIButton *)sender;

- (void)showInViewWithOriginY:(CGFloat)originY;

- (void)setWarningViewIconAndTitleColor:(BOOL)isSucceed;
- (void)disMissWarningView:(NSTimeInterval)duration;

@end
