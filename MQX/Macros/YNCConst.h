//
//  YNCConst.h
//  MQX
//
//  Created by yc-sh-vr-pc05 on 2018/3/3.
//  Copyright © 2018年 YunEEC. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

@interface YNCConst : NSObject

/*--------------------------- Add by GavinYu Start ----------------------------*/
// Mine module
//show tips msg
UIKIT_EXTERN NSString *const YNC_MINE_LOGIN_EMAIL_TIPS_MSG;               //email tips msg
UIKIT_EXTERN NSString *const YNC_MINE_LOGIN_EMAIL_ERROR_TIPS_MSG;               //error email tips msg
UIKIT_EXTERN NSString *const YNC_MINE_LOGIN_PASSWORD_TIPS_MSG;               //password tips msg
UIKIT_EXTERN NSString *const YNC_MINE_LOGIN_LOGINING_TIPS_MSG;      //logining tips msg
UIKIT_EXTERN NSString *const YNC_MINE_SENDFLYLOG_TEL_TIPS_MSG;      //send flylog tel tips msg
UIKIT_EXTERN NSString *const YNC_MINE_SENDFLYLOG_QUESTION_TIPS_MSG;      //send flylog question tips msg
UIKIT_EXTERN NSString *const YNC_MINE_RESETPASSWORD_VERIFICATIONCODE_TIPS_MSG;  //reset password verificationCode tips msg

//Value-Key
UIKIT_EXTERN NSString *const YNC_MINE_TOKEN_KEY;
UIKIT_EXTERN NSString *const YNC_USER_LATITUDE_KEY;
UIKIT_EXTERN NSString *const YNC_USER_LONGITUDE_KEY;
UIKIT_EXTERN NSString *const YNC_USER_ACCOUNT_KEY;
UIKIT_EXTERN NSString *const YNC_USER_PASSWORD_KEY;
UIKIT_EXTERN NSString *const YNC_USER_ID_KEY;
UIKIT_EXTERN NSString *const YNC_DRONE_FLY_STATE_KEY;
UIKIT_EXTERN NSString *const YNC_APP_LOST_DATE_KEY;
UIKIT_EXTERN NSString *const YNC_APP_RESTART_DATE_KEY;
UIKIT_EXTERN NSString *const YNC_FLIGHT_LOG_FILE_TMP_PATH__KEY;
UIKIT_EXTERN NSString *const YNC_APP_FIRST_LAUNCH_KEY;
UIKIT_EXTERN NSString *const YNC_APP_EVER_LAUNCH_KEY;
UIKIT_EXTERN NSString *const YNC_DRONESETTING_UNIT_KEY;
UIKIT_EXTERN NSString *const YNC_APCOMMAND_VERSION_KEY;
UIKIT_EXTERN NSString *const YNC_USER_PRIVACYPOLICY_KEY;
UIKIT_EXTERN NSString *const YNC_FLIGHT_LOG_SYN_STATUS_KEY;
UIKIT_EXTERN NSString *const YNC_CAMERA_BIND_STATE_KEY;//相机绑定状态

UIKIT_EXTERN NSString *const YNC_USER_FLYVERSION_KEY; // 飞控版本
UIKIT_EXTERN NSString *const YNC_USER_RCVERSION_KEY; // 遥控器版本
UIKIT_EXTERN NSString *const YNC_USER_APPVERSION_KEY; // app版本
UIKIT_EXTERN NSString *const YNC_USER_CAMERAVERSION_KEY; // 相机版本

UIKIT_EXTERN NSString *const YNC_SERVER_FLYVERSION_KEY; // 服务器飞控版本
UIKIT_EXTERN NSString *const YNC_SERVER_RCVERSION_KEY; // 服务器遥控器版本
UIKIT_EXTERN NSString *const YNC_SERVER_CAMERAVERSION_KEY; // 服务器相机版本

UIKIT_EXTERN NSString *const YNC_DRONEGALLERY_SCROLLPOINTY; //飞机图库中scrollView的Y坐标偏移量
UIKIT_EXTERN NSString *const YNC_MAIN_TIRO_GUIDE_SHOW_STATUS_KEY;//新手指引图显示标志
UIKIT_EXTERN NSString *const YNC_REMOTECONTROL_TAKEPHOTO_KEY; //遥控器拍照

UIKIT_EXTERN NSString *const YNC_USER_IS_INITIATIVE_LOGIN_KEY;//标志用户是什么方式登录的(0:后台被动登录，1:主动登录，2：注册后自动登录)

UIKIT_EXTERN NSString *const YNC_USER_COUNTRY_KEY;//用户选择的国家

UIKIT_EXTERN NSString *const YNC_DRONE_SOLE_NUMBER_KEY;//飞机唯一识别号

//Notification
UIKIT_EXTERN NSString *const YNC_CAMEAR_WARNING_NOTIFICATION;
UIKIT_EXTERN NSString *const YNC_DRONESETTING_UNIT_NOTIFICATION;
UIKIT_EXTERN NSString *const YNC_CAMERA_INFO_NOTIFICATION;
UIKIT_EXTERN NSString *const YNC_CAMERA_BIND_STATE_NOTIFICATION;
/*--------------------------- Add by GavinYu End ----------------------------*/

/*--------------------------- Add by Hank Start ----------------------------*/

// Notification
UIKIT_EXTERN NSString *const YNC_CAMERA_SHUTTER_NOTIFICATION;
// 网络状态:WiFi
UIKIT_EXTERN NSString *const YNC_NETWORK_STATUS_WIFI_NOTIFICATION;
// 网络状态:GPRS
UIKIT_EXTERN NSString *const YNC_NETWORK_STATUS_WWAN_NOTIFICATION;
// // 网络状态:没有网络
UIKIT_EXTERN NSString *const YNC_NETWORK_STATUS_NOTREACHABLE_NOTIFICATION;
// 相机连接状态---未连接
UIKIT_EXTERN NSString *const YNC_CAMERA_STATE_NOT_CONNECT_NOTIFICATION;
// 相机连接状态---已连接
UIKIT_EXTERN NSString *const YNC_CAMERA_STATE_CONNECTED_NOTIFICATION;
/*--------------------------- Add by Hank End ----------------------------*/

@end
