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
#import "YNCDeviceInfoModel.h"

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
    [self.droneImageArray addObject:@"icon_aircraft_mqx"];
    //初始化子视图
    [self configSubView];
    //适配子视图
    [self autolayout];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    // 如果不是竖屏, 强制转为竖屏
    WS(weakSelf);
    [UIView animateWithDuration:.3 animations:^{
        [weakSelf forceOrientationPortrait];
    } completion:^(BOOL finished) {
        
    }];
    
    [self.view layoutIfNeeded];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self.view layoutIfNeeded];
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

//MARK: -- 执行bindViewMode
- (void)bindViewModel {
    [super bindViewModel];
    
    WS(weakSelf);
    [_kvoController observe:[YNCABECamManager sharedABECamManager] keyPath:@"WiFiConnected" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
        BOOL tmpWiFiConnected = [change[NSKeyValueChangeNewKey] boolValue];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (tmpWiFiConnected) {
                [weakSelf refreshUI:tmpWiFiConnected];
            }
        });
    }];
}
//MARK: -- 初始化子视图
- (void)configSubView {
    _connectionStatusButton.userInteractionEnabled = YES;
    [_connectionStatusButton setTitle:NSLocalizedString(@"homepage_device_not_conneted", nil) forState:UIControlStateNormal];
    [self prepareForScrollView];
    
    [_readyToFlyButton setTitleColor:[UIColor grayishColor] forState:UIControlStateNormal];
    [_readyToFlyButton setTitle:NSLocalizedString(@"homepage_flight_interface", nil) forState:UIControlStateNormal];
    [_buyInfoButton setTitle:NSLocalizedString(@"homepage_how_to_buy", nil) forState:UIControlStateNormal];
    
    [self changeToBGColor:UICOLOR_FROM_HEXRGB(0xaab7b8):UICOLOR_FROM_HEXRGB(0x6c787b)];
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

//MARK: -- 适配视图
- (void)autolayout {
    [self.referView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(APPWIDTH, APPHEIGHT));
    }];
    
    [self.connectionStatusButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_referView).offset(12);
        make.top.equalTo(_referView).offset(42);
        make.size.mas_equalTo(CGSizeMake(355, 30));
    }];
    
    [self.myScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.referView);
        make.height.equalTo(@(290));
        make.centerY.equalTo(self.referView.mas_centerY).offset(-25);
    }];
    
    [self.droneNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.referView.mas_left).offset(15); make.top.equalTo(self.myScrollView.mas_bottom).offset(-22);
        make.size.mas_equalTo(CGSizeMake(74, 40));
    }];
    
    [self.downArrowImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.droneNameLabel.mas_right).offset(10);
        make.centerY.equalTo(self.droneNameLabel.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(10, 6));
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

- (void)refreshUI:(BOOL)WiFiConnected {
    // 根据飞机状态刷新UI
    if (WiFiConnected) {
        [_connectionStatusButton setTitleColor:[UIColor yncFirebirdGreenColor] forState:UIControlStateNormal];
        [_connectionStatusButton setTitle:[YNCABECamManager sharedABECamManager].deviceInfo.ssid forState:UIControlStateNormal];
        
        [_readyToFlyButton setTitle:NSLocalizedString(@"homepage_start_to_fly", nil) forState:UIControlStateNormal];
        [_readyToFlyButton setTitleColor:[UIColor yncFirebirdGreenColor] forState:UIControlStateNormal];
    } else {
        [_readyToFlyButton setTitle:NSLocalizedString(@"homepage_flight_interface", nil) forState:UIControlStateNormal];
        [_readyToFlyButton setTitleColor:[UIColor grayishColor] forState:UIControlStateNormal];
        
        [_connectionStatusButton setTitleColor:[UIColor grayishColor] forState:UIControlStateNormal];
        [_connectionStatusButton setTitle:NSLocalizedString(@"homepage_device_not_conneted", nil) forState:UIControlStateNormal];
    }
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
//MARK: -- 背景渐变色
- (void)changeToBGColor:(UIColor *)upperColor :(UIColor *)lowerColor {
    [UIView animateWithDuration:kAnimationBGColorDuration animations:^{
        self.gradient = [CAGradientLayer layer];
        self.gradient.frame = CGRectMake(0, 0, APPWIDTH, APPHEIGHT);
        
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

// MARK: Unwind
- (IBAction)mainViewControllerUnwindSegue:(UIStoryboardSegue *)unwindSegue {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
