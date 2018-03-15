//
//  YNCBaseViewController.h
//  MQX
//
//  Created by yc-sh-vr-pc05 on 2018/3/15.
//  Copyright © 2018年 YunEEC. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YNCAppConfig.h"

@interface YNCBaseViewController : UIViewController
{
    FBKVOController *_kvoController;
}
//绑定viewmodel
- (void)bindViewModel;

@end
