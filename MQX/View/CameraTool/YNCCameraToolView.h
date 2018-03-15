//
//  YNCCameraToolView.h
//  MQX
//
//  Created by yc-sh-vr-pc05 on 2018/3/3.
//  Copyright © 2018年 YunEEC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, YNCCameraMode) {
    YNCCameraModeVideo = 0,
    YNCCameraModeTakePhoto
};

typedef void(^YNCCameraEventBlock)(UIButton *sender);

@interface YNCCameraToolView : UIView

@property (copy, nonatomic) YNCCameraEventBlock cameraToolViewEventBlock;
@property (weak, nonatomic) IBOutlet UIButton *switchModeButton;
@property (weak, nonatomic) IBOutlet UIButton *cameraOperateButton;
@property (nonatomic, assign) YNCCameraMode cameraMode;

//录像只显示录像时间
@property (assign, nonatomic) BOOL isShowVideoTime;

+ (YNCCameraToolView *)instanceCameraToolView;
- (void)initSubView:(BOOL)connected;
- (void)updateBtnImageWithConnect:(BOOL)connect;
- (IBAction)clickCameraSwitchModeButton:(UIButton *)sender;
- (IBAction)clickCameraOperateButton:(UIButton *)sender;
- (IBAction)clickCameraSettingButton:(UIButton *)sender;
- (IBAction)clickGalleryButton:(UIButton *)sender;

@end
