//
//  YNCDroneGalleryBaseViewController.m
//  MQX
//
//  Created by yc-sh-vr-pc05 on 2018/3/17.
//  Copyright © 2018年 YunEEC. All rights reserved.
//

#import "YNCDroneGalleryBaseViewController.h"

@interface YNCDroneGalleryBaseViewController ()

@end

@implementation YNCDroneGalleryBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     [self addNotification];
}

- (void)addNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleCameraNotConnectNotification:) name:YNC_CAMERA_STATE_NOT_CONNECT_NOTIFICATION object:nil];
}

- (void)removeNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:YNC_CAMERA_STATE_NOT_CONNECT_NOTIFICATION object:nil];
}

- (void)handleCameraNotConnectNotification:(NSNotification *)notification
{
    
}

- (void)dealloc
{
    DLog(@"*********baseViewControllerDealloc");
    [self removeNotification];
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
