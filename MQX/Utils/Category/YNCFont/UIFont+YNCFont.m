//
//  UIFont+YNCFont.m
//  YuneecApp
//
//  Created by yc-sh-vr-pc05 on 2017/3/4.
//  Copyright © 2017年 yuneec. All rights reserved.
//

#import "UIFont+YNCFont.h"

#import "YNCMacros.h"

@implementation UIFont (YNCFont)

//MARK: -- ten Size Bold
+ (UIFont *)tenBoldFontSize {
    return UIFONTBOLDSYSTEM(10.0);
}

//MARK: -- sixteen Size Bold
+ (UIFont *)sixteenBoldFontSize {
    return UIFONTBOLDSYSTEM(16.0);
}

//MARK: -- eighteen Size Bold
+ (UIFont *)eighteenBoldFontSize {
    return UIFONTBOLDSYSTEM(18.0);
}

//MARK: -- twentyOne Size Bold
+ (UIFont *)twentyOneBoldFontSize {
    return UIFONTBOLDSYSTEM(21.0);
}

//MARK: -- ten Size
+ (UIFont *)tenFontSize {
    return UIFONTSYSTEM(10.0);
}

//MARK: -- twelve Size
+ (UIFont *)twelveFontSize {
    return UIFONTSYSTEM(12.0);
}

//MARK; -- thirteen Size
+ (UIFont *)thirteenFontSize {
    return UIFONTSYSTEM(13.0);
}

//MARK: -- fifteen Size
+ (UIFont *)fourteenFontSize {
    return UIFONTSYSTEM(14.0);
}

//MARK: -- sixteen Size
+ (UIFont *)sixteenFontSize {
    return UIFONTSYSTEM(16.0);
}

//MARK: -- eighteen Size
+ (UIFont *)eighteenFontSize {
    return UIFONTSYSTEM(18.0);
}

@end
