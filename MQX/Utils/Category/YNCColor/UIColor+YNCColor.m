//
//  UIColor+YNCColor.m
//  YuneecApp
//
//  Created by yc-sh-vr-pc05 on 2017/3/4.
//  Copyright © 2017年 yuneec. All rights reserved.
//

#import "UIColor+YNCColor.h"

#import "YNCMacros.h"

@implementation UIColor (YNCColor)

/*--------------------------- Add by GavinYu Start ----------------------------*/
//MARK: -- Light red color红色
+ (UIColor *)lightRedColor {
    return UICOLOR_FROM_HEXRGB(0xff0030);
}

//MARK: -- grayish color浅灰色
+ (UIColor *)grayishColor {
    return UICOLOR_FROM_HEXRGB(0x888888);
}

//MARK: -- middleGray中黑色
+ (UIColor *)middleGrayColor {
    return UICOLOR_FROM_HEXRGB(0xbbbbbb);
}

//MARK: -- light grayish color淡灰色
+ (UIColor *)lightGrayishColor {
    return UICOLOR_FROM_HEXRGB(0xdddddd);
}

//MARK: -- atrous 深黑色
+ (UIColor *)atrousColor {
    return UICOLOR_FROM_HEXRGB(0x1e1e1e);
}

//MARK: -- Blue蓝色
+ (UIColor *)yncBlueColor {
    return UICOLOR_FROM_HEXRGB(0x226bbb);
}

//MARK: -- Green绿色
+ (UIColor *)yncGreenColor {
    return UICOLOR_FROM_HEXRGB(0x00c666);
}

//MARK: -- glaucous（蓝绿色）
+ (UIColor *)glaucousColor{
    return UICOLOR_FROM_HEXRGB(0x11aabb);
}

//视图背景色
+ (UIColor *)yncViewBackgroundColor {
    return UICOLOR_FROM_HEXRGB(0xf8f8f8);
}

//MARK: -- 火鸟的浅绿色
+ (UIColor *)yncFirebirdLightGreenColor {
    return UICOLOR_FROM_HEXRGB(0x99eebb);
}

//MARK: -- 火鸟的深绿色
+ (UIColor *)yncFirebirdDarkGreenColor {
    return UICOLOR_FROM_HEXRGB(0x119555);
}

//MARK: -- 火鸟的黄色
+ (UIColor *)yncFirebirdYellowColor {
    return UICOLOR_FROM_HEXRGB(0xffb81e);
}

//MARK: -- 火鸟的绿色
+ (UIColor *)yncFirebirdGreenColor {
    return UICOLOR_FROM_HEXRGB(0x00dd77);
}

//MARK: -- 火鸟的纯白色
+ (UIColor *)yncFirebirdWhiteColor {
    return [UIColor whiteColor];
}
/*--------------------------- Add by GavinYu End ----------------------------*/

@end
