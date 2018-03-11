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

@interface YNCMqxViewController () <UIGestureRecognizerDelegate, YNCCameraSettingViewDelegate>

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

@end

@implementation YNCMqxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  [self videoPreview];
  [self createCameraToolView];
}

//MARK: -- Lazyload  videoHomepageView
- (YNCVideoHomepageView *)videoHomepageView {
    if (!_videoHomepageView) {
        _videoHomepageView = [YNCVideoHomepageView instanceVideoHomepageView];
        _videoHomepageView.backgroundColor = [UIColor clearColor];
    }
    
    return _videoHomepageView;
}

//MARK: -- Lazyload  leftvideoHomepageView
- (YNCVideoHomepageView *)leftvideoHomepageView {
    if (!_leftVideoHomepageView) {
        _leftVideoHomepageView = [YNCVideoHomepageView instanceVideoHomepageView];
        _leftVideoHomepageView.backgroundColor = [UIColor clearColor];
    }
    
    return _leftVideoHomepageView;
}

//MARK: -- Lazyload  rightvideoHomepageView
- (YNCVideoHomepageView *)rightvideoHomepageView {
    if (!_rightVideoHomepageView) {
        _rightVideoHomepageView = [YNCVideoHomepageView instanceVideoHomepageView];
        
        _rightVideoHomepageView.backgroundColor = [UIColor clearColor];
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
        [_fpvSwitchButton setImage:[UIImage imageNamed:@"btn_fpv_switch"] forState:UIControlStateNormal];
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

//MARK: -- 创建FPV的首页视图
- (void)createFirebirdFPVHomepageView {
    WS(weakSelf);
    
    self.fpvHomepageView = [UIView new];
    self.fpvHomepageView.backgroundColor = [UIColor atrousColor];
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
    self.fpvLineView.backgroundColor = UICOLOR_FROM_HEXRGB(0x00ffa8);
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
    
    [self.myNavigationBar setNavigationBarButtonEventBlock:^(YNCEventAction eventAction){
        if (eventAction == YNCEventActionNavBarHomeBtn) {
            //do something
            [weakSelf performSegueWithIdentifier:@"unwindToFlight" sender:weakSelf];
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
  
#warning TODO: --
  [self.cameraToolView initSubView:YES];
  
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    [weakSelf setCameraToolViewShowStatus:NO];
  });
  [self.cameraToolView setCameraToolViewEventBlock:^(UIButton *sender) {
    switch (sender.tag) {
      case YNCEventActionCameraSwitchMode:
      {
        [weakSelf changeCurrentCameraMode];
      }
        break;
        
      case YNCEventActionCameraOperate:
      {
        [weakSelf takePhotoOrRecroding];
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
            //                        weakSelf.cameraSettingView.frame = CGRectMake(0, 0, width, kScreenHeight);
            [weakSelf.view layoutIfNeeded];
          }];
        }
      }
        break;
        
      case YNCEventActionCameraGallery:
      {
//        if ([[YNCCameraManager sharedCameraManager].totalStorage isEqualToString:@"0MB"]) {
//          [[YNCMessageBox instance] show:[NSString stringWithFormat:@"%@", NSLocalizedString(@"flight_interface_warning_CAMERA_NO_SDCARD", nil)]];
//          return;
//        }
//        YNCFB_DroneGalleryViewController *fb_droneGalleryVC = [[YNCFB_DroneGalleryViewController alloc] initWithNibName:NSStringFromClass([YNCFB_DroneGalleryViewController class]) bundle:[NSBundle mainBundle]];
//        [weakSelf.navigationController pushViewController:fb_droneGalleryVC animated:YES];
        
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
  }
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
  UIEvent *event = [[UIEvent alloc] init];
  CGPoint locataion = [gestureRecognizer locationInView:gestureRecognizer.view];
  UIView *view = [gestureRecognizer.view hitTest:locataion withEvent:event];
    
  return YES;
}

//MARK: -- 拍照/录像
- (void)takePhotoOrRecroding
{
  
}

//MARK: -- 开始录像
- (void)startRecord {
    [[AbeCamHandle sharedInstance] setRecordStatus:@1 result:^(BOOL succeeded) {
      [[YNCMessageBox instance] show:succeeded==YES?@"start Record succeeded":@"start Record failed"];
    }];
}
//MARK: -- 停止录像
- (void)stopRecord {
  [[AbeCamHandle sharedInstance] setRecordStatus:@0 result:^(BOOL succeeded) {
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
- (void)changeCurrentCameraMode {
  [[AbeCamHandle sharedInstance] setRecordStatus:@1 result:^(BOOL succeeded) {
    if (succeeded) {
      NSLog(@"open recored success ");
    }else{
      NSLog(@"strat record failed");
      
    }
  }];
}

//MARK: -- 翻转镜头
- (void)convertVideo:(BOOL)status {
  [[AbeCamHandle sharedInstance] setFlipWithStatus:[NSNumber numberWithBool:status] result:^(BOOL succeeded) {
    if (succeeded) {
      DLog( @"convert succeeded.");
    } else {
      DLog( @"convert failed.");
    }
  }];
}

//MARK: -- 切换FPV模式
- (void)switchFPVModel:(BOOL)isFPV {
  [[AbeCamHandle sharedInstance] setDualViewStatus:isFPV];
}

- (IBAction)clickTakePhotoButton:(UIButton *)sender {
  [self takePhoto];
}

- (IBAction)clickStartRecordButton:(UIButton *)sender {
  [self startRecord];
}

- (IBAction)clickStopRecordButton:(UIButton *)sender {
  [self stopRecord];
}

- (void)clickFPVSwitchButton:(UIButton *)sender {
  [sender setSelected:!sender.isSelected];
  [self switchFPVModel:sender.isSelected];
}

- (IBAction)clickConvertButton:(UIButton *)sender {
  [sender setSelected:!sender.isSelected];
  [self convertVideo:sender.isSelected];
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
