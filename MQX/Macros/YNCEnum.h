//
//  YNCEnum.h
//  MQX
//
//  Created by yc-sh-vr-pc05 on 2018/3/3.
//  Copyright © 2018年 YunEEC. All rights reserved.
//

#ifndef YNCEnum_h
#define YNCEnum_h


/*--------------------------- Add by GavinYu Start ----------------------------*/

//MARK: -- 按钮事件的枚举
typedef NS_ENUM(NSUInteger, YNCEventAction) {
    //login and register
    YNCEventActionLogin = 101,
    YNCEventActionRegister,
    
    //user info
    YNCEventActionEditUserInfo,
    
    //NavgationBar button
    YNCEventActionNavBarLeftBtn,
    YNCEventActionNavBarRightBtn,
    YNCEventActionNavBarRightFlightLogSettingBtn,
    
    //横屏导航栏
    YNCEventActionNavBarHomeBtn,
    YNCEventActionNavBarSettingBtn,
    
    //相机操作工具栏
    YNCEventActionCameraSwitchMode,
    YNCEventActionCameraOperate,
    YNCEventActionCameraSetting,
    YNCEventActionCameraGallery,
    
    //图传的火鸟首页按钮事件
    YNCEventActionFirebirdHomepageTrims,
    YNCEventActionFirebirdHomepageWifiName
};

//MARK: -- 切图的命名的枚举
typedef NS_ENUM(NSUInteger, YNCCropType) {
    YNCCropTypeButton = 0,
    YNCCropTypeButtonAble,
    YNCCropTypeIcon,
    YNCCropTypeBackground
};

//MARK: -- 飞行模式
typedef NS_ENUM(NSUInteger, YNCFlightMode) {
    //驾驶员模式
    YNCFlightModePilot = 0,
    //自拍模式
    YNCFlightModeSelfie,
    //环绕模式
    YNCFlightModeOrbit,
    //路程预设模式
    YNCFlightModeJourney,
    //跟随模式
    YNCFlightModeFollowMe,
    //FPV模式
    YNCFlightModeFPV,
    //体感模式
    YNCFlightModeSomatosensory
};

//MARK: -- DrogButton Enum
typedef NS_ENUM(NSUInteger, YNCDragButtonType) {
    //起飞按钮
    YNCDragButtonTypeTakeOff = 0,
    //降落按钮
    YNCDragButtonTypeLand,
    //一键返航按钮
    YNCDragButtonTypeGoHome
};

//MARK: -- DrogButtonState Enum
typedef NS_ENUM(NSUInteger, YNCDragButtonState) {
    //正常状态
    YNCDragButtonStateNormal = 0,
    //高亮状态
    YNCDragButtonStateHighlighted,
    //到顶选中松开状态
    YNCDragButtonStateSelected,
    //暂停状态
    YNCDragButtonStateStop,
    //未知状态
    YNCDragButtonStateUnknown
};

//MARK: -- 手柄操作模式 Enum
typedef NS_ENUM(NSUInteger, YNCHandleMode) {
    //美国手
    YNCHandleModeUSA = 0,
    //日本手
    YNCHandleModeJapan,
    //未知状态
    YNCHandleModeUnknown
};

//MARK: -- 方位：上下左右前后 Enum
typedef NS_ENUM(NSUInteger, YNCDirection) {
    //左
    YNCDirectionLeft = 0,
    //右
    YNCDirectionRight,
    //前
    YNCDirectionFront,
    //后
    YNCDirectionBehind,
    //上
    YNCDirectionUp,
    //下
    YNCDirectionDown,
    //未知
    YNCDirectionUnknown
};

//MARK: -- Firebird 的 飞行模式
typedef NS_ENUM(NSUInteger, YNCFirebirdFlightMode) {
    //    YNCFirebirdFlightMode_Throttle_SOLID = 0, //
    //    YNCFirebirdFlightMode_Throttle_FLASHING, //1
    //    YNCFirebirdFlightMode_Throttle_WOULD_BE_SOLID_NO_GPS, //2
    //    YNCFirebirdFlightMode_Angle_SOLID, //3
    //    YNCFirebirdFlightMode_Angle_FLASHING, //4
    //    YNCFirebirdFlightMode_Angle_WOULD_BE_SOLID_NO_GPS, //5
    //    YNCFirebirdFlightMode_SMART, //6
    //    YNCFirebirdFlightMode_SMART_BUT_NO_GPS, //7
    //    YNCFirebirdFlightMode_MOTORS_STARTING, //8
    //    YNCFirebirdFlightMode_TEMP_CALIB, //9
    //    YNCFirebirdFlightMode_PRESS_CALIB, //10
    //    YNCFirebirdFlightMode_ACCELBIAS_CALIB, //11
    //    YNCFirebirdFlightMode_EMERGENCY_KILLED, //12
    //    YNCFirebirdFlightMode_GO_HOME,//13
    //    YNCFirebirdFlightMode_LANDING, //14
    //    YNCFirebirdFlightMode_BINDING, //15
    //    YNCFirebirdFlightMode_READY_TO_START, //16
    //    YNCFirebirdFlightMode_WAITING_FOR_RC, //17
    //    YNCFirebirdFlightMode_MAG_CALIB, //18
    //    YNCFirebirdFlightMode_UNKNOWN,
    //    YNCFirebirdFlightMode_Agility, //20
    //    YNCFirebirdFlightMode_FOLLOW, //21
    //    YNCFirebirdFlightMode_FOLLOW_NO_ST10_GPS, //22
    //    YNCFirebirdFlightMode_Watch_Me, //23
    //    YNCFirebirdFlightMode_Watch_Me_NO_ST10_GPS, //24
    //    YNCFirebirdFlightMode_GUIDE_MODE,//25
    //    YNCFirebirdFlightMode_CCC, //26
    //    YNCFirebirdFlightMode_Jour, //27
    //    YNCFirebirdFlightMode_Orbit, //28
    //    YNCFirebirdFlightMode_POI, //29
    //    YNCFirebirdFlightMode_3D_FOLLOW_WIZARD, //30
    //    YNCFirebirdFlightMode_3D_Watch_Me_WIZARD //31
    FIXWING_BEGINNER=0,        //稳定安全模式
    FIXWING_MEDIUN=1,          //稳定模式
    FIXWING_EXPERIENCER=2,     //三轴模式
    FIX_WING_LOST_SINGAL=3,    //信号丢失
    FIX_WING_LOITER=4,         //回航盘旋
    FIX_WING_GO_HOME=5,        //自动降落
    MAG_CAL=6,                 //地磁校准
    WRONG_TASK=7              //错误提醒
};

//MARK: -- HD Racer 的 飞行模式
typedef NS_ENUM(NSUInteger, YNCHDRacerFlightMode) {
    YNCHDRacerFlightModeAccelerator = 2,        //油门模式
    YNCHDRacerFlightModePressure    = 5,       //气压模式
    YNCHDRacerFlightModeUnknown = 0x00ff       //未知模式
};

//MARK: -- 通道类型
typedef NS_ENUM(NSUInteger, YNCChannelIndexType) {
    YNCChannelIndexTypeLeftUpDown = 0,
    YNCChannelIndexTypeRightLeftRight,
    YNCChannelIndexTypeRightUpDown,
    YNCChannelIndexTypeLeftLeftRight
};

//MARK: -- 警告类型
typedef NS_ENUM(NSInteger, YNCWarningLevel) {
    YNCWarningLevelFirst = 0,
    YNCWarningLevelSecond,
    YNCWarningLevelThird,
    YNCWarningLevelUnknown = 0x00ff
};

//视频流显示模式：单屏、双屏
typedef NS_ENUM(NSInteger, YNCModeDisplay)  {
    YNCModeDisplayNormal = 0,
    YNCModeDisplayGlass
};

//MARK: -- 飞行状态
typedef NS_ENUM(NSInteger, YNCFlyingStatus) {
    ON_GROUND = 0,
    TAKING_OFF,
    IN_AIR,
    TAKE_OFF_FAILED,
    LADING,
    READY,
    IN_MISSION,
    RETURN_TO_HOME,
    UNKNOWN
};

//GPS状态
typedef NS_ENUM(NSInteger, YNCGPSStatus) {
    YNCGPSStatusClose = 0,
    YNCGPSStatusOpen,
    YNCGPSStatusEnable,
    YNCGPSStatusDisable
};

//GPS状态
typedef NS_ENUM(NSUInteger, YNCVehicleType) {
    YNCVehicleType_H920 = 1,
    YNCVehicleType_Q500,
    YNCVehicleType_350QX,
    YNCVehicleType_CHROMA,
    YNCVehicleType_TYPHOON_H,
    YNCVehicleType_H920_PLUS,
    YNCVehicleType_520,
    YNCVehicleType_HD_RACER,
    YNCVehicleType_250QX,
    YNCVehicleType_FIREBIRD_FPV
};

/*--------------------------- Add by GavinYu End ----------------------------*/

/*--------------------------- Add by Hank start ----------------------------*/
#pragma mark - 图片编辑相关
//MARK: -- 图片编辑公共模块显示种类 Enum
typedef NS_ENUM(NSInteger, YNCImageEditorType) {
    YNCImageEditorSorts = 0, // 形状,翻转,滤镜
    YNCImageEditorShapeCut, // 形状
    YNCImageEditorFilter, // 滤镜
    YNCImageEditorWatermark // 水印
};

//MARK: -- collectionView的类型 Enum
typedef NS_ENUM(NSInteger, YNCDisplayType)  {
    YNCDisplayTypeSystemPhoto = 1, // 系统图片
    YNCDisplayTypeSystemVideo, // 系统视频
    YNCDisplayTypeDroneMedia, // 飞机
    YNCDisplayTypeVideoMake, // 视频编辑选择界面
    YNCDisplayTypeImageMake, // 图片编辑
    YNCDisplayTypeDroneGallery // 飞机图库
};

//MARK: -- 饱和度,对比度,亮度子模块的类型 Enum
typedef NS_ENUM(NSInteger, YNCImageFineTurningType) {
    YNCImageBrightnessType = 0, // 亮度
    YNCImageConstrastType, // 对比度
    YNCImageSaturationType, // 饱和度
};

//MARK: -- 裁剪框类型 Enum
typedef NS_ENUM(NSInteger, YNCCropScaleType) {
    YNCCropScaleOneToOne, // 1:1
    YNCCropScaleFourToThree, // 4:3
    YNCCropScaleThreeToFour, // 3:4
    YNCCropScaleSixteenToNine, // 16:9
    YNCCropScaleNineToSixteen, // 9:16
    YNCCropScaleCustom, // 自由
};

#pragma mark - 相机设置
//MARK: -- 列表视图类型 Enum
typedef NS_ENUM(NSInteger, YNCCameraSettingViewType){
    YNCCameraSettingViewTypeCameraSetting = 0, //相机设置主界面
    YNCCameraSettingViewTypeWhiteBlance, // 白平衡
    YNCCameraSettingViewTypeCameraMode, // 相机模式
    YNCCameraSettingViewTypeMeteringMode, // 测光模式
    YNCCameraSettingViewTypeScenesMode, // 场景模式
    YNCCameraSettingViewTypeVideoFormat, // 视频格式
    YNCCameraSettingViewTypeVideoResolution, // 视频尺寸
    YNCCameraSettingViewTypePhotoFormat, // 照片格式
    YNCCameraSettingViewTypePhotoResolution, // 照片尺寸
    YNCCameraSettingViewTypePhotoQuality, // 照片质量
    YNCCameraSettingViewTypeFlickerMode // 抗频闪
};

//MARK: -- 设置slider类型 Enum
typedef NS_ENUM(NSInteger, YNCSettingSliderColor){
    YNCSettingSliderColorBlack,
    YNCSettingSliderColorRed,
    YNCSettingSliderColorGreen,
    YNCSettingSliderColorGray,
};

typedef NS_ENUM(NSInteger, YNCSettingSliderType){
    YNCSettingSliderTypeFlightSetting,
    YNCSettingSliderTypeCameraSetting,
};

//MARK: -- 设置飞机r类型 Enum
typedef NS_ENUM(NSInteger, YNCDroneType){
    YNCDroneTypeFireBird,
    YNCDroneTypeBreeze2,
    YNCDroneTypeTyphoonQ
};

//MARK: -- 设置进度条样式
typedef NS_ENUM(NSInteger, YNCFB_ProgressViewType){
    YNCFB_ProgressViewTypeHorizontal,
    YNCFB_ProgressViewTypeVertical
};

//MARK: -- 设置进度条颜色
typedef NS_ENUM(NSInteger, YNCFB_ProgressViewColorType) {
    YNCFB_ProgressViewColorTypeDark,
    YNCFB_ProgressViewColorTypeLittle
};

//MARK: -- 遥控器状态
typedef NS_ENUM(NSInteger, YNCRC_State) {
    YNCRC_StateEnterBindMode,
    YNCRC_StateExitBindMode
};


typedef NS_ENUM(NSInteger, YNCPlayerMode) {
    YNCPlayerModeFullScreen,
    YNCPlayerModeNoFullScreen
};

typedef NS_ENUM(NSInteger, YNCDownloadWindowMode) {
    YNCDownloadWindowModeHorizontal,
    YNCDownloadWindowModeVertical
};
/*--------------------------- Add by Hank End ----------------------------*/

#endif /* YNCEnum_h */
