//
//  MainViewController.m
//  MQX
//
//  Created by yc-sh-vr-pc05 on 2018/2/28.
//  Copyright © 2018年 YunEEC. All rights reserved.
//

#import "MainViewController.h"

#import "YNCABECamManager.h"
#import <ABECam/ABECam.h>

@interface MainViewController ()

@end

@implementation MainViewController

//MARK: -- View life methods
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //ABECam connect TalkSession
    if ([YNCABECamManager sharedABECamManager].WiFiConnected) {
        [[AbeCamHandle sharedInstance] connectedTalkSession];
    }
    
    //配置子视图
    [self configSubView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBarHidden = NO;
    
    [super viewWillDisappear:animated];
}

- (void)dealloc {
    [[AbeCamHandle sharedInstance] disconnectedTalkSession];
}

//MARK: -- 初始化子视图
- (void)configSubView {
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
