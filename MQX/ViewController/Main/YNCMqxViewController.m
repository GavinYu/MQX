//
//  YNCMqxViewController.m
//  MQX
//
//  Created by yc-sh-vr-pc05 on 2018/3/3.
//  Copyright © 2018年 YunEEC. All rights reserved.
//

#import "YNCMqxViewController.h"

#import "YNCVideoPreviewViewController.h"
#import "YNCAppConfig.h"
#import "YNCCameraToolView.h"
#import "YNCCameraSettingView.h"
#import "YNCNavigationBar.h"
#import "YNCVideoHomepageView.h"
#import "YNCABECamManager.h"
#import "AppDelegate.h"
#import "YNCNavigationViewController.h"
#import "YNCWarningConstMacro.h"
#import "YNCDroneGalleryPreviewViewController.h"
#import "YNCWarningManager.h"
#import "YNCNavigationViewController.h"

@interface YNCMqxViewController () <UIGestureRecognizerDelegate, YNCCameraSettingViewDelegate>
{
    dispatch_source_t _countVideoDurationTimer;
    NSInteger _doubleClickCount;
}

//相机工具栏
@property (strong, nonatomic) YNCCameraToolView *cameraToolView;
//当前的显示模式（普通模式 or 眼镜模式）
@property (assign, nonatomic) YNCModeDisplay currentDisplay;
//相机设置视图
@property (strong, nonatomic) YNCCameraSettingView *cameraSettingView;
@property (strong, nonatomic) YNCNavigationBar *myNavigationBar;
@property (strong, nonatomic) YNCNavigationBar *fpvNavigationBar;
@property (strong, nonatomic) UIButton *fpvSwitchButton;
@property (strong, nonatomic) UIView *fpvHomepageView;
@property (strong, nonatomic) YNCVideoHomepageView *videoHomepageView;
//重绘FPV相关的变量
@property (strong, nonatomic) YNCVideoHomepageView *leftVideoHomepageView;
@property (strong, nonatomic) YNCVideoHomepageView *rightVideoHomepageView;
@property (strong, nonatomic) YNCNavigationBar *leftNavigationBar;
@property (strong, nonatomic) YNCNavigationBar *rightNavigationBar;
@property (strong, nonatomic) UIView *fpvLineView;

@property (assign, nonatomic) NSUInteger videoDuration;

@property (strong, nonatomic) FBKVOController *kvoController;

@end

@implementation YNCMqxViewController
//MARK: -- View life cycle methods
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    //绑定KVO
    [self bindViewModel];
    //关闭返回手势
    self.fd_prefersNavigationBarHidden = YES;
    self.fd_interactivePopDisabled = YES;
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    //强制旋转横屏
    [UIView animateWithDuration:.3 animations:^{
        [self forceOrientationLandscape];
    }];
    // Do any additional setup after loading the view.
    self.currentDisplay = YNCModeDisplayNormal;
    
    [self videoPreview];
    
    [self initMySubView];
    
    [self addGestureRecognizers];
    [self addNotification];
}
//MARK: -- Dealloc methods
- (void)dealloc {
    DLog(@"Dealloc: %@",[self class]);
    
    [self removeNotification];
}
//MARK: -- Lazyload kvoController
- (FBKVOController *)kvoController {
    if (!_kvoController) {
        _kvoController = [[FBKVOController alloc] initWithObserver:self];
    }
    
    return _kvoController;
}
//MARK: -- Lazyload  videoHomepageView
- (YNCVideoHomepageView *)videoHomepageView {
    if (!_videoHomepageView) {
        _videoHomepageView = [YNCVideoHomepageView instanceVideoHomepageView];
    }
    
    return _videoHomepageView;
}

//MARK: -- Lazyload  leftvideoHomepageView
- (YNCVideoHomepageView *)leftvideoHomepageView {
    if (!_leftVideoHomepageView) {
        _leftVideoHomepageView = [YNCVideoHomepageView instanceVideoHomepageView];
    }
    
    return _leftVideoHomepageView;
}

//MARK: -- Lazyload  rightvideoHomepageView
- (YNCVideoHomepageView *)rightvideoHomepageView {
    if (!_rightVideoHomepageView) {
        _rightVideoHomepageView = [YNCVideoHomepageView instanceVideoHomepageView];
    }
    
    return _rightVideoHomepageView;
}

//MARK: -- Lazyload  leftNavigationBar
- (YNCNavigationBar *)leftNavigationBar {
    if (!_leftNavigationBar) {
        _leftNavigationBar = [YNCNavigationBar instanceNavigationBar];
    }
    
    return _leftNavigationBar;
}

//MARK: -- Lazyload  rightNavigationBar
- (YNCNavigationBar *)rightNavigationBar {
    if (!_rightNavigationBar) {
        _rightNavigationBar = [YNCNavigationBar instanceNavigationBar];
    }
    
    return _rightNavigationBar;
}

//MARK: -- Lazyload myNavigationBar
- (YNCNavigationBar *)myNavigationBar {
    if (!_myNavigationBar) {
        _myNavigationBar = [YNCNavigationBar instanceNavigationBar];
    }
    
    return _myNavigationBar;
}

//MARK: -- Lazyload fpvNavigationBar
- (YNCNavigationBar *)fpvNavigationBar {
    if (!_fpvNavigationBar) {
        _fpvNavigationBar = [YNCNavigationBar instanceNavigationBar];
    }
    
    return _fpvNavigationBar;
}

//MARK: -- Lazyload fpvSwitchButton
- (UIButton *)fpvSwitchButton {
    if (!_fpvSwitchButton) {
        _fpvSwitchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fpvSwitchButton setImage:[UIImage imageNamed:@"btn_FPV"] forState:UIControlStateNormal];
        [_fpvSwitchButton addTarget:self action:@selector(clickFPVSwitchButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _fpvSwitchButton;
}

//MARK: -- lazyload videoPreview
- (UIView *)videoPreview {
    if (!_videoPreview) {
        UIStoryboard *tmpMainBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        YNCVideoPreviewViewController *videoPreviewViewController = [tmpMainBoard instantiateViewControllerWithIdentifier:@"VideoPreviewController"];
        [self addChildViewController:videoPreviewViewController];
        [self.view insertSubview:videoPreviewViewController.view atIndex:0];
        [videoPreviewViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.view);
            make.size.equalTo(self.view);
        }];
        [videoPreviewViewController didMoveToParentViewController:self];
        
        _videoPreview = videoPreviewViewController.view;
        
        [self.view layoutIfNeeded];
    }
    
    return _videoPreview;
}

//MARK: -- Lazyload cameraToolView
- (YNCCameraToolView *)cameraToolView {
  if (!_cameraToolView) {
    _cameraToolView = [YNCCameraToolView instanceCameraToolView];
  }
  
  return _cameraToolView;
}

//MARK: -- 添加  通知
- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleCameraWarningNotification:) name:YNC_CAMEAR_WARNING_NOTIFICATION object:nil];
}

//MARK: -- 移除 通知
- (void)removeNotification{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:YNC_CAMEAR_WARNING_NOTIFICATION object:nil];
}

//MARK: -- 处理相机警告通知
- (void)handleCameraWarningNotification:(NSNotification *)notification {
    int tmpType = [notification.userInfo[@"msgid"] intValue];
    YNCWarningLevel tmpWarningLevel = [[YNCWarningManager sharedWarningManager] getWarningType:tmpType];
    if (tmpWarningLevel == YNCWarningLevelFirst) {
        [self.leftNavigationBar updateStateView:notification.userInfo];
        [self.rightNavigationBar updateStateView:notification.userInfo];
        [self.myNavigationBar updateStateView:notification.userInfo];
    } else {
        [self showCameraWarningWithNumber:tmpType];
    }
}

//MARK: -- 显示相机操作警告
- (void)showCameraWarningWithNumber:(int)number
{
    if (![[YNCWarningManager sharedWarningManager].thirdWarningArray containsObject:[NSNumber numberWithInt:number]]) {
        [self handleShowWarning:@{@"msgid":[NSNumber numberWithInt:number], @"isHidden":[NSNumber numberWithBool:NO]}];
    }
}

//MARK: -- 显示二级或者三级警报
- (void)handleShowWarning:(NSDictionary *)warningDic {
    [[YNCWarningManager sharedWarningManager] setContainerView:self.leftVideoHomepageView];
    [[YNCWarningManager sharedWarningManager] showWarningViewInViewWithObject:warningDic withModeDisplay:self.currentDisplay withDirectCode:1];
    
    [[YNCWarningManager sharedWarningManager] setContainerView:self.rightVideoHomepageView];
    [[YNCWarningManager sharedWarningManager] showWarningViewInViewWithObject:warningDic withModeDisplay:self.currentDisplay withDirectCode:2];
    
    [[YNCWarningManager sharedWarningManager] setContainerView:self.videoHomepageView];
    [[YNCWarningManager sharedWarningManager] showWarningViewInViewWithObject:warningDic withModeDisplay:self.currentDisplay withDirectCode:0];
}

//MARK: -- 强制横屏
- (void)forceOrientationLandscape
{
    AppDelegate *appdelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    appdelegate.isForceLandscape=YES;
    appdelegate.isForcePortrait=NO;
    [appdelegate application:[UIApplication sharedApplication] supportedInterfaceOrientationsForWindow:self.view.window];
    
    YNCNavigationViewController *navi = (YNCNavigationViewController *)self.navigationController;
    navi.interfaceOrientation = UIInterfaceOrientationLandscapeRight;
    navi.interfaceOrientationMask = UIInterfaceOrientationMaskLandscapeRight;
    
    //强制翻转屏幕，Home键在右边。
    [[UIDevice currentDevice] setValue:@(UIInterfaceOrientationLandscapeRight) forKey:@"orientation"];
    //刷新
    [UIViewController attemptRotationToDeviceOrientation];
}

//MARK: -- init subView 初始化子视图
- (void)initMySubView {
    [self createFPVSwitchButton];
    [self createVideoHomepageView];
    [self createNavigationBar];
    [self createFPVVideoHomepageView];
    [self createCameraToolView];
}
//MARK: -- 创建 fpvSwitchButton
- (void)createFPVSwitchButton {
    WS(weakSelf);
    
    [self.view addSubview:self.fpvSwitchButton];
    [self.fpvSwitchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.view.mas_bottom).offset(-15);
        make.right.equalTo(weakSelf.view.mas_right).offset(-20-BottomUnsafeArea);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
}
//MARK: -- 创建Firebird 首页视图
- (void)createVideoHomepageView {
    WS(weakSelf);
    
    [self.view insertSubview:self.videoHomepageView belowSubview:self.fpvSwitchButton];
    [self.videoHomepageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view).offset(BottomUnsafeArea);
        make.top.equalTo(weakSelf.view);
        make.size.mas_equalTo(CGSizeMake(SCREENWIDTH - TopUnsafeArea - BottomUnsafeArea , SCREENHEIGHT - HorizontalScreenBottomUnsafeArea));
    }];
    
    [self.videoHomepageView layoutIfNeeded];
    
    [self.videoHomepageView initSubView:self.currentDisplay];
}
//MARK: -- 创建FPV的首页视图
- (void)createFPVVideoHomepageView {
    WS(weakSelf);
    
    self.fpvHomepageView = [UIView new];
    self.fpvHomepageView.backgroundColor = [UIColor clearColor];
    [self.view insertSubview:self.fpvHomepageView belowSubview:self.fpvSwitchButton];
    
    [self.fpvHomepageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view).offset(BottomUnsafeArea);
        make.top.equalTo(weakSelf.view);
        make.size.mas_equalTo(CGSizeMake(SCREENWIDTH - TopUnsafeArea - BottomUnsafeArea , SCREENHEIGHT - HorizontalScreenBottomUnsafeArea));
    }];
    
    [self.fpvHomepageView addSubview:self.leftvideoHomepageView];
    [self.fpvHomepageView addSubview:self.rightvideoHomepageView];
    
    [self.leftvideoHomepageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.fpvHomepageView);
        make.top.equalTo(weakSelf.fpvHomepageView).offset((SCREENHEIGHT-HorizontalScreenBottomUnsafeArea) *0.25);
        make.size.mas_equalTo(CGSizeMake((SCREENWIDTH-BottomUnsafeArea-TopUnsafeArea)*0.5, (SCREENHEIGHT-HorizontalScreenBottomUnsafeArea)*0.5));
    }];
    
    [self.rightvideoHomepageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.leftvideoHomepageView);
        make.left.equalTo(weakSelf.fpvHomepageView).offset((SCREENWIDTH-BottomUnsafeArea-TopUnsafeArea)*0.5);
        make.size.mas_equalTo(weakSelf.leftvideoHomepageView);
    }];
    
    [self.fpvHomepageView layoutIfNeeded];
    
    [self.leftvideoHomepageView initSubView:YNCModeDisplayGlass];
    [self.rightvideoHomepageView initSubView:YNCModeDisplayGlass];
    
    [self createFPVNavigationBar];
    
    self.fpvLineView = [UIView new];
    self.fpvLineView.backgroundColor = UICOLOR_FROM_HEXRGB(0xff5cdb);
    [self.fpvHomepageView addSubview:self.fpvLineView];
    [self.fpvLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.fpvHomepageView);
        make.centerX.equalTo(self.fpvHomepageView);
        make.size.mas_equalTo(CGSizeMake(1.0, self.fpvHomepageView.bounds.size.height));
    }];
    
    self.fpvHomepageView.hidden = YES;
}

//MARK: -- 创建导航栏
- (void)createNavigationBar {
    WS(weakSelf);

    [self.view addSubview:self.myNavigationBar];
    [self.myNavigationBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.videoHomepageView);
        make.top.equalTo(weakSelf.view);
        make.size.mas_equalTo(CGSizeMake(SCREENWIDTH - TopUnsafeArea - BottomUnsafeArea, YNCNAVGATIONBARHEIGHT));
    }];

    [self.view layoutIfNeeded];
    
    [self.myNavigationBar initSubView:self.currentDisplay];
    
    BOOL tmpWiFiConnected = [YNCABECamManager sharedABECamManager].WiFiConnected;
    self.myNavigationBar.WiFiConnected = tmpWiFiConnected;
    [self.myNavigationBar updateStateView:@{@"msgid":[NSNumber numberWithInt:tmpWiFiConnected==YES?YNCWARNING_DRONE_CONNECTED:YNCWARNING_DEVICE_DISCONNECTED], @"isHidden":[NSNumber numberWithBool:NO]}];
    
    [self.myNavigationBar setNavigationBarButtonEventBlock:^(YNCEventAction eventAction){
        if (eventAction == YNCEventActionNavBarHomeBtn) {
            //do something
            if (weakSelf.kvoController) {
                weakSelf.kvoController = nil;
            }
            [weakSelf performSegueWithIdentifier:@"unwindToMain" sender:weakSelf];
        }
    }];
}

//MARK: -- 创建FPV模式的导航栏
- (void)createFPVNavigationBar {
    WS(weakSelf);
    
    [self.fpvHomepageView addSubview:self.leftNavigationBar];
    [self.leftNavigationBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(weakSelf.leftvideoHomepageView);
        make.size.mas_equalTo(CGSizeMake((SCREENWIDTH-TopUnsafeArea-BottomUnsafeArea)*0.5, YNCNAVGATIONBARHEIGHT*0.5));
    }];
    
    [self.leftNavigationBar initSubView:YNCModeDisplayGlass];
    [self.leftNavigationBar hiddenNavigationBarSubView:YES withModeDisplay:YNCModeDisplayGlass];
    
    [self.fpvHomepageView addSubview:self.rightNavigationBar];
    [self.rightNavigationBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(weakSelf.rightvideoHomepageView);
        make.size.mas_equalTo(CGSizeMake((SCREENWIDTH-TopUnsafeArea-BottomUnsafeArea)*0.5, YNCNAVGATIONBARHEIGHT*0.5));
    }];
    
    [self.rightNavigationBar initSubView:YNCModeDisplayGlass];
    [self.rightNavigationBar hiddenNavigationBarSubView:YES withModeDisplay:YNCModeDisplayGlass];
    
    BOOL tmpWiFiConnected = [YNCABECamManager sharedABECamManager].WiFiConnected;
    self.leftNavigationBar.WiFiConnected = tmpWiFiConnected;
    self.rightNavigationBar.WiFiConnected = tmpWiFiConnected;
    [self.leftNavigationBar updateStateView:@{@"msgid":[NSNumber numberWithInt:tmpWiFiConnected==YES?YNCWARNING_DRONE_CONNECTED:YNCWARNING_DEVICE_DISCONNECTED], @"isHidden":[NSNumber numberWithBool:NO]}];
    [self.rightNavigationBar updateStateView:@{@"msgid":[NSNumber numberWithInt:tmpWiFiConnected==YES?YNCWARNING_DRONE_CONNECTED:YNCWARNING_DEVICE_DISCONNECTED], @"isHidden":[NSNumber numberWithBool:NO]}];
    
    [self.fpvHomepageView layoutIfNeeded];
}

//MARK: -- 创建相机工具栏
- (void)createCameraToolView {
  WS(weakSelf);
  
  [self.view addSubview:self.cameraToolView];
  [self.cameraToolView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.right.equalTo(weakSelf.view).offset(-8);
    make.centerY.equalTo(weakSelf.view);
    make.size.mas_equalTo(CGSizeMake(50.0, 185.0));
  }];
  
  [self.cameraToolView initSubView:[YNCABECamManager sharedABECamManager].WiFiConnected];
  
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    [weakSelf setCameraToolViewShowStatus:NO];
  });
    
  [self.cameraToolView setCameraToolViewEventBlock:^(UIButton *sender) {
    switch (sender.tag) {
      case YNCEventActionCameraSwitchMode:
      {
          [weakSelf changeCurrentCameraMode:sender];
      }
        break;
        
      case YNCEventActionCameraOperate:
      {
          [weakSelf takePhotoOrRecroding:sender];
      }
        break;
        
      case YNCEventActionCameraSetting:
      {
        if (!weakSelf.cameraSettingView) {
          CGFloat width = APPWIDTH - (APPWIDTH - weakSelf.cameraToolView.frame.origin.x);
          weakSelf.cameraSettingView = [[YNCCameraSettingView alloc] init];
          weakSelf.cameraSettingView.delegate = weakSelf;
          [weakSelf.view insertSubview:weakSelf.cameraSettingView belowSubview:weakSelf.cameraToolView];
          [weakSelf.cameraSettingView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.view);
            make.left.equalTo(weakSelf.view).offset(width);
            make.width.equalTo(@(width));
            make.height.equalTo(@(APPHEIGHT));
          }];
          [weakSelf.view layoutIfNeeded];
          [weakSelf.cameraSettingView createUI];
          
          [weakSelf.cameraSettingView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.view);
          }];
          [UIView animateWithDuration:0.3 animations:^{
            [weakSelf.view layoutIfNeeded];
          }];
        }
      }
        break;
        
      case YNCEventActionCameraGallery:
      {
          if ([[YNCABECamManager sharedABECamManager].totalStorage isEqualToString:@"0MB"]) {
              [[YNCMessageBox instance] show:NSLocalizedString(@"flight_interface_warning_CAMERA_NO_SDCARD", nil)];
              return;
          }
          
          if ([YNCABECamManager sharedABECamManager].isRecordingVideo) {
              [[YNCMessageBox instance] show:NSLocalizedString(@"gallery_enter_drone_gallery_warning_recording", nil)];
              return;
          }
          
          YNCDroneGalleryPreviewViewController *droneGalleryVC = [[YNCDroneGalleryPreviewViewController alloc] init];
          YNCNavigationViewController *droneGalleryNC = [[YNCNavigationViewController alloc] initWithRootViewController:droneGalleryVC];
          droneGalleryNC.interfaceOrientation = UIInterfaceOrientationLandscapeRight;
          droneGalleryNC.interfaceOrientationMask = UIInterfaceOrientationMaskLandscapeRight;
          droneGalleryNC.navigationController.navigationBarHidden = YES;
          [weakSelf presentViewController:droneGalleryNC animated:YES completion:nil];
      }
        break;
        
      default:
        break;
    }
  }];
}

//MARK: -- 添加手势
- (void)addGestureRecognizers {
  UISwipeGestureRecognizer *leftSwipe =[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(gestureRecognizersAction:)];
  //配置属性
  //一个清扫手势  只能有两个方向(上和下) 或者 (左或右)
  //如果想支持上下左右清扫  那么一个手势不能实现  需要创建两个手势
  leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
  //添加到指定视图
  [self.view addGestureRecognizer:leftSwipe];
  
  UISwipeGestureRecognizer *rightSwipe =[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(gestureRecognizersAction:)];
  rightSwipe.direction =UISwipeGestureRecognizerDirectionRight;
  [self.view addGestureRecognizer:rightSwipe];
  
  //创建手势对象
  UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gestureRecognizersAction:)];
  //配置属性
  //轻拍次数
  tap.numberOfTapsRequired = 2;
  //轻拍手指个数
  tap.numberOfTouchesRequired = 1;
  tap.delegate = self;
  //将手势添加到指定的视图上
  [self.view addGestureRecognizer:tap];
}

//MARK: -- 隐藏/显示相机工具栏（CameraTool）
- (void)setCameraToolViewShowStatus:(BOOL)isShow {
  WS(weakSelf);
  [UIView animateWithDuration:0.3 animations:^{
    weakSelf.cameraToolView.transform = CGAffineTransformMakeTranslation(isShow==YES?0:66+BottomUnsafeArea, 0);
  }];
}
//MARK: -- 手势事件
- (void)gestureRecognizersAction:(UIGestureRecognizer *)recognizer {
  WS(weakSelf);
  if ([recognizer isKindOfClass:[UISwipeGestureRecognizer class]]) {
    if (self.currentDisplay == YNCModeDisplayGlass) {
      return;
    }
    
    UISwipeGestureRecognizer *tmpRecognizer = (UISwipeGestureRecognizer *)recognizer;
    if (tmpRecognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
      [self setCameraToolViewShowStatus:YES];
    } else if (tmpRecognizer.direction == UISwipeGestureRecognizerDirectionRight) {
      if (self.cameraSettingView != nil) {
        return;
      }
      [self setCameraToolViewShowStatus:NO];
    }
    
  } else if ([recognizer isKindOfClass:[UITapGestureRecognizer class]]) {
    if (self.currentDisplay == YNCModeDisplayGlass) {
      return;
    }
    
    [self setCameraToolViewShowStatus:NO];
      
      _doubleClickCount++;
      if (_doubleClickCount == 1) {
          [self.videoHomepageView hiddenSubView:YES withDoubleClickCount:_doubleClickCount];
          [self.leftVideoHomepageView hiddenSubView:YES withDoubleClickCount:_doubleClickCount];
          [self.rightVideoHomepageView hiddenSubView:YES withDoubleClickCount:_doubleClickCount];
      } else if (_doubleClickCount == 2) {
          [UIView animateWithDuration:0.3 animations:^{
              weakSelf.myNavigationBar.alpha = 0;
              weakSelf.fpvSwitchButton.alpha = 0;
          }];
          
          [self.videoHomepageView hiddenSubView:YES withDoubleClickCount:_doubleClickCount];
          [self.leftVideoHomepageView hiddenSubView:YES withDoubleClickCount:_doubleClickCount];
          [self.rightVideoHomepageView hiddenSubView:YES withDoubleClickCount:_doubleClickCount];
          
      } else if (_doubleClickCount == 3) {
          [UIView animateWithDuration:0.3 animations:^{
              weakSelf.myNavigationBar.alpha = 1.0;
              weakSelf.fpvSwitchButton.alpha = 1.0;
          }];
          
          [self.videoHomepageView hiddenSubView:NO withDoubleClickCount:_doubleClickCount];
          [self.leftVideoHomepageView hiddenSubView:NO withDoubleClickCount:_doubleClickCount];
          [self.rightVideoHomepageView hiddenSubView:NO withDoubleClickCount:_doubleClickCount];
          
          _doubleClickCount = 0;
      }
  }
}

#pragma mark - YNCCameraSettingViewDelegate
- (void)popView
{
    WS(weakSelf);
    [self.cameraSettingView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view).offset(SCREENWIDTH);
    }];
    [UIView animateWithDuration:0.3 animations:^{
        //        weakSelf.cameraSettingView.frame = CGRectMake(SCREENWIDTH, 0, SCREENWIDTH, SCREENHEIGHT);
        [weakSelf.view layoutIfNeeded];
    }  completion:^(BOOL finished) {
        if (finished) {
            [weakSelf.cameraSettingView removeFromSuperview];
            weakSelf.cameraSettingView = nil;
        }
    }];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
  UIEvent *event = [[UIEvent alloc] init];
  CGPoint locataion = [gestureRecognizer locationInView:gestureRecognizer.view];
  UIView *view = [gestureRecognizer.view hitTest:locataion withEvent:event];
    if ([view isKindOfClass:[UITableView class]]) {
        return NO;
    }
    
  return YES;
}

//MARK: -- 拍照/录像
- (void)takePhotoOrRecroding:(UIButton *)sender {
    if (self.cameraToolView.cameraMode == YNCCameraModeVideo) {
        if (sender.isSelected) {
            [self startRecord];
        } else {
            [self stopRecord];
        }
    } else {
        [self takePhoto];
    }
}

//MARK: -- 开始录像
- (void)startRecord {
    WS(weakSelf);
    [[AbeCamHandle sharedInstance] setRecordStatus:@1 result:^(BOOL succeeded) {
        if (succeeded) {
            [weakSelf setVideoTimeView:YES];
            [YNCABECamManager sharedABECamManager].isRecordingVideo = YES;
        }
      [[YNCMessageBox instance] show:succeeded==YES?@"start Record succeeded":@"start Record failed"];
    }];
}
//MARK: -- 停止录像
- (void)stopRecord {
    WS(weakSelf);
  [[AbeCamHandle sharedInstance] setRecordStatus:@0 result:^(BOOL succeeded) {
      if (succeeded) {
          [weakSelf setVideoTimeView:NO];
          [YNCABECamManager sharedABECamManager].isRecordingVideo = NO;
      }
    [[YNCMessageBox instance] show:succeeded==YES?@"stop Record succeeded":@"stop Record failed"];
  }];
}
//MARK: -- 拍照
- (void)takePhoto
{
  [[AbeCamHandle sharedInstance] sdCardTakePictureWithResult:^(BOOL succeeded) {
    [[YNCMessageBox instance] show:succeeded==YES?@"take photo succeeded":@"take photo failed"];
  }];
}

//MARK: -- 切换相机模式（录像/拍照）
- (void)changeCurrentCameraMode:(UIButton *)sender {
    self.cameraToolView.cameraMode = sender.isSelected==YES?YNCCameraModeTakePhoto:YNCCameraModeVideo;
}

//MARK: -- 切换FPV模式
- (void)switchFPVModel:(BOOL)isFPV {
  [[AbeCamHandle sharedInstance] setDualViewStatus:isFPV];
}

//MARK: -- FPV按钮事件
- (void)clickFPVSwitchButton:(UIButton *)sender {
    if (self.cameraSettingView != nil) {
        [self.cameraSettingView removeFromSuperview];
        self.cameraSettingView = nil;
    }
    
    [sender setSelected:!sender.isSelected];
    [self switchFPVModel:sender.isSelected];

    self.currentDisplay = sender.isSelected == YES?YNCModeDisplayGlass:YNCModeDisplayNormal;
    
    if (self.currentDisplay == YNCModeDisplayGlass) {
        [self setCameraToolViewShowStatus:NO];
        [self.myNavigationBar hiddenNavigationBarSubView:YES withModeDisplay:YNCModeDisplayNormal];
        self.videoHomepageView.hidden = YES;
        self.fpvHomepageView.hidden = NO;
        
        [self.view bringSubviewToFront:self.fpvHomepageView];
        [self.view bringSubviewToFront:self.fpvSwitchButton];
        [self.view bringSubviewToFront:self.myNavigationBar];
    } else {
        self.fpvHomepageView.hidden = YES;
        self.videoHomepageView.hidden = NO;
        [self.myNavigationBar hiddenNavigationBarSubView:NO withModeDisplay:YNCModeDisplayNormal];
        self.cameraToolView.hidden = NO;
        
        [self.view bringSubviewToFront:self.videoHomepageView];
        [self.view bringSubviewToFront:self.fpvSwitchButton];
        [self.view bringSubviewToFront:self.myNavigationBar];
    }
    
    [self.view bringSubviewToFront:self.cameraToolView];
    [self.view layoutIfNeeded];
}

//MARK: -- 绑定ViewModel
- (void)bindViewModel {
    WS(weakSelf);
    [self.kvoController observe:[YNCABECamManager sharedABECamManager] keyPath:@"WiFiConnected" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
        BOOL tmpWiFiConnected = [change[NSKeyValueChangeNewKey] boolValue];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!tmpWiFiConnected) {
                [YNCUtil saveUserDefaultInfo:[NSNumber numberWithBool:NO] forKey:@"videoFlipStatus"];
                [weakSelf setVideoTimeView:NO];
            }
            
            [weakSelf.myNavigationBar updateStateView:@{@"msgid":[NSNumber numberWithInt:tmpWiFiConnected==YES?YNCWARNING_DRONE_CONNECTED:YNCWARNING_DEVICE_DISCONNECTED], @"isHidden":[NSNumber numberWithBool:NO]}];
            [weakSelf.leftNavigationBar updateStateView:@{@"msgid":[NSNumber numberWithInt:tmpWiFiConnected==YES?YNCWARNING_DRONE_CONNECTED:YNCWARNING_DEVICE_DISCONNECTED], @"isHidden":[NSNumber numberWithBool:NO]}];
            [weakSelf.rightNavigationBar updateStateView:@{@"msgid":[NSNumber numberWithInt:tmpWiFiConnected==YES?YNCWARNING_DRONE_CONNECTED:YNCWARNING_DEVICE_DISCONNECTED], @"isHidden":[NSNumber numberWithBool:NO]}];
            weakSelf.myNavigationBar.WiFiConnected = tmpWiFiConnected;
            weakSelf.leftNavigationBar.WiFiConnected = tmpWiFiConnected;
            weakSelf.rightNavigationBar.WiFiConnected = tmpWiFiConnected;
            [weakSelf.cameraToolView updateBtnImageWithConnect:tmpWiFiConnected];
            
            
        });
    }];
    
    [self.kvoController observe:[YNCABECamManager sharedABECamManager] keyPath:@"freeStorage" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
        NSString *tmpNew = change[NSKeyValueChangeNewKey];
        NSString *tmpOld = change[NSKeyValueChangeOldKey];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (tmpOld != NULL && tmpNew != NULL) {
                if (tmpOld.length > 0 && tmpNew.length > 0) {
                    if (![tmpNew isEqualToString:tmpOld]) {
                        [weakSelf.cameraSettingView updateCameraSettingView];
                    }
                }
            }
        });
    }];
    
    
}

//MARK: -- start count video duration
- (void)startCountVideoDurationTimer {
    WS(weakSelf);
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), kPeriod * NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        //在这里执行事件
        weakSelf.videoDuration++;
        NSString *tmpVideoString = [YNCUtil convertSecondToDisplayString:weakSelf.videoDuration];
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.videoHomepageView.videoTimeView.recordTimeInSecond = tmpVideoString;
        });
    });
    
    dispatch_resume(_timer);
    
    _countVideoDurationTimer = _timer;
}

//MARK: -- destroy count video duration
- (void)destroyCountVideoDurationTimer {
    if (_countVideoDurationTimer) {
        self.videoDuration = 0;
        dispatch_source_cancel(_countVideoDurationTimer);
        _countVideoDurationTimer = nil;
    }
}

//MARK: -- 显示/隐藏 录像时间
- (void)setVideoTimeView:(BOOL)show {
    self.videoHomepageView.isShowVideoTimeView = show;
    self.leftVideoHomepageView.isShowVideoTimeView = show;
    self.rightVideoHomepageView.isShowVideoTimeView = show;
    
    if (show) {
        //开启计数定时器
        [self startCountVideoDurationTimer];
    } else {
        //关闭计数定时器
        [self destroyCountVideoDurationTimer];
    }
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
