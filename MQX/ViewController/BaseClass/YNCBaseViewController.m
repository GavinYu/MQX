//
//  YNCBaseViewController.m
//  MQX
//
//  Created by yc-sh-vr-pc05 on 2018/3/15.
//  Copyright © 2018年 YunEEC. All rights reserved.
//

#import "YNCBaseViewController.h"

@interface YNCBaseViewController ()

@end

@implementation YNCBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [UIViewController attemptRotationToDeviceOrientation];
    // Do any additional setup after loading the view.
    
    [self bindViewModel];
}

//MAKR: -- 绑定viewmodel
- (void)bindViewModel {
    _kvoController = [[FBKVOController alloc] initWithObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
