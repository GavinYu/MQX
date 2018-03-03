//
//  YNCCameraToolView.m
//  MQX
//
//  Created by yc-sh-vr-pc05 on 2018/3/3.
//  Copyright © 2018年 YunEEC. All rights reserved.
//

#import "YNCCameraToolView.h"

#import "YNCAppConfig.h"

@interface YNCCameraToolView ()

@property (weak, nonatomic) IBOutlet UIButton *cameraSettingButton;
@property (weak, nonatomic) IBOutlet UIButton *galleryButton;

@end

@implementation YNCCameraToolView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc {
    NSLog(@"dealloc: %@", NSStringFromClass([self class]));
}

- (void)setCameraMode:(YNCCameraMode)cameraMode
{
    _cameraMode = cameraMode;
    if (cameraMode == YNCCameraModeVideo) {
        self.backImageView.hidden = YES;
        self.numLabel.hidden = YES;
        [UIButton setButtonImageForState:_cameraOperateButton withImageName:@"video"];
    } else if (cameraMode == YNCCameraModeTakePhoto) {
        [UIButton setButtonImageForState:_cameraOperateButton withImageName:@"takephoto"];
    }
}

- (void)setPhotoMode:(YNCPhotoMode)photoMode
{
    _photoMode = photoMode;
    if (photoMode == YNCPhotoModeSingle) {
        self.backImageView.hidden = YES;
        self.numLabel.hidden = YES;
    } else if (photoMode == YNCPhotoModeBurst){
        self.backImageView.hidden = NO;
        self.backImageView.image = [UIImage imageNamed:@"image_burst"];
        self.numLabel.hidden = NO;
    } else if (photoMode == YNCPhotoModeTimeLapse) {
        self.backImageView.hidden = NO;
        self.backImageView.image = [UIImage imageNamed:@"image_timelapse"];
        self.numLabel.hidden = NO;
    }
}

+ (YNCCameraToolView *)instanceCameraToolView {
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"YNCCameraToolView" owner:nil options:nil];
    return [nibView objectAtIndex:0];
}

- (void)initSubView:(BOOL)connected {
    //    _backView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
    //
    //    self.isCancel = NO;
    _switchModeButton.tag = YNCEventActionCameraSwitchMode;
    self.cameraOperateButton.tag = YNCEventActionCameraOperate;
    self.cameraSettingButton.tag = YNCEventActionCameraSetting;
    self.galleryButton.tag = YNCEventActionCameraGallery;
    
    //    self.pointLabel.layer.cornerRadius = self.pointLabel.bounds.size.width * 0.5;
    //    self.pointLabel.layer.masksToBounds = YES;
    
    self.backImageView = [[UIImageView alloc] init];
    [_cameraOperateButton addSubview:_backImageView];
    [_backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_cameraOperateButton);
        make.width.height.equalTo(@(25));
    }];
    
    self.numLabel = [[UILabel alloc] init];
    _numLabel.textAlignment = NSTextAlignmentCenter;
//    _numLabel.textColor = TextGreenColor;
    _numLabel.font = [UIFont systemFontOfSize:9.0f];
    [_cameraOperateButton addSubview:_numLabel];
    [_numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_cameraOperateButton);
        make.width.equalTo(@(18));
        make.height.equalTo(@(10));
    }];
#ifdef DIRECT_DRONE
    [self updateBtnImageWithConnect:YES];
#else
    [self updateBtnImageWithConnect:connected];
#endif
    
    self.photoMode = YNCPhotoModeSingle;
    
    //    if (_cameraToolViewEventBlock) {
    //        _cameraToolViewEventBlock(YNCEventActionCameraSwitchMode);
    //    }
    
}

- (void)updateBtnImageWithConnect:(BOOL)connect
{
    if (connect) {
        self.switchModeButton.enabled = YES;
        self.cameraOperateButton.enabled = YES;
        self.cameraSettingButton.enabled = YES;
        self.galleryButton.enabled = YES;
        [UIButton setButtonImageForState:self.switchModeButton withImageName:@"camera_switch_mode"];
//        if ([YNCCameraManager sharedCameraManager].cameraMode == YuneecCameraModePhoto) {
//            self.cameraMode = YNCCameraModeTakePhoto;
//        } else if ([YNCCameraManager sharedCameraManager].cameraMode == YuneecCameraModeVideo) {
//            self.cameraMode = YNCCameraModeVideo;
//        }
        [UIButton setButtonImageForState:self.cameraSettingButton withImageName:@"carmaSetting"];
        [UIButton setButtonImageForState:self.galleryButton withImageName:@"gallery"];
    } else {
        self.switchModeButton.enabled = NO;
        self.cameraOperateButton.enabled = NO;
        self.cameraSettingButton.enabled = NO;
        self.galleryButton.enabled = NO;
        [self.switchModeButton setImage:[UIImage imageNamed:@"btn_camera_switch_mode_disable"] forState:(UIControlStateNormal)];
        [self.cameraOperateButton setImage:[UIImage imageNamed:@"btn_video_disable"] forState:(UIControlStateNormal)];
        [self.cameraSettingButton setImage:[UIImage imageNamed:@"btn_carmaSetting_disable"] forState:(UIControlStateNormal)];
        [self.galleryButton setImage:[UIImage imageNamed:@"btn_gallery_disable"] forState:(UIControlStateNormal)];
        
    }
}


- (void)updateSubView:(YNCCameraMode)cameraMode {
    
}

- (IBAction)clickCameraSwitchModeButton:(UIButton *)sender {
    if (_cameraToolViewEventBlock) {
        _cameraToolViewEventBlock(sender);
    }
}

- (IBAction)clickCameraOperateButton:(UIButton *)sender {
    
    if (_cameraToolViewEventBlock) {
        _cameraToolViewEventBlock(sender);
    }
}

- (IBAction)clickCameraSettingButton:(UIButton *)sender {
    if (_cameraToolViewEventBlock) {
        _cameraToolViewEventBlock(sender);
    }
}

- (IBAction)clickGalleryButton:(UIButton *)sender {
    if (_cameraToolViewEventBlock) {
        _cameraToolViewEventBlock(sender);
    }
}

//MARK: -- SET IsShowVideoTime
- (void)setIsShowVideoTime:(BOOL)isShowVideoTime {
    _cameraOperateButton.hidden = isShowVideoTime;
    _switchModeButton.hidden = isShowVideoTime;
    _cameraSettingButton.hidden = isShowVideoTime;
    _galleryButton.hidden = isShowVideoTime;
}

@end
