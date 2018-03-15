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
    DLog(@"dealloc: %@", NSStringFromClass([self class]));
}
//MARK: -- setter cameraMode
- (void)setCameraMode:(YNCCameraMode)cameraMode {
    _cameraMode = cameraMode;
    if (cameraMode == YNCCameraModeVideo) {
        [UIButton setButtonImageForState:_switchModeButton withImageName:@"switch_photoMode"];
        [UIButton setButtonImageForState:_cameraOperateButton withImageName:@"video"];
    } else if (cameraMode == YNCCameraModeTakePhoto) {
        [UIButton setButtonImageForState:_switchModeButton withImageName:@"switch_videoMode"];
        [UIButton setButtonImageForState:_cameraOperateButton withImageName:@"takePhoto"];
    }
}

+ (YNCCameraToolView *)instanceCameraToolView {
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"YNCCameraToolView" owner:nil options:nil];
    return [nibView objectAtIndex:0];
}

- (void)initSubView:(BOOL)connected {
    self.cameraMode = YNCCameraModeVideo;
    
    _switchModeButton.tag = YNCEventActionCameraSwitchMode;
    _cameraOperateButton.tag = YNCEventActionCameraOperate;
    _cameraSettingButton.tag = YNCEventActionCameraSetting;
    _galleryButton.tag = YNCEventActionCameraGallery;
    
    [self updateBtnImageWithConnect:connected];

}
//MARK: -- 根据连接状态更新相机工具栏
- (void)updateBtnImageWithConnect:(BOOL)connect
{
    self.switchModeButton.enabled = connect;
    self.cameraOperateButton.enabled = connect;
    self.galleryButton.enabled = connect;

    [UIButton setButtonImageForState:self.galleryButton withImageName:@"drone_gallery"];
    if (self.cameraMode == YNCCameraModeVideo) {
        [UIButton setButtonImageForState:_switchModeButton withImageName:@"switch_photoMode"];
        [UIButton setButtonImageForState:_cameraOperateButton withImageName:@"video"];
    } else if (self.cameraMode == YNCCameraModeTakePhoto) {
        [UIButton setButtonImageForState:_switchModeButton withImageName:@"switch_videoMode"];
        [UIButton setButtonImageForState:_cameraOperateButton withImageName:@"takePhoto"];
    }
}
//MARK: -- 
- (IBAction)clickCameraSwitchModeButton:(UIButton *)sender {
    [sender setSelected:!sender.isSelected];
    
    if (_cameraToolViewEventBlock) {
        _cameraToolViewEventBlock(sender);
    }
}
//MARK: --
- (IBAction)clickCameraOperateButton:(UIButton *)sender {
    if (_cameraToolViewEventBlock) {
        _cameraToolViewEventBlock(sender);
    }
}
//MARK: --
- (IBAction)clickCameraSettingButton:(UIButton *)sender {
    if (_cameraToolViewEventBlock) {
        _cameraToolViewEventBlock(sender);
    }
}
//MARK: --
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
