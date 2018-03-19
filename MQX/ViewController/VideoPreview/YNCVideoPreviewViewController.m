//
//  YNCVideoPreviewViewController.m
//  MQX
//
//  Created by yc-sh-vr-pc05 on 2018/3/3.
//  Copyright © 2018年 YunEEC. All rights reserved.
//

#import "YNCVideoPreviewViewController.h"

#import "YNCABECamManager.h"
#import "YNCAppConfig.h"


@interface YNCVideoPreviewViewController () <AbeCamHandleDelegate>

@end

@implementation YNCVideoPreviewViewController

//MARK: -- View life methods
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    // Do any additional setup after loading the view.
    [self configABECamHandle];
}

- (void)dealloc {
    [self destroyAbeCam];
}

//MARK: -- 配置ABECam 显示图传界面
- (void)configABECamHandle {
    [[AbeCamHandle sharedInstance] addLiveViewToSuperView:self.view Rect:self.view.bounds dualView:NO];
    [AbeCamHandle sharedInstance].delegate = self;//最先设置好 first set delegate
    
    if ([[AbeCamHandle sharedInstance] checkTalkSeesion]) {
        [[AbeCamHandle sharedInstance] openLiveVideoResult:^(BOOL succeeded) {
            if (succeeded) {
                // should chose right mode
                //                    [[AbeCamHandle sharedInstance] openVideo:mode720];
                BOOL tmp = [[AbeCamHandle sharedInstance] openVideo:mode7218];
                DLog(@"open stream %@", tmp==YES?@"succeed":@"failed");
            }else{
                DLog(@"open failed");
            }
        }];
    }else{
        DLog(@"talk session disconnect, reconnect");
    }
}

//MARK: -- 销毁 AbeCam
- (void)destroyAbeCam {
    [[AbeCamHandle sharedInstance] closeVideo];
    [[AbeCamHandle sharedInstance] clearFrame];
    [[AbeCamHandle sharedInstance] removeLiveView];
}

//MARK: -- AbeCamHandleDelegate methods
//MARK: -- 检查WiFi错误
-(void)checkWifiError {
    DLog(@"[%s  %d], thread: %@", __func__, __LINE__, [NSThread currentThread]);
}

-(void)liveStreamDidConnected {
    DLog(@"[%d %s], %@ ", __LINE__, __func__, [NSThread currentThread]);
}

-(void)liveStreamDidDisconnected {
    DLog(@"[%d %s], %@ ", __LINE__, __func__, [NSThread currentThread]);
    
}

//-(void)liveStreamConnectedFailed;
-(void)liveStreamDidRcvFrm {
    //        DLog(@"[%d %s], %@ ", __LINE__, __func__, [NSThread currentThread]);
}

-(void)liveStreamRcvErrData {
    DLog(@"[%s  %d], thread: %@", __func__, __LINE__, [NSThread currentThread]);
}

-(void)talkSessonDidConnected {
    DLog(@"[%d %s], %@ ", __LINE__, __func__, [NSThread currentThread]);
    
    [[AbeCamHandle sharedInstance] syncTime:[NSDate date] result:^(BOOL succeeded) {
        if (succeeded) {
            DLog(@"sync time success");
            
        }else{
            DLog(@"sync time failed");
        }
    }];
}

-(void)talkSessonDidDisconnected {
    //    DLog(@"[%d %s], %@ ", __LINE__, __func__, [NSThread currentThread]);
}

-(void)recordStart {
    DLog(@"[%d %s], %@ ", __LINE__, __func__, [NSThread currentThread]);
}

-(void)recordWriteFrame {
    DLog(@"[%d %s], %@ ", __LINE__, __func__, [NSThread currentThread]);
    
}

-(void)recordStop {
    DLog(@"[%d %s], %@ ", __LINE__, __func__, [NSThread currentThread]);
}
//MARK: -- 当前视频转换为图像格式 current video to uiimage
-(void)getCurrentVideoToImg:(UIImage *)img
{
    DLog(@"[%s  %d], thread: %@", __func__, __LINE__, [NSThread currentThread]);
//    imgView.image = img;
}

//MARK: --  ReceiveMemoryWarning
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
