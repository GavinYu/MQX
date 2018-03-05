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

@interface YNCMqxViewController () <UIGestureRecognizerDelegate, YNCCameraSettingViewDelegate>

//相机工具栏
@property (strong, nonatomic) YNCCameraToolView *cameraToolView;
//当前的显示模式（普通模式 or 眼镜模式）
@property (assign, nonatomic) YNCModeDisplay currentDisplay;
//相机设置视图
@property (strong, nonatomic) YNCCameraSettingView *cameraSettingView;

@end

@implementation YNCMqxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  [self videoPreview];
  [self createCameraToolView];
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
    
//    _doubleClickCount++;
//    if (_doubleClickCount == 1) {
//      [self.firebirdHomepageView hiddenSubView:YES withDoubleClickCount:_doubleClickCount];
//      [self.leftFirebirdHomepageView hiddenSubView:YES withDoubleClickCount:_doubleClickCount];
//      [self.rightFirebirdHomepageView hiddenSubView:YES withDoubleClickCount:_doubleClickCount];
//    } else if (_doubleClickCount == 2) {
//      [UIView animateWithDuration:0.3 animations:^{
//        weakSelf.myNavigationBar.alpha = 0;
//        weakSelf.fpvSwitchButton.alpha = 0;
//      }];
//
//      [self.firebirdHomepageView hiddenSubView:YES withDoubleClickCount:_doubleClickCount];
//      //            [self.leftFirebirdHomepageView hiddenSubView:YES withDoubleClickCount:_doubleClickCount];
//      //            [self.rightFirebirdHomepageView hiddenSubView:YES withDoubleClickCount:_doubleClickCount];
//
//    } else if (_doubleClickCount == 3) {
//      [UIView animateWithDuration:0.3 animations:^{
//        weakSelf.myNavigationBar.alpha = 1.0;
//        weakSelf.fpvSwitchButton.alpha = 1.0;
//      }];
    
//      [self.firebirdHomepageView hiddenSubView:NO withDoubleClickCount:_doubleClickCount];
//      [self.leftFirebirdHomepageView hiddenSubView:NO withDoubleClickCount:_doubleClickCount];
//      [self.rightFirebirdHomepageView hiddenSubView:NO withDoubleClickCount:_doubleClickCount];
//
//      _doubleClickCount = 0;
//    }
  }
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
  UIEvent *event = [[UIEvent alloc] init];
  CGPoint locataion = [gestureRecognizer locationInView:gestureRecognizer.view];
  UIView *view = [gestureRecognizer.view hitTest:locataion withEvent:event];
//  if ([view isKindOfClass:[YNCFlightStatusView_Firebird class]] || [view isKindOfClass:[YNCStatusView_Firebird class]] || [view isKindOfClass:[YNCTransformView class]]) {
//    return YES;
//  } else {
//    return NO;
//  }
  
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

- (IBAction)clickFPVButton:(UIButton *)sender {
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
