//
//  YNCCameraToolView.h
//  MQX
//
//  Created by yc-sh-vr-pc05 on 2018/3/3.
//  Copyright © 2018年 YunEEC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, YNCCameraMode) {
    YNCCameraModeTakePhoto = 0,
    YNCCameraModeVideo
};

typedef NS_ENUM(NSUInteger, YNCPhotoMode) {
    YNCPhotoModeSingle = 0,
    YNCPhotoModeBurst,
    YNCPhotoModeTimeLapse
};

typedef void(^YNCCameraEventBlock)(UIButton *sender);

@interface YNCCameraToolView : UIView

@property (copy, nonatomic) YNCCameraEventBlock cameraToolViewEventBlock;
@property (weak, nonatomic) IBOutlet UIButton *switchModeButton;
@property (weak, nonatomic) IBOutlet UIButton *cameraOperateButton;
@property (nonatomic, assign) YNCPhotoMode photoMode;
@property (nonatomic, assign) YNCCameraMode cameraMode;
@property (strong, nonatomic) UIImageView *backImageView;
@property (strong, nonatomic) UILabel *numLabel;

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
