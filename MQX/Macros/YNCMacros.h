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
/*--------------------------- Add by GavinYu End ----------------------------*/


#endif /* YNCMacros_h */
