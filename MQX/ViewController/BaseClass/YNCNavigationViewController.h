//
//  YNCNavigationViewController.h
//  YuneecApp
//
//  Created by yc-sh-vr-pc05 on 2017/6/13.
//  Copyright © 2017年 yuneec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YNCNavigationViewController : UINavigationController

//旋转方向 默认竖屏
@property (nonatomic , assign) UIInterfaceOrientation interfaceOrientation;
@property (nonatomic , assign) UIInterfaceOrientationMask interfaceOrientationMask;

@end
