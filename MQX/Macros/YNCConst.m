//
//  YNCConst.m
//  MQX
//
//  Created by yc-sh-vr-pc05 on 2018/3/3.
//  Copyright © 2018年 YunEEC. All rights reserved.
//

#import "YNCConst.h"

@implementation YNCConst

/*--------------------------- Add by GavinYu Start ----------------------------*/
// Mine module
//show tips msg
NSString *const YNC_MINE_LOGIN_EMAIL_TIPS_MSG = @"请输入注册邮箱";
NSString *const YNC_MINE_LOGIN_EMAIL_ERROR_TIPS_MSG = @"请输入正确的邮箱";
NSString *const YNC_MINE_LOGIN_PASSWORD_TIPS_MSG = @"请输入6-18位密码";
NSString *const YNC_MINE_LOGIN_LOGINING_TIPS_MSG = @"登录中...";
NSString *const YNC_MINE_SENDFLYLOG_TEL_TIPS_MSG = @"请输入您的电话";
NSString *const YNC_MINE_SENDFLYLOG_QUESTION_TIPS_MSG = @"请输入您的问题";
NSString *const YNC_MINE_RESETPASSWORD_VERIFICATIONCODE_TIPS_MSG = @"请输入验证码";

//Value-Key
NSString *const YNC_MINE_TOKEN_KEY = @"YNC_MINE_TOKEN_KEY";
NSString *const YNC_USER_LATITUDE_KEY = @"YNC_USER_LATITUDE_KEY";
NSString *const YNC_USER_LONGITUDE_KEY = @"YNC_USER_LONGITUDE_KEY";
NSString *const YNC_USER_ACCOUNT_KEY = @"YNC_USER_ACCOUNT_KEY";
NSString *const YNC_USER_PASSWORD_KEY = @"YNC_USER_PASSWORD_KEY";
NSString *const YNC_USER_ID_KEY = @"YNC_USER_ID_KEY";
NSString *const YNC_DRONE_FLY_STATE_KEY = @"YNC_DRONE_FLY_STATE_KEY";
NSString *const YNC_APP_LOST_DATE_KEY = @"YNC_APP_LOST_DATE_KEY";
NSString *const YNC_APP_RESTART_DATE_KEY = @"YNC_APP_RESTART_DATE_KEY";
NSString *const YNC_FLIGHT_LOG_FILE_TMP_PATH__KEY = @"YNC_FLIGHT_LOG_FILE_TMP_PATH__KEY";
NSString *const YNC_APP_FIRST_LAUNCH_KEY = @"YNC_APP_FIRST_LAUNCH_KEY";
NSString *const YNC_APP_EVER_LAUNCH_KEY = @"YNC_APP_EVER_LAUNCH_KEY";
NSString *const YNC_DRONESETTING_UNIT_KEY = @"YNC_DRONESETTING_UNIT_KEY";
NSString *const YNC_APCOMMAND_VERSION_KEY = @"YNC_APCOMMAND_VERSION_KEY"; // 飞控版本
NSString *const YNC_USER_PRIVACYPOLICY_KEY = @"YNC_USER_PRIVACYPOLICY_KEY";
NSString *const YNC_FLIGHT_LOG_SYN_STATUS_KEY = @"YNC_FLIGHT_LOG_SYN_STATUS_KEY";//上传飞行日志---自动同步的状态
NSString *const YNC_CAMERA_BIND_STATE_KEY = @"YNC_CAMERA_BIND_STATE_KEY";//相机绑定状态

NSString *const YNC_USER_FLYVERSION_KEY = @"YNC_USER_FLYVERSION_KEY"; // 飞控版本
NSString *const YNC_USER_RCVERSION_KEY = @"YNC_USER_RCVERSION_KEY"; // 遥控器版本
NSString *const YNC_USER_APPVERSION_KEY = @"YNC_USER_APPVERSION_KEY"; // app版本
NSString *const YNC_USER_CAMERAVERSION_KEY = @"YNC_USER_CAMERAVERSION_KEY"; // 相机版本（样式：相机版本_美版）

NSString *const YNC_SERVER_FLYVERSION_KEY = @"YNC_SERVER_FLYVERSION_KEY"; // 飞控版本
NSString *const YNC_SERVER_RCVERSION_KEY = @"YNC_SERVER_RCVERSION_KEY"; // 遥控器版本
NSString *const YNC_SERVER_CAMERAVERSION_KEY = @"YNC_SERVER_CAMERAVERSION_KEY"; // 相机版本
NSString *const YNC_DRONEGALLERY_SCROLLPOINTY = @"YNC_DRONEGALLERY_SCROLLPOINTY"; //飞机图库中scrollView的Y坐标偏移量
NSString *const YNC_MAIN_TIRO_GUIDE_SHOW_STATUS_KEY = @"YNC_MAIN_TIRO_GUIDE_SHOW_STATUS_KEY"; //新手指引图显示标志
NSString *const YNC_REMOTECONTROL_TAKEPHOTO_KEY = @"YNC_REMOTECONTROL_TAKEPHOTO_KEY"; //遥控器拍照 0不可以，1可以

NSString *const YNC_USER_IS_INITIATIVE_LOGIN_KEY = @"YNC_USER_IS_INITIATIVE_LOGIN_KEY";//标志用户是什么方式登录的(0:后台被动登录，1:主动登录，2：注册后自动登录)

NSString *const YNC_USER_COUNTRY_KEY = @"YNC_USER_COUNTRY_KEY";//用户选择的国家
NSString *const YNC_DRONE_SOLE_NUMBER_KEY = @"YNC_DRONE_SOLE_NUMBER_KEY";//飞机唯一识别号

//Notification
NSString *const YNC_CAMEAR_WARNING_NOTIFICATION = @"YNC_CAMEAR_WARNING_NOTIFICATION";
NSString *const YNC_DRONESETTING_UNIT_NOTIFICATION = @"YNC_DRONESETTING_UNIT_NOTIFICATION";
NSString *const YNC_CAMERA_INFO_NOTIFICATION = @"YNC_CAMERA_INFO_NOTIFICATION";
NSString *const YNC_CAMERA_BIND_STATE_NOTIFICATION = @"YNC_CAMERA_BIND_STATE_NOTIFICATION";
/*--------------------------- Add by GavinYu End ----------------------------*/


/*--------------------------- Add by Hank Start ----------------------------*/

// Notification
NSString *const YNC_CAMERA_SHUTTER_NOTIFICATION = @"YNC_CAMERA_SHUTTER_NOTIFICATION";
// 网络状态:WiFi
NSString *const YNC_NETWORK_STATUS_WIFI_NOTIFICATION = @"YNC_NETWORK_STATUS_WIFI_NOTIFICATION";
// 网络状态:GPRS
NSString *const YNC_NETWORK_STATUS_WWAN_NOTIFICATION = @"YNC_NETWORK_STATUS_WWAN_NOTIFICATION";
// 网络状态:没有网络
NSString *const YNC_NETWORK_STATUS_NOTREACHABLE_NOTIFICATION = @"YNC_NETWORK_STATUS_NOTREACHABLE_NOTIFICATION";

// 相机连接状态---未连接
NSString *const YNC_CAMERA_STATE_NOT_CONNECT_NOTIFICATION = @"YNC_CAMERA_STATE_NOT_CONNECT_NOTIFICATION";
// 相机连接状态---已连接
NSString *const YNC_CAMERA_STATE_CONNECTED_NOTIFICATION = @"YNC_CAMERA_STATE_CONNECTED_NOTIFICATION";
/*--------------------------- Add by Hank End ----------------------------*/

@end
