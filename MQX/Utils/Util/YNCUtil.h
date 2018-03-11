//
//  YNCUtil.h
//  MQX
//
//  Created by yc-sh-vr-pc05 on 2018/3/3.
//  Copyright © 2018年 YunEEC. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>
#import "YNCEnum.h"
#import <CoreLocation/CoreLocation.h>

typedef  NS_ENUM(NSInteger,NetWorkStatus)
{
    NetWorkNotReachable,
    NetWorkIsWIFI,
    NetWorkIs3G,
};

NS_ASSUME_NONNULL_BEGIN

@interface YNCUtil : NSObject

/*--------------------------- Add by GavinYu Start ----------------------------*/
#pragma mark 获取文本的高度
+ (CGFloat)getTextHeightWithContent:(nullable NSString *)content withContentSizeOfWidth:(CGFloat)contentWidth withAttribute:(nullable NSDictionary<NSString *, id> *)attribute;
#pragma mark 获取文本的宽度
+ (CGFloat)getTextWidthWithContent:(nullable NSString *)content withContentSizeOfHeight:(CGFloat)contentHeight withAttribute:(nullable NSDictionary<NSString *, id> *)attribute;
#pragma mark  邮箱合法验证
+ (BOOL)isValidateEmail:(nullable NSString *)email;
#pragma mark 获取本地UserDefault信息
+(nullable id)getUserDefaultInfo:(NSString *)key;
#pragma mark 保存本地UserDefault信息
+(void)saveUserDefaultInfo:(nullable id)value forKey:(NSString *)key;
#pragma mark 移除本地UserDefault信息
+(void)removeUserDefaultInfo:(NSString *)key;
//MARK: second change string
+ (NSString *)timeFormatted:(NSInteger)totalSeconds;
//图像头尾虚化
+ (UIImage *)imageHeadandTailBlur:(NSString *)imageName;
//MARK: -- 强制旋转屏幕
+ (void)orientationToPortrait:(UIInterfaceOrientation)orientation;
#pragma mark 字符串转换为时间
+ (NSDate *)dateFromString:(NSString *)dateString withFormat:(NSString *)formatString;
#pragma mark 时间转换为字符串
+ (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)formatString;
//MARK: -- 根据GPS计算两个点的距离
+ (CGFloat)calculateDistanceSourceLocationCoordinate2D:(CLLocationCoordinate2D)origCoordinate  WithDistLocationCoordinate2D:(CLLocationCoordinate2D)distCoordinate;
//MARK: -- 获取信号等级
+ (NSInteger)getSignalLevel:(NSInteger)number;
//MARK: -- 单位转换（米->英尺）
+ (CGFloat)meterTransformToFeet:(CGFloat)meter;
//MARK: -- 单位转换（千米/小时->英里/小时）
+ (CGFloat)kmPerHourTransformToMilesPerHour:(CGFloat)kmPH;
#pragma mark -
#pragma mark 获取资源图片
+(UIImage *)imagJPGPathName:(NSString *)name;
+(UIImage *)imagPNGPathName:(NSString *)name;
//MARK: -- 验证WiFi名称是否符合1-21个字符，仅支持字母、数字、下划线
+ (BOOL)isValidWiFiName:(NSString *)inputString;
//MARK: -- 验证WiFi密码是否符合8-21个字符，仅支持字母、数字、下划线
+ (BOOL)isValidWiFiPassword:(NSString *)inputString;
//MARK: -- 获取HD Racer的飞行模式
+ (NSString *)getHDRacerFlightMode:(YNCHDRacerFlightMode)HDRacerFlightMode;
/*--------------------------- Add by GavinYu End ----------------------------*/

#pragma mark - Add By Jack Wu

/**
 *  返回不为nil的字符串
 *
 *  @param string 目标字符串
 *
 *  @return NSString
 */
+ (NSString *)nullString:(NSString *)string;

#pragma mark ----------------- 获取视频第一帧 网络视频 && 本地视频 -----------

/**
 *  获取网络视频第一帧图片
 *
 *  @param urlString 网络视频url
 *
 *  @return 网络视频第一帧
 */
+ (UIImage*)getVideoPreViewImage:(NSString *)urlString;

/**
 *  获取本地视频第一帧图片
 *
 *  @param urlString 本地视频url
 *
 *  @return 本地视频第一帧
 */
+ (UIImage *)getLoaclVideoPreViewImage:(NSString *)urlString;


/**
 根据key获取国际化后的字符
 
 @param string 字符key
 @return  国际化转化后的名称
 */
+ (NSString *)getLocalizableStringWithString:(NSString *)string;

/**
 *  创建菊花
 *
 *  @return UIActivityIndicatorView
 */
+ (UIActivityIndicatorView *)creatActivityIndicatorView;

/*******************************************************************************/
/********************** Add by JackWu End **************************************/
/*******************************************************************************/

// Kenny Start
+ (NSString *)getAppLanguage;
+ (BOOL)getIsSeenAgreement;
+ (void)setIsSeenAgreement:(BOOL)val;
+ (float)getLatestAgreementVersion;
+ (void)setLatestAgreementVersion:(float)version;
+ (NSString *)getAgreementUrl;
+ (void)setAgreementUrl:(NSString *)url;
// Kenny end

@end

NS_ASSUME_NONNULL_END
