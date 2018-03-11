//
//  YNCWarningConstMacro.h
//  YuneecApp
//
//  Created by yc-sh-vr-pc05 on 2017/5/25.
//  Copyright © 2017年 yuneec. All rights reserved.
//

#ifndef YNCWarningConstMacro_h
#define YNCWarningConstMacro_h

//MARK: - 一级警告jjj
//遥控器与飞机模块---基础状态
//设备未连接
static const int YNCWARNING_DEVICE_DISCONNECTED    = 100;
//设备已连接（注：暂时没用到）
static const int YNCWARNING_DEVICE_CONNECTED       = 101;
//飞机未连接
static const int YNCWARNING_DRONE_DISCONNECTED     = 102;
//飞行器已连接
static const int YNCWARNING_DRONE_CONNECTED        = 103;
//图传信号弱（注：暂时没用到）
static const int YNCWARNING_DRONE_WIFI_WEAK        = 104;
//图传信号丢失（相机未连接）
static const int YNCWARNING_DRONE_WIFI_DISCONNECTED= 105;
//2.4G信道未连接（飞机未连接！）
static const int YNCWARNING_ZIGBEE_DISCONNECTED    = 106;

//飞机Drone
//飞机电量低，请不要飞远（注：暂时没用到）
static const int YNCWARNING_VOLTAGE_1              = 200;
//飞机电量不足，请立即降落。（注：暂时没用到）
static const int YNCWARNING_VOLTAGE_2              = 201;
//马达故障
static const int YNCWARNING_MOTOR_FAILSAFE         = 202;
//调速器故障
static const int YNCWARNING_MOTOR_ESC              = 203;
//主控版温度过高
static const int YNCWARNING_HIGH_TEMPERATURE       = 204;
//地磁需要校准，请先校准再起飞
static const int YNCWARNING_COMPASS_CALIBRATION    = 205;
//飞行距离过远
static const int YNCWARNING_FLYAWAY                = 206;
//当前处于禁飞区
static const int YNCWARNING_NO_FLY_ZONE            = 207;
//
static const int YNCWARNING_ACC_ERROR              = 208;
//
static const int YNCWARNING_MEGNETIC_ERROR         = 209;
//
static const int YNCWARNING_GYROSCOPE_ERROR        = 210;
//
static const int YNCWARNING_GPS_LOST_FIRSTCLASS    = 211;
//
static const int YNCWARNING_GPS_ERROR_FIRSTCLASS   = 212;
//低电压报警
static const int YNCWARNING_FIXING_LOW_POWER_STAGE1= 213;
//严重低电压报警
static const int YNCWARNING_FIXING_LOW_POWER_STAGE2= 214;

static const int YNCWARNING_VOLTAGE_3              = 215;

/*----------飞控警报-----------*/
//陀螺仪异常
static const int YNCWARNING_FLIGHTCONTROL_GYRO_ERROR = 216;
//气压计异常
static const int YNCWARNING_FLIGHTCONTROL_BAROMETER_ERROR = 217;
//地磁异常
static const int YNCWARNING_FLIGHTCONTROL_GEOMAGNETISM_ERROR = 218;
//GPS异常
static const int YNCWARNING_FLIGHTCONTROL_GPS_ERROR = 219;
//EEPROM报错或存储数据检测异常
static const int YNCWARNING_FLIGHTCONTROL_EEPROM_ERROR = 220;
/*----------飞控警报-----------*/


//MARK: - 二级警告
//飞行操作相关的
//自动降落中（起飞点）
static const int YNCWARNING_AUTO_LANDING           = 300;
//回航盘旋中
static const int YNCWARNING_BACK_CIRCLEDING        = 301;
//环境磁场过强，请更换飞行环境
static const int YNCWARNING_MAGNETIC_STRONG        = 302;
//飞机连接丢失，已进入回航盘旋模式，30s后无法重连将自动降落
static const int YNCWARNING_DRONE_LOST_CONNECTED   = 303;
//相机初始化失败，请重启后尝试
static const int YNCWARNING_CAMERA_INIT_FAILED     = 304;
//遥控器电量低
static const int YNCWARNING_CONTROL_VOLTAGE_LOW    = 305;
//飞行中GPS丢失
static const int YNCWARNING_FLYING_LOST_GPS        = 306;
//
static const int YNCWARNING_RETURN_TO_HOME         = 307;
//一级报警：低电量，在空中：请及时返航
static const int YNCWARNING_FIXING_LOW_POWER_STAGE1_HINT_AIR        = 308;
//二级报警：严重低电量，已定位Home点，在空中：飞机自动返航
static const int YNCWARNING_FIXING_LOW_POWER_STAGE2_HINT_WITHHOME   = 309;
//二级报警：严重低电量，未定位Home点，在空中：请立即降落！
static const int YNCWARNING_FIXING_LOW_POWER_STAGE2_HINT_NOHOME     = 310;
//三级报警：严重低电量，在地面：飞机动力系统关闭，请更换电池
static const int YNCWARNING_FIXING_LOW_POWER_STAGE3_HINT_GROUND     = 311;

//未设置HOME点
static const int YNCWARNING_FLIGHTCONTROL_NO_SETTING_HOME     = 312;


//MARK: - 三级警告
//存储空间不足，无法拍照
static const int YNCWARNING_CAMERA_NOT_TAKEPHOTO   = 400;
//存储空间不足，无法录像
static const int YNCWARNING_CAMERA_NOT_VIDEO       = 401;
//拍照失败
static const int YNCWARNING_CAMERA_TAKE_PHOTO_FAILED = 402;
//开始录像失败
static const int YNCWARNING_CAMERA_START_VIDEO_FAILED = 403;
//停止录像失败
static const int YNCWARNING_CAMERA_STOP_VIDEO_FAILED = 404;
//相机模式切换失败
static const int YNCWARNING_CAMERA_SWITCH_MODE_FAILED = 405;
//频闪设置失败
static const int YNCWARNING_CAMERA_SET_FICKER_FAILED = 406;
//设置EV值失败
static const int YNCWARNING_CAMERA_SET_EV_FAILED = 407;
//白平衡设置失败
static const int YNCWARNING_CAMERA_SET_WB_FAILED = 408;
//SD卡格式化失败
static const int YNCWARNING_CAMERA_SD_FORMAT_FAILED = 409;
//SD卡格式化成功
static const int YNCWARNING_CAMERA_SD_FORMAT_SUCCEED = 410;
//发送指令超时
static const int YNCWARNING_COMMEND_TIME_OUT = 411;
//绑定指令超时
static const int YNCWARNING_BIND_COMMEDN_TIME_OUT = 412;
//相机设置指令失败
static const int YNCWARNING_SETTING_COMMAND_FAIL = 413;
//相机SDK繁忙
static const int YNCWARNING_CAMERA_BUSY = 414;
// 新增 by hank start
//停止拍照失败
static const int YNCWARNING_CAMERA_STOP_TAKE_PHOTO_FAILED = 415;
//连拍拍照模式设置失败
static const int YNCWARNING_PHOTO_MODE_BURST_FAILED = 416;
//间隔拍照模式设置失败
static const int YNCWARNING_PHOTO_MODE_TIMELAPSE_FAILED = 417;
//测光模式设置失败
static const int YNCWARNING_METER_MODE_FAILED = 418;
//场景模式设置失败
static const int YNCWARNING_IMAGE_QUALITY_MODE_FAILED = 419;
//照片格式设置失败
static const int YNCWARNING_PHOTO_FORMAT_FAILED = 420;
//照片分辨率设置失败
static const int YNCWARNING_PHOTO_RESOLUTION_FAILED = 421;
//视频格式设置失败
static const int YNCWARNING_VIDEO_FILE_FORMAT_FAILED = 422;
//视频分辨率设置失败
static const int YNCWARNING_VIDEO_RESOLUTION_FAILED = 423;
//照片质量设置失败
static const int YNCWARNING_PHOTO_QUALITY_FAILED = 424;
//恢复默认设置失败
static const int YNCWARNING_RESET_ALL_SETTINGS_FAILED = 425;
//ISO设置失败
static const int YNCWARNING_ISO_SETTINGS_FAILED = 426;
//快门设置失败
static const int YNCWARNING_SHUTTER_MODE_FAILED = 427;
//曝光值设置失败
static const int YNCWARNING_EXPOSURE_MODE_FAILED = 428;
// end

//New Add by gavin ---start
/*----------相机警报-----------*/
//相机未插SD卡
static const int YNCWARNING_CAMERA_NO_SDCARD = 429;
//相机正在录像，无法切换模式
static const int YNCWARNING_CAMERA_ISRECORDING = 430;
//相机正在间隔拍照，无法切换模式
static const int YNCWARNING_CAMERA_ISINTERVALPHOTO = 431;
//相机发送指令失败
static const int YNCWARNING_CAMERA_SEND_COMMAND_FAILED = 432;
////相机正在录像状态
//static const int YNCWARNING_CAMERA_ISRECORDING_VIDEO = 433;
////相机不处于录像状态
//static const int YNCWARNING_CAMERA_ISNOT_VIDEO_MODE = 434;
////相机不处于拍照状态
//static const int YNCWARNING_CAMERA_ISNOT_PHOTO_MODE = 435;
//相机SD卡没有存储空间
static const int YNCWARNING_CAMERA_SDCARD_NO_SPACE = 436;
//在拍照模式下不支持设置视频尺寸
static const int YNCWARNING_VIDEO_RESOLUTION_NO_SUPPORT_PHOTO_MODE = 437;
//在录像模式下不支持设置拍照模式（间拍、连拍等等）
static const int YNCWARNING_SHOT_MODE_NO_SUPPORT_VIDEO_MODE = 438;
//正在录像不能切换相机模式（先停止录像）
static const int YNCWARNING_CAMERA_MODE_NO_SUPPORT_IN_RECORDING = 439;
//未连接相机，不能用遥控器拍照录像
static const int YNCWARNING_CAMERA_DISCONNECT_CAN_NOT_TAKINGPHOTO = 440;
//间隔拍照模式下，不能切换相机模式
static const int YNCWARNING_PHOTO_MODE_TIMELAPSE_CAN_NOT_SETTING_CAMERA_MODE = 441;
//低延时开关设置失败
static const int YNCWARNING_CAMERA_LOW_LATENCY_MODE_FAILED = 498;
//视频方向（正反）开关设置失败
static const int YNCWARNING_CAMERA_VIDEO_DIRECTION_FAILED = 499;

/*----------相机警报-----------*/




#endif /* YNCWarningConstMacro_h */
