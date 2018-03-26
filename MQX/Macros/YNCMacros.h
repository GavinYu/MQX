//
//  YNCMacros.h
//  MQX
//
//  Created by yc-sh-vr-pc05 on 2018/3/3.
//  Copyright © 2018年 YunEEC. All rights reserved.
//

//  App所有的宏常量 仅限于 #define

#ifndef YNCMacros_h
#define YNCMacros_h

/*--------------------------- Add by GavinYu Start ----------------------------*/
//RGB颜色转换（16进制->10进制）
#ifndef UICOLOR_FROM_HEXRGB
#define UICOLOR_FROM_HEXRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#endif

#ifndef UICOLOR_FROM_HEXRGB_ALPHA
#define UICOLOR_FROM_HEXRGB_ALPHA(rgbValue, alphaValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:alphaValue]
#endif

//RGB颜色设置
#ifndef UICOLOR_FROM_RGB
#define UICOLOR_FROM_RGB(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#endif

// 屏幕高度
#ifndef SCREENHEIGHT
#define SCREENHEIGHT ([[UIScreen mainScreen] bounds].size.width > [[UIScreen mainScreen] bounds].size.height?[[UIScreen mainScreen] bounds].size.height:[[UIScreen mainScreen] bounds].size.width)
#endif

// 屏幕宽度
#ifndef SCREENWIDTH
#define SCREENWIDTH ([[UIScreen mainScreen] bounds].size.width < [[UIScreen mainScreen] bounds].size.height?[[UIScreen mainScreen] bounds].size.height:[[UIScreen mainScreen] bounds].size.width)
#endif

// 坐标快捷
#define APPFRAME(x,y,width,height)     CGRectMake((x),(y),(width),(height))

//屏幕宽度(正常情况下)
#define APPWIDTH [UIScreen mainScreen].bounds.size.width

//屏幕高度(正常情况下)
#define APPHEIGHT [UIScreen mainScreen].bounds.size.height

//索引基础值
#define BASETAG   100
//iphone x 判断
#define DeviceIsIPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

// 横屏导航栏高度
#ifndef YNCNAVGATIONBARHEIGHT
#define YNCNAVGATIONBARHEIGHT 36.0
#endif

// 导航栏高度
#ifndef NAVGATIONBARHEIGHT
#define NAVGATIONBARHEIGHT (DeviceIsIPhoneX == YES ? 88 : 64)
#endif

// iPhone X 竖屏底部不安全区域部分高度
#ifndef BottomUnsafeArea
#define BottomUnsafeArea (DeviceIsIPhoneX == YES ? 34 : 0)
#endif

// iPhone X 竖屏顶部不安全区域部分高度
#ifndef TopUnsafeArea
#define TopUnsafeArea (DeviceIsIPhoneX == YES ? 44 : 0)
#endif

// iPhone X 横屏底部不安全区域部分高度
#ifndef HorizontalScreenBottomUnsafeArea
#define HorizontalScreenBottomUnsafeArea (DeviceIsIPhoneX == YES ? 14 : 0)
#endif

// 状态栏高度
#ifndef STATUSBARHEIGHT
#define STATUSBARHEIGHT  (DeviceIsIPhoneX == YES ? 44 : 20)
#endif

// 底部Tab高度
#ifndef TABBARHEIGHT
#define TABBARHEIGHT 49
#endif

// weakSelf
#ifndef WS
#define WS(weakSelf)  __weak __typeof(self) weakSelf = self
#endif

//设置系统默认字体样式的大小
#ifndef UIFONTSYSTEM
#define UIFONTSYSTEM(fontSize) [UIFont systemFontOfSize:(CGFloat)fontSize]
#endif

//设置系统默认粗体字体样式的大小
#ifndef UIFONTBOLDSYSTEM
#define UIFONTBOLDSYSTEM(fontSize) [UIFont boldSystemFontOfSize:(CGFloat)fontSize]
#endif

//设置自定义字体样式和大小
#ifndef UIFONTCUSTOM
#define UIFONTCUSTOM(fontName,fontSize) [UIFont fontWithName:(NSString *)fontName size:fontSize]
#endif

#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] \n" fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#define DLogRect(rect)  DLog(@"%s x=%f, y=%f, w=%f, h=%f", #rect, rect.origin.x, rect.origin.y,rect.size.width, rect.size.height)
#define DLogPoint(pt) DLog(@"%s x=%f, y=%f", #pt, pt.x, pt.y)
#define DLogSize(size) DLog(@"%s w=%f, h=%f", #size, size.width, size.height)
#define ALog(fmt, ...)  { UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%s\n [Line %d] ", __PRETTY_FUNCTION__, __LINE__] message:[NSString stringWithFormat:fmt, ##__VA_ARGS__]  delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]; [alert show]; }
#else
#define DLog(...)
#define DLogRect(rect)
#define DLogPoint(pt)
#define DLogSize(size)
#define ALog(...)
#endif

//App当前的版本号
#ifndef APPVERSION
#define APPVERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#endif

//当前系统的版本号
#ifndef SYSTEMVERSION
#define SYSTEMVERSION [[[UIDevice currentDevice] systemName] stringByAppendingString:[[UIDevice currentDevice] systemVersion]]
#endif

#ifndef ISLarge47Inch
#define ISLarge47Inch ([UIScreen mainScreen].bounds.size.height>667)//6+
#endif

//当前应用在App Store的App ID
#ifndef YNC_APP_ID
#define YNC_APP_ID @"1231375336"
#endif

/// 第一个参数是当下的控制器适配iOS11 一下的，第二个参数表示scrollview或子类
#define YNCAdjustsScrollViewInsetNever(controller,view) if(@available(iOS 11.0, *)) {view.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;} else if([controller isKindOfClass:[UIViewController class]]) {controller.automaticallyAdjustsScrollViewInsets = false;}
//获取图片资源地址
#ifndef YNC_IMAGESBUNDLE_PATH
#define YNC_IMAGESBUNDLE_PATH [[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"YNCImagesBundle" ofType:@"bundle"]]
#endif

//系统版本大于等于iOS10
#ifndef NO_BELOW_iOS10
#define NO_BELOW_iOS10 ([[UIDevice currentDevice].systemVersion doubleValue] >= 10.0)
#endif

#define YNC_WIFI_NAME_REGULAR   @"^([a-zA-Z0-9_]){1,21}$"
#define YNC_WIFI_PASSWORD_REGULAR   @"^([a-zA-Z0-9_]){8,21}$"
#define YNC_EMAIL_FORMAT_REGULAR    @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"

// 是否为空对象
#define YNCObjectIsNil(__object)  ((nil == __object) || [__object isKindOfClass:[NSNull class]])

// 字符串为空
#define YNCStringIsEmpty(__string) ((__string.length == 0) || MHObjectIsNil(__string))

// 字符串不为空
#define YNCStringIsNotEmpty(__string)  (!MHStringIsEmpty(__string))

// 数组为空
#define YNCArrayIsEmpty(__array) ((MHObjectIsNil(__array)) || (__array.count==0))

//购买链接
#ifndef YNC_STORE_LINK
#define YNC_STORE_LINK   @"https://yuneec.tmall.com"
#endif

#define kPeriod 1.0  //定时器时间 （每秒执行一次）

//颜色配置
#define TextGrayColor UICOLOR_FROM_HEXRGB(0x888888)  // 文字浅灰
#define TextBlackColor UICOLOR_FROM_HEXRGB(0x1e1e1e)  // 文字黑色
#define TextOrangeColor UICOLOR_FROM_HEXRGB(0xf53333) // 文字橘色
#define TextLittleGrayColor UICOLOR_FROM_HEXRGB(0xbbbbbb) // 浅灰
#define TextGreenColor UICOLOR_FROM_HEXRGB(0x27bb77)
#define TextWhiteColor UICOLOR_FROM_HEXRGB(0xffffff)
// 背景色
#define BackgroundColor_Black UICOLOR_FROM_HEXRGB(0x1e1e1e)
#define BackgroundColor_White UICOLOR_FROM_HEXRGB(0xffffff)
#define BackgroundColor_NavigationView UICOLOR_FROM_HEXRGB(0xf8f8f8)
#define BackgroundColor_green_cameraSettingCell UICOLOR_FROM_HEXRGB(0x2bbb77)
#define BackgroundColor_ImportLabel UICOLOR_FROM_HEXRGB(0xff5533)
#define BackgroundColor_Green UICOLOR_FROM_HEXRGB(0x27bb77)

// 线的色值
#define LineColor_litteGray UICOLOR_FROM_HEXRGB(0xbbbbbb)
#define LineColor_darkGray UICOLOR_FROM_HEXRGB(0x1e1e1e)
#define LineColor_importListColor UICOLOR_FROM_HEXRGB(0xdddddd)
#define LineColor_Orange UICOLOR_FROM_HEXRGB(0xf53333)
#define LineColor_greenColor UICOLOR_FROM_HEXRGB(0x27bb77)

// 字体
#define SystemFont_19 [UIFont systemFontOfSize:19.0] // 这里对应的是36px
#define SystemFont_18 [UIFont systemFontOfSize:18.0] // 这里对应的是34px
#define SystemFont_17 [UIFont systemFontOfSize:17.0] // 这里对应的是32px
#define SystemFont_16 [UIFont systemFontOfSize:16.0] // 这里对应的是30px
#define SystemFont_15 [UIFont systemFontOfSize:15.0] // 这里对应的是28px
#define SystemFont_14 [UIFont systemFontOfSize:14.0] // 这里对应的是26px
#define SystemFont_13 [UIFont systemFontOfSize:13.0] // 这里对应的是24px
#define SystemFont_12 [UIFont systemFontOfSize:12.0] // 这里对应的是22px
#define SystemFont_11 [UIFont systemFontOfSize:11.0] // 这里对应的是20px
#define SystemFont_10 [UIFont systemFontOfSize:10.0] // 这里对应的是18px
#define SystemFont_9 [UIFont systemFontOfSize:9] // 这里对应的是16px
#define SystemFont_8 [UIFont systemFontOfSize:8] // 这里对应的是14px

// 缓存地址
#define DocumentDirectiory [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]
#define Document_Download [DocumentDirectiory stringByAppendingPathComponent:@"download"]
#define Document_ImageEdit [DocumentDirectiory stringByAppendingPathComponent:@"imageEdit"]
#define Document_FlightLog [DocumentDirectiory stringByAppendingPathComponent:@"flightLog"]
#define Document_FilterImage [DocumentDirectiory stringByAppendingPathComponent:@"filterImage"]
#define Document_Version [DocumentDirectiory stringByAppendingPathComponent:@"version"]
#define Document_Download_Video [Document_Download stringByAppendingPathComponent:@"Video"]
#define Document_Download_Photo [Document_Download stringByAppendingPathComponent:@"Photo"]

#define kURL_MQX_VIDEO @"https://192.168.99.1/VIDEO"
#define kURL_MQX_PHOTO @"https://192.168.99.1/PHOTO"
#define kURL_Breeze_2DCIM @"http://192.168.42.1/DCIM/100MEDIA/"

/*--------------------------- Add by GavinYu End ----------------------------*/


#endif /* YNCMacros_h */
