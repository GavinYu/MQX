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
    [self bindViewModel];
    // Do any additional setup after loading the view.
    [self configABECamHandle];
    [self openAbeCamStream];
}

- (void)dealloc {
    [self destroyAbeCamStream];
    [[AbeCamHandle sharedInstance] removeLiveView];
}

//MARK: -- 配置ABECam 显示图传界面
- (void)configABECamHandle {
    [[AbeCamHandle sharedInstance] addLiveViewToSuperView:self.view Rect:self.view.bounds dualView:NO];
}

//MARK: -- 打开 AbeCam
- (void)openAbeCamStream {
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
- (void)destroyAbeCamStream {
    [[AbeCamHandle sharedInstance] closeLiveVideoResult:^(BOOL succeeded) {
        if (succeeded) {
            [[AbeCamHandle sharedInstance] closeVideo];
        }
    }];
    
    [[AbeCamHandle sharedInstance] clearFrame];
}

//MARK: -- 绑定ViewModel
- (void)bindViewModel {
    WS(weakSelf);
    [self.kvoController observe:[YNCABECamManager sharedABECamManager] keyPath:@"WiFiConnected" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
        BOOL tmpWiFiConnected = [change[NSKeyValueChangeNewKey] boolValue];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (tmpWiFiConnected) {
                [weakSelf openAbeCamStream];
            } else {
                [weakSelf destroyAbeCamStream];
            }
        });
    }];
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
