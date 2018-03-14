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

#import "YNCAppConfig.h"
#import <QuartzCore/QuartzCore.h>
#import "YNCPopWindowView.h"
#import "AppDelegate.h"
#import "YNCScrollLabelView.h"
#import "YNCNavigationViewController.h"
#import "YNCDeviceInfoDataModel.h"

static const CGFloat kAnimationBGColorDuration = 0.5;
static CGFloat kDroneNameFontSize = 38.0f;

@interface MainViewController () <UIScrollViewDelegate>

@property (strong, nonatomic) NSMutableArray *droneImageArray;

@property (weak, nonatomic) IBOutlet UIView *referView;
@property (weak, nonatomic) IBOutlet UIButton *connectionStatusButton;
@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;
@property (weak, nonatomic) IBOutlet UILabel *droneNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *downArrowImage;
@property (weak, nonatomic) IBOutlet UIButton *droneTypeSelectionButton;
@property (weak, nonatomic) IBOutlet YNCScrollLabelView *tipsView;
@property (weak, nonatomic) IBOutlet UIButton *readyToFlyButton;
@property (weak, nonatomic) IBOutlet UIButton *buyInfoButton;

@property (strong, nonatomic) CAGradientLayer *gradient;

@end

@implementation MainViewController

//MARK: -- View life methods
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //ABECam connect TalkSession
    if ([YNCABECamManager sharedABECamManager].WiFiConnected) {
        [[AbeCamHandle sharedInstance] connectedTalkSession];
        [self getDroneDeviceInfo];
    }
    
    //配置子视图
    [self configSubView];
    
    [self addNotifications];
    
    [self autolayout];
    [self localize];
    
    [self initViews];
    
    
    
    [self prepareForScrollView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    
    // 如果不是竖屏, 强制转为竖屏
    WS(weakSelf);
    [UIView animateWithDuration:.3 animations:^{
        [weakSelf forceOrientationPortrait];
    } completion:^(BOOL finished) {
        
#ifndef DIRECT_DRONE
        // 根据飞机状态刷新UI
        [weakSelf refreshUI];
#endif
    }];
    
    [self.view layoutIfNeeded];
}

- (void)viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBarHidden = NO;
    
    [super viewWillDisappear:animated];
}

- (void)dealloc {
    [[AbeCamHandle sharedInstance] disconnectedTalkSession];
    DLog(@"dealloc %@", NSStringFromClass([self class]));

}

//MARK: -- lazyload
- (NSMutableArray *)droneImageArray {
    if (!_droneImageArray) {
        _droneImageArray = [NSMutableArray new];
    }
    
    return _droneImageArray;
}
//MARK: -- 初始化子视图
- (void)configSubView {
    [_connectionStatusButton setTitle:NSLocalizedString(@"homepage_device_not_conneted", nil) forState:UIControlStateNormal];
    [self prepareForScrollView];
    [_readyToFlyButton setTitle:NSLocalizedString(@"homepage_flight_interface", nil) forState:UIControlStateNormal];
    [_buyInfoButton setTitle:NSLocalizedString(@"homepage_how_to_buy", nil) forState:UIControlStateNormal];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self.view layoutIfNeeded];
}

//MARK: -- Add Notifications
- (void)addNotifications {

    
}




//MARK: -- 设置状态栏
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

//MARK: -- 强制竖屏
- (void)forceOrientationPortrait
{
    AppDelegate *appdelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    appdelegate.isForcePortrait=YES;
    appdelegate.isForceLandscape=NO;
    [appdelegate application:[UIApplication sharedApplication] supportedInterfaceOrientationsForWindow:self.view.window];
    
    YNCNavigationViewController *navi = (YNCNavigationViewController *)self.navigationController;
    navi.interfaceOrientation = UIInterfaceOrientationPortrait;
    navi.interfaceOrientationMask = UIInterfaceOrientationMaskPortrait;
    
    //设置屏幕的转向为竖屏
    [[UIDevice currentDevice] setValue:@(UIDeviceOrientationPortrait) forKey:@"orientation"];
    //刷新
    [UIViewController attemptRotationToDeviceOrientation];
}


#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([NSStringFromClass([segue destinationViewController].class) isEqualToString:@"YNCMainViewController"]) {
        NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeRight];
        [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
    }
}


//MARK: Private Methods
- (void)localize {
    [self.connectionStatusButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [self.droneNameLabel setFont:[UIFont systemFontOfSize:38]];
    [self.readyToFlyButton.titleLabel setFont:[UIFont systemFontOfSize:18]];
}

- (void)initViews {
    // Image
    //    self.tabBarItem.image = [[UIImage imageNamed:@"Aircraft0"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //    self.tabBarItem.selectedImage = [[UIImage imageNamed:@"Aircraft1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    [self.readyToFlyButton setTitle:NSLocalizedString(@"homepage_flight_interface", nil) forState:UIControlStateNormal];
    [self.readyToFlyButton setTitleColor:[UIColor grayishColor] forState:UIControlStateNormal];
    
    //    self.bgView.backgroundColor = [UIColor redColor];
    //
    //    self.referView.backgroundColor = [UIColor yellowColor];
#ifdef DIRECT_DRONE
    _connectionStatusButton.userInteractionEnabled = YES;
#endif
}

- (void)autolayout {
    
    [self.referView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(APPWIDTH, APPHEIGHT-TABBARHEIGHT));
        //        make.edges.equalTo(self.bgView);
    }];
    
    
    [self.connectionStatusButton mas_makeConstraints:^(MASConstraintMaker *make) {

        make.right.equalTo(self.referView.mas_right);
        make.left.equalTo(@(16));
        make.height.equalTo(@(30));
        make.top.equalTo(self.referView.mas_bottom);
    }];
    
    [self.myScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.referView);
        make.height.equalTo(@(290));
        make.centerY.equalTo(self.referView.mas_centerY).offset(-25);
    }];

    [self.droneNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.referView.mas_left).offset(15);
        make.height.equalTo(@(48));
        make.top.equalTo(self.myScrollView.mas_bottom).offset(-22);
    }];
    
    [self.downArrowImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(10));
        make.height.equalTo(@(6));
        make.left.equalTo(self.droneNameLabel.mas_right).offset(10);
        make.centerY.equalTo(self.droneNameLabel.mas_centerY);
    }];
    
    [self.droneTypeSelectionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.droneNameLabel.mas_left);
        make.right.equalTo(self.downArrowImage.mas_right);
        make.height.equalTo(self.droneNameLabel.mas_height);
        make.centerY.equalTo(self.droneNameLabel.mas_centerY);
    }];
    
    [self.tipsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.referView.mas_left).offset(16);
        make.width.equalTo(@(309));
        make.height.equalTo(@(20));
        make.top.equalTo(self.droneNameLabel.mas_bottom);
    }];
    
    [self.readyToFlyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.referView.mas_left).offset(12);
        make.top.equalTo(self.tipsView.mas_bottom).offset(35);
        make.width.equalTo(@((APPWIDTH - 37 ) * 0.72));
        make.height.equalTo(@(71));
    }];
    
    [self.buyInfoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@((APPWIDTH - 24) * 0.28));
        make.height.equalTo(@(30));
        make.top.equalTo(self.tipsView.mas_bottom).offset(62);
        make.left.equalTo(self.readyToFlyButton.mas_right).offset(13);
    }];
}

- (void)refreshUI {
    // 根据飞机状态刷新UI
    
            if (1) {
                [self.connectionStatusButton setTitle:NSLocalizedString(@"flight_interface_warning_CONNECTION_STABLE",nil) forState:UIControlStateNormal];
                [self.readyToFlyButton setTitle:NSLocalizedString(@"homepage_start_to_fly", nil) forState:UIControlStateNormal];
                [self.readyToFlyButton setTitleColor:[UIColor yncFirebirdGreenColor] forState:UIControlStateNormal];
            } else {
                [self.readyToFlyButton setTitle:NSLocalizedString(@"homepage_flight_interface", nil) forState:UIControlStateNormal];
                [self.readyToFlyButton setTitleColor:[UIColor atrousColor] forState:UIControlStateNormal];
                [self.connectionStatusButton setTitle:NSLocalizedString(@"homepage_remote_controller_connected", nil) forState:UIControlStateNormal];
            }
    
        
        [self.droneNameLabel setText:@"HD RACER"];
}

// MARK: UI Aux Methods
- (void)adjustUI {
    CGFloat width;
    CGSize size = [_droneNameLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kDroneNameFontSize]}];
    CGSize adjustedSize = CGSizeMake(ceilf(size.width), ceilf(size.height));
    width = adjustedSize.width + 2;
    
    [_droneNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(width));
    }];
    
    [_downArrowImage updateConstraintsIfNeeded];
    [_droneTypeSelectionButton updateConstraintsIfNeeded];
}

- (void)changeToBGColor:(UIColor *)upperColor :(UIColor *)lowerColor {
    
    [UIView animateWithDuration:kAnimationBGColorDuration animations:^{
        self.gradient = [CAGradientLayer layer];
        self.gradient.frame = CGRectMake(0, 0, APPWIDTH, APPHEIGHT-TABBARHEIGHT);
        
        self.gradient.colors = @[(id)upperColor.CGColor, (id)lowerColor.CGColor];
        [self.view.layer insertSublayer:self.gradient below:self.referView.layer];
    }];
}

//MARK: -- 配置MyScrollView
- (void)prepareForScrollView {
    CGFloat s_height = 290;//self.myScrollView.frame.size.height;
    CGFloat s_width = APPWIDTH;//self.myScrollView.frame.size.width
    
    for (int i = 0; i < self.droneImageArray.count; ++i) {
        UIImageView *itemImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:self.droneImageArray[i]]];
        [_myScrollView addSubview:itemImageView];
        [itemImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.myScrollView).offset(i*s_width);
            make.centerY.equalTo(self.myScrollView);
            make.size.mas_equalTo(CGSizeMake(s_width, s_height));
        }];
    }
}

// MARK: UIScrollView Delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    static NSInteger previousPage = 0;
    CGFloat pageWidth = self.myScrollView.frame.size.width;
    float fractionalPage = self.myScrollView.contentOffset.x / pageWidth;
    NSInteger page = lroundf(fractionalPage);
    
    if (previousPage != page) {
        // Update
       
        previousPage = page;
        
       
    }
}

//MARK: Orientation
- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

//MARK: 设备连接状态按钮事件
- (IBAction)clickDeviceConnectedButton:(UIButton *)sender {
    NSString * urlString = NO_BELOW_iOS10==YES?@"App-Prefs:root=WIFI":@"prefs:root=WIFI";
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:urlString]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString] options:@{} completionHandler:nil];
    }
}
//MARK: -- 获取设备信息
- (void)getDroneDeviceInfo {
    
    [[YNCABECamManager sharedABECamManager] getDeviceInfo:^(YNCDeviceInfoDataModel *deviceInfo) {
        if (deviceInfo != nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [_connectionStatusButton setTitle:deviceInfo.ssid forState:UIControlStateNormal];
            });
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
