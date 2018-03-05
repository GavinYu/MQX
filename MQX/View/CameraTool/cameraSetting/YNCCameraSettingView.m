//
//  YNCCameraSettingView.m
//  YuneecApp
//
//  Created by vrsh on 20/03/2017.
//  Copyright © 2017 yuneec. All rights reserved.
//

#import "YNCCameraSettingView.h"
#import "YNCCameraCommonSettingView.h"
#import "YNCFB_ShutterView.h"
#import "YNCPopWindowView.h"
#import "YNCAppConfig.h"

#define kAnimationTime 0.3
#define kViewWidth 210.0

@interface YNCCameraSettingView ()<YNCCameraCommonSettingViewDelegate>

@property (nonatomic, copy) NSDictionary *dataDictionary;
@property (nonatomic, strong) YNCCameraCommonSettingView *cameraSettingView; // 相机设置主页
@property (nonatomic, strong) YNCCameraCommonSettingView *whiteBlanceView; // 白平衡视图
@property (nonatomic, strong) YNCCameraCommonSettingView *cameraModeView; // 拍照模式
@property (nonatomic, strong) YNCCameraCommonSettingView *meteringModeView; // 测光模式
@property (nonatomic, strong) YNCCameraCommonSettingView *scenesModeView; // 场景模式视图
@property (nonatomic, strong) YNCCameraCommonSettingView *videoFormatView; // 视频格式
@property (nonatomic, strong) YNCCameraCommonSettingView *videoResolutionView; // 视频尺寸视图
@property (nonatomic, strong) YNCCameraCommonSettingView *photoFormatView; // 照片格式
@property (nonatomic, strong) YNCCameraCommonSettingView *photoResolutionView; // 照片尺寸
@property (nonatomic, strong) YNCCameraCommonSettingView *photoQualityView; // 照片质量
@property (nonatomic, strong) YNCCameraCommonSettingView *flickerModeView; // 频闪模式
@property (nonatomic, assign) YNCCameraSettingViewType type;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSIndexPath *previousIndexPath;

@end

@implementation YNCCameraSettingView

- (NSDictionary *)dataDictionary
{
    if (!_dataDictionary) {
        self.dataDictionary = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    return _dataDictionary;
}

- (void)createUI
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(self.frame.size.width - kViewWidth-10, 16, kViewWidth, self.frame.size.height - 32)];
    _scrollView.contentSize = CGSizeMake(kViewWidth * 2, self.frame.size.height - 32);
    _scrollView.scrollEnabled = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.alpha = 0.9;
    [self addSubview:_scrollView];
    
    self.cameraSettingView = [[YNCCameraCommonSettingView alloc] initWithFrame:CGRectMake(0, 0, kViewWidth, _scrollView.frame.size.height)];
    [_scrollView addSubview:_cameraSettingView];
    _cameraSettingView.delegate = self;
    _cameraSettingView.cameraSettingViewType = YNCCameraSettingViewTypeCameraSetting;
    _cameraSettingView.showBackBtn = NO;
    _cameraSettingView.hasFooterView = YES;
    _cameraSettingView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.9];
    self.type = YNCCameraSettingViewTypeCameraSetting;
//    self.cameraManager = [YNCCameraManager sharedCameraManager];
//    _cameraSettingView.dataDictionary = self.cameraManager.dataDictionary;
    [self addObserver:self forKeyPath:@"cameraManager.freeStorage" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}

#pragma mark - YNCCameraCommonSettingViewDelegate
- (void)cameraSettingView_didSelectedIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = self.scrollView.frame.size.width;
    switch (indexPath.row) {
        case 4: //白平衡
        {
            self.whiteBlanceView = [[YNCCameraCommonSettingView alloc] initWithFrame:CGRectMake(width, 0, kViewWidth, _scrollView.frame.size.height)];
            _whiteBlanceView.delegate = self;
            [_scrollView addSubview:_whiteBlanceView];
            _whiteBlanceView.showBackBtn = YES;
            _whiteBlanceView.hasFooterView = NO;
            _whiteBlanceView.cameraSettingViewType = YNCCameraSettingViewTypeWhiteBlance;
            self.type = YNCCameraSettingViewTypeWhiteBlance;
            NSString *path = [[NSBundle mainBundle] pathForResource:@"WhiteBalance" ofType:@"plist"];
            _whiteBlanceView.dataDictionary = [NSMutableDictionary dictionaryWithContentsOfFile:path];
//            NSString *whiteBalanceStr = [[YNCCameraManager sharedCameraManager] getDictionaryWithIndex:0];
//            NSIndexPath *originIndexPath = [YNCCameraUtility convertWhiteBalanceStrToIndexPath:whiteBalanceStr];
//            if (originIndexPath) {
//                _whiteBlanceView.originIndexPath = originIndexPath;
//            }
//            [[YNCCameraManager sharedCameraManager] getWhiteBalanceMode:^(NSError * _Nullable error, YuneecCameraWhiteBalanceMode whiteBalanceMode, NSUInteger manualWhiteBalanceValue) {
//                if (error) {
//                    kLOG_ERROR;
//                } else {
//                    _whiteBlanceView.originIndexPath = [YNCCameraUtility convertWhiteBalanceModeToIndexPath:whiteBalanceMode];
//                }
//            }];
            [self pushView];
        }
            break;
            
        case 5: // 拍照模式
        {
            //在录像模式下不支持设置拍照模式（间拍、连拍等等）
//            if (self.cameraManager.cameraMode == YuneecCameraModeVideo) {
//                [self postNotificationWithNumber:YNCWARNING_SHOT_MODE_NO_SUPPORT_VIDEO_MODE];
//                return;
//            }
            self.cameraModeView = [[YNCCameraCommonSettingView alloc] initWithFrame:CGRectMake(width, 0, kViewWidth, _scrollView.frame.size.height)];
            _cameraModeView.delegate = self;
            [_scrollView addSubview:_cameraModeView];
            _cameraModeView.showBackBtn = YES;
            _cameraModeView.hasFooterView = NO;
            _cameraModeView.cameraSettingViewType = YNCCameraSettingViewTypeCameraMode;
            self.type = YNCCameraSettingViewTypeCameraMode;
            NSString *path = [[NSBundle mainBundle] pathForResource:@"YNCFB_CameraMode" ofType:@"plist"];
            _cameraModeView.dataDictionary = [NSMutableDictionary dictionaryWithContentsOfFile:path];
//            NSString *cameraModeStr = [[YNCCameraManager sharedCameraManager] getDictionaryWithIndex:1];
//            NSIndexPath *originIndexPath = [YNCCameraUtility convertCameraModeStrToIndexPath:cameraModeStr];
//            if (originIndexPath) {
//                _cameraModeView.originIndexPath = originIndexPath;
//            }
//            [[YNCCameraManager sharedCameraManager] getFlickerMode:^(NSError * _Nullable error, YuneecCameraFlickerMode flickerMode) {
//                if (error) {
//                    kLOG_ERROR;
//                } else {
//                    _cameraModeView.originIndexPath = [YNCCameraUtility convertFlickerModeToIndexPath:flickerMode];
//                }
//            }];
            [self pushView];
        }
            
            break;
        case 6: // 测光模式
        {
            self.meteringModeView = [[YNCCameraCommonSettingView alloc] initWithFrame:CGRectMake(width, 0, kViewWidth, _scrollView.frame.size.height)];
            _meteringModeView.delegate = self;
            [_scrollView addSubview:_meteringModeView];
            _meteringModeView.showBackBtn = YES;
            _meteringModeView.hasFooterView = NO;
            _meteringModeView.cameraSettingViewType = YNCCameraSettingViewTypeMeteringMode;
            self.type = YNCCameraSettingViewTypeMeteringMode;
            NSString *path = [[NSBundle mainBundle] pathForResource:@"YNCFB_MeteringMode" ofType:@"plist"];
            _meteringModeView.dataDictionary = [NSMutableDictionary dictionaryWithContentsOfFile:path];
//            NSString *meteringModeStr = [[YNCCameraManager sharedCameraManager] getDictionaryWithIndex:2];
//            NSIndexPath *originIndexPath = [YNCCameraUtility convertMeterModeStrToIndexPath:meteringModeStr];
//            if (originIndexPath) {
//                _meteringModeView.originIndexPath = originIndexPath;
//            }
            [self pushView];
        }
            
            break;
        case 7: // 场景模式
        {
            self.scenesModeView = [[YNCCameraCommonSettingView alloc] initWithFrame:CGRectMake(width, 0, kViewWidth, _scrollView.frame.size.height)];
            _scenesModeView.delegate = self;
            [_scrollView addSubview:_scenesModeView];
            _scenesModeView.showBackBtn = YES;
            _scenesModeView.hasFooterView = NO;
            _scenesModeView.cameraSettingViewType = YNCCameraSettingViewTypeScenesMode;
            self.type = YNCCameraSettingViewTypeScenesMode;
            NSString *path = [[NSBundle mainBundle] pathForResource:@"ScenesMode" ofType:@"plist"];
            _scenesModeView.dataDictionary = [NSMutableDictionary dictionaryWithContentsOfFile:path];
//            NSString *scencesModeStr = [[YNCCameraManager sharedCameraManager] getDictionaryWithIndex:3];
//            NSIndexPath *originIndexPath = [YNCCameraUtility convertScenseModeStrToIndexPath:scencesModeStr];
//            if (originIndexPath) {
//                _scenesModeView.originIndexPath = originIndexPath;
//            }
//            [[YNCCameraManager sharedCameraManager] getImageQualityMode:^(NSError * _Nullable error, YuneecCameraImageQualityMode imageQualityMode) {
//                if (error) {
//                    kLOG_ERROR;
//                } else {
//                    _scenesModeView.originIndexPath = [YNCCameraUtility converImageQualityModeToIndexPath:imageQualityMode];
//                }
//            }];
            [self pushView];
        }
            
            break;
        case 8: // 视频格式
        {
            self.videoFormatView = [[YNCCameraCommonSettingView alloc] initWithFrame:CGRectMake(width, 0, kViewWidth, _scrollView.frame.size.height)];
            _videoFormatView.delegate = self;
            [_scrollView addSubview:_videoFormatView];
            _videoFormatView.showBackBtn = YES;
            _videoFormatView.hasFooterView = NO;
            _videoFormatView.cameraSettingViewType = YNCCameraSettingViewTypeVideoFormat;
            self.type = YNCCameraSettingViewTypeVideoFormat;
            NSString *path = [[NSBundle mainBundle] pathForResource:@"YNCFB_VideoFormat" ofType:@"plist"];
            _videoFormatView.dataDictionary = [NSMutableDictionary dictionaryWithContentsOfFile:path];
//            NSString *videoFormatStr = [[YNCCameraManager sharedCameraManager] getDictionaryWithIndex:4];
//            NSIndexPath *originIndexPath = [YNCCameraUtility convertVideoFormatStrToIndexPath:videoFormatStr];
//            if (originIndexPath) {
//                _videoFormatView.originIndexPath = originIndexPath;
//            }
            [self pushView];
        }
            
            break;
        case 9: // 视频尺寸
        {
            //在拍照模式下不支持设置视频尺寸
//            if (self.cameraManager.cameraMode == YuneecCameraModePhoto) {
//                [self postNotificationWithNumber:YNCWARNING_VIDEO_RESOLUTION_NO_SUPPORT_PHOTO_MODE];
//                return;
//            }
          
            self.videoResolutionView = [[YNCCameraCommonSettingView alloc] initWithFrame:CGRectMake(width, 0, kViewWidth, _scrollView.frame.size.height)];
            _videoResolutionView.delegate = self;
            [_scrollView addSubview:_videoResolutionView];
            _videoResolutionView.showBackBtn = YES;
            _videoResolutionView.hasFooterView = NO;
            _videoResolutionView.cameraSettingViewType = YNCCameraSettingViewTypeVideoResolution;
            self.type = YNCCameraSettingViewTypeVideoResolution;
            NSString *path = [[NSBundle mainBundle] pathForResource:@"YNCFB_VideoResolution" ofType:@"plist"];
            _videoResolutionView.dataDictionary = [NSMutableDictionary dictionaryWithContentsOfFile:path];
//            NSString *videoResolutionStr = [[YNCCameraManager sharedCameraManager] getDictionaryWithIndex:5];
//            NSIndexPath *originIndexPath = [YNCCameraUtility convertVideoResolutionStrToIndexPath:videoResolutionStr];
//            if (originIndexPath) {
//                _videoResolutionView.originIndexPath = originIndexPath;
//            }
//            [[YNCCameraManager sharedCameraManager] getVideoResolution:^(NSError * _Nullable error, YuneecCameraVideoResolution resolution, YuneecCameraVideoFrameRate frameRate) {
//                if (error) {
//                    kLOG_ERROR;
//                } else {
//                    _videoResolutionView.originIndexPath = [YNCCameraUtility convertVideoResolutionAndFrameRateToIndexPath:resolution frameRate:frameRate];
//                }
//            }];
            [self pushView];
        }
            
            break;
        case 10: // 照片格式
        {
            self.photoFormatView = [[YNCCameraCommonSettingView alloc] initWithFrame:CGRectMake(width, 0, kViewWidth, _scrollView.frame.size.height)];
            _photoFormatView.delegate = self;
            [_scrollView addSubview:_photoFormatView];
            _photoFormatView.showBackBtn = YES;
            _photoFormatView.hasFooterView = NO;
            _photoFormatView.cameraSettingViewType = YNCCameraSettingViewTypePhotoFormat;
            self.type = YNCCameraSettingViewTypePhotoFormat;
            NSString *path = [[NSBundle mainBundle] pathForResource:@"YNCFB_PhotoFormat" ofType:@"plist"];
            _photoFormatView.dataDictionary = [NSMutableDictionary dictionaryWithContentsOfFile:path];
//            NSString *photoFormatStr = [[YNCCameraManager sharedCameraManager] getDictionaryWithIndex:6];
//            NSIndexPath *originIndexPath = [YNCCameraUtility convertPhotoFormatStrToIndexPath:photoFormatStr];
//            if (originIndexPath) {
//                _photoFormatView.originIndexPath = originIndexPath;
//            }
            [self pushView];
        }
            
            break;
        case 11: // 照片尺寸
        {
            self.photoResolutionView = [[YNCCameraCommonSettingView alloc] initWithFrame:CGRectMake(width, 0, kViewWidth, _scrollView.frame.size.height)];
            _photoResolutionView.delegate = self;
            [_scrollView addSubview:_photoResolutionView];
            _photoResolutionView.showBackBtn = YES;
            _photoResolutionView.hasFooterView = NO;
            _photoResolutionView.cameraSettingViewType = YNCCameraSettingViewTypePhotoResolution;
            self.type = YNCCameraSettingViewTypePhotoResolution;
            NSString *path = [[NSBundle mainBundle] pathForResource:@"YNCFB_PhotoResolution" ofType:@"plist"];
            _photoResolutionView.dataDictionary = [NSMutableDictionary dictionaryWithContentsOfFile:path];
//            NSString *photoResolutionStr = [[YNCCameraManager sharedCameraManager] getDictionaryWithIndex:7];
//            NSIndexPath *originIndexPath = [YNCCameraUtility convertPhotoResolutionStrToIndexPath:photoResolutionStr];
//            if (originIndexPath) {
//                _photoResolutionView.originIndexPath = originIndexPath;
//            }
            [self pushView];
        }
            break;
            
        case 12: // 照片质量
        {
            self.photoQualityView = [[YNCCameraCommonSettingView alloc] initWithFrame:CGRectMake(width, 0, kViewWidth, _scrollView.frame.size.height)];
            _photoQualityView.delegate = self;
            [_scrollView addSubview:_photoQualityView];
            _photoQualityView.showBackBtn = YES;
            _photoQualityView.hasFooterView = NO;
            _photoQualityView.cameraSettingViewType = YNCCameraSettingViewTypePhotoQuality;
            self.type = YNCCameraSettingViewTypePhotoQuality;
            NSString *path = [[NSBundle mainBundle] pathForResource:@"YNCFB_PhotoQuality" ofType:@"plist"];
            _photoQualityView.dataDictionary = [NSMutableDictionary dictionaryWithContentsOfFile:path];
//            NSString *photoQualityStr = [[YNCCameraManager sharedCameraManager] getDictionaryWithIndex:8];
//            NSIndexPath *originIndexPath = [YNCCameraUtility convertPhotoQualityStrToIndexPath:photoQualityStr];
//            if (originIndexPath) {
//                _photoQualityView.originIndexPath = originIndexPath;
//            }
            [self pushView];
        }
            break;
        case 13: // 频闪模式
        {
            self.flickerModeView = [[YNCCameraCommonSettingView alloc] initWithFrame:CGRectMake(width, 0, kViewWidth, _scrollView.frame.size.height)];
            _flickerModeView.delegate = self;
            [_scrollView addSubview:_flickerModeView];
            _flickerModeView.showBackBtn = YES;
            _flickerModeView.hasFooterView = NO;
            _flickerModeView.cameraSettingViewType = YNCCameraSettingViewTypeFlickerMode;
            self.type = YNCCameraSettingViewTypeFlickerMode;
            NSString *path = [[NSBundle mainBundle] pathForResource:@"YNCFB_FlickerValue" ofType:@"plist"];
            _flickerModeView.dataDictionary = [NSMutableDictionary dictionaryWithContentsOfFile:path];
//            NSString *flickerModeStr = [[YNCCameraManager sharedCameraManager] getDictionaryWithIndex:9];
//            NSIndexPath *originIndexPath = [YNCCameraUtility convertFlickerModeStrToIndexPath:flickerModeStr];
//            if (originIndexPath) {
//                _flickerModeView.originIndexPath = originIndexPath;
//            }
//            [[YNCCameraManager sharedCameraManager] getFlickerMode:^(NSError * _Nullable error, YuneecCameraFlickerMode flickerMode) {
//                if (error) {
//                    kLOG_ERROR;
//                } else {
//                    _flickerModeView.originIndexPath = [YNCCameraUtility convertFlickerModeToIndexPath:flickerMode];
//                }
//            }];
            [self pushView];
        }
            break;
        default:
            break;
    }
}

// MARK:推出动画
- (void)pushView
{
    [UIView animateWithDuration:0.2 animations:^{
        _scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width, 0);
    }];
}

- (void)popView:(UIView *)view
{
    __block UIView *newView = view;
    [UIView animateWithDuration:0.2 animations:^{
        _scrollView.contentOffset = CGPointMake(0, 0);
    } completion:^(BOOL finished) {
        self.type = YNCCameraSettingViewTypeCameraSetting;
        [newView removeFromSuperview];
        newView = nil;
    }];
}

#pragma mark - 0.白平衡
- (void)whiteBalanceView_didSelectedIndexPath:(NSIndexPath *)indexPath
{
    //白平衡
//    YuneecCameraWhiteBalanceMode whiteBalanceMode;
//    if (indexPath.row == 0) {
//        whiteBalanceMode = YuneecCameraWhiteBalanceModeAuto;
//    } else if (indexPath.row == 1) {
//        whiteBalanceMode = YuneecCameraWhiteBalanceModeSunny;
//    } else if (indexPath.row == 2) {
//        whiteBalanceMode = YuneecCameraWhiteBalanceModeSunrise;
//    } else if (indexPath.row == 3) {
//        whiteBalanceMode = YuneecCameraWhiteBalanceModeSunset;
//    } else if (indexPath.row == 4) {
//        whiteBalanceMode = YuneecCameraWhiteBalanceModeCloudy;
//    } else if (indexPath.row == 5) {
//        whiteBalanceMode = YuneecCameraWhiteBalanceModeFlucrescent;
//    } else if (indexPath.row == 6) {
//        whiteBalanceMode = YuneecCameraWhiteBalanceModeIncandescent;
//    } else{
//        whiteBalanceMode = YuneecCameraWhiteBalanceModeLock;
//    }
//    WS(weakSelf);
//    [[YNCCameraManager sharedCameraManager] setWhiteBalanceMode:whiteBalanceMode block:^(NSError * _Nullable error) {
//        if (error == nil) {
//#ifdef OPENTOAST_HANK
//            [[YNCMessageBox instance] show:@"set White Balance success"];
//#endif
////            NSString *whiteBalanace = [YNCCameraUtility convertWhiteBalanceModeToString:whiteBalanceMode];
////            [[YNCCameraManager sharedCameraManager] getDictionaryWithIndex:0 content:whiteBalanace];
//
//            [_whiteBlanceView whiteBalance_changeCellStyleWithIndexPath:indexPath];
//        } else {
//            [weakSelf postNotificationWithNumber:YNCWARNING_CAMERA_SET_WB_FAILED];
//            kLOG_ERROR;
//        }
//    }];
}

#pragma mark - 1.拍照模式
- (void)cameraModeView_didSelectedIndexPath:(NSIndexPath *)indexPath
{
//    if ([YNCCameraManager sharedCameraManager].photoMode == YuneecCameraPhotoModeTimeLapse) {
//        if (indexPath.row == 2) {
//            return;
//        }
//    } else if ([YNCCameraManager sharedCameraManager].photoMode == YuneecCameraPhotoModeBurst) {
//        if (indexPath.row == 1) {
//            return;
//        }
//    }
//    if ([YNCCameraManager sharedCameraManager].isCapturingPhotoTimelapse) {
//        [self postNotificationWithNumber:YNCWARNING_PHOTO_MODE_TIMELAPSE_CAN_NOT_SETTING_CAMERA_MODE];
//        return;
//    }
//    BOOL isChangeCell = NO;
//    YuneecCameraPhotoMode photoMode = YuneecCameraPhotoModeSingle;
//    NSInteger changeRow = 0;
//    NSUInteger amount = [YNCCameraManager sharedCameraManager].currentBurstAmount;
//    NSUInteger millisecond = 0;
//    YuneecRational *evStep = [[YuneecRational alloc] initWithNumerator:0 denominator:1];
//
//    if (indexPath.row == 0) {
//        changeRow = 0;
//        photoMode = YuneecCameraPhotoModeSingle;
//        isChangeCell = YES;
//    } else if (indexPath.row == 1) { // 连拍
//        changeRow = 1;
//        photoMode = YuneecCameraPhotoModeBurst;
//        isChangeCell = YES;
//        amount = 3;
//    } else if (indexPath.row == 2){ // 间隔拍照
//        if ([YNCCameraManager sharedCameraManager].photoMode != YuneecCameraPhotoModeBurst) {
//            changeRow = 2;
//            photoMode = YuneecCameraPhotoModeTimeLapse;
//            isChangeCell = YES;
//            millisecond = 2;
//        }
//    } else {
//        if ([YNCCameraManager sharedCameraManager].photoMode == YuneecCameraPhotoModeBurst) {
//            changeRow = 2;
//            photoMode = YuneecCameraPhotoModeTimeLapse;
//            isChangeCell = YES;
//            millisecond = 2000;
//        }
//    }
//
//    NSString *photoModeStr = [YNCCameraUtility convertPhotoModeToString:photoMode];
//    WS(weakSelf);
//    if ([YNCCameraManager sharedCameraManager].photoMode == photoMode) {
//        return;
//    }
//    [[YNCCameraManager sharedCameraManager] setPhotoMode:photoMode amount:amount millisecond:millisecond evStep:evStep block:^(NSError * _Nullable error) {
//        if (error == nil) {
//#ifdef OPENTOAST_HANK
//            [[YNCMessageBox instance] show:@"set photo mode success"];
//#endif
//            [[YNCCameraManager sharedCameraManager] setDictionaryWithIndex:1 content:photoModeStr];
//            [YNCCameraManager sharedCameraManager].photoMode = photoMode;
//            if (photoMode == YuneecCameraPhotoModeBurst) {
//                [YNCCameraManager sharedCameraManager].currentBurstAmount = amount;
//            } else if (photoMode == YuneecCameraPhotoModeTimeLapse) {
//                [YNCCameraManager sharedCameraManager].currentMillisecond = millisecond;
//            }
//            dispatch_async(dispatch_get_main_queue(), ^{
//                if (isChangeCell) {
//                    [weakSelf.cameraModeView reloadTableView];
//                    NSIndexPath *changeIndexPath = [NSIndexPath indexPathForRow:changeRow inSection:0];
//                    [weakSelf.cameraModeView cameraMode_changeCellStyleWithIndexPath:changeIndexPath];
//                }
//            });
//        } else {
//            [weakSelf postNotificationWithNumber:YNCWARNING_PHOTO_MODE_BURST_FAILED];
//        }
//    }];
}

#pragma mark - 拍照模式 - 连拍
- (void)fb_photoModeBurstNumber:(UIButton *)btn
{
//    YuneecCameraPhotoMode photoMode = YuneecCameraPhotoModeBurst;
//    NSUInteger amount = 3;
//    NSUInteger millisecond = 0;
//    YuneecRational *evStep = [[YuneecRational alloc] initWithNumerator:0 denominator:1];
//    if (btn.tag == 203) {
//        amount = 3;
//    } else if (btn.tag == 205) {
//        amount = 5;
//    } else if (btn.tag == 207) {
//        amount = 7;
//    }
//    WS(weakSelf);
//    [[YNCCameraManager sharedCameraManager] setPhotoMode:photoMode amount:amount millisecond:millisecond evStep:evStep block:^(NSError * _Nullable error) {
//        if (error == nil) {
//            [_cameraModeView changeBurstCellBtnTitleColor:amount];
//        } else {
//            [weakSelf postNotificationWithNumber:YNCWARNING_PHOTO_MODE_BURST_FAILED];
//        }
//    }];
}

#pragma mark - 拍照模式 - 间隔拍摄
- (void)fb_photoModeTimeLapse:(UIButton *)btn
{
//    if ([YNCCameraManager sharedCameraManager].isCapturingPhotoTimelapse) {
//        [self postNotificationWithNumber:YNCWARNING_PHOTO_MODE_TIMELAPSE_CAN_NOT_SETTING_CAMERA_MODE];
//        return;
//    }
//    YuneecCameraPhotoMode photoMode = YuneecCameraPhotoModeTimeLapse;
//    NSUInteger amount = 0;
//    NSUInteger millisecond = 0;
//    YuneecRational *evStep = [[YuneecRational alloc] initWithNumerator:0 denominator:1];
//    if (btn.tag == 402) {
//        millisecond = 2000;
//    } else if (btn.tag == 405) {
//        millisecond = 5000;
//    } else if (btn.tag == 410) {
//        millisecond = 10000;
//    } else if (btn.tag == 415) {
//        millisecond = 15000;
//    } else if (btn.tag == 420) {
//        millisecond = 20000;
//    }
//    WS(weakSelf);
//    [[YNCCameraManager sharedCameraManager] setPhotoMode:photoMode amount:amount millisecond:millisecond evStep:evStep block:^(NSError * _Nullable error) {
//        if (error == nil) {
//            [_cameraModeView changeTimeLapseCellBtnTitleColor:millisecond];
//        } else {
//            [weakSelf postNotificationWithNumber:YNCWARNING_PHOTO_MODE_TIMELAPSE_FAILED];
//        }
//    }];
}

#pragma mark - 2.测光模式
- (void)meteringModeView_didSelectedIndexPath:(NSIndexPath *)indexPath
{
//    if ([YNCCameraManager sharedCameraManager].current_aeMode == YuneecCameraAEModeManual) {
//        [[YNCMessageBox instance] show:NSLocalizedString(@"camera_setting_metering_warning", nil)];
//        return;
//    }
//
//    YuneecCameraMeterMode meterMode;
//    if (indexPath.row == 0) {
//        meterMode = YuneecCameraMeterModeAverage;
//    } else if (indexPath.row == 1) {
//        meterMode = YuneecCameraMeterModeCenter;
//    } else  {
//        meterMode = YuneecCameraMeterModeSpot;
//    }
//    WS(weakSelf);
//    [[YNCCameraManager sharedCameraManager] setMeterMode:meterMode block:^(NSError * _Nullable error) {
//        if (error == nil) {
//#ifdef OPENTOAST_HANK
//            [[YNCMessageBox instance] show:@"set Meter mode success"];
//#endif
//            [YNCCameraManager sharedCameraManager].meterMode = meterMode;
//            [_meteringModeView videoMode_changeCellStyleWithIndexPath:indexPath];
//        } else {
//            [weakSelf postNotificationWithNumber:YNCWARNING_METER_MODE_FAILED];
//        }
//    }];
}

#pragma mark - 3.场景模式
- (void)sceneModeView_didSelectedIndexPath:(NSIndexPath *)indexPath
{
//    YuneecCameraImageQualityMode imageQualityMode;
//    if (indexPath.row == 0) {
//        imageQualityMode = YuneecCameraImageQualityModeNature;
//    } else if (indexPath.row == 1) {
//        imageQualityMode = YuneecCameraImageQualityModeSaturation;
//    } else if (indexPath.row == 2) {
//        imageQualityMode = YuneecCameraImageQualityModeRaw;
//    } else {
//        imageQualityMode = YuneecCameraImageQualityModeNight;
//    }
//    WS(weakSelf);
//    [[YNCCameraManager sharedCameraManager] setImageQualityMode:imageQualityMode block:^(NSError * _Nullable error) {
//        if (error == nil) {
//#ifdef OPENTOAST_HANK
//            [[YNCMessageBox instance] show:@"set image quality success"];
//#endif
////            NSString *imageQuality = [YNCCameraUtility converImageQualityModeToString:imageQualityMode];
////            [[YNCCameraManager sharedCameraManager] getDictionaryWithIndex:3 content:imageQuality];
//            [_scenesModeView videoMode_changeCellStyleWithIndexPath:indexPath];
//        } else {
//            [weakSelf postNotificationWithNumber:YNCWARNING_IMAGE_QUALITY_MODE_FAILED];
//        }
//    }];
}

#pragma mark - 4.视频格式
- (void)videoFormatView_didSelectedIndexPath:(NSIndexPath *)indexPath
{
//    YuneecCameraVideoFileFormat videoFileFormat;
//    if (indexPath.row == 0) {
//        videoFileFormat = YuneecCameraVideoFileFormatMP4;
//    } else {
//        videoFileFormat = YuneecCameraVideoFileFormatMOV;
//    }
//    WS(weakSelf);
//    [[YNCCameraManager sharedCameraManager] setVideoFileFormat:videoFileFormat block:^(NSError * _Nullable error) {
//        if (error == nil) {
//#ifdef OPENTOAST_HANK
//            [[YNCMessageBox instance] show:@"set video file format success"];
//#endif
//            [_videoFormatView videoMode_changeCellStyleWithIndexPath:indexPath];
//        } else {
//            [weakSelf postNotificationWithNumber:YNCWARNING_VIDEO_FILE_FORMAT_FAILED];
//        }
//    }];
}

#pragma mark - 5.视频尺寸
- (void)videoResolutionView_didSelectedIndexPath:(NSIndexPath *)indexPath
{
//    YuneecCameraVideoResolution videoResolution;
//    YuneecCameraVideoFrameRate videoFrameRate;
//    NSString *warningStr = nil;
//    if (indexPath.row == 0) {
//        videoResolution = YuneecCameraVideoResolution3840x2160;
//        videoFrameRate = YuneecCameraVideoFrameRate30FPS;
//        warningStr = NSLocalizedString(@"camera_setting_fpv_warning", nil);
//    } else if (indexPath.row == 1) {
//        videoResolution = YuneecCameraVideoResolution1920x1080;
//        videoFrameRate = YuneecCameraVideoFrameRate30FPS;
//        warningStr = NSLocalizedString(@"camera_setting_fpv_warning", nil);
//    } else {
//        videoResolution = YuneecCameraVideoResolution1280x720;
//        videoFrameRate = YuneecCameraVideoFrameRate60FPS;
//    }
//    WS(weakSelf);
//    [[YNCCameraManager sharedCameraManager] setVideoResolution:videoResolution framerate:videoFrameRate block:^(NSError * _Nullable error) {
//        if (error) {
//            [weakSelf postNotificationWithNumber:YNCWARNING_VIDEO_RESOLUTION_FAILED];
//        } else {
//            if (warningStr != nil) {
//                [[YNCMessageBox instance] show:warningStr];
//            }
//            [_videoResolutionView videoMode_changeCellStyleWithIndexPath:indexPath];
//        }
//    }];
}

#pragma mark - 6.照片格式
- (void)photoFormatView_didSelectedIndexPath:(NSIndexPath *)indexPath
{
//    YuneecCameraPhotoFormat photoFormat;
//    if (indexPath.row == 0) {
//        photoFormat = YuneecCameraPhotoFormatJpg;
//    } else {
//        photoFormat = YuneecCameraPhotoFormatJpgRaw;
//    }
//    WS(weakSelf);
//    [[YNCCameraManager sharedCameraManager] setPhotoFormat:photoFormat block:^(NSError * _Nullable error) {
//        if (error) {
//            [weakSelf postNotificationWithNumber:YNCWARNING_PHOTO_FORMAT_FAILED];
//        } else {
//#ifdef OPENTOAST_HANK
//            [[YNCMessageBox instance] show:@"set Phote Format success"];
//#endif
//            [_photoFormatView videoMode_changeCellStyleWithIndexPath:indexPath];
//        }
//    }];
}

#pragma mark - 7.照片尺寸
- (void)photoResolutionView_didSelectedIndexPath:(NSIndexPath *)indexPath
{
//    WS(weakSelf);
//    if (indexPath.row == 0) {
//        [[YNCCameraManager sharedCameraManager] setPhotoResolution:YuneecCameraPhotoResolution4160x3120 block:^(NSError * _Nullable error) {
//            if (error == nil) {
//#ifdef OPENTOAST_HANK
//                [[YNCMessageBox instance] show:@"setResolution4160x3120_Success"];
//#endif
////                NSString *photoResolution = [YNCCameraUtility convertPhotoResolutionToString:YuneecCameraPhotoResolution4160x3120];
////                [[YNCCameraManager sharedCameraManager] getDictionaryWithIndex:7 content:photoResolution];
//                [[YNCCameraManager sharedCameraManager] setPhotoAspectRatio:YuneecCameraPhotoAspectRatio4_3 block:^(NSError * _Nullable error) {
//                    if (error) {
//                        [weakSelf postNotificationWithNumber:YNCWARNING_PHOTO_RESOLUTION_FAILED];
//                    } else {
//#ifdef OPENTOAST_HANK
//                        [[YNCMessageBox instance] show:@"set Camera photo aspect ratio 4:3"];
//#endif
//                        [_photoResolutionView videoMode_changeCellStyleWithIndexPath:indexPath];
//                    }
//                }];
//            } else {
//                kLOG_ERROR;
//            }
//        }];
//    }
}

#pragma mark - 8.照片质量
- (void)photoQualityView_didSelectedIndexPath:(NSIndexPath *)indexPath
{
//    YuneecCameraPhotoQuality photoQuality;
//    if (indexPath.row == 0) {
//        photoQuality = YuneecCameraPhotoQualityLow;
//    } else if (indexPath.row == 1) {
//        photoQuality = YuneecCameraPhotoQualityNormal;
//    } else if (indexPath.row == 2) {
//        photoQuality = YuneecCameraPhotoQualityHigh;
//    } else {
//        photoQuality = YuneecCameraPhotoQualityUltraHigh;
//    }
//    WS(weakSelf);
//    [[YNCCameraManager sharedCameraManager] setPhotoQuality:photoQuality block:^(NSError * _Nullable error) {
//        if (error) {
//            [weakSelf postNotificationWithNumber:YNCWARNING_PHOTO_QUALITY_FAILED];
//        } else {
//#ifdef OPENTOAST_HANK
//            [[YNCMessageBox instance] show:@"photo Quality set success"];
//#endif
//            [_photoQualityView videoMode_changeCellStyleWithIndexPath:indexPath];
//        }
//    }];
}

#pragma mark - 9.抗频闪
- (void)fickerModeView_didSelectedIndexPath:(NSIndexPath *)indexPath
{
//    YuneecCameraFlickerMode flickerMode;
//    if (indexPath.row == 0) {
//        flickerMode = YuneecCameraFlickerModeAuto;
//    } else if (indexPath.row == 1) {
//        flickerMode = YuneecCameraFlickerMode50Hz;
//    } else {
//        flickerMode = YuneecCameraFlickerMode60Hz;
//    }
//    WS(weakSelf);
//    [[YNCCameraManager sharedCameraManager] setFlickerMode:flickerMode block:^(NSError * _Nullable error) {
//        if (error) {
//            [weakSelf postNotificationWithNumber:YNCWARNING_CAMERA_SET_FICKER_FAILED];
//        } else {
//#ifdef OPENTOAST_HANK
//            [[YNCMessageBox instance] show:@"setFlickerMode_success"];
//#endif
////            NSString *flicker = [YNCCameraUtility convertFlickerModeToString:flickerMode];
////            [[YNCCameraManager sharedCameraManager] getDictionaryWithIndex:1 content:flicker];
//            [_flickerModeView videoMode_changeCellStyleWithIndexPath:indexPath];
//        }
//    }];
}

// MARK:消失动画
- (void)back
{
    switch (self.type) {
        case YNCCameraSettingViewTypeWhiteBlance:
        {
            [self popView:_whiteBlanceView];
        }
            break;
            case YNCCameraSettingViewTypeCameraMode:
        {
            [self popView:_cameraModeView];
        }
            break;
            case YNCCameraSettingViewTypeMeteringMode:
        {
            [self popView:_meteringModeView];
        }
            break;
            case YNCCameraSettingViewTypeScenesMode:
        {
            [self popView:_scenesModeView];
        }
            break;
            case YNCCameraSettingViewTypeVideoFormat:
        {
            [self popView:_videoFormatView];
        }
            break;
        case YNCCameraSettingViewTypeVideoResolution:
        {
            [self popView:_videoResolutionView];
        }
            break;
        case YNCCameraSettingViewTypePhotoFormat:
        {
            [self popView:_photoFormatView];
        }
            break;
        case YNCCameraSettingViewTypePhotoResolution:
        {
            [self popView:_photoResolutionView];
        }
            break;
        case YNCCameraSettingViewTypePhotoQuality:
        {
            [self popView:_photoQualityView];
        }
            break;
        case YNCCameraSettingViewTypeFlickerMode:
        {
            [self popView:_flickerModeView];
        }
            break;
            
        default:
            break;
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.type + 3 inSection:0];
    if (self.type == YNCCameraSettingViewTypeVideoResolution) {
        WS(weakSelf);
        double delayInSeconds = 0.5f;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (ino64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
//                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.type + 3 inSection:0];
//                DLog(@"_________________indexPath.row:%ld, type:%ld", indexPath.row, weakSelf.type);
                [weakSelf.cameraSettingView reloadCellWithIndexPaths:@[indexPath]];
            });
        });
    } else {
        [self.cameraSettingView reloadCellWithIndexPaths:@[indexPath]];
    }
}

- (void)updataShutterView
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    [self.cameraSettingView reloadCellWithIndexPaths:@[indexPath]];
}

#pragma mark - 恢复默认设置
- (void)footerView_resetCameraSettings
{
    WS(weakSelf);
    
    [YNCPopWindowView showMessage:NSLocalizedString(@"camera_setting_reset_tip", nil)
               buttonTitleConfirm:NSLocalizedString(@"person_center_sure", nil)
                buttonTitleCancel:NSLocalizedString(@"person_center_cancel", nil)
                        colorType:PopWindowViewColorTypeOrange
                         sizeType:PopWindowViewSizeTypeBig
                    handleConfirm:^{
//        [[YNCCameraManager sharedCameraManager] resetAllCameraSettings:^(NSError * _Nullable error) {
//            if (error) {
//                [weakSelf postNotificationWithNumber:YNCWARNING_RESET_ALL_SETTINGS_FAILED];
//            } else {
//                double delayInSeconds = 1.5f;
//                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (ino64_t)(delayInSeconds * NSEC_PER_SEC));
//                dispatch_after(popTime, dispatch_get_main_queue(), ^{
//                    weakSelf.cameraSettingView.dataDictionary = weakSelf.cameraManager.dataDictionary;
//                    [weakSelf.cameraSettingView reloadTableView];
//                });
//            }
//        }];
    } handleCancel:^{
        
    }];
}

#pragma mark - 格式化内存卡
- (void)footerView_formatSDcardStoreage
{
    WS(weakSelf);
    [YNCPopWindowView showMessage:NSLocalizedString(@"camera_setting_do_you_want_to_format_sd_card", nil)
               buttonTitleConfirm:NSLocalizedString(@"person_center_sure", nil)
                buttonTitleCancel:NSLocalizedString(@"person_center_cancel", nil)
                        colorType:PopWindowViewColorTypeOrange
                         sizeType:PopWindowViewSizeTypeSmall
                    handleConfirm:^{
//        [[YNCCameraManager sharedCameraManager] formatCameraStorage:^(NSError * _Nullable error) {
//            if (error) {
//                [weakSelf postNotificationWithNumber:YNCWARNING_CAMERA_SD_FORMAT_FAILED];
//            } else {
//                [weakSelf postNotificationWithNumber:YNCWARNING_CAMERA_SD_FORMAT_SUCCEED];
//                [weakSelf.cameraSettingView updateFooterViewStorage];
//            }
//        }];
    } handleCancel:^{
        
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = touches.anyObject;
    CGPoint point = [touch locationInView:self];
    if (!CGRectContainsPoint(self.scrollView.frame, point)&&[_delegate respondsToSelector:@selector(popView)]) {
        [_delegate popView];
    } else {
        
    }
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    WS(weakSelf);
    if ([keyPath isEqualToString:@"cameraManager.freeStorage"]) {
        if ([change.allKeys containsObject:@"new"] && [change.allKeys containsObject:@"old"]) {
            if (change[@"new"] != NULL && change[@"old"] != NULL) {
                if (![change[@"new"] isEqualToString:change[@"old"]]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf.cameraSettingView updateFooterViewStorage];
                    });
                }
            }
        }
    }
}

- (void)postNotificationWithNumber:(int)number
{
    [[NSNotificationCenter defaultCenter] postNotificationName:YNC_CAMEAR_WARNING_NOTIFICATION object:nil userInfo:@{@"msgid":[NSNumber numberWithInt:number], @"isHidden":[NSNumber numberWithBool:NO]}];
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"cameraManager.freeStorage"];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
