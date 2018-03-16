//
//  YNCUtil.m
//  MQX
//
//  Created by yc-sh-vr-pc05 on 2018/3/3.
//  Copyright © 2018年 YunEEC. All rights reserved.
//

#import "YNCUtil.h"

#import <AVFoundation/AVFoundation.h>
#import "YNCMacros.h"

static NSString *_hasSeenAgreement = @"_hasSeenAgreement";
static NSString *_latestAgreementVersion = @"_latestAgreementVersion";
static NSString *_agreementUrl = @"_agreementUrl";

@implementation YNCUtil

/*--------------------------- Add by GavinYu Start ----------------------------*/
#pragma mark 获取文本的高度
+ (CGFloat)getTextHeightWithContent:(nullable NSString *)content withContentSizeOfWidth:(CGFloat)contentWidth withAttribute:(nullable NSDictionary<NSString *, id> *)attribute {
    CGSize size = [content boundingRectWithSize:CGSizeMake(contentWidth, MAXFLOAT)
                                        options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                     attributes:attribute context:nil].size;
    
    return size.height;
}

#pragma mark 获取文本的宽度
+ (CGFloat)getTextWidthWithContent:(nullable NSString *)content withContentSizeOfHeight:(CGFloat)contentHeight withAttribute:(nullable NSDictionary<NSString *, id> *)attribute {
    CGSize size = [content boundingRectWithSize:CGSizeMake(MAXFLOAT, contentHeight)
                                        options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                     attributes:attribute context:nil].size;
    
    return size.width;
}

#pragma mark  邮箱合法验证
+(BOOL)isValidateEmail:(nullable NSString *)email
{
    return  [self isValidateByRegex:YNC_EMAIL_FORMAT_REGULAR withInputString:email];
}

#pragma mark 获取本地UserDefault信息
+(nullable id)getUserDefaultInfo:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] valueForKey:key];
}

#pragma mark 保存本地UserDefault信息
+(void)saveUserDefaultInfo:(nullable id)value forKey:(NSString *)key {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setValue:value forKey:key];
    [userDefault synchronize];
}

#pragma mark 移除本地UserDefault信息
+(void)removeUserDefaultInfo:(NSString *)key {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault removeObjectForKey:key];
    [userDefault synchronize];
}

//MARK: second change string
+ (NSString *)timeFormatted:(NSInteger)totalSeconds
{
    CGFloat minutes = totalSeconds / 60.0;
    
    return [NSString stringWithFormat:@"%.1f", minutes];
}

//MARK: -- 图像头尾虚化
+ (UIImage *)imageHeadandTailBlur:(NSString *)imageName {
    CIContext *context = [CIContext contextWithOptions:nil];
    
    CIImage *inputImage = [[CIImage alloc] initWithImage:[UIImage imageNamed:imageName]];
    
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    
    [filter setValue:inputImage forKey:kCIInputImageKey];
    
    [filter setValue:[NSNumber numberWithFloat:9.0] forKey:@"inputRadius"];
    
    CIImage *result=[filter outputImage];
    
    CGImageRef cgImage = [context createCGImage:result fromRect:[inputImage extent]];
    
    UIImage *resultImage = [UIImage imageWithCGImage:cgImage];
    
    CGImageRelease(cgImage);
    
    return resultImage;
}

//MARK: -- 获取Firebird的飞行模式
+ (NSString *)getFirebirdFlightMode:(YNCFirebirdFlightMode)firebirdFlightMode {
    NSString *flightModeStr;
    
    switch (firebirdFlightMode) {
        case 0:
            flightModeStr = NSLocalizedString(@"flight_interface_mode_FIXWING_BEGINNER", nil);
            break;
            
        case 1:
            flightModeStr = NSLocalizedString(@"flight_interface_mode_FIXWING_MEDIUN", nil);
            break;
            
        case 2:
            flightModeStr = NSLocalizedString(@"flight_interface_mode_FIXWING_EXPERIENCER", nil);
            break;
            
        case 3:
            flightModeStr = NSLocalizedString(@"flight_interface_mode_FIXWING_LOST_SINGAL", nil);
            break;
            
        case 4:
            flightModeStr = NSLocalizedString(@"flight_interface_mode_FIXWING_LOITER", nil);
            break;
            
        case 5:
            flightModeStr = NSLocalizedString(@"flight_interface_mode_FIXWING_GO_HOME", nil);
            break;
            
        case 6:
            flightModeStr = NSLocalizedString(@"flight_interface_mode_FIXWING_MAG_CAL", nil);
            break;
            
        case 7:
            flightModeStr = NSLocalizedString(@"flight_interface_mode_FIXWING_WRONG_TASK", nil);
            break;
 
        default:
            flightModeStr = @"";
            break;
    }
    
    return flightModeStr;
}

//MARK: -- 获取HD Racer的飞行模式
+ (NSString *)getHDRacerFlightMode:(YNCHDRacerFlightMode)HDRacerFlightMode {
    NSString *flightModeStr;
    
    switch (HDRacerFlightMode) {
        case YNCHDRacerFlightModeAccelerator:
            flightModeStr = NSLocalizedString(@"flight_interface_flight_mode_accelerator", nil);
            break;
            
        case YNCHDRacerFlightModePressure:
            flightModeStr = NSLocalizedString(@"flight_interface_flight_mode_pressure", nil);
            break;
            
        case YNCHDRacerFlightModeUnknown:
            flightModeStr = @"Disarmed";
            break;
            
        default:
            flightModeStr = @"Disarmed";
            break;
    }
    
    return flightModeStr;
}

//MARK: -- 强制旋转屏幕
+ (void)orientationToPortrait:(UIInterfaceOrientation)orientation {
    SEL selector = NSSelectorFromString(@"setOrientation:");
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
    [invocation setSelector:selector];
    [invocation setTarget:[UIDevice currentDevice]];
    int val = orientation;
    [invocation setArgument:&val atIndex:2];//前两个参数已被target和selector占用
    [invocation invoke];
    
}

#pragma mark -
#pragma mark 字符串转换为时间
+ (NSDate *)dateFromString:(NSString *)dateString withFormat:(NSString *)formatString{
    
    //@"yyyy-MM-dd HH:mm:ss zzz"，zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatString];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    
    return destDate;
}

#pragma mark 时间转换为字符串
+ (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)formatString{
    //@"yyyy-MM-dd HH:mm:ss zzz"，zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatString];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    
    return destDateString;
}

//MARK: -- 根据GPS计算两个点的距离
+ (CGFloat)calculateDistanceSourceLocationCoordinate2D:(CLLocationCoordinate2D)origCoordinate  WithDistLocationCoordinate2D:(CLLocationCoordinate2D)distCoordinate {
    CLLocationDistance distance = 0;
    
    CLLocation *orig = [[CLLocation alloc] initWithLatitude:origCoordinate.latitude longitude:origCoordinate.longitude];
    CLLocation* dist = [[CLLocation alloc] initWithLatitude:distCoordinate.latitude longitude:distCoordinate.longitude];
    
    distance = [orig distanceFromLocation:dist];
    //    DLog(@"距离:%.1f M",distance);
    
    return  distance;
}

//MARK: -- 获取信号等级
+ (NSInteger)getSignalLevel:(NSInteger)number {
    NSInteger m = 0;
    if (number >= 15) {
        m = 5;
    } else if (number >= 12) {
        m = 4;
    } else if (number >= 8) {
        m = 3;
    } else if (number >= 4) {
        m = 2;
    } else if (number > 0) {
        m = 1;
    }
    
    return m;
}

//MARK: -- 单位转换（米->英尺）
+ (CGFloat)meterTransformToFeet:(CGFloat)meter {
    return meter * 3.2808399;
}

//MARK: -- 单位转换（千米/小时->英里/小时）
+ (CGFloat)kmPerHourTransformToMilesPerHour:(CGFloat)kmPH {
    return kmPH/1.6;
}
#pragma mark -
#pragma mark 获取资源图片
// 加载JPG图片
+(UIImage *)imagJPGPathName:(NSString *)name
{
    if (ISLarge47Inch) {
        [name stringByAppendingString:@"@3x"];
    } else {
        [name stringByAppendingString:@"@2x"];
    }
    
    return [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:name ofType:@"jpg"]];
}
// 加载PNG图片
+(UIImage *)imagPNGPathName:(NSString *)name
{
    if (ISLarge47Inch) {
        name = [name stringByAppendingString:@"@3x"];
    } else {
        name = [name stringByAppendingString:@"@2x"];
    }
    
    return [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:name ofType:@"png"]];
}
//MARK: -- 验证WiFi名称是否符合1-21个字符，仅支持字母、数字、下划线
+ (BOOL)isValidWiFiName:(NSString *)inputString {
    return [self isValidateByRegex:YNC_WIFI_NAME_REGULAR withInputString:inputString];
}
//MARK: -- 验证WiFi密码是否符合8-21个字符，仅支持字母、数字、下划线
+ (BOOL)isValidWiFiPassword:(NSString *)inputString {
    return [self isValidateByRegex:YNC_WIFI_PASSWORD_REGULAR withInputString:inputString];
}
//MARK: -- 匹配正则表达式
+ (BOOL)isValidateByRegex:(NSString *)regex withInputString:(NSString *)inputString {
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pre evaluateWithObject:inputString];
}

/*--------------------------- Add by GavinYu End ----------------------------*/


+ (NSString *)nullString:(NSString *)string {
    if ([string isKindOfClass:[NSNull class]])
    {
        return @"";
    }
    if (string == nil || [string isEqualToString:@"null"] || [string isEqualToString:@"<null>"])
    {
        string = @"";
    }
    return string;
}

#pragma mark - 获取视频第一帧 网络视频 && 本地视频

+ (UIImage *)getVideoPreViewImage:(NSString *)urlString{
    
    if(urlString.length == 0)
    {
        return [UIImage imageNamed:@"cacheImage"];
    }
    NSString *tempUrlString = urlString;
    NSURL *videoPath = [NSURL URLWithString:tempUrlString];
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoPath options:nil];
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *img = [[UIImage alloc] initWithCGImage:image];
    if(img == nil)
    {
        return [UIImage imageNamed:@"firebirdVideoEduMorentu"];
    }
    return img;
    
}

+ (UIImage *)getLoaclVideoPreViewImage:(NSString *)urlString{
    if(urlString.length == 0)
    {
        return [UIImage imageNamed:@"firebirdVideoEduMorentu"];
    }
    NSString *tempUrlString = urlString;
    NSURL *videoPath = [NSURL fileURLWithPath:tempUrlString];
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoPath options:nil];
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *img = [[UIImage alloc] initWithCGImage:image];
    if(img == nil)
    {
        return [UIImage imageNamed:@"firebirdVideoEduMorentu"];
    }
    return img;
}

+ (NSString *)getLocalizableStringWithString:(NSString *)string {
    return NSLocalizedString(string, nil);
}

+ (UIActivityIndicatorView *)creatActivityIndicatorView {
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake((APPWIDTH-20)/2,(APPHEIGHT-30-64)/2,30.0f,30.0f)];
    [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    return activityIndicator;
}

/*--------------------------- Add by JackWu End ----------------------------*/
+ (NSString *)getAppLanguage {
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    if ([language hasPrefix:@"zh-Hans"]) {
        return @"zh-cn";
    } else {
        return @"en-us";
    }
}

+ (BOOL)getIsSeenAgreement {
    return [[NSUserDefaults standardUserDefaults] boolForKey:_hasSeenAgreement];
}

+ (void)setIsSeenAgreement:(BOOL)val {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setBool:val forKey:_hasSeenAgreement];
    [userDefault synchronize];
}

+ (float)getLatestAgreementVersion {
    return [[NSUserDefaults standardUserDefaults] floatForKey:_latestAgreementVersion];
}

+ (void)setLatestAgreementVersion:(float)version {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setFloat:version forKey:_latestAgreementVersion];
    [userDefault synchronize];
}

+ (NSString *)getAgreementUrl  {
    return [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@_%@", _agreementUrl, [YNCUtil getAppLanguage]]];
}

+ (void)setAgreementUrl:(NSString *)url {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:url forKey:[NSString stringWithFormat:@"%@_%@", _agreementUrl, [YNCUtil getAppLanguage]]];
    [userDefault synchronize];
}

+ (NSString *)convertSecondToDisplayString:(NSUInteger)seconds
{
    NSInteger remindHours = seconds / 3600;
    
    NSInteger remindMinutes = (seconds - (remindHours * 3600)) / 60;
    
    NSInteger remindSeconds = seconds - (remindMinutes * 60) - (remindHours * 3600);
    
    return [NSString stringWithFormat:@"%02d:%02d:%02d", (int32_t)remindHours, (int32_t)remindMinutes, (int32_t)remindSeconds];
}

@end
